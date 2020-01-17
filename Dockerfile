FROM python:3.7-alpine3.7
EXPOSE 5000

ENV SETTINGS_MODULE project.settings
ENV LOG_DIR /var/logs
ENV GUNICORN_RELOAD False

# Устанавливаем все зависомости на образа.
RUN apk add --update --no-cache \
        tzdata \
        g++ \
        libffi-dev \
    ln -fs /usr/share/zoneinfo/Europe/Moscow /etc/localtime

RUN mkdir -p /var/logs

WORKDIR /opt/project
COPY requirements.txt /opt/project/requirements.txt
RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r requirements.txt
RUN apk del g++ libffi-dev && rm -rf /var/cache/apk/*

COPY . /opt/project/

CMD gunicorn -b 0.0.0.0:5000 -k=sync -w=5 project.wsgi
