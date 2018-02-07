# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# https://doc.scrapy.org/en/latest/topics/items.html

import scrapy


class CrawlerSeadeItem(scrapy.Item):
    candidatos = scrapy.Field()
    partido = scrapy.Field()
    votos = scrapy.Field()
    votos_per = scrapy.Field()
    pass
