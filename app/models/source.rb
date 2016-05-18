class Source < ApplicationRecord
  validates :text_id, :name, presence: true
  validates :text_id, format: {with: /\A[a-z0-9_]+\z/}
end
