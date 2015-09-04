#!/bin/bash

EXT=/docker-entrypoint-ext.d
WORKING_GUNICORN_INI=$EXT/working.gunicorn.ini
WORKING_GUNICORN_APP=$EXT/working.gunicorn.app

[[ -f $WORKING_GUNICORN_INI ]] && rm $WORKING_GUNICORN_INI
if [[ -n $GUNICORN_INI_FILE ]] ; then
    [[ -f $GUNICORN_INI_FILE ]] && cp $GUNICORN_INI_FILE $WORKING_GUNICORN_INI
fi
if [[ ! -f $WORKING_GUNICORN_INI ]] ; then
    [[ -f $EXT/gunicorn.ini ]] && cp $EXT/gunicorn.ini $WORKING_GUNICORN_INI  
fi

[[ -f $WORKING_GUNICORN_APP ]] && rm $WORKING_GUNICORN_APP
if [[ -n $GUNICORN_APP_MODULE ]] ; then
    [[ -f $GUNICORN_APP_MODULE ]] && cp $GUNICORN_APP_MODULE $WORKING_GUNICORN_APP
fi
if [[ ! -f $WORKING_GUNICORN_APP ]] ; then
    [[ -f $EXT/gunicorn.app ]] && cp $EXT/gunicorn.app $WORKING_GUNICORN_APP
fi
