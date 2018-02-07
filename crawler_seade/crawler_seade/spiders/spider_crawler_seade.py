import scrapy
import datetime

anos = ['1982', '1988', '1992']

class crawler_seade(scrapy.Spider):
    name = "crawler_seade"
    login_url = 'http://produtos.seade.gov.br/produtos/moveleitoral/index.php?tip=5'
    start_urls = [login_url]


    def parse(self, response):
        yield scrapy.FormRequest(url='http://produtos.seade.gov.br/produtos/moveleitoral/index.php',
            formdata={'loc': '4', 'ano_list[]': '1988'},
            callback=self.cidade
        )

    def cidade(self, response):
        yield scrapy.FormRequest(url='http://produtos.seade.gov.br/produtos/moveleitoral/index.php',
            formdata={'ano': '4', 'l': 'M', 'mun': '', 'bot4': 'Continue'},
            callback=self.cidades_scrap
        )

    def cidades_scrap(self, response):
        for each in response.css('option'):
            yield {'cidade': each.css('::text').extract_first()}

    def parse2(self, response):
        print('EPALAIAP')
        filename = 'quotes.html'
        with open(filename, 'wb') as f:
            f.write(response.body)
