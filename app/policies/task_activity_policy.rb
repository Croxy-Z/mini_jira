# frozen_string_literal: true

class TaskActivityPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope.none unless user
      return scope.all if user.admin?

      scope.joins(:project).where(projects: { user_id: user.id })
    end
  end

  def show?
    user.admin? || record.project.user_id == user.id
  end
end
