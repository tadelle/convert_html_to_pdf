cd venv/lib/python3.11/site-packages
zip lambda.zip *
mv lambda.zip ../../../../
cd ../../../../
zip lambda.zip main.py
zip lambda.zip service/*
mv lambda.zip ../infra/
