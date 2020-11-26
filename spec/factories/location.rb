FactoryBot.define do
  factory :location do
    name {Faker::Name.name}
    phone {Faker::PhoneNumber.subscriber_number(length: 10)}
    address {Faker::Address.full_address}
    district {["Hai Chau","Thanh Khe","Lien Chieu","Son Tra","Ngu Hanh Son","Cam Le","Hoa Vang"].sample}
    description {Faker::Lorem.sentence(word_count: 20)}
  end
end
