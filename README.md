This repo is used to deploy fastAPI on AWS lambda. It is refered in terraform-templates repo. All the code must be placed in app folder.


# Prerequisites:
1. Add `AWS_ROLE_TO_ASSUME` to github secrets with a correct arn from infrastructure deployment. Settings -> Secrets and variables -> Actions -> New repository secret ->
```
Name: AWS_ROLE_TO_ASSUME
Secret: <arn:aws:iam::123456789:role/fwf-github-actions>
```


# Local development
Go to AWS and create a dynamodb with TABLE_NAME=db TABLE_PK=pk. Run `aws configure` to allow a connection.

```
python -m venv venv
source venv/bin/activate
python -m pip install -r requirements-dev.txt
TABLE_NAME=db TABLE_PK=pk uvicorn app.main:app --reload --port 8000
deactivate
```
