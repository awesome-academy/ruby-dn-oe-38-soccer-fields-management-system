FactoryBot.define do
  factory :yard do
    location_id {Location.first.id}
    code {["A","B","C","D","E","G"].sample}
    type_yard {[5,7,11].sample.to_i}
  end
end
