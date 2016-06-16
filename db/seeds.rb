topr = Source.create!(text_id: :topr, name: 'TOPR')

morskie_oko = Location.create!(text_id: :morskie_oko, name: 'Schronisko nad Morskim Okiem', latitude: '49.201389', longitude: '20.071306', elevation: 1410)
piec_stawow = Location.create!(text_id: :piec_stawow, name: 'Schronisko w Dolinie Pięciu Stawów', latitude: '49.213611', longitude: '20.04875', elevation: 1671)
kasprowy_wierch = Location.create!(text_id: :kasprowy_wierch, name: 'Kasprowy Wierch (Obserwatorium)', latitude: '49.232528', longitude: '19.981833', elevation: 1987)

temperature_c = Property.create!(text_id: :temperature, name: 'Temperatura', unit: '°C')
wind_speed_ms = Property.create!(text_id: :wind_speed, name: 'Prędkość wiatru', unit: 'm/s')
wind_direction = Property.create!(text_id: :wind_direction, name: 'Kierunek wiatru', unit: '°')

[topr].product([morskie_oko, piec_stawow, kasprowy_wierch], [temperature_c, wind_speed_ms, wind_direction]).each do |source, location, property|
  Series.create!(source: source, location: location, property: property)
end