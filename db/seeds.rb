# frozen_string_literal: true

demo_user = User.find_or_initialize_by(email: "demo@example.com")
demo_user.assign_attributes(
  password: "password123",
  password_confirmation: "password123",
  role: :user
)
demo_user.save!

demo_project = demo_user.projects.find_or_initialize_by(title: "Website redesign")
demo_project.assign_attributes(
  description: "Demo project for showcasing the Kanban board workflow."
)
demo_project.save!

demo_tasks = [
  {
    title: "Prepare project brief",
    description: "Collect requirements and define the scope of the redesign.",
    status: :to_do
  },
  {
    title: "Build responsive layout",
    description: "Create the main page layout with Tailwind CSS and reusable components.",
    status: :in_progress
  },
  {
    title: "Set up CI pipeline",
    description: "Run RuboCop, security checks, and RSpec in GitHub Actions.",
    status: :done
  }
]

demo_tasks.each do |attributes|
  task = demo_project.tasks.find_or_initialize_by(title: attributes[:title])
  task.assign_attributes(attributes)
  task.save!
end
