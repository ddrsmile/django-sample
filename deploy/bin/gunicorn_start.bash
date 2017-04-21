#!/bin/bash
NAME=django.sample
ROOT=/srv/webapps/${NAME}                            # Django的根目錄
DJANGODIR=${ROOT}/sample                             # Django project的根目錄
DEPLOYDIR=${ROOT}/deploy                             # 部署用的根目錄
SOCKFILE=${DEPLOYDIR}/run/gunicorn_${NAME}.sock      # 讓Nginx使用的sock位置
USER=webapps                                         # 執行script的使用者
GROUP=webapps                                        # 執行script的使用者群組
NUM_WORKERS=3
DJANGO_SETTINGS_MODULE=sample.settings               # Django project的設定檔案位置
DJANGO_WSGI_MODULE=sample.wsgi                       # Django project的WSGI模組檔案位置


cd $DEPLOYDIR
source ${ROOT}/env/bin/activate
export DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE
export PYTHONPATH=$DJANGODIR:$PYTHONPATH

RUNDIR=$(dirname $SOCKFILE)
test -d $RUNDIR || mkdir -p $RUNDIR

exec ${ROOT}/env/bin/gunicorn ${DJANGO_WSGI_MODULE}:application \
    --name $NAME \
    --workers $NUM_WORKERS \
    --user=$USER  --group=$GROUP \
    --bind=unix:$SOCKFILE \
    --log-level=debug \
    --log-file=-
