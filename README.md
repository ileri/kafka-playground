# BAUM Kafka

Steps

~~~sh
docker-compose build

docker-compose run app yarn install

docker-compose run app rails db:create

docker-compose run app rails db:migrate

docker-compose run app rails consumer:start

docker-compose up
~~~
