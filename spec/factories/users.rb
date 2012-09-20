# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:name) {|n| "User #{n}" }
    sequence(:uid) {|n| "uid#{n}" }
    provider "mxit"
  end
end
