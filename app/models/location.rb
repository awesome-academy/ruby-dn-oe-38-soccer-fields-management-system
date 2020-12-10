class Location < ApplicationRecord
  has_many :yards, dependent: :destroy
  has_many :comments, dependent: :destroy

  ransack_alias :location, :name_or_phone_address

  scope :order_by_name, ->{order :name}

  VALID_PHONE_REGEX = /\A\d[0-9]{9}\z/.freeze
  validates :name, presence: true,
            length: {maximum: Settings.model.default}
  validates :phone, presence: true,
            format: {with: VALID_PHONE_REGEX}
  validates :address, presence: true,
            length: {maximum: Settings.model.default}
  validates :district, presence: true,
            length: {maximum: Settings.model.default}
  scope :search_name, (lambda do |param|
    where("lower(name) LIKE :search", search: "%#{param}%") if param.present?
  end)
end
