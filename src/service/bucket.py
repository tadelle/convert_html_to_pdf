import os
import uuid
import boto3
import typing

#if typing.TYPE_CHECKING:
from mypy_boto3_s3 import S3Client

endpoint_url = None
# if os.getenv("STAGE") == "local":
#     endpoint_url = "https://localhost.localstack.cloud:4566"

#s3: "S3Client" = boto3.client("s3", endpoint_url=endpoint_url)
s3: "S3Client" = boto3.client("s3")

def download_file(bucket_name, key):
    tmpkey = key.replace('/', '')
    download_path = f'/tmp/{uuid.uuid4()}{tmpkey}'
    s3.download_file(bucket_name, key, download_path)
    return download_path


def upload_file(bucket_name, file_path, key):
    s3.upload_file(file_path, bucket_name, key)
    return True
