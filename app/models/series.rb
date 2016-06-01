class Series < ApplicationRecord
  belongs_to :source, inverse_of: :series, validate: true
  belongs_to :location, inverse_of: :series, validate: true
  belongs_to :property, inverse_of: :series, validate: true

  has_many :measurements, inverse_of: :series, dependent: :destroy

  validates :property_id, uniqueness: {scope: [:location_id, :source_id]}
end
