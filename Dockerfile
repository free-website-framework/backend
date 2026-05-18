ARG PYTHON_VERSION
FROM public.ecr.aws/lambda/python:${PYTHON_VERSION}

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN set -eux; \
    pip install -r requirements.txt -vvv 2>&1 | tee /tmp/pip.log; \
    cat /tmp/pip.log; \
    exit 1
RUN pip install -r requirements.txt -vvv
COPY app ${LAMBDA_TASK_ROOT}

CMD [ "app.main.handler" ]