# Mini Jira — SaaS Kanban Board

Mini Jira is a portfolio Ruby on Rails application inspired by Jira/Trello-style Kanban workflows.

The goal of this project is not just to implement CRUD, but to demonstrate production-oriented backend and full-stack engineering practices: authentication, authorization, IDOR protection, service objects, request/system tests, Hotwire interactions, ViewComponents, Docker-based development, and CI security checks.

## Demo preview

### Kanban board

![Kanban board](docs/screenshots/project-board.png)

### Workspace dashboard

![Dashboard](docs/screenshots/dashboard.png)

### Task details modal

![Task details modal](docs/screenshots/task-details-modal.png)

### Project settings and danger zone

![Project settings and danger zone](docs/screenshots/project-settings-danger-zone.png)

### Projects overview

![Projects overview](docs/screenshots/projects-index.png)

### Sign in with demo account

![Sign in page](docs/screenshots/sign-in.png)

## What this project demonstrates

- Ruby on Rails 8 application structure
- Authentication with Devise
- Authorization with Pundit
- IDOR protection through policy scopes and nested resource lookup
- Kanban-style task management
- Hotwire/Turbo modal task creation
- Stimulus-powered task movement
- ViewComponent-based UI decomposition
- RSpec test suite: request, model, policy, service, system, and component specs
- Docker-based local development and test environment
- GitHub Actions CI with RSpec, RuboCop, Brakeman, bundler-audit, and importmap audit

## Tech stack

- Ruby on Rails 8
- MySQL 8
- Devise
- Pundit
- Hotwire / Turbo / Stimulus
- ViewComponent
- Tailwind CSS
- RSpec / FactoryBot / Capybara / Selenium
- Docker / Docker Compose
- GitHub Actions

## Features

- User registration and authentication
- Project CRUD
- Nested task management inside projects
- Kanban board with task statuses: To Do, In Progress, Done
- Turbo-powered task creation modal
- Stimulus-powered task movement between columns
- Server-side authorization for project and task access
- JSON contract for task movement endpoint
- Responsive Tailwind-based UI

## Security and data protection

Security is one of the main focuses of this project.

The application protects user data through:

- Devise authentication
- Pundit authorization policies
- Policy scopes for user-owned records
- Nested resource lookup to reduce IDOR risk
- Strong parameters to prevent mass assignment
- Database constraints for authorization-sensitive fields
- Pundit verification safety-net for controller actions
- Brakeman static analysis in CI
- Bundler Audit and Importmap Audit in CI

Examples of protected scenarios:

- A user cannot access another user's project by changing the project ID in the URL.
- A user cannot create a project for another user through forged `user_id` params.
- A user cannot move or update tasks from a project they do not own.

## Testing and CI

The project uses RSpec as the main test framework.

Test coverage includes:

- Model specs for validations, associations, and database constraints
- Policy specs for authorization rules
- Request specs for authentication, authorization, IDOR protection, mass assignment, and JSON contracts
- Service specs for business operations and result objects
- System specs for user-facing Hotwire flows
- Component specs for ViewComponent-rendered UI

The CI pipeline runs on GitHub Actions and uses the Docker-based test environment.

CI checks include:

- RSpec test suite
- RuboCop style checks
- Brakeman static security analysis
- Bundler Audit for vulnerable Ruby gems
- Importmap Audit for vulnerable JavaScript dependencies
- Tailwind CSS build before tests

## Local development

The project is designed to run with Docker Compose.

### Start the application

```bash
docker compose up
```

The Rails application will be available at:

```text
http://localhost:3000
```

MailDev is available at:

```text
http://localhost:1080
```

## Demo data

To prepare the database and create demo data, run:

```bash
docker compose exec web bin/rails db:prepare db:seed
```

Demo account:

- Email: `demo@example.com`
- Password: `password123`

The seed data creates a demo Kanban project with tasks across all workflow statuses.

### Run the test suite

```bash
docker compose run --rm test bundle exec rspec
```

### Run RuboCop

```bash
docker compose exec web bundle exec rubocop
```

### Run the full CI script locally

```bash
docker compose run --rm test bin/ci
```


### Linux note

On Linux, if Docker creates root-owned files in the project directory, run commands with the current host user:

```bash
docker compose run --rm --user "$(id -u):$(id -g)" -e HOME=/tmp test bundle exec rspec
```

## Project status

Current focus:

- Stable Kanban CRUD flow
- Secure project/task ownership boundaries
- Hotwire-based task creation
- Stimulus-based task movement
- RSpec coverage for core business and security scenarios
- Docker-based CI pipeline

Planned next improvements:

- Better README screenshots / GIFs
- Deployment
- Background jobs for async notifications
- Basic audit trail for task status changes
- Optional AI task assistant integration

Not planned for the initial MVP:

- Billing
- Full public REST API
- RAG / vector search
- Complex enterprise permissions

These features may be added later only if they provide clear product value and do not turn the project into an over-engineered demo.
