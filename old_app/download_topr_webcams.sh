#!/bin/bash

set +e

date=`date '+%FT%H%M%S'`

wget -nv -O "snapshots/topr/${date}-moko_1.jpg" 'http://kamery.topr.pl/moko/moko_01.jpg'
wget -nv -O "snapshots/topr/${date}-moko_2.jpg" 'http://kamery.topr.pl/moko_TPN/moko_02.jpg'
wget -nv -O "snapshots/topr/${date}-piec_stawow.jpg" 'http://kamery.topr.pl/stawy2/stawy2.jpg'
wget -nv -O "snapshots/topr/${date}-piec_stawow_buczynowa.jpg" 'http://kamery.topr.pl/stawy1/stawy1.jpg'
wget -nv -O "snapshots/topr/${date}-gasienicowa.jpg" 'http://kamery.topr.pl/gasienicowa/gasie.jpg'
wget -nv -O "snapshots/topr/${date}-goryczkowa.jpg" 'http://kamery.topr.pl/goryczkowa/gorycz.jpg'
wget -nv -O "snapshots/topr/${date}-chocholowska.jpg" 'http://kamery.topr.pl/chocholowska/chocholow.jpg'
