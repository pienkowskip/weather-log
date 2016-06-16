require 'thread'
require 'monitor'

require_relative 'wget'
require_relative '../../bigdecimal_ext'

module Weather
  module Fetcher
    class Topr < Wget
      include MonitorMixin

      def self.uniform_location(latitude, longitude, elevation)
        [latitude, longitude, elevation].map(&BigDecimal.method(:new!))
      end

      URL = 'http://www.pogoda.tatrynet.pl/pogoda/weatherMiddleware_v1.0/xml/lokalizacje1.xml'.freeze
      CACHE_TIMEOUT = 30
      LOCATION_XML_ID_MAP = {
          uniform_location('49.232528', '19.981833', 1987) => 'gor',
          uniform_location('49.213611', '20.04875', 1671) => 'ps',
          uniform_location('49.201389', '20.071306', 1410) => 'mo',
      }.freeze

      def initialize
        super
        @fetched_at = nil
        @cache = nil
        @cache_evicter = nil
      end

      def fetch(location, source_config)
        id = LOCATION_XML_ID_MAP[self.class.uniform_location(location.latitude, location.longitude, location.elevation)]
        raise FetchingError, 'Location not supported.' unless id
        fetched_at, xml = read_cache
        unless fetched_at
          fetched_at, xml = super(URL)
          write_cache(fetched_at, xml)
        end
        md = /<lokalizacja id="#{Regexp.escape(id)}">.+?<\/lokalizacja>/m.match(xml)
        raise FetchingError, 'XML element with [%s] id not found in response.' % id unless md
        return fetched_at, md[0]
      end

      private

      def read_cache
        synchronize do
          evict_cache if @fetched_at && @fetched_at < Time.now - CACHE_TIMEOUT
          return @fetched_at, @cache
        end
      end

      def write_cache(fetched_at, xml)
        synchronize do
          return if @fetched_at && @fetched_at >= fetched_at
          evict_cache
          @fetched_at = fetched_at
          @cache = xml
          @cache_evicter = Thread.new do
            sleep(CACHE_TIMEOUT)
            evict_cache
          end
        end
      end

      def evict_cache
        synchronize do
          @fetched_at = nil
          @cache = nil
          if @cache_evicter
            @cache_evicter.kill unless @cache_evicter == Thread.current
            @cache_evicter = nil
          end
        end
      end
    end
  end
end