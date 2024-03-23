import uuid
import boto3
import typing

if typing.TYPE_CHECKING:
    from mypy_boto3_s3 import S3Client

s3: "S3Client" = boto3.client("s3")


def download_file(bucket_name: str, key: str) -> str:
    tmpkey = key.replace('/', '')
    download_path = f'/tmp/{uuid.uuid4()}{tmpkey}'
    s3.download_file(bucket_name, key, download_path)
    return download_path


def upload_file(bucket_name: str, file_path: str, key: str) -> bool:
    s3.upload_file(file_path, bucket_name, key)
    return True
