module Caber::Object
  extend ActiveSupport::Concern

  included do
  end

  def grant_permission_to(permission, subject)
    Caber::Relation.create!(subject: subject, permission: permission, object: self)
  end

  def grants_permission_to?(permission, subject)
    Caber::Relation.where(object: self, subject: [subject, nil], permission: permission).present?
  end
end
