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

RUN pip3 install tox==3.14.3 coverage==4.5.4
RUN pip3 install -r requirements.txt
RUN pip3 install django_coverage_plugin==1.6.0 

# copy app files
COPY . /usr/app
