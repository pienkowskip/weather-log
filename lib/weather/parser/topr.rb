require 'nokogiri'
require 'time'

require_relative 'measurement'
require_relative 'parsing_error'

module Weather
  module Parser
    class Topr
      def parse(fetched_at, file)
        root = Nokogiri::XML(file) { |config| config.strict.nonet.noblanks }
        root = root.root
        measured_at = get_node_text(root, './dateTimeStr')
        measured_at = measured_at ? Time.parse(measured_at) : fetched_at
        results = []
        add_measurement = ->(xpath, name, unit) do
          text = get_node_text(root, xpath)
          results.push(Measurement.new(name, text, unit)) if text
        end
        add_measurement.call('./temperatura/aktualna', :temperature, '°C')
        add_measurement.call('./wiatr/silaAvg', :wind_speed, 'm/s')
        add_measurement.call('./wiatr/kierunek', :wind_direction, '°')
        return measured_at, results
      end

      private

      def get_node_text(root, xpath)
        set = root.xpath(xpath)
        raise ParsingError, 'XML element at [%s] XPath was not found.' % xpath if set.empty?
        raise ParsingError, 'XML element at [%s] XPath is ambiguous.' % xpath if set.size > 1
        node = set.first
        return nil if node.children.empty?
        raise ParsingError, 'Content of XML element at [%s] XPath is not only text.' % xpath if node.children.size > 1 || !node.child.text?
        text = node.child.text.strip
        text.empty? ? nil : text
      end
    end
  end
end