# Steps toward automation

In this blog post, I'll be discussing my approach to automating tasks that
software engineers have to perform for their job. Before diving into the core
concept, I'd like to define and narrow down the idea of automation within
software engineering.

Automation, in this context, refers to code created by programmers to simplify
tasks. The users benefiting from this automation are the computer programs
themselves. The platforms on which programmers automate tasks include
development machines, CI/CD systems, cron jobs, and more. Typically, there is a
trigger for the automated task, such as an updated file, a new version of a
container, or the presence of a binary file. The job may involve security
scanning, updating downstream dependencies, or sending Slack messages.

Automation complexity arises when scripts have interdependencies, often
represented as a pipeline in a CI/CD system like GitHub Actions, GoCD, or
Concourse. An example pipeline can be a new git commit that happened in the code
base, tests need to run against the code, and when they pass, the code gets
deployed into an environment, which has performance and end-to-end tests to make
sure there was no regression. If anything fails in the pipeline, you can rerun
any part of the pipeline just in case.

As a software engineer, I've established two ground rules around automation.

First, automate yourself out of a job, a mindset more than something precisely
actionable. If you find yourself repeatedly performing a task that doesn't
require critical thinking but still consumes time, try to figure out how to
automate it. For example, if you're always responsible for deployments and it
takes up a significant portion of your time, automate the process to free up
your schedule.

My second rule for automation is only to automate things you can do manually.
Many engineers, myself included, have fallen into the trap of automating a task
before fully understanding the problem, leading to spectacular failures when
there's no manual fallback. To avoid this, ensure you know the commands and
requirements for manually executing the automated task in emergencies.

Applying these two rules will help you identify the repetitive tasks you're
performing and automate them with confidence. Enabling you to share your
understanding with team members and provide context.

I once worked on an application where our platform was a CI/CD system that
allowed people to install and update a platform. We provided bundled scripts,
which meant most users never saw the commands contained within the scripts. We
embedded these scripts and commands in our documentation to maintain
transparency, allowing users to run them from their development environment.

We wanted to prevent users from encountering issues when copying and pasting
commands from the documentation, such as syntax errors or incorrect arguments.
Applying the two rules ensured the commands worked manually and within our CI/CD
system. First, we manually tested the commands before adding them to the
documentation. Second, we used the bundled scripts in our CI/CD system to
confirm they also worked there. This approach led to documentation with its own
CI/CD, ensuring everything was valid and functional. It was an advantageous
experience.

With any rules, there are always going to be edge cases. For example, there may
be security constraints with running specific code. The condition requires that
code be executed within a particular environment because the credentials and
network access have been isolated. You'll never be able to run this locally from
your development machine.

Also, with manual and automated intervention, there will be times when you want
to do something manually constantly. It could be for the satisfaction,
validation, and verification that it Just Works™ correctly. It could also be
that you are the only one that runs this. Where the line exists between
automation and manual execution is a personal/team preference; just make sure to
check yourself that your automation is not over-engineering a straightforward
process.

In conclusion, automation in software engineering can be a powerful tool to save
time, reduce human error, and streamline processes. By adhering to the two
ground rules of automation and considering edge cases and personal/team
preferences, you can create a robust automation system that benefits you and
your team. Remember, automation aims to make life easier for you and your fellow
engineers.
