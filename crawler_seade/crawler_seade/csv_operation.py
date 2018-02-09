import pandas as pd

# Arrumando o csv de Prefeitos
file = 'arquivos_finais/dados_captados_prefeito.csv'
head = [
    'candidato',
    'partido',
    'votosnom',
    'votosper',
    'municipio',
    'eleicao',
    'cargo'
]
df = pd.read_csv(file, sep=';', names=head)
df['key'] = df['candidato'] + df['partido'] + df['municipio'] + df['eleicao'].map(str)
df['dup'] = df.duplicated(['key'])
df2 = df[(df.dup == True)]
display(df2)
