# This controller should be used for account creation
class User < ApplicationRecord
  has_secure_password
end
