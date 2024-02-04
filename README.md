# Conversão automática html para pdf

Aqui criamos um bucket S3 e uma lambda acionada por um trigger do bucket. Toda vez que um arquivo com característica específicas for criado ele acionará uma lambda que realizará a conversão do arquivo html para arquivo pdf. O novo arquivo será colocado no bucket com o prefixo pdf/.

## Montando o ambiente de desenvolvimento

### Pré-requisitos
Para esse projeto vamos precisar:
- docker e docker-compose;
- terraform 1.6+
- python 3.11+
- aws-cli-v2

### 1 - Clone o projeto:
```shell
git clone https://github.com/tadelle/convert_html_to_pdf.git
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

### 7 - Inicie o Terraform
```shell
cd ../infra
tflocal init
```

## Publicando

### 8 - Prepare o pacote da lambda para ser publicado
Para preparar o pacote devemos montar todas as dependências da nossa lambda. Podemos fazer isso usando o comando abaixo, estando na pasta /src/.

pip3 install -r requirements.txt -t package --upgrade

As dependências serão montadas na pasta package. Devemos compactar todo o conteúdo dessa pasta incluindo o nosso código fonte usando o formato zip.

Podemos usar qualquer método para produzir o arquivo zip, mas o importante é que o arquivo main.py, assim como a pasta service estejam na raiz. As pastas da biblioteca ficam no mesmo nível que o arquivo main. Como mostrado na imagem abaixo.

![Estrutura do arquivo zip](lambda_zip.png)

Para facilitar montei o arquivo publica.sh que faz tudo que foi informado acima e ainda faz a publicação e apaga a pasta com as dependências, pois não precisaremos mais dela.

### 8.1 - Monte o arquivo .zip a ser usado para publicação da lambda
```shell
cd ../src
./publicar.sh
```

### 9 - Verifique se o bucket e a lambda foram criados corretamente
```shell
aws s3 ls --endpoint-url=http://localhost:4566
```
Resultado esperado:
```
2024-01-31 21:59:52 my-bucket-test
```

```shell
aws lambda list-functions --endpoint-url=http://localhost:4566
```
Será exibida a lambda e suas propriedades. Para sair pressione q.
```
{
    "Functions": [
        {
            "FunctionName": "lambda_convert",
            "FunctionArn": "arn:aws:lambda:sa-east-1:000000000000:function:lambda_convert",
            "Runtime": "python3.11",

            ...

            "SnapStart": {
                "ApplyOn": "None",
                "OptimizationStatus": "Off"
            }
        }
    ]
}
```

Verifique que até o momento o bucket está vazio
```shell
aws s3 ls my-bucket-test --endpoint-url=http://localhost:4566
```

### 10 - Fazendo upload do arquivo html para o bucket e verificando em seguida
```shell
aws s3 cp exemplo.html s3://my-bucket-test/html/ --endpoint-url=http://localhost:4566
aws s3 ls my-bucket-test --endpoint-url=http://localhost:4566
```

### 11 - Verificando o bucket
Se tudo deu certo você verá dois prefixos (como se fossem pastas): html e pdf.
```shell
aws s3 ls my-bucket-test --endpoint-url=http://localhost:4566
```
### 12 - Vamos fazer download do arquivo pdf gerado.
```shell
awslocal s3 cp s3://my-bucket-test/pdf/exemplo.pdf exemplo.pdf
```
