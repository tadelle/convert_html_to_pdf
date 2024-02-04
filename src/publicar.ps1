pip install -r requirements.txt -t package --upgrade
pip install -t package --platform manylinux2014_x86_64 --implementation cp --python-version 3.11 --only-binary=:all: --upgrade Pillow
pip install -t package --platform manylinux2014_x86_64 --implementation cp --python-version 3.11 --only-binary=:all: --upgrade cryptography==3.4.8
Compress-Archive -Path package\* -DestinationPath lambda.zip
Compress-Archive -Path main.py -DestinationPath lambda.zip -Update
Compress-Archive -Path service -DestinationPath lambda.zip -Update
Move-Item lambda.zip ..\infra\lambda_convert\ -Force
Remove-Item -Path .\package\ -Confirm:$false -Recurse -Force
Set-Location -Path ..\infra\
tflocal apply --auto-approve
Set-Location -Path ..\src\
