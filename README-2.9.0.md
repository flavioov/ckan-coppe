# ckan v2.9.0

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

