# sdi-centos7-gunicorn

This images includes the gunicorn wsgi server. Gunicorn is the process, that is started by the container and DOES NOT use supervisord or anything alike.

No virtualenvs are used, as the service the gunicorn application is the sole purpuse of the container and therefore it is not necessary.

# How to use this image

* Create a `gunicorn.ini` within the `/docker-entrypoint.ext.d` directory with your gunicorn configuration
* Create a `gunicorn.app` within the `/docker-entrypoint.ext.d` directory which contains the `APP_MODULE` that should be started

Here is an example of a `/docker-entrypoint.ext.d/gunicorn.ini` that expects the application with in `/pub` directory.

```
import multiprocessing

bind = "0.0.0.0:5000"
workers = multiprocessing.cpu_count() * 2 + 1
threads = multiprocessing.cpu_count() * 2 + 1
max_requests = 4096
timeout = 120
chdir = "/pub"
pythonpath = "/pub"
```

To start the application `app` within the `app.py` file in the `/pub` directory, create the file `/docker-entrypoint.ext.d/gunicorn.app` with this content:

```
app.app
```

The `/pub` directory is created by the image, you can mount it as volume, store your application there and get on with it.

# Logging

Gunicorn allows to define a logging configuration via config file. The image contains a logging configuration, that defines access- anderrorloggers for gunicorn. Both log using the logstash_formatter to logfiles within the /logs directory.

The 'root' logger also logs to /logs/root_logger.log. This configuration file is copied into /docker-entrypoint-ext.d on first startup so it can be changed later on.

The logging-configuration is injected into the `gunicorn.ini` automatically.

# Example

To get started und to see the glory of Logging in combination with the elk put the following `docker-compose.yml` into a directory:

```
elk:
  expose:
    - 5601
  hostname: elk
  image: sumpfgottheit/centos7-elk
  ports:
    - 5601:5601
  volumes:
    - _logs:/logs
    - elk/volumes/docker-entrypoint-ext.d:/docker-entrypoint-ext.d
    - elk/volumes/elastichsearchdata:/var/elasticsearch
    - elk/volumes/logstash.d:/etc/logstash.d
gunicorn:
  env:
  	PIP_REQUIREMENTS_FILE=/pub/requirement.txt
  expose:
    - 5000
  ports:
    - 5000:5000
  hostname: gunicorn
  image: sumpfgottheit/centos7-gunicorn
  volumes:
    - _logs/gunicorn:/logs
    - gunicorn/volumes/docker-entrypoint-ext.d:/docker-entrypoint-ext.d
    - gunicorn/volumes/pub:/pub
```

Now run `docker-compose up`. The gunicorn container **will fail** with `gunicorn: error: No application module specified`, but all necessary directories are created - lazy we are...

## The application

Got to `$projectdir/gunicorn/volumes/pub` and put the following file as `app.py` into this directory:

```
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello World!'
```

## The requirements file

The **gunicorn** container got the environment variable `PIP_REQUIREMENTS_FILE` set in the `docker-compose.yml`. This variable points to the `requirements` file, that pip will try to install on starting the container. 

So place the contents of the file below as `$projectdir/gunicorn/volumes/pub/requirements.txt` and the necessary modules for the `app.py` will be installed:

```
Flask==0.10.1
Jinja2==2.7.3
MarkupSafe==0.23
Werkzeug==0.10.4
futures==3.0.3
itsdangerous==0.24
wsgiref==0.1.2
```

## gunicorn.ini

Save this file as `$projectdir/gunicorn/volumes/docker-entrypoint-ext.d/gunicorn.ini`

```
import multiprocessing

bind = "0.0.0.0:5000"
workers = multiprocessing.cpu_count() * 2 + 1
threads = multiprocessing.cpu_count() * 2 + 1
chdir = "/pub"
```

## gunicorn.app

Save this file as `$projectdir/gunicorn/volumes/docker-entrypoint-ext.d/gunicorn.app`

```
app.app
```

