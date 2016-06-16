require 'minitest/mock'

require 'weather/fetcher/fetching_error'
require 'weather/fetcher/topr'
require 'weather/parser/topr'

namespace :db do
  namespace :snapshots do
    desc 'Loads meteo snapshots from files.'
    task load: :environment do
      logger = Logger.new(STDOUT)
      logger.level = Logger::INFO
      Rails.logger = logger
      topr = Source.find_by!(text_id: :topr)
      locations = Location.ordered.distinct.joins(:series).where(series: {source: topr})
      series_map = {}
      topr.series.includes(:property).each do |series|
        series_map[[series.location_id, series.property.text_id, series.property.unit]] = series
      end
      fetcher = Weather::Fetcher::Topr.new
      parser = Weather::Parser::Topr.new
      next_progress_info = Time.now + 30
      FileList['./snapshots/topr/*.xml'].sort.each do |filename|
        md = /\/(\d{4})-(\d{2})-(\d{2})T(\d{6})\.xml\z/.match(filename)
        unless md
          logger.warn { 'Snapshot filename [%s] did not matched date regexp. Skipping.' % filename }
          next
        end
        fetched_at = Time.parse(md[1..-1].join(''))
        if Time.now > next_progress_info
          logger.info { 'Progress: parsing TOPR file fetched at [%s].' % fetched_at }
          next_progress_info = Time.now + 30
        end
        xml = nil
        read_cache = -> do
          xml = File.read(filename) if xml.nil?
          raise Weather::Fetcher::FetchingError, 'Empty file served.' if xml.empty?
          return fetched_at, xml
        end
        fetcher.stub :read_cache, read_cache do
          locations.each do |location|
            Snapshot.transaction do
              snapshot = Snapshot.create!(source: topr, location: location, created_at: fetched_at, status: :created)
              begin
                _, file = fetcher.fetch(location, topr.config)
                snapshot.file = file
                snapshot.media_type = 'text/xml'
                snapshot.status = :fetched
                snapshot.save!
                measured_at, measurements = parser.parse(fetched_at, file)
                Measurement.transaction(requires_new: true) do
                  measurements.each do |msrm|
                    msrm_series = series_map[[location.id, msrm.what.to_s, msrm.unit]]
                    raise ActiveRecord::RecordNotFound, 'Series not found for [%s] measurement returned by parser.' % msrm.to_json unless msrm_series
                    same_msrm = Measurement.find_by(series: msrm_series, created_at: measured_at)
                    if same_msrm
                      logger.warn do
                        'Different measurement for same [%s] time, [%s] series and [%s] location. Current: [%s] vs new: [%s]. Parsed file: [%s]. Ignoring.' %
                            [measured_at, msrm.what, location.text_id, same_msrm.value, msrm.value, filename]
                      end unless same_msrm.value == msrm.value
                      next
                    end
                    Measurement.create!(series: msrm_series, snapshot: snapshot, created_at: measured_at, value: msrm.value)
                  end
                  snapshot.status = :parsed
                  snapshot.save!
                end
              rescue ActiveRecord::ActiveRecordError
                raise
              rescue => error
                logger.warn { 'Problem with [%s] snapshot file. Error: [%s].' % [filename, error.inspect] }
                snapshot.set_error(error)
                snapshot.save!
              end
            end
          end
        end
      end
    end
  end
end