#!/bin/bash

set +e

date=`date '+%FT%H%M%S'`
wget -nv -O "snapshots/topr/${date}.xml" 'http://www.test.tatrynet.pl/pogoda/weatherMiddleware_v1.0/xml/lokalizacje1.xml'

date=`date '+%FT%H%M%S'`
wget -nv -O "snapshots/meteoblue/${date}-rysy.json" 'http://my.meteoblue.com/dataApi/dispatch.pl?apikey=41f2dd49fb6a&type=json_7day_3h_firstday&lat=49.179444&lon=20.088333&asl=2503'
wget -nv -O "snapshots/meteoblue/${date}-moko.json" 'http://my.meteoblue.com/dataApi/dispatch.pl?apikey=41f2dd49fb6a&type=json_7day_3h_firstday&lat=49.201389&lon=20.071306&asl=1410'
wget -nv -O "snapshots/meteoblue/${date}-kasprowy.json" 'http://my.meteoblue.com/dataApi/dispatch.pl?apikey=41f2dd49fb6a&type=json_7day_3h_firstday&lat=49.231833&lon=19.981556&asl=1987'
wget -nv -O "snapshots/meteoblue/${date}-lomnica.json" 'http://my.meteoblue.com/dataApi/dispatch.pl?apikey=41f2dd49fb6a&type=json_7day_3h_firstday&lat=49.195556&lon=20.2125&asl=2634'
wget -nv -O "snapshots/meteoblue/${date}-jungfraujoch.json" 'http://my.meteoblue.com/dataApi/dispatch.pl?apikey=41f2dd49fb6a&type=json_7day_3h_firstday&lat=46.55&lon=7.98&asl=3576'
wget -nv -O "snapshots/meteoblue/${date}-pian_rosa.json" 'http://my.meteoblue.com/dataApi/dispatch.pl?apikey=41f2dd49fb6a&type=json_7day_3h_firstday&lat=45.93&lon=7.70&asl=3488'

date=`date '+%FT%H%M%S'`
wget -nv -O "snapshots/meteocentrale/${date}-lomnica.html" 'http://www.meteocentrale.ch/en/europe/slovakia/weather-lomnicky-stit/details/S119300/'
wget -nv -O "snapshots/meteocentrale/${date}-jungfraujoch.html" 'http://www.meteocentrale.ch/en/europe/switzerland/weather-jungfraujoch/details/S067300/'
wget -nv -O "snapshots/meteocentrale/${date}-pian_rosa.html" 'http://www.meteocentrale.ch/en/europe/italy/weather-pian-rosa/details/S160520/'
wget -nv -O "snapshots/meteocentrale/${date}-grindelwald.html" 'http://www.meteocentrale.ch/en/europe/switzerland/weather-grindelwald/details/S069038/'

date=`date '+%FT%H%M%S'`
wget -nv -O "snapshots/wunderground/${date}-lomnica.json" 'http://api.wunderground.com/api/cdd30e71cfa957a1/conditions/q/zmw:00000.1.11930.json'
wget -nv -O "snapshots/wunderground/${date}-jungfraujoch.json" 'http://api.wunderground.com/api/cdd30e71cfa957a1/conditions/q/zmw:00000.1.06730.json'
wget -nv -O "snapshots/wunderground/${date}-pian_rosa.json" 'http://api.wunderground.com/api/cdd30e71cfa957a1/conditions/q/zmw:00000.1.16052.json'
wget -nv -O "snapshots/wunderground/${date}-grindelwald.json" 'http://api.wunderground.com/api/cdd30e71cfa957a1/conditions/q/pws:IGRINDEL11.json'

./analyze.rb > web/data.json
