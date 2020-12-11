FactoryBot.define do
  factory :booking do
    time_cost_id {TimeCost.first.id}
    user_id {User.first.id}
    note {Faker::Lorem.sentence(word_count: 10)}
    trait :today do
      booking_date {Date.today.to_s}
      status {0}
    end
    trait :next_date do
      booking_date {(Date.today+1).to_s}
      status {0}
    end
    trait :accept do
      booking_date {(Date.today+1).to_s}
      status {1}
    end
  end
end
