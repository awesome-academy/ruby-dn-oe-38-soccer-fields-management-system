class Location < ApplicationRecord
  has_many :yards, dependent: :destroy

  scope :order_by_name, ->{order :name}

  VALID_PHONE_REGEX = /\A\d[0-9]{9}\z/.freeze
  validates :name, presence: true,
            length: {maximum: Settings.model.user.name_max}
  validates :phone, presence: true,
            format: {with: VALID_PHONE_REGEX}
  validates :address, presence: true,
            length: {maximum: Settings.model.user.name_max}
  validates :distric, presence: true,
            length: {maximum: Settings.model.user.name_max}
end
