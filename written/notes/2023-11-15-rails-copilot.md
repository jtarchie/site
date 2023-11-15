# Deploying a Rails Application with AWS Copilot

This post outlines deploying a Rails application using AWS Copilot, a CLI tool
designed to provide a Heroku-like experience within the AWS ecosystem. Before
proceeding, it's recommended to familiarize yourself with the basics by
following the
["Deploy your first application"](https://aws.github.io/copilot-cli/docs/getting-started/first-app-tutorial/)
guide in the Copilot documentation.

I used the [Jumpstart Rails](https://jumpstartrails.com/) project template for
this deployment. The steps and configurations discussed here are specific to
this template but might be adaptable to other Rails applications.

**Important Notes:**

- Each `copilot` command executes CloudFormation operations in the background.
  Inspecting the CloudFormation Stacks in the AWS console can be insightful if
  you encounter issues.
- `copilot` commands can be time-consuming.

### Setting Up the Application

First, log into the AWS account and set up the application and environment using
the following commands:

```bash
# Log into the AWS account (using SSO for this deployment)
aws configure sso

# Initialize the application repository
copilot init \
  -a rails-app \
  -t "Load Balanced Web Service" \
  -n web \
  -d ./Dockerfile.production

# Create a test/development environment
copilot env init \
  --name dev \
  --app rails-app \
  --default-config
```

This step does not deploy the application but sets up the necessary
configuration within your repository's `copilot/` directory.

### Database Configuration

Next, allocate the database as a
[`storage`](https://aws.github.io/copilot-cli/docs/commands/storage-init/) unit:

```bash
copilot storage init \
  -n webdb \
  -t Aurora \
  -w web \
  -l environment \
  --engine PostgreSQL \
  --initial-db railsapp
```

For the application to access database credentials, modify the `manifest.yml`
file as follows:

```yaml
network:
  vpc:
    security_groups:
      - from_cfn: ${COPILOT_APPLICATION_NAME}-${COPILOT_ENVIRONMENT_NAME}-webdbSecurityGroup
secrets:
  DATABASE_JSON:
    from_cfn: ${COPILOT_APPLICATION_NAME}-${COPILOT_ENVIRONMENT_NAME}-webdbAuroraSecret
```

### Application Configuration

AWS provides `DATABASE_JSON` instead of the typical `DATABASE_URL`. Adjust the
`database.yml` to parse these credentials:

```yaml
production:
  <<: *default
  # Parse DATABASE_JSON if available
  <% if ENV['DATABASE_JSON'] %>
  <%   require 'json' %>
  <%   db_config = JSON.parse(ENV['DATABASE_JSON']) %>
  username: <%= db_config['username'] %>
  password: <%= db_config['password'] %>
  host: <%= db_config['host'] %>
  port: <%= db_config['port'] %>
  database: <%= db_config['dbname'] %>
  <% else %>
  url: <%= ENV['DATABASE_URL'] %>
  <% end %>
```

In your `Dockerfile.production`, include instructions for precompiling assets
and starting the Rails server:

```docker
RUN SECRET_KEY_BASE=dummy-staging-key bin/rails assets:precompile
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
```

Set environment variables for production in your `manifest.yml`:

```yaml
variables:
  RAILS_ENV: production
  SECRET_KEY_BASE: <value from `rails secret`>
```

### Service Configuration

Configure the application as a
["Load Balanced Web Service"](https://aws.github.io/copilot-cli/docs/manifest/lb-web-service/)
to enable command execution in the container, essential for tasks like database
migration.

```yaml
exec: true
```

Define routing and health check settings:

```yaml
http:
  path: '/'
  healthcheck: '/up'
```

Since SSL support isn't provided by default, turn off SSL enforcement in
`config/environments/production.rb`:

```ruby
config.force_ssl = false
```

### Deploying the Application

Deploy the application and database using the following commands:

```bash
copilot deploy \
  --deploy-env \
  --env dev \
  --name web

# Run database migrations post-deployment
copilot svc exec \
  --command "bin/rails db:migrate" \
  -n web

# View application logs
copilot svc logs

# Display deployment information
copilot svc show
```

You should have a URL in the `show` command that will expose your app to the
public Internet.

We did it! We've deployed our application.

> Note: To clean it all up `copilot app delete`.

### Additional Resources

- [Deploy Django App](https://www.endpointdev.com/blog/2022/06/how-to-deploy-django-app-with-aurora-serverless-and-copilot/):
  Offers insights into web app deployment in the cloud, including database
  configuration.
- [SSL Support Discussion](https://github.com/aws/copilot-cli/issues/207
- [Chat](https://matrix.to/#/!QdxoBcgpJveoAoIPCc:gitter.im/$YqOcVQ2VqEqsXvDqEYeOsEOR-mp7HhDbLoBJCw67J8I?via=gitter.im&via=matrix.org&via=matrix.unope.ru)
  with support from AWS Copilot.
