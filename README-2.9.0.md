
# ckan v2.9.0

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



[update your sources using this](https://lists-archive.okfn.org/pipermail/ckan-dev/2016-July/021467.html):
ckan --config=/etc/ckan/production.ini views create geojson_view

#adicionar "storage.py" (copiado do ckan v2.6.9) em ckan/controller/storage.py
#adicionar "db.py" (copiado do ckan v2.6.9) em ckanext/datastore/db.py


erro ao logar com usuario do ckan:
```text
 File "/usr/lib/ckan/venv/src/ckan/ckan/lib/helpers.py", line 1594, in get_display_timezone
    return tzlocal.get_localzone()
  File "/usr/lib/ckan/venv/local/lib/python2.7/site-packages/tzlocal/unix.py", line 123, in get_localzone
    _cache_tz = _get_localzone()
  File "/usr/lib/ckan/venv/local/lib/python2.7/site-packages/tzlocal/unix.py", line 117, in _get_localzone
    raise pytz.UnknownTimeZoneError('Can not find any timezone configuration')
UnknownTimeZoneError: 'Can not find any timezone configuration'
```

