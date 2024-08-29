module Caber::Subject
  extend ActiveSupport::Concern

  included do
    has_many :caber_relations, as: :subject, class_name: "Caber::Relation", dependent: :destroy
    scope :with_permission, ->(permission) { where("caber_relations.permission": permission) }

    def self.can_have_permissions_on(model)
      has_many :"permitted_#{model.name.pluralize.parameterize}", through: :caber_relations, source: :object, source_type: model.name
    end
  end

  def has_permission_on?(permission, object)
    object.grants_permission_to? permission, self
  end
end
