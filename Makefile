IMAGE_NAME = registry.cn-beijing.aliyuncs.com/docker_wachoo_1/airflow
IMAGE_VERSION = 1.0.0
CONTAINER_NAMES = airflow-${IMAGE_VERSION}-0

.PHONY: build start push

build: build-version

build-version:
	docker build -t ${IMAGE_NAME}:${IMAGE_VERSION}  .

tag-latest:
	docker tag ${IMAGE_NAME}:${IMAGE_VERSION} ${IMAGE_NAME}:latest

start:
	docker run --rm -it --name ${CONTAINER_NAMES} -v `pwd`/plugins\:/usr/local/airflow/plugins  -v `pwd`/config/airflow.cfg\:/usr/local/airflow/airflow.cfg -v `pwd`/opt\:/data/opt  -v `pwd`/dags\:/usr/local/airflow/dags   ${IMAGE_NAME}:${IMAGE_VERSION} /bin/bash
	

push:   build-version tag-latest
	docker push ${IMAGE_NAME}:${IMAGE_VERSION}; docker push ${IMAGE_NAME}:latest
      
