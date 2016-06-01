class Source < ApplicationRecord
  has_many :snapshots, inverse_of: :source, dependent: :destroy
  has_many :series, inverse_of: :source, dependent: :destroy

  validates :text_id, :name, presence: true
  validates :text_id, text_id: true
end
