FactoryBot.define do
  factory :wiki do
    sequence(:title) {|n| "Title#{n}"}
    sequence(:body) {|n| "This is body number #{n}"}
    private false
    user
  end
end
