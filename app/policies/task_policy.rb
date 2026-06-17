# frozen_string_literal: true

class TaskPolicy < ApplicationPolicy
  def show?
    owner? || admin?
  end

  def create?
    owner? || admin?
  end

  def update?
    owner? || admin?
  end

  def move?
    update?
  end

  def edit?
    update?
  end

  def destroy?
    owner? || admin?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.none unless user
      return scope.all if user.admin?

      scope.joins(:project).where(projects: { user_id: user.id })
    end
  end

  private

  def owner?
    record.project.user_id == user.id
  end

  def admin?
    user.admin?
  end
end
