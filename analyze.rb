#!/usr/bin/env ruby

require 'json'
require 'nokogiri'
require 'csv'
require 'time'
require 'logger'
require 'set'

def to_num(value)
  (Integer(value) rescue Float(value)) rescue value
end

class Sink
  def initialize
    @keys = Set.new
    @sink = {}
  end

  def add(time, key, value)
    return false if value.nil?
    #return false if Time.parse('2016-04-01 08:00:00') > time
    time = time.to_i
    @sink[time] = {} unless @sink.include?(time)
    @sink[time][key] = value
    @keys.add(key)
    true
  end

  def save_csv(io)
    keys = @keys.to_a.sort
    csv = CSV.new(io)
    csv.puts(['timestamp', 'datetime'] + keys)
    @sink.keys.sort.each do |ts|
      cols = keys.map { |key| @sink[ts][key] }
      cols.unshift(ts, Time.at(ts).strftime('%F %T'))
      csv.puts(cols)
    end
  end

  def save_json(io)
    series = {}
    @sink.keys.sort.each do |ts|
      @sink[ts].each do |key, value|
        series[key] = [] unless series.include?(key)
        #value = (Integer(value) rescue Float(value)) rescue value
        series[key].push([ts * 1000, value])
      end
    end
    # io.write(JSON.pretty_generate(series))
    JSON.dump(series, io)
  end
end

sink = Sink.new
logger = Logger.new(STDERR)

files = Dir.glob('./meteoblue/*.json')
files.sort!
files.each do |path|
  md = path.match(/\/(\d{4}\-\d{2}-\d{2}T\d{6})-([a-z0-9_]+)\.json\z/)
  next unless md
  timestamp, location = Time.strptime(md[1], '%FT%H%M%S'), md[2]
  json = File.open(path, 'r') { |file| JSON.load(file) rescue nil }
  if json.nil?
    logger.warn { 'Invalid Meteoblue file [%s].' % path }
    next
  end
  current = json.fetch('current')
  ['temperature', 'wind_speed'].each do |name|
    sink.add(timestamp, ['meteoblue', location, name].join('.'), current[name])
  end
end

files = Dir.glob('./wunderground/*.json')
files.sort!
files.each do |path|
  md = path.match(/\/(\d{4}\-\d{2}-\d{2}T\d{6})-([a-z0-9_]+)\.json\z/)
  next unless md
  timestamp, location = Time.strptime(md[1], '%FT%H%M%S'), md[2]
  json = File.open(path, 'r') { |file| JSON.load(file) rescue nil }
  if json.nil?
    logger.warn { 'Invalid Weather Underground file [%s].' % path }
    next
  end
  current = json.fetch('current_observation')
  timestamp = Time.at(Integer(current.fetch('observation_epoch')))
  [
      ['wind_kph', 'wind_speed'],
      ['temp_c', 'temperature']
  ].each do |from, to|
    sink.add(timestamp, ['wunderground', location, to].join('.'), current[from])
  end
end

files = Dir.glob('./meteocentrale/*.html')
files.sort!
files.each do |path|
  md = path.match(/\/(\d{4}\-\d{2}-\d{2}T\d{6})-([a-z0-9_]+)\.html\z/)
  next unless md
  timestamp, location = Time.strptime(md[1], '%FT%H%M%S'), md[2]
  begin
  doc = Nokogiri::HTML(File.open(path))
  wind_speed = doc.css('#weather-detail-summary > div.column-2').first.text.match(/Avg\. wind speed: ([0-9]+(\.[0-9]+)?) km\/h/)[1]
  temperature = doc.css('#weather-detail-summary > div.column-4').first.text.match(/\A(\-?[0-9]+(\.[0-9]+)?)°C\z/)[1]
  sink.add(timestamp, ['meteocentrale', location, 'temperature'].join('.'), to_num(temperature))
  sink.add(timestamp, ['meteocentrale', location, 'wind_speed'].join('.'), to_num(wind_speed))
  rescue
    logger.warn { 'Parsing error Meteocentrale file [%s].' % path }
  end
end


files = Dir.glob('./topr/*.xml')
files.sort!
location_mapper = {
    'gor' => 'goryczkowa',
    'ps' => 'piec_stawow',
    'mo' => 'moko',
}
fields_mapper = {
    ['temperatura', 'aktualna'] => 'temperature',
    ['wiatr', 'silaAvg'] => 'wind_speed_avg',
    ['wiatr', 'silaMax'] => 'wind_speed_max',
}
files.each do |path|
  md = path.match(/\/(\d{4}\-\d{2}-\d{2}T\d{6})\.xml\z/)
  next unless md
  timestamp = Time.strptime(md[1], '%FT%H%M%S')
  doc = Nokogiri::XML(File.open(path)) { |config| config.noblanks }
  doc.xpath('/lokalizacje/lokalizacja').each do |location_node|
    location = location_mapper.fetch(location_node.attr(:id))
    location_timestamp = timestamp
    data = []
    location_node.traverse do |node|
      next unless node.text?
      path = []
      text = node.content
      node = node.parent
      while node != location_node do
        path.push(node.name)
        node = node.parent
      end
      path.reverse!
      if path == ['dateTimeStr']
        location_timestamp = Time.parse(text)
        next
      end
      path = fields_mapper[path]
      next if path.nil?
      data.push([['topr', location, path].join('.'), text])
    end
    data.each do |key, value|
	    value = to_num(value)
value = value * 3.6	    if key.include?('wind_speed')
      sink.add(location_timestamp, key, value)
    end
  end
end

# File.open('output.csv', 'w') do |file|
#   sink.save_csv(file)
# end

sink.save_json(STDOUT)
