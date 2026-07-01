# frozen_string_literal: true

demo_user = User.find_or_initialize_by(email: "demo@example.com")
demo_user.assign_attributes(
  password: "password123",
  password_confirmation: "password123",
  role: :user
)
demo_user.save!

demo_projects = [
  {
    title: "Website redesign",
    description: "Demo project for showcasing the Kanban board workflow.",
    tasks: [
      {
        title: "Prepare project brief",
        description: "Collect requirements and define the scope of the redesign.",
        status: :to_do
      },
      {
        title: "Create wireframes",
        description: "Sketch the main pages and agree on the user flow before implementation.",
        status: :to_do
      },
      {
        title: "Review accessibility checklist",
        description: "Check color contrast, keyboard navigation, and semantic structure.",
        status: :to_do
      },
      {
        title: "Build responsive layout",
        description: "Create the main page layout with Tailwind CSS and reusable components.",
        status: :in_progress
      },
      {
        title: "Implement task creation modal",
        description: "Use Turbo Frames and Turbo Streams to create tasks without a full page reload.",
        status: :in_progress
      },
      {
        title: "Refactor task columns",
        description: "Extract shared empty-state markup and keep the DOM stable for Turbo updates.",
        status: :in_progress
      },
      {
        title: "Set up CI pipeline",
        description: "Run RuboCop, security checks, and RSpec in GitHub Actions.",
        status: :done
      },
      {
        title: "Add authorization policies",
        description: "Protect projects and tasks with Pundit scopes and nested resource lookup.",
        status: :done
      },
      {
        title: "Write regression system spec",
        description: "Cover the hidden empty-state behavior after Turbo task creation.",
        status: :done
      }
    ]
  },
  {
    title: "Mobile app launch",
    description: "Planning board for preparing a mobile product release.",
    tasks: [
      {
        title: "Define release checklist",
        description: "List the final tasks required before publishing the first mobile release.",
        status: :to_do
      },
      {
        title: "Prepare onboarding copy",
        description: "Write concise onboarding text for new users.",
        status: :to_do
      },
      {
        title: "Test authentication flow",
        description: "Verify registration, sign in, sign out, and password reset scenarios.",
        status: :in_progress
      },
      {
        title: "Review error states",
        description: "Check validation messages and failed request handling.",
        status: :done
      },
      {
        title: "Create release notes draft",
        description: "Summarize the first release features for internal review.",
        status: :done
      },
      {
        title: "Configure staging environment",
        description: "Prepare environment variables and database settings for staging.",
        status: :done
      }
    ]
  },
  {
    title: "Internal CRM cleanup",
    description: "Maintenance board for improving an internal customer management tool.",
    tasks: [
      {
        title: "Audit outdated customer fields",
        description: "Find unused fields and document which ones can be removed safely.",
        status: :to_do
      },
      {
        title: "Plan database constraint updates",
        description: "Identify columns that should have stronger null and default constraints.",
        status: :to_do
      },
      {
        title: "Fix flaky system spec",
        description: "Stabilize an asynchronous UI scenario by waiting for the correct DOM state.",
        status: :in_progress
      },
      {
        title: "Extract shared view partial",
        description: "Remove duplicated markup from related views.",
        status: :to_do
      },
      {
        title: "Patch authorization gap",
        description: "Ensure nested resources are always loaded through the authorized parent scope.",
        status: :done
      },
      {
        title: "Document security assumptions",
        description: "Explain IDOR protection, strong parameters, and policy scope boundaries.",
        status: :done
      }
    ]
  }
]

demo_projects.each do |project_attributes|
  project = demo_user.projects.find_or_initialize_by(title: project_attributes[:title])
  project.assign_attributes(description: project_attributes[:description])
  project.save!

  project_attributes[:tasks].each do |task_attributes|
    task = project.tasks.find_or_initialize_by(title: task_attributes[:title])
    task.assign_attributes(task_attributes)
    task.save!
  end
end
