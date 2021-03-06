class Property < ApplicationRecord
  has_many :series, inverse_of: :property, dependent: :destroy

  scope :ordered, -> { order(:text_id, :unit) }

  validates :text_id, :name, :unit, presence: true
  validates :text_id, text_id: true
  validates :unit, uniqueness: {scope: :text_id}
end
