# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :game do
    word "better"
    choices "MyText"
    user
    factory :won_game do
      choices{ word }
    end
    factory :lost_game do
      choices{ "zzzzzzzzzzzzzzz" }
    end
  end
end
