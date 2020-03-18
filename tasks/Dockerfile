FROM tiangolo/uwsgi-nginx-flask:python3.6

RUN pip install --upgrade pip
RUN pip install redis
RUN pip install prometheus_client

ADD /task-api /app
