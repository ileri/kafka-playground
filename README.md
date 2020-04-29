# Kafka Playground

Bu depo, Apache Kafka'nın Ruby on Rails uygulamalarıyla birlikte kullanılması
için kolay deneme ve geliştirme ortamı sunmayı amaçlamaktadır.

Örnek uygulama olarak, belirlenen bir dizindeki değişiklikler izlenmekte,
dizine yeni eklenen dosyalar bir Ruby betiği tarafından Kafka'ya iletilmekte,
Ruby on Rails uygulamasıdaki Sidekiq arkaplan görevcisi de Kafka'yı dinleyerek
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

docker-compose run app rails consumer:start

docker-compose up
~~~

## Ruby on Rails ise Kafka Akışlarını Dinleme

Ruby on Rails, bir web framework'ü olması nedeniyle temel görevi kullanıcılar
tarafından gönderilen isteklere cevap dönmektir. İstek-cevap sirkülasyonu
dışında özellikle arkaplanda çalışması gereken işlemler olduğu durumlarda bu
işlemler doğrudan web sunucusuna değil, ActiveJob ile uyumlu olarak çalışabilen
Sidekiq gibi arkaplan görevcilerine yaptırılır.
Bu sayede web sunucu uygulaması meşgul edilmemiş olur ve kullanıcıların
isteklerine sorunsuz şekilde cevap vermeye devam eder.

Örneğimizdeki gibi Apache Kafka'dan gelen akışı sürekli kontrol etmesi
gereken bir durum olduğunda bu işi de arkaplan görevleri ile yapmak
gerekecektir.

Bu örnekte de bu işlemi yapması için Sidekiq arkaplan görev yöneticisi
kullanılmıştır. Arkaplan görevi olarak yürütülmesi istenilen işlemler
Ruby on Rails uygulamalarında `app/jobs` dizininin altındaki dosyalarda
tanımlanır. Bu örnekte de `app/jobs` dizininin altındaki
`kafka_consumer_job.rb` adlı dosyada `KafkaConsumerJob` isimli bir görev
tanımlanmıştır.

Apache Kafka ile bağlantı kurmak ve işlemler yapabilmek için
[ruby-kafka](https://github.com/zendesk/ruby-kafka) isimli gem uygulamaya
dahil edilmiştir. `KafkaConsumerJob` isimli görev içerisinde Kafka bağlantı
bilgileri ortam değişkenlerinden alınmıştır. Kafka kümesine bağlantı kurabilmek
için ortam değişkenlerinden elde edilen bilgiler kullanılarak bir `Kafka`
nesnesi oluşturulmuştur.

`Kafka` nesnesi kullanılarak bir adet `Consumer` nesnesi elde elde edilmiş,
ardından `each_message` bloğu ile Kafka'da akış devam ettiği sürece gelen
mesajları okuyan bir döngü oluşturulmuştur. Elde edilen mesaj nesnesi istenilen
amaç doğrultusunda kullanılabilmektedir.

### Kafka Bağlantı Kurulma Gecikmesi

`Docker Compose` aracı kullanılarak geliştirilen ortamda `depends_on` anahtar
kelimesi yardımıyla servisler arası bağımlılık ilişkisi kurularak hangi
servisin daha önce ayağa kaldırılacağı belirlense de servisi içeren konteynerin
çalışması istenilen servisin hazır olduğu garanti edemez. 

Bu depodaki sunulan örnek ortamda da `sidekiq` servisinin ayağa kaldırılması
için `kafka` servisinin ayağa kalkmış olması istenmekte ancak
`kafka` servisinin içerisindeki Apache Kafka servisinin bağlantıya
hazır duruma gelmesi bir miktar vakit almaktadır. Bu sırada `kafka`
konteynerinin hazır olduğu düşünülerek ayağa kaldırılan `sidekiq` konteyneri
içerisindeki Kafka istemcisi bağlantı kurmaya çalışıp başarısız olmakta, hata
üretmektedir.

Sadece `sidekiq` servisi değil, aynı şekilde bir dizini dinleyerek dizine eklenen yeni dosyaları haber vermekle görevli `Ruby` dilinde geliştirilmiş
producer betiğini içeren `producer` servisi için de aynı durum geçerlidir.

Bu durumu engellemek için hem `producer` servisi hem de consumer işlevi yürüten
`sidekiq` servisinin çalıştırdığı görevin içerisinde, Kafka nesnesi
oluşturulduktan sonra verilen zaman aşımı süresi içerisinde hata yönetimi
yapacak şekilde topic varlığı kontrolü yapılmakta, başarısız olunması durumunda
zaman aşımı süresi dolana kadar bir saniye aralıklarla tekrar denenmektedir.
