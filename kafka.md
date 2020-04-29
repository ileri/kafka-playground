# Apache Kafka

Apache Kafka dağıtık akış platformudur. 
Dağıtık yapısının yönetimi için ZooKeeper'i kullanır. 
ZooKeeper, yapılandırma bilgilerini koruma, isimlendirme ve dağıtık yapılardaki
senkronizasyonu sağlamaya yardımcı merkezi bir servistir. Kafka brokerlerini
yönetir.

Kafka beş adet temel API'ye sahiptir.

- **Producer API**  : Bir yada birden fazla Kafka topic'ine akış yayını
yapılmasına olanak verir.
- **Consumer API**  : Bir yada birden fazla Kafka topic'indeki akış
yayınını dinlenilebilmesini sağlar.
- **Streams API**   : Bir yada birden fazla topic üzerindeki gerçek zamanlı
akış girdisini alarak bir akış işleyici görevi görmesine olanak sağlayan ve
ilgili topic'lere çıktı olarak yazılmasını sağlayan uygulamalar
geliştirilmesine olanak sağlar.
- **Connector API** : Kafka topic'lerinin mevcut uygulama veya veri sistemleri
ile bağlantı kurmasını sağlar.
- **Admin API**     : Topic'ler, broker'ler ve diğer kafka nesnelerinin
yönetimine olanak verir.

## Topic

Topic, Kafka'da akış kayıtlarının tutulduğu kategori veya besleme adıdır,
yani akış mesajlarının tutulduğu kategorinin ismidir.
Apache Kafka birden çok topic kullanımını desteklemektedir ve topic'ler
varsayılan olarak çoklu takipçiyi desteklemektedir.
Topic'ler bölümlerden ( partition ) oluşurlar. Varsayılan olarak bir adet
partition'dan oluşan topic'lerde partition numaralandırmaları 0 dan başlar.

Topic'e kaydedilen akış mesajları, topic'i oluşturan partitionlardan bir
tanesine kaydedilir. Kaydedilen mesajlar birden fazla partition varsa bu
partitionlara dağıtılabilir ve her bir mesaj bir partition'a kaydedilirken
artan şekilde bir offset değeri alır. Her bir partition içindeki mesajların
zamana göre sıralı olduğu kesin şekilde bilinmektedir ancak partitionlar arası
mesaj sırası için garanti verilemez.

Topic'lere yani partitionlara kaydedilen mesajlar belirli bir süre boyunca
diskte saklanmaktadır. Bu süre varsayılan olarak bir haftadır. Belirlenen
süreden daha eski veriler otomatik olarak silinmektedir.

## Broker

Broker, akış mesajlarının saklandığı topic'lerin partitionlarını barındıran
birimdir. Kafka ekosisteminde birden fazla broker mevcut ise yani
Kafka Cluster'ı oluşturulmuş ise topic'i oluşturan partitionlar
bu brokerlara dağıtılır.
