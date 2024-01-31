# Conversão automática html para pdf

Aqui criamos um bucket S3 e uma lambda acionada por um trigger do bucket. Toda vez que um arquivo com característica específicas for criado ele acionará uma lambda que realizará a conversão do arquivo html para arquivo pdf. O novo arquivo será colocado no bucket com o prefixo pdf/.

## Montando o ambiente de desenvolvimento

### Pré-requisitos
Para esse projeto vamos precisar:
- docker e docker-compose;
- terraform 1.6+
- python 3.11+

### 1 - Clone o projeto:
```shell
git clone git@github.com:tadelle/convert_html_to_pdf.git
cd convert_html_to_pdf
```

### 2 - Monte um ambiente virtual:
```shell
cd src
python -m venv venv
```

### 3 - Ative o ambiente virtual (Linux)
```shell
source venv/bin/activate
```

### 4 - Instale a dependências
```shell
pip install -r requirements.txt
```

### 5 - Instale o terraform-local
```shel
pip install terraform-local
```

### 6 - Inicie o container do LocalStack usando docker-compose
```shell
cd ../localstack/
docker compose up -d
```

## Publicando

### 1 - Prepare o pacote da lambda para ser publicado
Devemos compactar todo o conteúdo da pasta site-packages, que contém as bibliotecas usadas pela lambda function.
Procure a pasta site-packages na pasta do seu ambiente virtual.

venv/lib/python3.11/site-packages
ou
venv/Lib/site-packages

Podemos usar qualquer método para produzir o arquivo zip, mas o importante é que o arquivo main.py, assim como a pasta service. As pastas da biblioteca ficam no mesmo nĩvel que o arquivo main. Como mostrado na imagem abaixo.

![Estrutura do arquivo zip](./src/lambda_zip.png)

### 7 - Inicie o Terraform
```shell
cd ../infra
tflocal init
```

### 8 - Verifique o planejamento do terraform
```shell
tflocal plan
```

### 9 - Aplique as mudanças
```shell
tflocal apply --auto-approve
```
