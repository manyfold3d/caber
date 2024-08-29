class Document < ApplicationRecord
  include Caber::Object

  can_grant_permissions_to User
end
