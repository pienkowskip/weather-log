require 'stringio'

class Snapshot < ApplicationRecord
  belongs_to :source, inverse_of: :snapshots, validate: true
  belongs_to :location, inverse_of: :snapshots, validate: true

  has_many :measurements, inverse_of: :snapshot, dependent: :destroy

  scope :ordered, -> { order(:created_at) }

  validates :created_at, :status, presence: true
  validates :status, inclusion: %w(created fetched parsed)

  def set_error(exception)
    self.error = exception.is_a?(Exception) ? self.class.error_to_text(exception) : exception
  end

  def self.error_to_text(exception)
    io = StringIO.new
    exc_to_s = ->(exc) { exc.message == exc.class.name ? exc.class.name : "#{exc.class.name}: #{exc.message}" }
    io.puts(exc_to_s.call(exception))
    exception.backtrace.each { |entry| io.puts("\tfrom #{entry}") }
    exc = exception
    cause_set = Set.new
    while exc.respond_to?(:cause) && exc.cause && cause_set.add?(exc.object_id)
      exc = exc.cause
      io.puts("Caused by: #{exc_to_s.call(exc)}")
      exc.backtrace.each { |entry| io.puts("\tfrom #{entry}") }
    end
    io.string
  end
end
