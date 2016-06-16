class Location < ApplicationRecord
  has_many :snapshots, inverse_of: :location, dependent: :destroy
  has_many :series, inverse_of: :location, dependent: :destroy

  scope :ordered, -> { order(:text_id) }

  validates :text_id, :name, presence: true
  validates :text_id, text_id: true, uniqueness: true
  validates :latitude, :longitude, :elevation, numericality: true, allow_blank: true
end
