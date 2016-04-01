FactoryGirl.define do
  factory :api_key do
    sequence(:key) { |n| "key_#{n}" }
    public_key "MyText"
    private_key "MyText"
    enabled false
  end

end
