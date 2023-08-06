build:
	docker-compose build

build-nc:
	docker-compose build --no-cache

build-progress:
	docker-compose build --no-cache --progress=plain

down:
	docker-compose down --volumes --remove-orphans

run:
	make down && docker-compose up

run-scaled:
	make down && docker-compose -f docker-compose.yml up --scale spark-yarn-worker=3

run-d:
	make down && docker-compose up -d

stop:
	docker-compose stop

submit:
	docker exec el-spark-master spark-submit --master spark://spark-master:7077 --deploy-mode client ./apps/$(app)

submit-yarn-test:
	docker exec da-spark-yarn-master spark-submit --master yarn --deploy-mode cluster ./examples/src/main/python/pi.py

submit-yarn-cluster:
	docker exec da-spark-yarn-master spark-submit --master yarn --deploy-mode cluster ./apps/$(app)

submit-da-book:
	make submit app=data_analysis_book/$(app)

rm-results:
	rm -r book_data/results/*