FROM debian:8.11-slim

LABEL "maintainer"="Radek Kysely <radek@kysely.org>"
LABEL "kdb+ license"="No Fee, Non-Commercial Use <https://kx.com/download/>"

ENV PORT=5000
ENV ON_STARTUP="-1\"Fresh startup\";"
ENV USER=""

RUN apt-get update && apt-get install -y \
    unzip=6.0* \
    lib32z1=1:1.2.8* \
    && rm -rf /var/lib/apt/lists/*

ADD https://kx.com/347_d0szre-fr8917_llrsT4Yle-5839sdX/3.6/linuxx86.zip \
    /root/kdbq.zip

RUN unzip /root/kdbq.zip -x q/q.q q/README.txt -d /root/ && rm /root/kdbq.zip

COPY docker-entrypoint.sh /usr/local/bin/

EXPOSE $PORT
ENTRYPOINT docker-entrypoint.sh "$PORT" "$ON_STARTUP" "$USER"
