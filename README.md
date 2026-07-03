# Mini Jira — SaaS Kanban Board

Mini Jira is a portfolio Ruby on Rails application inspired by Jira/Trello-style Kanban workflows.

The goal of this project is not just to implement CRUD, but to demonstrate production-oriented backend and full-stack engineering practices: authentication, authorization, IDOR protection, service objects, request/system tests, Hotwire interactions, ViewComponents, Docker-based development, and CI security checks.

## Demo preview

### Task movement demo

![Task movement demo](docs/demo/move-task.gif)

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
- Hotwire/Turbo-powered modal interactions
- Stimulus-powered task movement between Kanban columns
- ViewComponent-based UI decomposition
- Service objects with explicit Result objects
- RSpec test suite: request, model, policy, service, system, and component specs
- Docker-based local development and test environment
- GitHub Actions CI with RSpec, RuboCop, Brakeman, Bundler Audit, and Importmap Audit

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
- Demo account with seeded workspace data
- Dashboard with workspace overview and recent projects
- Project CRUD
- Project settings page with a dedicated danger zone for destructive actions
- Nested task management inside projects
- Kanban board with task statuses: To Do, In Progress, Done
- Turbo-powered task creation modal
- Task details modal with full description preview
- Turbo-powered task editing and deletion
- Stimulus-powered task movement between columns
- Flash messages with manual dismiss and auto-dismiss behavior
- Server-side authorization for project and task access
- JSON contract for task movement endpoint
- Responsive Tailwind-based UI
- Protection against long user-generated text breaking the layout

## Architecture decisions

This project intentionally keeps the architecture simple, but separates responsibilities where it improves maintainability, security, or testability.

- Controllers handle HTTP concerns: authentication, authorization, params, redirects, and Turbo responses.
- Pundit policies and policy scopes protect user-owned resources and reduce IDOR risk.
- Service objects are used for business operations that may grow later, such as project creation, task creation, and task movement.
- Result objects make service outcomes explicit and easier to test without relying on controller state.
- ViewComponents are used for reusable UI pieces where extracting markup improves readability.
- Hotwire/Turbo is used for modal-based task interactions without introducing a separate frontend framework.
- Stimulus is used only where client-side behavior is needed, such as moving tasks between Kanban columns and dismissing flash messages.
- Docker keeps local development, test runs, and CI closer to the same environment.

The goal is not to over-engineer the application, but to show clear boundaries between HTTP, authorization, business logic, UI rendering, and client-side behavior.

## Testing and quality checks

The project includes multiple layers of automated checks to cover business logic, authorization, UI behavior, and security.

- Model specs for validations, associations, and database-level constraints.
- Request specs for authentication, authorization, CRUD behavior, invalid params, Turbo responses, and JSON contracts.
- Policy specs for Pundit access rules and ownership boundaries.
- Service specs for explicit business operations and Result objects.
- System specs for the main Hotwire/Turbo user flows.
- Component specs for reusable ViewComponent UI pieces.
- Brakeman for static security analysis.
- Bundler Audit and Importmap Audit for dependency checks.
- RuboCop for code style and consistency.
- Tailwind CSS build verification.
- Seed validation to ensure the demo dataset stays usable.

Run the full local CI pipeline:

```bash
docker compose run --rm --user "$(id -u):$(id -g)" -e HOME=/tmp test bin/ci
```

The CI pipeline is designed to verify the demo seeds without polluting the test database before the RSpec suite runs.

## Security and data protection

Security is one of the main focuses of this project.

The application protects user data through:

- Devise authentication
- Pundit authorization policies
- Policy scopes for user-owned records
- Nested resource lookup to reduce IDOR risk
- Strong parameters to prevent mass assignment
- Database constraints for authorization-sensitive fields
- Pundit verification safety net for controller actions
- Brakeman static analysis in CI
- Bundler Audit and Importmap Audit in CI

Examples of protected scenarios:

- A user cannot access another user's project by changing the project ID in the URL.
- A user cannot create a project for another user through forged `user_id` params.
- A user cannot update, delete, or move tasks from a project they do not own.
- A user cannot assign unsafe task attributes through forged form params.

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

The seed data creates a demo workspace with projects and Kanban tasks across all workflow statuses.

## Running checks locally

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

The same pattern is used by the full local CI command:

```bash
docker compose run --rm --user "$(id -u):$(id -g)" -e HOME=/tmp test bin/ci
```

## Project status

Current focus:

- Stable Kanban CRUD flow
- Secure project/task ownership boundaries
- Hotwire-based task creation, details, editing, and deletion flows
- Stimulus-based task movement
- RSpec coverage for core business, security, and UI scenarios
- Docker-based CI pipeline
- Portfolio-ready README with screenshots and demo data

Planned next improvements:

- Deployment
- CI/CD deployment preparation
- Background jobs for async notifications
- Basic audit trail for task status changes
- Optional AI task assistant integration

Not planned for the initial MVP:

- Billing
- Full public REST API
- RAG / vector search
- Complex enterprise permissions

These features may be added later only if they provide clear product value and do not turn the project into an over-engineered demo.
