import os
from urllib.parse import unquote_plus
from service.bucket import download_file, upload_file
from service.convert import convert_html_to_pdf


def lambda_handler(event, context):

    for record in event['Records']:
        # Obtém o nome do arquivo criado.
        html_file = record['s3']['object']['key']
        # Remove a extensão .html do nome do arquivo.
        object_name = html_file.split('/')[-1].split('.')[0]
        # Obtém o nome do bucket
        bucket_name = record['s3']['bucket']['name']
        # Faz o download do arquivo HTML e retorna o caminho onde foi salvo.
        download_path = download_file(bucket_name, html_file)
        # Converte o arquivo HTML em PDF e retorna o caminho onde foi salvo.
        pdf_file = convert_html_to_pdf(download_path)
        # Se a conversão ocorreu com sucesso, faz o upload do arquivo PDF 
        # para o bucket S3 e exclui os arquivos temporários.
        if pdf_file != '':
            upload_file(bucket_name, pdf_file, f'pdf/{object_name}.pdf')
            os.remove(pdf_file)
            os.remove(download_path)
