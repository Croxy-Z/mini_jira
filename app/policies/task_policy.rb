# frozen_string_literal: true

class TaskPolicy < ApplicationPolicy
  def show?
    record.project.user_id == user.id || user.admin?
  end

  def create?
    record.project.user_id == user.id || user.admin?
  end

  def update?
    show?
  end

  def destroy?
    show?
  end

  class Scope < ApplicationPolicy::Scope
  end
end
