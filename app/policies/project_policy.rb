# frozen_string_literal: true

class ProjectPolicy < ApplicationPolicy
  # Who can see own projects?
  def index?
    user.present?
  end

  # Who can see specific project?
  def show?
    record.user_id == user.id || user.admin?
  end

  # Who can create projects?
  def create?
    user.manager? || user.admin?
  end

  def new?
    create?
  end

  # Who can update projects?
  def update?
    record.user_id == user.id || user.admin?
  end

  # Who can destroy projects?
  def destroy?
    record.user_id == user.id || user.admin?
  end

  class Scope < ApplicationPolicy::Scope
  end
end
