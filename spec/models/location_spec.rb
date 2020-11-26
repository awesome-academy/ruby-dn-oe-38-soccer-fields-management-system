require "rails_helper"

RSpec.describe Location, type: :model do
  describe "associations" do
    it {should have_many(:yards)}
    it {should have_many(:comments)}
  end

  describe "validations" do
    it {should validate_presence_of(:name) }
    it {should validate_length_of(:name).is_at_most(Settings.rspec.model.length_character)}
    it {should validate_presence_of(:phone)}
    it {should allow_value(Faker::Number.leading_zero_number(digits: 10)).for(:phone)}
    it {should validate_presence_of(:address) }
    it {should validate_length_of(:address).is_at_most(Settings.rspec.model.length_character)}
    it {should validate_presence_of(:district) }
    it {should validate_length_of(:district).is_at_most(Settings.rspec.model.length_character)}
  end

  describe "scope search yard" do
    it "search with no input" do
      expect(Location.search_name("")).to be_truthy
    end
    it "search with valid input" do
      expect(Location.search_name("H")).to be_truthy
    end
    it "search with invalid input" do
      expect(Location.search_name("***")).to match_array([])
    end
  end
end
