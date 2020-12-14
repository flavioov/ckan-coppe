# ckan v2.9.0
Geoview - wms: funcionado!
Geoview - geojson: ????

### cli
ckan --config=/etc/ckan/production.ini <command>

### update ckan python packages
git fetch
git checkout ckan-2.9.1
pip install --upgrade -r requirements.txt
pip install --upgrade -r requirements-py2.txt
python setup.py develop

### goeview

[ogc](https://en.wikipedia.org/wiki/Open_Geospatial_Consortium)
[gis](https://en.wikipedia.org/wiki/Geographic_information_system)
[wcs](https://en.wikipedia.org/wiki/Web_Coverage_Service)
[wfs](https://en.wikipedia.org/wiki/Web_Feature_Service)
[wms](https://en.wikipedia.org/wiki/Web_Map_Service)

harvest - data de fontes e serviços existentes
publish - datação e documentação por upload direto
discover - data com ferramenta de alta capacidade de busca
use - visualização ou download de data

#### geoview - wms
1) apenas executar 'docker-compose up -d --build'
2) adicionar ao production.ini as configurações dos plugins em ./ckan-2.9/production.conf
3) para carregar o mapa com o geoview (formato wms)
   3.1) crair um dataset
   3.2) adicionar o arquivo /geostuff/openlayers
   3.3) formato do arquivo: wms

#### geoview - geojson

[update your sources using this](https://lists-archive.okfn.org/pipermail/ckan-dev/2016-July/021467.html):
ckan --config=/etc/ckan/production.ini views create geojson_view

