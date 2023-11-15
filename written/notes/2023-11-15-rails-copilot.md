# Deploying Rails with AWS Copilot

The following is what I captured to deploy a Rails application using AWS
[`copilot`](https://aws.github.io/copilot-cli). It is AWS CLI to provide a
_heroku_-like experience in the AWS ecosystem.

The project I started with [Jumpstart Rails](https://jumpstartrails.com/) for
the project. These commands and edits apply to the configuration and
expectations of that project template, but could _probably_ be applied to other
Rails applications.

> Note: Every `copilot` invocation is doing Cloudformation in the background. If
> you ever need to debug looking at the Stacks in Cloudformation console can be
> very helpful.

> Note: Every `copilot` invocation can take awhile.

```bash
# log into the account that will manage the deployment
# for my deployment, I used SSO
aws configure sso

# lets initialized the repository to be an app
# and have an environment
# this creates artifacts in `copilot/web/`
copilot init \
  -a rails-app \
  -t "Load Balanced Web Service" \
  -n web \
  -d ./Dockerfile.production

# create a test/dev environment
# this create artifacts in `copilot/environments`
copilot env init \
  --name dev \
  --app rails-app \
  --default-config
```

This does not deploy the application. It is just setting up configuration and
pluming within the repository. It should all be under `copilot/` directory.

We have to allocate the database as a
[`storage`](https://aws.github.io/copilot-cli/docs/commands/storage-init/) unit.
The following command was used:

```bash
copilot storage init \
  -n webdb \
  -t Aurora \
  -w web \
  -l environment \
  --engine PostgreSQL \
  --initial-db railsapp
```

When setting up the database, the credentials need to be passed to the the
application. The preferred method is to use the Copilot service for reading the
credentials. We need to add the service `manifest.yml` the following:

```yaml
network:
  vpc:
    security_groups:
      - from_cfn: ${COPILOT_APPLICATION_NAME}-${COPILOT_ENVIRONMENT_NAME}-webdbSecurityGroup
secrets:
  DB_SECRET:
    from_cfn: ${COPILOT_APPLICATION_NAME}-${COPILOT_ENVIRONMENT_NAME}-webdbAuroraSecret
```

This value is `DATABASE_JSON`, not the common `DATABASE_URL` that Rails
reference. As far as I can tell, AWS doesn't provide that URL format, so we have
to handle this. In our `database.yml`, we have to read that environment
variables:

```yaml
production:
  <<: *default
  <% if ENV['DATABASE_JSON'] != nil %>
  <%   begin %>
  <%     require 'json' %>
  <%     db_config = JSON.parse(ENV['DATABASE_JSON']) %>
  <%     username = db_config['username'] %>
  <%     password = db_config['password'] %>
  <%     host = db_config['host'] %>
  <%     port = db_config['port'] %>
  <%     database = db_config['dbname'] %>
  username: <%= username %>
  password: <%= password %>
  host: <%= host %>
  port: <%= port %>
  database: <%= database %>
  <%   rescue JSON::ParserError %>
  url: <%= ENV['DATABASE_URL'] %>
  <%   end %>
  <% end %>
```

We need to configure that, which `Dockerfile` to use:

```yaml
image:
  build: Dockerfile.production
  port: 3000
```

There are changes that need to be made to the `Dockerfile.production` so that it
can run. These changes are related to precompile assets and starting the rails
server:

```docker
RUN SECRET_KEY_BASE=dummy-staging-key bin/rails assets:precompile

CMD ["bin/rails", "server", "-b", "0.0.0.0"]
```

We need to configure environment variables to the application to be able to
initialized:

```yaml
variables:
  RAILS_ENV: production
  SECRET_KEY_BASE: <value from `rails secret`>
```

We configuring our application as
["Load Balanced Web Service"](https://aws.github.io/copilot-cli/docs/manifest/lb-web-service/),
so that we can execute commands in the container. This allows us to load up
rails console, migrate the database, etc. If we use another one of the services,
we lose that ability, so this is the compromise.

> Note: Originally, the service "Request-Driven Web Service" was used, but it
> didn't allow execution of commands.

Please enable the execution option in the `manifest.yml`:

```yaml
exec: true
```

Let's setup our routing from the load balancer to the application. We can add a
healthcheck, too. This is in the same `manifest.yml` referenced:

```yaml
http:
  path: '/'
  healthcheck: '/up'
```

Since we are using this service, it does not provide SSL support by default.
That requires extra configuration. At the moment, these instructions just
support the non-SSL deployment.

Because of the above, we have to set SSL enforcement off in
`config/environments/production.rb`:

```ruby
config.force_ssl = false
```

Deploying the application:

```bash
# deploy the database
copilot env deploy -n dev

# deploy the application
copilot deploy

# run the database migrations for Rails after the deployment
copilot svc exec --command "bin/rails db:migrate"

# look at the logs of the running application
copilot svc logs

# show information of the currently deployed application
copilot svc show
```

Resources:

- [Deploy Django App](https://www.endpointdev.com/blog/2022/06/how-to-deploy-django-app-with-aurora-serverless-and-copilot/),
  this had good resources of how to deploy a web app into the cloud. It helped
  with the configuration of the database.
- [SSL support](https://github.com/aws/copilot-cli/issues/2071), a GitHub issue
  that has a discussion on setting up SSL. It requires having DNS being setup in
  Route 53.
- [Rails secret](https://til.hashrocket.com/posts/8b8b4d00a3-generate-a-rails-secret-key)
  generation.
