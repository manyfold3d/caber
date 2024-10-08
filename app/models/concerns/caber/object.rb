module Caber::Object
  extend ActiveSupport::Concern

  included do
    has_many :caber_relations, as: :object, class_name: "Caber::Relation", dependent: :destroy
    scope :with_permission, ->(permission) { where("caber_relations.permission": permission) }

    def self.can_grant_permissions_to(model)
      has_many :"permitted_#{model.name.pluralize.parameterize}", through: :caber_relations, source: :subject, source_type: model.name
    end

    scope :granted_to, ->(permission, subject) {
                         includes(:caber_relations).where(
                           "caber_relations.subject": subject,
                           "caber_relations.permission": permission
                         )
                       }
  end

  def grant_permission_to(permission, subject)
    rel = Caber::Relation.find_or_initialize_by(subject: subject, object: self)
    rel.permission = permission
    rel.save!
  end

  def grants_permission_to?(permission, subject)
    Caber::Relation.where(object: self, subject: [subject, nil], permission: permission).present?
  end

  def revoke_permission(permission, subject)
    Caber::Relation.where(object: self, subject: subject, permission: permission).destroy_all
  end

  def revoke_all_permissions(subject)
    Caber::Relation.where(object: self, subject: subject).destroy_all
  end
end
