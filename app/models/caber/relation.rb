class Caber::Relation < ActiveRecord::Base
  belongs_to :subject, polymorphic: true, required: false
  belongs_to :object, polymorphic: true

  validates :permission, inclusion: {in: Caber.configuration.permissions}
end
