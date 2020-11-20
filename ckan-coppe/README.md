# ckan-coppe

### Instalação ckan via pacote

erro:\
ModuleNotFoundError: No module named 'distutils.core'\
solução:\
apt-get install python3-pip\


### instalação via 'sources'

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


