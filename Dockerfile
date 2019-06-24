FROM lambci/lambda:build-python3.7

COPY . .

RUN pwd

RUN mkdir -p /tmp/python/lib/python3.7/site-packages/
