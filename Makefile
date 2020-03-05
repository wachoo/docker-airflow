IMAGE_NAME = registry.cn-beijing.aliyuncs.com/docker_wachoo_1/airflow
IMAGE_VERSION = 1.0.1
DOCKERFILE = Dockerfile
CONTAINER_NAMES = airflow-${IMAGE_VERSION}-0

.PHONY: build start push

build: build-version tag-latest start-celeryExecutor

build-version:
	docker build -t ${IMAGE_NAME}:${IMAGE_VERSION} -f ./${DOCKERFILE} .

tag-latest:
	docker tag ${IMAGE_NAME}:${IMAGE_VERSION} ${IMAGE_NAME}:latest

start-celeryExecutor:
	docker ps |grep 'dockerairflow'|awk '{print $1}'|xargs docker rm -f
#	docker-compose -f docker-compose-CeleryExecutor-local-149.yml up -d
	docker-compose -f docker-compose-CeleryExecutor-redis-slave.yml up -d

start:
	docker run --rm -it --name ${CONTAINER_NAMES} -v `pwd`/plugins\:/usr/local/airflow/plugins  -v `pwd`/config/airflow.cfg\:/usr/local/airflow/airflow.cfg -v `pwd`/opt\:/data/opt  -v `pwd`/dags\:/usr/local/airflow/dags   ${IMAGE_NAME}:${IMAGE_VERSION} /bin/bash


push:   build-version tag-latest
	docker push ${IMAGE_NAME}:${IMAGE_VERSION}; docker push ${IMAGE_NAME}:latest
      
