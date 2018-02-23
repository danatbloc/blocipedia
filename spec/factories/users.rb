FactoryBot.define do
  factory :user do
    pw = "123456"
    sequence(:name) {|n| "User#{n}"}
    sequence(:email){|n| "user#{n}@factoryz123z.com" }
    password pw
    password_confirmation pw
    confirmed_at Time.now
  end
end
