# -*- coding: utf-8 -*-
import scrapy


class EztvSpider(scrapy.Spider):
    name = 'eztv'
    allowed_domains = ['eztv.io']
    start_urls = ['http://eztv.io/']

    def parse(self, response):
        pass
