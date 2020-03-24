FROM postgres:9.6

ENV POSTGRES_USER test
ENV POSTGRES_PASSWORD test
ENV POSTGRES_DB test

COPY init.sql /docker-entrypoint-initdb.d/
