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
