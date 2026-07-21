# Mini Jira — Rails 8 SaaS Kanban Board

Mini Jira is a production-oriented Ruby on Rails 8 portfolio application inspired by Jira/Trello-style Kanban workflows.

It demonstrates secure multi-user resource handling, Hotwire interactions, PostgreSQL-backed background jobs, audit logging, automated testing, Docker-based development, CI, and deployment readiness.

[![CI](https://github.com/Croxy-Z/mini_jira/actions/workflows/ci.yml/badge.svg)](https://github.com/Croxy-Z/mini_jira/actions/workflows/ci.yml)

## Live demo

**URL:** https://mini-jira-81ci.onrender.com

**Demo account:**

- Email: `demo@example.com`
- Password: `password123`

The public demo runs on Render with Neon PostgreSQL and Resend API email delivery.

## Demo preview

### Task movement

![Task movement demo](docs/demo/move-task.gif)

### Kanban board

![Kanban board](docs/screenshots/project-board.png)

### Workspace dashboard

![Dashboard](docs/screenshots/dashboard.png)

### Task details and activity history

![Task details modal](docs/screenshots/task-details-modal.png)

## Highlights

- Devise authentication and Pundit authorization
- IDOR protection through policy scopes and nested resource lookup
- Kanban board with Hotwire/Turbo and Stimulus interactions
- Task movement audit trail with actor and status transition history
- PostgreSQL-backed application data and Rails 8 multi-database production configuration
- Async email delivery with Active Job, Solid Queue, ActionMailer, and Resend API
- Service objects with explicit Result objects for business operations
- RSpec request, model, policy, service, component, and system specs
- Docker-based development and test environments
- Remote Selenium container for stable system specs in Docker and CI
- GitHub Actions quality gates with RSpec, RuboCop, Brakeman, Bundler Audit, and Importmap Audit
- Kamal configuration for VPS-style deployment with separate web/job roles and PostgreSQL accessory

## Tech stack

- Ruby on Rails 8
- PostgreSQL 16
- Devise
- Pundit
- Hotwire / Turbo / Stimulus
- ViewComponent
- Tailwind CSS v4
- Active Job / Solid Queue
- ActionMailer / Resend API
- RSpec / FactoryBot / Capybara / Selenium
- Docker / Docker Compose
- GitHub Actions
- Kamal

## Architecture

The application intentionally keeps the architecture simple and separates responsibilities only where it improves maintainability, security, or testability.

- Controllers handle HTTP concerns: authentication, authorization, params, redirects, and Turbo responses.
- Pundit policies and policy scopes protect user-owned resources and reduce IDOR risk.
- Service objects handle business operations that benefit from explicit boundaries, such as project creation, task creation, and task movement.
- Result objects make service outcomes explicit and easy to test.
- Task movement and audit record creation happen in one database transaction.
- ViewComponents extract reusable UI pieces without introducing a separate frontend framework.
- Hotwire/Turbo handles modal flows and server-driven UI updates; Stimulus handles focused client-side behavior.
- Email delivery runs asynchronously through Active Job and Solid Queue.
- System specs use a dedicated Selenium Chrome container instead of running Chromium inside the Rails test container.

## Testing and security

The test suite covers business logic, authorization boundaries, UI flows, and deployment-related behavior.

- Request specs for authentication, authorization, CRUD, invalid params, Turbo responses, and JSON contracts
- Policy specs for ownership and access rules
- Service specs for business operations and audit logging
- System specs for core Hotwire/Turbo flows
- Component specs for reusable UI pieces
- Model specs for validations, associations, constraints, and background mailer jobs

Security-focused protections include:

- Devise authentication
- Pundit authorization and policy scopes
- Nested resource lookup to reduce IDOR risk
- Strong parameters to prevent mass assignment
- Database constraints for authorization-sensitive fields
- Pundit verification safety net for controller actions
- Brakeman, Bundler Audit, and Importmap Audit in CI
- Environment-based deployment secrets
- PostgreSQL deployment configuration without public database exposure

## Local development

Start the application:

```bash
docker compose up
```

Rails:

```text
http://localhost:3000
```

MailDev:

```text
http://localhost:1080
```

Prepare the database and demo data:

```bash
docker compose exec web bin/rails db:prepare db:seed
```

## Running checks locally

Run the test suite:

```bash
docker compose run --rm test bundle exec rspec
```

Run RuboCop:

```bash
docker compose exec web bundle exec rubocop
```

Run the full local CI pipeline:

```bash
docker compose run --rm test bin/ci
```

## Linux note

On Linux, Docker can create root-owned files in the project directory if commands are executed as the default container user. The project commands use the current host user and a writable HOME directory to keep generated files editable:

```bash
docker compose run --rm --user "$(id -u):$(id -g)" -e HOME=/tmp test bundle exec rspec
```


## Deployment

The public demo is deployed on:

```text
Render -> Rails / Puma / Solid Queue
Neon  -> PostgreSQL
Resend -> transactional email delivery over HTTPS API
```

The repository also includes Kamal configuration for a VPS-style deployment:

```text
web container -> Rails / Puma / HTTP requests
job container -> Solid Queue worker / background jobs
db accessory  -> PostgreSQL
```

This keeps the public demo simple and free while preserving a production-oriented Kamal/VPS deployment path.
