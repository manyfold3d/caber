module Caber::Object
  extend ActiveSupport::Concern

  included do
    scope :with_permission, ->(permission) { where("caber_relations.permission": permission) }
  end

  def grant_permission_to(permission, subject)
    Caber::Relation.create!(subject: subject, permission: permission, object: self)
  end

  def grants_permission_to?(permission, subject)
    Caber::Relation.where(object: self, subject: [subject, nil], permission: permission).present?
  end
end
