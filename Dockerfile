FROM public.ecr.aws/lambda/python:3.14

WORKDIR /build

RUN  dnf install -y zip
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt -t package
COPY app/ package/

RUN cd package && zip -r /build/lambda.zip .