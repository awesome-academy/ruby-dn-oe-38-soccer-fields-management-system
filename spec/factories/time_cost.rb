FactoryBot.define do
  factory :time_cost do
    yard_id {Yard.first.id}
    time {"05:00"}
    cost {100000}
  end
end
