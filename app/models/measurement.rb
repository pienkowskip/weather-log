class Measurement < ApplicationRecord
  belongs_to :series, inverse_of: :measurements, validate: true
  belongs_to :snapshot, inverse_of: :measurements, validate: true

  scope :ordered, -> { order(:created_at) }

  validates :created_at, :value, presence: true
  validates :value, numericality: true
  validates :created_at, uniqueness: {scope: :series}
end
