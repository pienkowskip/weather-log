#!/bin/bash

set +e

date=`date '+%FT%H%M%S'`

wget -nv -O "topr/${date}.xml" 'http://www.test.tatrynet.pl/pogoda/weatherMiddleware_v1.0/xml/lokalizacje1.xml'
wget -nv -O "topr/${date}-moko_1.jpg" 'http://kamery.topr.pl/moko/moko_01.jpg'
wget -nv -O "topr/${date}-moko_2.jpg" 'http://kamery.topr.pl/moko_TPN/moko_02.jpg'
wget -nv -O "topr/${date}-piec_stawow.jpg" 'http://kamery.topr.pl/stawy2/stawy2.jpg'
wget -nv -O "topr/${date}-piec_stawow_buczynowa.jpg" 'http://kamery.topr.pl/stawy1/stawy1.jpg'
wget -nv -O "topr/${date}-gasienicowa.jpg" 'http://kamery.topr.pl/gasienicowa/gasie.jpg'
wget -nv -O "topr/${date}-goryczkowa.jpg" 'http://kamery.topr.pl/goryczkowa/gorycz.jpg'
wget -nv -O "topr/${date}-chocholowska.jpg" 'http://kamery.topr.pl/chocholowska/chocholow.jpg'

wget -nv -O "meteoblue/${date}-rysy.json" 'http://my.meteoblue.com/dataApi/dispatch.pl?apikey=41f2dd49fb6a&type=json_7day_3h_firstday&lat=49.179444&lon=20.088333&asl=2503'
wget -nv -O "meteoblue/${date}-moko.json" 'http://my.meteoblue.com/dataApi/dispatch.pl?apikey=41f2dd49fb6a&type=json_7day_3h_firstday&lat=49.201389&lon=20.071306&asl=1410'
wget -nv -O "meteoblue/${date}-kasprowy.json" 'http://my.meteoblue.com/dataApi/dispatch.pl?apikey=41f2dd49fb6a&type=json_7day_3h_firstday&lat=49.231833&lon=19.981556&asl=1987'
wget -nv -O "meteoblue/${date}-lomnica.json" 'http://my.meteoblue.com/dataApi/dispatch.pl?apikey=41f2dd49fb6a&type=json_7day_3h_firstday&lat=49.195556&lon=20.2125&asl=2634'

wget -nv -O "meteocentrale/${date}-lomnica.html" 'http://www.meteocentrale.ch/en/europe/slovakia/weather-lomnicky-stit/details/S119300/'

wget -nv -O "wunderground/${date}-lomnica.json" 'http://api.wunderground.com/api/cdd30e71cfa957a1/conditions/q/zmw:00000.1.11930.json'
