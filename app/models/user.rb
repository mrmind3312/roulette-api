class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :availabilities, class_name: 'Users::Availability', foreign_key: 'users_id'

  # def jwt_payload
  #   super.merge({ email: })
  # end

  # It is executed when a token dispatched for that user instance, and it takes token and payload as parameters.
  # def on_jwt_dispatch(token, payload)
  #   do_something(token, payload)
  # end

  def show
    self_attributes = attributes.except(
      'encrypted_password',
      'reset_password_token',
      'reset_password_sent_at',
      'remember_created_at',
      'jti'
    )

    self_attributes[:availabilities] = users_availabilities.map do |user_availability|
      {
        service: user_availability.service&.name,
        start_at: user_availability.catalog_hour.start_at,
        end_at: user_availability.catalog_hour.end_at
      }
    end

    self_attributes
  end
end
