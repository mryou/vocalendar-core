class ExLinkAccess < ApplicationRecord
  default_scope -> { order('created_at desc') }
  belongs_to :ex_link, required: false
end
