def calFactor time
  case time
    when "05:00","06:00","07:00","08:00","09:00",
      "10:00","11:00","12:00","13:00","14:00",
      "15:00","16:00"
      return 2
    when "17:00","18:00","19:00"
      return 3
    else
      return 4
  end
end

# Create user admin
User.create!(name: "Thanh Long",
  email:"thanhlongdnit@gmail.com",
  phone: Faker::Number.leading_zero_number(digits: 10),
  password: "123456",
  password_confirmation: "123456",
  role: 1,
  confirmed_at: Time.zone.now)
  # actived: true,
  # actived_at: Time.zone.now

#Create user
30.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "123456"
  phone = Faker::Number.leading_zero_number(digits: 10)
  User.create!(name: name,
  email: email,
  phone: phone,
  password: password,
  password_confirmation: password,
  confirmed_at: Time.zone.now)
  # actived: true,
  # actived_at: Time.zone.now)
end

#Create Location
20.times do |n|
  name = Faker::Name.name
  phone= Faker::Number.leading_zero_number(digits: 10)
  address = Faker::Address.full_address
  district = ["Hai Chau","Thanh Khe","Lien Chieu","Son Tra","Ngu Hanh Son","Cam Le","Hoa Vang"]
  description = Faker::Lorem.sentence(word_count: 20)
  Location.create!(name:name,
  phone:phone,
  address:address,
  district:district.sample,
  description:description)
end

#Create Yard
60.times do |n|
  type=[5,7,11].sample.to_i
  code = type.to_s+["A","B","C","D","E","G"].sample
  Yard.create!(
  location_id: Location.pluck(:id).sample,
  code: code,
  type_yard: type)
end

# Create time_cost
1.times do |n|
  times = ["05:00","06:00","07:00","08:00","09:00",
          "10:00","11:00","12:00","13:00","14:00",
          "15:00","16:00","17:00","18:00","19:00",
          "20:00","21:00","22:00","23:00"]
  cost = 80000
  ids=Yard.limit(20).pluck(:id)
  ids.each do |id|
    times.each do |time|
      TimeCost.create!(
        yard_id: id,
        time: time,
        cost: cost*calFactor(time))
    end
  end
end

#Create booking
1.times do |n|
  users = User.limit(10).pluck(:id)
  users.each do |id|
    status = [0,1,2,3].sample
    Booking.create!(
      time_cost_id: TimeCost.pluck(:id).sample,
      user_id: id,
      status: status,
      note: Faker::Lorem.sentence(word_count: 10),
      booking_date: Faker::Date.between(from: '2020-10-23', to: '2020-12-01')
    )
  end
end

1.times do |n|
  users = User.limit(10).pluck(:id)
  users.each do |id|
    Comment.create!(
      location_id: Location.pluck(:id).sample,
      user_id: id,
      content: Faker::Lorem.sentence(word_count: 10)
    )
  end
end
