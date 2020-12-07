FactoryBot.define do
  factory :user do
    name {Faker::FunnyName.name}
    email {Faker::Internet.free_email}
    phone {Faker::Number.leading_zero_number(digits: 10)}
    password {"123123"}
    password_confirmation {"123123"}
    trait :user do
      role {User.roles[:user]}
    end
    trait :admin do
      role {User.roles[:admin]}
    end
    actived {true}
    actived_at {Time.now}
  end
end
