FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "l#{n}@email.com" }
    password '12345678'
    password_confirmation '12345678'
  end
end
