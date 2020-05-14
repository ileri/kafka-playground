# Kafka Playground

Bu depo, Apache Kafka'nın Ruby on Rails uygulamalarıyla birlikte kullanılması
için kolay deneme ve geliştirme ortamı sunmayı amaçlamaktadır.

Örnek uygulama olarak, belirlenen bir dizindeki değişiklikler izlenmekte,
dizine yeni eklenen dosyalar bir Ruby betiği tarafından Kafka'ya iletilmekte,
Ruby on Rails uygulamasıdaki Racecar consumer'ı da Kafka'yı dinleyerek
yeni eklenen dosyaların yollarını veritabanına kaydetmektedir.

Gerçekleme ile gili detaylar aşağıdaki bölümlerde incelenmektedir. Apache Kafka
ile ilgili hızlıca bilgi edinmek için bu depodaki kısa [Kafka](./kafka.md)
dokümantasyonunu inceleyebilirsiniz.

## Uygulamaları Ayağa Kaldırma

Docker Compose ile oluşturulan çoklu servislerden oluşan ortamı ayağa
kaldırmak için aşağıdaki işlem adımlarını uygulayabilirsiniz.

~~~sh
docker-compose build

docker-compose run app yarn install

docker-compose run app rails db:create

docker-compose run app rails db:migrate

docker-compose up
~~~

## Ruby on Rails ise Kafka Akışlarını Dinleme

Apache Kafka ile bağlantı kurmak ve consumer işlemleri yapabilmek için
[racecar](https://github.com/zendesk/racecar) isimli gem uygulamaya
dahil edilmiştir. `NewFileListenerConsumer` isimli consumer oluşturulmuştur.
Procfile dosyasına da worker olarak eklenilen racecar komutu sayesinde
web sunucusu olarak çalışan Puma uygulamasından bağımsız şekilde Kafka'dan
gelen mesajlar dinlenilmekte, elde edilen mesaj nesnesi istenilen
amaç doğrultusunda kullanılabilmektedir.
