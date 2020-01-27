FROM python:3.7.4-slim-buster

LABEL MAINTAINER="Lawrence Mathenge Kamau <lawrencekamau5@gmail.com>"
LABEL application="Torrent-Scraper-Backend"

ENV TERM=xterm-256color

WORKDIR /usr/app

# update and install necessary packages
RUN apt-get -y update && apt-get -y upgrade && \
  apt-get install -y software-properties-common python3-dev

RUN pip3 install --upgrade pip setuptools

COPY requirements.txt /usr/app
COPY requirements requirements

RUN pip install -r requirements.txt
