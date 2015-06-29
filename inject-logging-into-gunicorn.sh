#!/bin/bash

# Add our logging configuration to the gunicorn.ini if necessary

E=/docker-entrypoint-ext.d
INI=$E/gunicorn.ini
L=$E/gunicorn.logging.conf

grep -E '^logconfig' $INI || echo 'logconfig = "$L"' >> $INI

[[ -f $L ]] || cp /gunicorn.logging.conf $L




