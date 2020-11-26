# ckan-coppe

# Instalação ckan via pacote
obs: CKAN 2.8 is Python 2.x only.
     CKAN 2.9 is planned to be compatible with both Python 2 and Python 3.
     CKAN 3.0 released afterward would be Python 3 only.

erro:\
ModuleNotFoundError: No module named 'distutils.core'\
solução:\
apt-get install python3-pip\


# instalação via 'sources'

erro:\
```text
 from ez_setup import use_setuptools
      File "/tmp/pip-install-w8xyavl0/repoze-who-friendlyform/ez_setup.py", line 94
        except pkg_resources.VersionConflict, e:

```
[stackoverflow](https://stackoverflow.com/questions/51272437/command-python-setup-py-egg-info-failed-with-error-code-1-in-tmp-pip-install)
"
https://pypi.org/project/unroll/#history — last release was in 2014. ez_setup.use_setuptools also was deprecated from
setuptools many years ago (it was so long ago I don't remember when). A bug report was opened in 2017 — still hasn't
got any replies from the author. The code seems too old and abandoned, and I'm sure it doesn't work with Python 3.
"

obs: ubuntu 20 não possui o repositorio para o pip2(python2)

solução:
- adicionar repositórrio do pip2
- instalar python 2 e pip2 manualmente
- usar o comando pip2 ao inves de pip
- instalar o virutalvenv (pip2 install virtualvenv)

```text
RUN apt-get install software-properties-common -y
RUN add-apt-repository universe -y && apt update  && apt-get upgrade -y \
    && apt install -y python2 curl && curl https://bootstrap.pypa.io/get-pip.py --output get-pip.py && python2 get-pip.py

pip2 install {...} virtualenv {...}

```

### postgres dockerfile
[config](https://www.postgresql.org/download/linux/ubuntu/)


```
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install postgresql
```
erro:\
E: gnupg, gnupg2 and gnupg1 do not seem to be installed, but one of them is required for this operation

```text
apt-get isntall gnupg gnupg1 gnupg2
```

# Instalação via docker-compose
obs: CKAN 2.8 is Python 2.x only.
     CKAN 2.9 is planned to be compatible with both Python 2 and Python 3.
     CKAN 3.0 released afterward would be Python 3 only.

## checkout tags/ckan-2.8.6

Debian Gis repo:
https://debian-gis-team.pages.debian.net/

erro 'db command not found':
solução:
 * remover todos os volumes docker: docker volumes prune e reinstalar novamente

error ao inicializar o container: 
```text

sqlalchemy.exc.ProgrammingError: (psycopg2.ProgrammingError) column user.password does not exist
LINE 1: SELECT "user".password AS user_password, "user".id AS user_i...

SQL: 'SELECT "user".password AS user_password, "user".id AS user_id, "user".name AS user_name, 
"user".fullname AS user_fullname, "user".email AS user_email, "user".apikey AS user_apikey, "user".created 
AS user_created, "user".reset_key AS user_reset_key, "user".about AS user_about, "user".activity_streams_email_notifications 
AS user_activity_streams_email_notifications, "user".sysadmin AS user_sysadmin, "user".state AS user_state \nFROM "user" 
\nWHERE "user".name = %(name_1)s OR "user".id = %(id_1)s ORDER BY "user".name \n LIMIT %(param_1)s'] [parameters: 
{'name_1': 'default', 'param_1': 1, 'id_1': 'default'}]

```
solução: postgres estava instalado na máquina e estava dando conflito com o container. Deletar postgres da máquina.

erro: pip install gsconfig (requirements from geoserver)
```text
ERROR: Exception:
Traceback (most recent call last):
  File "/usr/lib/ckan/venv/local/lib/python2.7/site-packages/pip/_internal/cli/base_command.py", line 228, in _main
    status = self.run(options, args)
  File "/usr/lib/ckan/venv/local/lib/python2.7/site-packages/pip/_internal/cli/req_command.py", line 182, in wrapper
    return func(self, options, args)
  File "/usr/lib/ckan/venv/local/lib/python2.7/site-packages/pip/_internal/commands/install.py", line 324, in run
    reqs, check_supported_wheels=not options.target_dir
  File "/usr/lib/ckan/venv/local/lib/python2.7/site-packages/pip/_internal/resolution/legacy/resolver.py", line 183, in resolve
    discovered_reqs.extend(self._resolve_one(requirement_set, req))
  File "/usr/lib/ckan/venv/local/lib/python2.7/site-packages/pip/_internal/resolution/legacy/resolver.py", line 388, in _resolve_one
    abstract_dist = self._get_abstract_dist_for(req_to_install)
  File "/usr/lib/ckan/venv/local/lib/python2.7/site-packages/pip/_internal/resolution/legacy/resolver.py", line 340, in _get_abstract_dist_for
    abstract_dist = self.preparer.prepare_linked_requirement(req)
  File "/usr/lib/ckan/venv/local/lib/python2.7/site-packages/pip/_internal/operations/prepare.py", line 483, in prepare_linked_requirement
    req, self.req_tracker, self.finder, self.build_isolation,
  File "/usr/lib/ckan/venv/local/lib/python2.7/site-packages/pip/_internal/operations/prepare.py", line 91, in _get_prepared_distribution
    abstract_dist.prepare_distribution_metadata(finder, build_isolation)
  File "/usr/lib/ckan/venv/local/lib/python2.7/site-packages/pip/_internal/distributions/sdist.py", line 38, in prepare_distribution_metadata
    self._setup_isolation(finder)
  File "/usr/lib/ckan/venv/local/lib/python2.7/site-packages/pip/_internal/distributions/sdist.py", line 96, in _setup_isolation
    reqs = backend.get_requires_for_build_wheel()
  File "/usr/lib/ckan/venv/local/lib/python2.7/site-packages/pip/_vendor/pep517/wrappers.py", line 161, in get_requires_for_build_wheel
    'config_settings': config_settings
  File "/usr/lib/ckan/venv/local/lib/python2.7/site-packages/pip/_vendor/pep517/wrappers.py", line 265, in _call_hook
    raise BackendUnavailable(data.get('traceback', ''))
BackendUnavailable

```
[Solução](https://github.com/ckan/ckan/issues/5618): pip install -U pipenv

#### Gdal
erro: pip install gdal
```text
extensions/gdal_wrap.cpp:3177:27: fatal error: cpl_vsi_error.h: No such file or directory
     #include "cpl_vsi_error.h"
                               ^
    compilation terminated.
    error: command 'x86_64-linux-gnu-gcc' failed with exit status 1

```

[How To Install GDAL/OGR Packages on Ubuntu](https://mothergeo-py.readthedocs.io/en/latest/development/how-to/gdal-ubuntu-pkg.html)
[instalar manualmente](https://www.geofis.org/en/install/install-on-linux/install-gdal-from-sources/)
[geospatial related pluguins](https://docs.ckan.org/projects/ckanext-spatial/en/latest/)

https://github.com/GeoinformationSystems/ckanext-geoserver

## checkout tags/ckan-2.9.1
