FactoryGirl.define do
  factory :battle do
    created_at 1.minute.ago
    choices "cat"
    score 1
    user
  end
end
