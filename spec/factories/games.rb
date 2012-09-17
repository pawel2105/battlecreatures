# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :game do
    word "MyString"
    choices "MyText"
    user nil
  end
end
