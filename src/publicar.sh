pip3 install -r requirements.txt -t package --upgrade
cd package
zip -r lambda.zip *
mv lambda.zip ..
cd ..
zip lambda.zip main.py
zip lambda.zip service/*
rm package -r
mv lambda.zip ../infra/lambda_convert/
cd ../infra/
tflocal apply -auto-approve
