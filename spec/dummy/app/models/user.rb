class User < ApplicationRecord
  include Caber::Subject

  can_have_permissions_on Document
end
