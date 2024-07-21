FactoryBot.define do
  factory :catalog_hour, class: 'Catalog::Hour' do
    # Define attributes here based on your model's schema
    start_at { "09:00" }
    end_at { "17:00" }
  end
end
