FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "developer#{n}@recorrido.cl" }
    password { 'password' }
  end
end
