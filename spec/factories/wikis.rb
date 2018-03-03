FactoryBot.define do
  factory :wiki do
    sequence(:title) {|n| "Title#{n}"}
    sequence(:body) {|n| "This is body number #{n}"}
    private false
    user
    sequence(:slug) {|n| "Title#{n}"}
  end
end
