# ckan-coppe

[sobre o geoserver](https://docs.geoserver.org/stable/en/user/index.html)


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
[sobre o geoserver](https://docs.geoserver.org/stable/en/user/index.html)

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
resumo:
* 

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

[geoserver repository]https://github.com/GeoinformationSystems/ckanext-geoserver

## checkout tags/ckan-2.9.0
[sobre o geoserver](https://docs.geoserver.org/stable/en/user/index.html)


adicionar à instalação do ckan(dockerfile do ckan): checkinstall
e instalar o libgdal-dev manualmente

```dockerfile
RUN wget http://download.osgeo.org/gdal/2.2.4/gdal-2.2.4.tar.gz \
        && tar -xvzf gdal-2.2.4.tar.gz \
        && cd gdal-2.2.4 \
        && ./configure --prefix=/usr \
        && make \
        && checkinstall
```

no ambiente pip do ckan (container): 

```text
source $CKAN_VENV/bin/activate && cd $CKAN_VENV/src/

pip install pillow gsconfig owgs==0.8.2 gdal==2.2.4
python setup.py install
python setup.py develop
cd ..
pip install ckanext-geoserver
```

erro: 
````text
{...}
File "/usr/lib/ckan/venv/src/ckanext-geoserver/ckanext/geoserver/model/Datastored.py", line 2, in <module>
import ckanext.datastore.db as db
ImportError: No module named db
````

solução: instalar datastore antigo

```text
git clone https://github.com/datagovuk/ckanext-datastore.git
obs: adicionar o seguinte código aos __init__.py 
```
erro:
```text
error: Namespace package problem: bedetsplug is a namespace package, but its
__init__.py does not call declare_namespace()! Please fix it.
```

Solução: adicionar o seguinte código aos __init__.py do datastore

```text
# this is a namespace package
try:
    import pkg_resources
    pkg_resources.declare_namespace(__name__)
except ImportError:     
    import pkgutil
    __path__ = pkgutil.extend_path(__path__, __name__)
```

erro: ckan não consegue inicializar por causa da extensão geoserver não conseguir importar o módulo storage.

```text
{...}
ckan          |     from ckanext.geoserver.model.ShapeFile import Shapefile
ckan          |   File "/usr/lib/ckan/venv/src/ckanext-geoserver/ckanext/geoserver/model/ShapeFile.py", line 6, in <module>
ckan          |     from ckanext.geoserver.misc.helpers import file_path_from_url
ckan          |   File "/usr/lib/ckan/venv/src/ckanext-geoserver/ckanext/geoserver/misc/helpers.py", line 6, in <module>
ckan          |     from ckan.controllers import storage
ckan          | ImportError: cannot import name storage

```
OBS: O nome storage é um script '.py' disponível dentro do ckan em $HOME_CKAN/src/ckan/ckan/controllers. Porém este
arquivo está disponível no ckan apenas até a versão 2.8.6. Ainda assim, não é possível instalar o geoserver nesta versão
 pois o erro na execução de geoserver "ImportError: No module named db" é solucionado quando da instalação da extensao 
 datastore (datagovuk), entretanto tal extensão demanda a versão exata 2.4.5 do psycopg2 que é a versão nativa do 
 ckan v2.7.9 ou versões anteriores.


## checkout tags/ckan-2.7.9

* alteração dockerfile ckan
  adicionar instalação do gdal
  instalar plugins: datastore + geoserver
  instalar depenências do geoserver: setuptools (atualizar) pillow gdal==2.4.4. gsconfig owslib==0.8.2
* alteração docker-compose
  adicionar variáveis de ambiente a serem importadas do .env e adicionadas ao ckan-entrypoint e mimetizar a versão 2.9.0
* alteração dockerfile postgresql
  mimetizar a versão 2.9.0
* alteração ckan-entrypoint.sh
  adicionar as configurações destinadas ao ckan.ini do datastore datapuhser geoserver e o que for usar (mesmo do docker-composer)
  . Aparentemente pelo ckan.ini apenas se ativa os plugins.
* alteração .env
    adicionar as variáveis adicionadas ao docker-compose e ao ckan-entrypoint
  
* configuração do container
1) abrir o container
2) entrar no ambiente pip
3) ir ao direorio $CKAN_HOME/src
4) clonar os repositórios [datasotre](https://github.com/flavioov/ckanext-datastore.git) e [geoserver](https://github.com/ngds/ckanext-geoserver.git) (pip install -e pasta)
5) instalar dependências do geoserver (obs: atualizar setuptools e instalar o gdal==2.4.4)
6) adicionar os plugins no arquivo de configuração do ckan (ckan.ini - encontrar (fora do container) via docker volume inspect ckan_config)
7) reiniciar o ckan

