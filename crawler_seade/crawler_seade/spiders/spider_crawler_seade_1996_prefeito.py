import scrapy
import re
import csv
import unidecode
import time
# import datetime

ano = ['1996']


def unique(sequence):
    seen = set()
    return [x for x in sequence if not (x in seen or seen.add(x))]


class crawler_seade(scrapy.Spider):
    name = "crawler_seade_1996"
    login_url = 'http://produtos.seade.gov.br/produtos/moveleitoral/index.php'
    login_url_du = 'http://produtos.seade.gov.br/produtos/moveleitoral/index.php?car=4'
    inicio = 0
    inicio_ano = 0
    start_urls = [
        'http://produtos.seade.gov.br/produtos/moveleitoral/index.php?tip=5'
    ]
    listacity = []
    listacityval = []

    def parse(self, response):
        year = ano[self.inicio_ano]
        request = scrapy.FormRequest(
            url=self.login_url,
            formdata={'loc': '4', 'ano_list[]': year},
            dont_filter=True,
            callback=self.post_continue
        )
        yield request

    def post_continue(self, response):
        yield scrapy.FormRequest(
            url=self.login_url,
            formdata={'ano': '4', 'l': 'M', 'mun': '', 'bot4': 'Continue'},
            dont_filter=True,
            callback=self.post_cidade
        )

    def post_cidade(self, response):
        if self.inicio == 0:
            self.listacity.clear()
            self.listacityval.clear()
            cidade_txt = response.css('option::text').extract()
            for city in cidade_txt:
                self.listacity.append(
                    unidecode.unidecode(
                        re.sub("\n", "", str(city)).strip().upper()
                    )
                )
            # self.listacity = self.listacity[:3]

            cidade_val = response.css('option::attr(value)').extract()
            for city in cidade_val:
                self.listacityval.append(city)
            # self.listacityval = self.listacityval[:3]

            self.listacity = unique(self.listacity)
            self.listacityval = unique(self.listacityval)

            x = self.inicio
        else:
            x = self.inicio

        request = scrapy.FormRequest(
            url=self.login_url_du,
            formdata={'loca_list[]': self.listacityval[x]},
            dont_filter=True,
            callback=self.post_cargo
        )
        request.meta['cidade_txt'] = self.listacity[x]
        yield request

    def post_cargo(self, response):
        request = scrapy.FormRequest(
            url=self.login_url,
            formdata={'res': '4', 'carg_list[]': '10', 'SAI': 'TELA'},
            dont_filter=True,
            callback=self.scrap
        )
        request.meta['cidade_txt'] = response.meta['cidade_txt']
        yield request

    def scrap(self, response):
        dados = str(response.css('table').extract())
        dados = re.sub("right", "left", dados)
        lista = re.findall("<td align=\"left\">(.*?)</td>", dados)
        x = len(lista)
        listafin = []
        while x != 0:
            elementos = list(lista[:4])
            elementos.append(response.meta['cidade_txt'])
            elementos.append(ano[self.inicio_ano])
            elementos[2] = int(re.sub('\.', '', elementos[2]))
            elementos.append("PREFEITO")
            listafin.append(elementos)
            lista = lista[4:]
            x = len(lista)
        listafin = [
            listafin[x] for x in range(len(listafin))
            if not(listafin[x] in listafin[:x])
        ]

        csvfile = 'dados_captados_1996.csv'

        with open(csvfile, 'a') as output:
            writer = csv.writer(
                output, lineterminator='\n',
                delimiter=';',
                quotechar='"',
                quoting=csv.QUOTE_ALL
            )
            writer.writerows(listafin)

        request = scrapy.Request(url=self.start_urls[0], dont_filter=True, callback=self.parse)
        if self.inicio == 0:
            self.inicio += 1
            yield request
        else:
            if self.inicio != len(self.listacityval) - 1:
                self.inicio += 1
                yield request
            else:
                if self.inicio_ano != len(ano) - 1:
                    self.inicio_ano += 1
                    print("Scrap do ano:",ano[self.inicio_ano])
                    time.sleep(10)
                    self.inicio = 0
                    yield request
                else:
                    print("Dados Captados")
                    return
