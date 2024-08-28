module Caber::Subject
  extend ActiveSupport::Concern

  included do
  end

  def has_permission_on?(permission, object)
    object.grants_permission_to? permission, self
  end
end
