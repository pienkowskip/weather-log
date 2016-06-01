class Snapshot < ApplicationRecord
  belongs_to :source, inverse_of: :snapshots, validate: true
  belongs_to :location, inverse_of: :snapshots, optional: true, validate: true

  has_many :measurements, inverse_of: :snapshot, dependent: :destroy

  validates :created_at, :status, presence: true
  validates :status, inclusion: %w(created fetched parsed)
end