### datastore
obs: [pacote python possivelmente alternativo com o módulo db presente](https://pypi.org/project/ckanext-datastore_ts/#modal-close)

mesmos passo seguidos para a solução dos problemas na instalação do ckan, todavia
a instalação do ckanext-datastore via 'python setup.py install' retorna o seguinte erro; (tentar fazer a instalação via pip install -e)
```
ckan          | File "/usr/lib/ckan/default/lib/python2.7/site-packages/ckanext/datastore/plugin.py", line 32, in configure
ckan          |     raise DatastoreException(error_msg)
ckan          | ckanext.datastore.plugin.DatastoreException: ckan.datastore_write_url not found in config

```
obs: https://git.govcloud.dk/SebastianEsp/dataset_catalogue.git

```text
Adição de repositórios no ubuntu

echo "deb-src http://gb.archive.ubuntu.com/ubuntu/ xenial main restricted" | sudo tee -a /etc/apt/sources.list
ou 
apt-get instal -y software-properties-common
apt-add-repository ppa:ubuntugis/ubuntugis-unstable
```

erro: datastore 
 geoserver - instalação ok
 datastore - instalação ok
 datastore - carregamento do pluguin: erro

```text
ckanext.datastore.plugin.DatastoreException: ckan.datastore_write_url not found in config
```

Solução: Adicionar em ckan-entrypoint.sh/set_environmets variaveis de ambiente:

```shell
set_environment () {
  export CKAN_SQLALCHEMY_URL=${CKAN_SQLALCHEMY_URL}
  export CKAN_SOLR_URL=${CKAN_SOLR_URL}
  export CKAN_REDIS_URL=${CKAN_REDIS_URL}
  export CKAN_STORAGE_PATH=${CKAN_STORAGE_PATH}
  export CKAN_SITE_URL=${CKAN_SITE_URL}
  # Variaveis adicionadas
  export CKAN_STORAGE_PATH=/var/lib/ckan
  export CKAN_DATAPUSHER_URL=${CKAN_DATAPUSHER_URL}
  export CKAN_DATASTORE_WRITE_URL=${CKAN_DATASTORE_WRITE_URL}
  export CKAN_DATASTORE_READ_URL=${CKAN_DATASTORE_READ_URL}
  export CKAN_SITE_URL=${CKAN_SITE_URL}
```

obs: talvez tenha que ser adicionadas as variaveis do geoserver


## geoserver 

Note A workspace name is a identifier describing your project. It must not exceed ten characters or contain spaces.
A Namespace URI (Uniform Resource Identifier) can usually be a URL associated with your project with an added 
trailing identifier indicating the workspace. The Namespace URI filed does not need to resolve to an actual valid 
web address.

#### dependencias
python2-lxml
pip install lxml
pip install -U ndg-httpsclient
pip install usginmodels
pip install shapely
git clone https://github.com/ngds/ckanext-metadata
git clone https://github.com/ngds/ckanext-spatial.git
apt-get install libgeos-dev libgeos-c1v5 libgeos-3.7.1

[inicializa geoserver?](https://confluence.csiro.au/display/seegrid/CKAN+Spatial+Extensions+Setup+Guide)
paster --plugin=ckanext-geoserver geoserver initdb --config=/etc/ckan/default/ckan.ini

instalar ckanext-pages?? criação de paginas no ckan