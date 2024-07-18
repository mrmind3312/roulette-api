class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :users_availabilities, class_name: 'Users::Availability', foreign_key: 'users_id'

  # def jwt_payload
  #   super.merge({ email: })
  # end

  # It is executed when a token dispatched for that user instance, and it takes token and payload as parameters.
  # def on_jwt_dispatch(token, payload)
  #   do_something(token, payload)
  # end
end