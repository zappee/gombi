# Empty

## 1) Kafka `producer` configuration
### 1.1) Producer per thread
~~~
DefaultKafkaProducerFactory<String, Event> factory = new DefaultKafkaProducerFactory<>(configuration());
factory.setProducerPerThread(<true/false>);
~~~

**Result of `false`:**
* Before sending the first message, Spring creates a new `producer`.
* Then Spring always reuse the same `producer` to send consecutive messages.
* The `ProducerFactory > PostProcessor > apply` method  is only called once, before sending the first message. 
* Log of sending the 1st message:
    ~~~
    DEBUG 203 --- [gombi-kafka-producer] [nio-8443-exec-8] c.r.g.c.m.MethodStatisticsAspect         : > calling the KafkaProducerController.sendOneMessage()...
    DEBUG 203 --- [gombi-kafka-producer] [nio-8443-exec-8] c.r.g.s.m.p.s.KafkaProducerService       : sending message to kafka: {topic: "incoming", payload: {sourceSystem: "payment-service", owner: "amelia", payload: "{"comment": "default message"}", createdInUtc: "2025-01-30 20:05:11.511"}
     INFO 203 --- [gombi-kafka-producer] [nio-8443-exec-8] o.a.k.clients.producer.ProducerConfig    : ProducerConfig values: 
        acks = -1
        auto.include.jmx.reporter = true
        batch.size = 16384
        bootstrap.servers = [kafka-1.hello.com:9092, kafka-2.hello.com:9092]
        buffer.memory = 33554432
        client.dns.lookup = use_all_dns_ips
        client.id = gombi-kafka-producer-producer-1
        compression.gzip.level = -1
        compression.lz4.level = 9
        compression.type = none
        compression.zstd.level = 3
        connections.max.idle.ms = 540000
        delivery.timeout.ms = 5000
        enable.idempotence = true
        enable.metrics.push = true
        interceptor.classes = []
        key.serializer = class org.apache.kafka.common.serialization.StringSerializer
        linger.ms = 0
        max.block.ms = 60000
        max.in.flight.requests.per.connection = 5
        max.request.size = 1048576
        metadata.max.age.ms = 300000
        metadata.max.idle.ms = 300000
        metadata.recovery.strategy = none
        metric.reporters = []
        metrics.num.samples = 2
        metrics.recording.level = INFO
        metrics.sample.window.ms = 30000
        partitioner.adaptive.partitioning.enable = true
        partitioner.availability.timeout.ms = 0
        partitioner.class = null
        partitioner.ignore.keys = false
        receive.buffer.bytes = 32768
        reconnect.backoff.max.ms = 1000
        reconnect.backoff.ms = 50
        request.timeout.ms = 500
        retries = 2147483647
        retry.backoff.max.ms = 1000
        retry.backoff.ms = 100
        sasl.client.callback.handler.class = null
        sasl.jaas.config = null
        sasl.kerberos.kinit.cmd = /usr/bin/kinit
        sasl.kerberos.min.time.before.relogin = 60000
        sasl.kerberos.service.name = null
        sasl.kerberos.ticket.renew.jitter = 0.05
        sasl.kerberos.ticket.renew.window.factor = 0.8
        sasl.login.callback.handler.class = null
        sasl.login.class = null
        sasl.login.connect.timeout.ms = null
        sasl.login.read.timeout.ms = null
        sasl.login.refresh.buffer.seconds = 300
        sasl.login.refresh.min.period.seconds = 60
        sasl.login.refresh.window.factor = 0.8
        sasl.login.refresh.window.jitter = 0.05
        sasl.login.retry.backoff.max.ms = 10000
        sasl.login.retry.backoff.ms = 100
        sasl.mechanism = GSSAPI
        sasl.oauthbearer.clock.skew.seconds = 30
        sasl.oauthbearer.expected.audience = null
        sasl.oauthbearer.expected.issuer = null
        sasl.oauthbearer.jwks.endpoint.refresh.ms = 3600000
        sasl.oauthbearer.jwks.endpoint.retry.backoff.max.ms = 10000
        sasl.oauthbearer.jwks.endpoint.retry.backoff.ms = 100
        sasl.oauthbearer.jwks.endpoint.url = null
        sasl.oauthbearer.scope.claim.name = scope
        sasl.oauthbearer.sub.claim.name = sub
        sasl.oauthbearer.token.endpoint.url = null
        security.protocol = PLAINTEXT
        security.providers = null
        send.buffer.bytes = 131072
        socket.connection.setup.timeout.max.ms = 30000
        socket.connection.setup.timeout.ms = 10000
        ssl.cipher.suites = null
        ssl.enabled.protocols = [TLSv1.2, TLSv1.3]
        ssl.endpoint.identification.algorithm = https
        ssl.engine.factory.class = null
        ssl.key.password = null
        ssl.keymanager.algorithm = SunX509
        ssl.keystore.certificate.chain = null
        ssl.keystore.key = null
        ssl.keystore.location = null
        ssl.keystore.password = null
        ssl.keystore.type = JKS
        ssl.protocol = TLSv1.3
        ssl.provider = null
        ssl.secure.random.implementation = null
        ssl.trustmanager.algorithm = PKIX
        ssl.truststore.certificates = null
        ssl.truststore.location = null
        ssl.truststore.password = null
        ssl.truststore.type = JKS
        transaction.timeout.ms = 60000
        transactional.id = null
        value.serializer = class org.springframework.kafka.support.serializer.JsonSerializer
    
     INFO 203 --- [gombi-kafka-producer] [nio-8443-exec-8] o.a.k.c.t.i.KafkaMetricsCollector        : initializing Kafka metrics collector
     INFO 203 --- [gombi-kafka-producer] [nio-8443-exec-8] o.a.k.clients.producer.KafkaProducer     : [Producer clientId=gombi-kafka-producer-producer-1] Instantiated an idempotent producer.
     INFO 203 --- [gombi-kafka-producer] [nio-8443-exec-8] o.a.kafka.common.utils.AppInfoParser     : Kafka version: 3.8.1
     INFO 203 --- [gombi-kafka-producer] [nio-8443-exec-8] o.a.kafka.common.utils.AppInfoParser     : Kafka commitId: 70d6ff42debf7e17
     INFO 203 --- [gombi-kafka-producer] [nio-8443-exec-8] o.a.kafka.common.utils.AppInfoParser     : Kafka startTimeMs: 1738267511636
     INFO 203 --- [gombi-kafka-producer] [nio-8443-exec-8] c.r.g.s.m.p.c.KafkaConfiguration         : ProducerFactory > PostProcessor > apply
     INFO 203 --- [gombi-kafka-producer] [nio-8443-exec-8] c.r.g.s.m.p.c.KafkaConfiguration         : ProducerFactory > listener: message producer has been added, id: producerFactory.gombi-kafka-producer-producer-1
     INFO 203 --- [gombi-kafka-producer] [ucer-producer-1] org.apache.kafka.clients.Metadata        : [Producer clientId=gombi-kafka-producer-producer-1] Cluster ID: _gntqMccRhST42TQj3kfKA
    DEBUG 203 --- [gombi-kafka-producer] [nio-8443-exec-8] c.r.g.c.m.MethodStatisticsAspect         : registering the method call to Micrometer: {meter-name: "remal_method_calls", method: "KafkaProducerController.sendOneMessage", status: "ok"}
    DEBUG 203 --- [gombi-kafka-producer] [nio-8443-exec-8] c.r.g.c.m.MethodStatisticsAspect         : < call ended: {name: KafkaProducerController.sendOneMessage, return: "A message has been sent to the <b>incoming</b> Kafka topic.", execution-in-ms: 183}
    DEBUG 203 --- [gombi-kafka-producer] [nio-8443-exec-8] c.r.g.c.m.MethodStatisticsAspect         : registering the method execution time to Micrometer: {meter-name: "remal_method_execution_time", method: "KafkaProducerController.sendOneMessage", execution-time-in-ms: 183}...
     INFO 203 --- [gombi-kafka-producer] [ucer-producer-1] o.a.k.c.p.internals.TransactionManager   : [Producer clientId=gombi-kafka-producer-producer-1] ProducerId set to 1000 with epoch 0
    DEBUG 203 --- [gombi-kafka-producer] [ucer-producer-1] c.r.g.s.m.p.s.KafkaProducerService       : sending a message to kafka has been finished
     INFO 203 --- [gombi-kafka-producer] [ucer-producer-1] c.r.g.s.m.p.s.KafkaProducerService       : message has been sent to Kafka successfully: {topic: "incoming", partition: 0, offset: 0, key: "null", value: "{sourceSystem: "payment-service", owner: "amelia", payload: "{"comment": "default message"}", createdInUtc: "2025-01-30 20:05:11.511""}
    ~~~

* Log of sending the 2nd message:
    ~~~
    DEBUG 203 --- [gombi-kafka-producer] [io-8443-exec-10] c.r.g.c.m.MethodStatisticsAspect         : > calling the KafkaProducerController.sendOneMessage()...
    DEBUG 203 --- [gombi-kafka-producer] [io-8443-exec-10] c.r.g.s.m.p.s.KafkaProducerService       : sending message to kafka: {topic: "incoming", payload: {sourceSystem: "payment-service", owner: "amelia", payload: "{"comment": "default message"}", createdInUtc: "2025-01-30 20:10:52.159"}
    DEBUG 203 --- [gombi-kafka-producer] [io-8443-exec-10] c.r.g.c.m.MethodStatisticsAspect         : registering the method call to Micrometer: {meter-name: "remal_method_calls", method: "KafkaProducerController.sendOneMessage", status: "ok"}
    DEBUG 203 --- [gombi-kafka-producer] [io-8443-exec-10] c.r.g.c.m.MethodStatisticsAspect         : < call ended: {name: KafkaProducerController.sendOneMessage, return: "A message has been sent to the <b>incoming</b> Kafka topic.", execution-in-ms: 6}
    DEBUG 203 --- [gombi-kafka-producer] [io-8443-exec-10] c.r.g.c.m.MethodStatisticsAspect         : registering the method execution time to Micrometer: {meter-name: "remal_method_execution_time", method: "KafkaProducerController.sendOneMessage", execution-time-in-ms: 6}...
    DEBUG 203 --- [gombi-kafka-producer] [ucer-producer-1] c.r.g.s.m.p.s.KafkaProducerService       : sending a message to kafka has been finished
     INFO 203 --- [gombi-kafka-producer] [ucer-producer-1] c.r.g.s.m.p.s.KafkaProducerService       : message has been sent to Kafka successfully: {topic: "incoming", partition: 0, offset: 1, key: "null", value: "{sourceSystem: "payment-service", owner: "amelia", payload: "{"comment": "default message"}", createdInUtc: "2025-01-30 20:10:52.159""}
    ~~~
* Log of sending the 3rd message:
    ~~~
    DEBUG 203 --- [gombi-kafka-producer] [nio-8443-exec-6] c.r.g.c.m.MethodStatisticsAspect         : > calling the KafkaProducerController.sendOneMessage()...
    DEBUG 203 --- [gombi-kafka-producer] [nio-8443-exec-6] c.r.g.s.m.p.s.KafkaProducerService       : sending message to kafka: {topic: "incoming", payload: {sourceSystem: "payment-service", owner: "amelia", payload: "{"comment": "default message"}", createdInUtc: "2025-01-30 20:11:49.223"}
    DEBUG 203 --- [gombi-kafka-producer] [nio-8443-exec-6] c.r.g.c.m.MethodStatisticsAspect         : registering the method call to Micrometer: {meter-name: "remal_method_calls", method: "KafkaProducerController.sendOneMessage", status: "ok"}
    DEBUG 203 --- [gombi-kafka-producer] [nio-8443-exec-6] c.r.g.c.m.MethodStatisticsAspect         : < call ended: {name: KafkaProducerController.sendOneMessage, return: "A message has been sent to the <b>incoming</b> Kafka topic.", execution-in-ms: 1}
    DEBUG 203 --- [gombi-kafka-producer] [nio-8443-exec-6] c.r.g.c.m.MethodStatisticsAspect         : registering the method execution time to Micrometer: {meter-name: "remal_method_execution_time", method: "KafkaProducerController.sendOneMessage", execution-time-in-ms: 1}...
    DEBUG 203 --- [gombi-kafka-producer] [ucer-producer-1] c.r.g.s.m.p.s.KafkaProducerService       : sending a message to kafka has been finished
     INFO 203 --- [gombi-kafka-producer] [ucer-producer-1] c.r.g.s.m.p.s.KafkaProducerService       : message has been sent to Kafka successfully: {topic: "incoming", partition: 0, offset: 2, key: "null", value: "{sourceSystem: "payment-service", owner: "amelia", payload: "{"comment": "default message"}", createdInUtc: "2025-01-30 20:11:49.223""}
    ~~~
**Result of `true`:**
* Before sending the message, Spring always creates a new `producer`.
* Then Spring always reuse the same `producer` to send consecutive messages.
* The `ProducerFactory > Listener > producerAdded` method is always called before sending a mew message as a new `producer` must be added.
* Clients must call `closeThreadBoundProducer()` to physically close the `producer` when it is no longer needed. Otherwise, the `ProducerFactory > listener > producerRemoved` method will never be called and the unused producers will not be removed and will remain in memory forever.
* The `ProducerFactory > PostProcessor > apply` method  is always called before sending the message.
* The `clientId` is always different from the previous as it is a new instance: `clientId=gombi-kafka-producer-producer-x`
* Log of sending the 1st message:
    ~~~
    DEBUG 208 --- [gombi-kafka-producer] [nio-8443-exec-2] c.r.g.c.m.MethodStatisticsAspect         : > calling the KafkaProducerController.sendOneMessage()...
    DEBUG 208 --- [gombi-kafka-producer] [nio-8443-exec-2] c.r.g.s.m.p.s.KafkaProducerService       : sending message to kafka: {topic: "incoming", payload: {sourceSystem: "payment-service", owner: "amelia", payload: "{"comment": "default message"}", createdInUtc: "2025-01-30 20:29:07.146"}
     INFO 208 --- [gombi-kafka-producer] [nio-8443-exec-2] o.a.k.clients.producer.ProducerConfig    : ProducerConfig values: 
        acks = -1
        auto.include.jmx.reporter = true
        batch.size = 16384
        bootstrap.servers = [kafka-1.hello.com:9092, kafka-2.hello.com:9092]
        buffer.memory = 33554432
        client.dns.lookup = use_all_dns_ips
        client.id = gombi-kafka-producer-producer-1
        compression.gzip.level = -1
        compression.lz4.level = 9
        compression.type = none
        compression.zstd.level = 3
        connections.max.idle.ms = 540000
        delivery.timeout.ms = 5000
        enable.idempotence = true
        enable.metrics.push = true
        interceptor.classes = []
        key.serializer = class org.apache.kafka.common.serialization.StringSerializer
        linger.ms = 0
        max.block.ms = 60000
        max.in.flight.requests.per.connection = 5
        max.request.size = 1048576
        metadata.max.age.ms = 300000
        metadata.max.idle.ms = 300000
        metadata.recovery.strategy = none
        metric.reporters = []
        metrics.num.samples = 2
        metrics.recording.level = INFO
        metrics.sample.window.ms = 30000
        partitioner.adaptive.partitioning.enable = true
        partitioner.availability.timeout.ms = 0
        partitioner.class = null
        partitioner.ignore.keys = false
        receive.buffer.bytes = 32768
        reconnect.backoff.max.ms = 1000
        reconnect.backoff.ms = 50
        request.timeout.ms = 500
        retries = 2147483647
        retry.backoff.max.ms = 1000
        retry.backoff.ms = 100
        sasl.client.callback.handler.class = null
        sasl.jaas.config = null
        sasl.kerberos.kinit.cmd = /usr/bin/kinit
        sasl.kerberos.min.time.before.relogin = 60000
        sasl.kerberos.service.name = null
        sasl.kerberos.ticket.renew.jitter = 0.05
        sasl.kerberos.ticket.renew.window.factor = 0.8
        sasl.login.callback.handler.class = null
        sasl.login.class = null
        sasl.login.connect.timeout.ms = null
        sasl.login.read.timeout.ms = null
        sasl.login.refresh.buffer.seconds = 300
        sasl.login.refresh.min.period.seconds = 60
        sasl.login.refresh.window.factor = 0.8
        sasl.login.refresh.window.jitter = 0.05
        sasl.login.retry.backoff.max.ms = 10000
        sasl.login.retry.backoff.ms = 100
        sasl.mechanism = GSSAPI
        sasl.oauthbearer.clock.skew.seconds = 30
        sasl.oauthbearer.expected.audience = null
        sasl.oauthbearer.expected.issuer = null
        sasl.oauthbearer.jwks.endpoint.refresh.ms = 3600000
        sasl.oauthbearer.jwks.endpoint.retry.backoff.max.ms = 10000
        sasl.oauthbearer.jwks.endpoint.retry.backoff.ms = 100
        sasl.oauthbearer.jwks.endpoint.url = null
        sasl.oauthbearer.scope.claim.name = scope
        sasl.oauthbearer.sub.claim.name = sub
        sasl.oauthbearer.token.endpoint.url = null
        security.protocol = PLAINTEXT
        security.providers = null
        send.buffer.bytes = 131072
        socket.connection.setup.timeout.max.ms = 30000
        socket.connection.setup.timeout.ms = 10000
        ssl.cipher.suites = null
        ssl.enabled.protocols = [TLSv1.2, TLSv1.3]
        ssl.endpoint.identification.algorithm = https
        ssl.engine.factory.class = null
        ssl.key.password = null
        ssl.keymanager.algorithm = SunX509
        ssl.keystore.certificate.chain = null
        ssl.keystore.key = null
        ssl.keystore.location = null
        ssl.keystore.password = null
        ssl.keystore.type = JKS
        ssl.protocol = TLSv1.3
        ssl.provider = null
        ssl.secure.random.implementation = null
        ssl.trustmanager.algorithm = PKIX
        ssl.truststore.certificates = null
        ssl.truststore.location = null
        ssl.truststore.password = null
        ssl.truststore.type = JKS
        transaction.timeout.ms = 60000
        transactional.id = null
        value.serializer = class org.springframework.kafka.support.serializer.JsonSerializer
    
     INFO 208 --- [gombi-kafka-producer] [nio-8443-exec-2] o.a.k.c.t.i.KafkaMetricsCollector        : initializing Kafka metrics collector
     INFO 208 --- [gombi-kafka-producer] [nio-8443-exec-2] o.a.k.clients.producer.KafkaProducer     : [Producer clientId=gombi-kafka-producer-producer-1] Instantiated an idempotent producer.
     INFO 208 --- [gombi-kafka-producer] [nio-8443-exec-2] o.a.kafka.common.utils.AppInfoParser     : Kafka version: 3.8.1
     INFO 208 --- [gombi-kafka-producer] [nio-8443-exec-2] o.a.kafka.common.utils.AppInfoParser     : Kafka commitId: 70d6ff42debf7e17
     INFO 208 --- [gombi-kafka-producer] [nio-8443-exec-2] o.a.kafka.common.utils.AppInfoParser     : Kafka startTimeMs: 1738268947249
     INFO 208 --- [gombi-kafka-producer] [nio-8443-exec-2] c.r.g.s.m.p.c.KafkaConfiguration         : ProducerFactory > PostProcessor > apply
     INFO 208 --- [gombi-kafka-producer] [nio-8443-exec-2] c.r.g.s.m.p.c.KafkaConfiguration         : ProducerFactory > listener: message producer has been added, id: producerFactory.gombi-kafka-producer-producer-1
     INFO 208 --- [gombi-kafka-producer] [ucer-producer-1] org.apache.kafka.clients.Metadata        : [Producer clientId=gombi-kafka-producer-producer-1] Cluster ID: Z3jqNJOGSde4C-WEbLVjHg
    DEBUG 208 --- [gombi-kafka-producer] [nio-8443-exec-2] c.r.g.c.m.MethodStatisticsAspect         : registering the method call to Micrometer: {meter-name: "remal_method_calls", method: "KafkaProducerController.sendOneMessage", status: "ok"}
    DEBUG 208 --- [gombi-kafka-producer] [nio-8443-exec-2] c.r.g.c.m.MethodStatisticsAspect         : < call ended: {name: KafkaProducerController.sendOneMessage, return: "A message has been sent to the <b>incoming</b> Kafka topic.", execution-in-ms: 162}
    DEBUG 208 --- [gombi-kafka-producer] [nio-8443-exec-2] c.r.g.c.m.MethodStatisticsAspect         : registering the method execution time to Micrometer: {meter-name: "remal_method_execution_time", method: "KafkaProducerController.sendOneMessage", execution-time-in-ms: 162}...
     INFO 208 --- [gombi-kafka-producer] [ucer-producer-1] o.a.k.c.p.internals.TransactionManager   : [Producer clientId=gombi-kafka-producer-producer-1] ProducerId set to 1000 with epoch 0
    DEBUG 208 --- [gombi-kafka-producer] [ucer-producer-1] c.r.g.s.m.p.s.KafkaProducerService       : sending a message to kafka has been finished
     INFO 208 --- [gombi-kafka-producer] [ucer-producer-1] c.r.g.s.m.p.s.KafkaProducerService       : message has been sent to Kafka successfully: {topic: "incoming", partition: 0, offset: 0, key: "null", value: "{sourceSystem: "payment-service", owner: "amelia", payload: "{"comment": "default message"}", createdInUtc: "2025-01-30 20:29:07.146""}
    ~~~
* Log of sending the 2nd message:
~~~
DEBUG 208 --- [gombi-kafka-producer] [nio-8443-exec-3] c.r.g.c.m.MethodStatisticsAspect         : > calling the KafkaProducerController.sendOneMessage()...
DEBUG 208 --- [gombi-kafka-producer] [nio-8443-exec-3] c.r.g.s.m.p.s.KafkaProducerService       : sending message to kafka: {topic: "incoming", payload: {sourceSystem: "payment-service", owner: "amelia", payload: "{"comment": "default message"}", createdInUtc: "2025-01-30 20:31:21.897"}
 INFO 208 --- [gombi-kafka-producer] [nio-8443-exec-3] o.a.k.clients.producer.ProducerConfig    : ProducerConfig values: 
	...
	client.id = gombi-kafka-producer-producer-2
	...

 INFO 208 --- [gombi-kafka-producer] [nio-8443-exec-3] o.a.k.c.t.i.KafkaMetricsCollector        : initializing Kafka metrics collector
 INFO 208 --- [gombi-kafka-producer] [nio-8443-exec-3] o.a.k.clients.producer.KafkaProducer     : [Producer clientId=gombi-kafka-producer-producer-2] Instantiated an idempotent producer.
 INFO 208 --- [gombi-kafka-producer] [nio-8443-exec-3] o.a.kafka.common.utils.AppInfoParser     : Kafka version: 3.8.1
 INFO 208 --- [gombi-kafka-producer] [nio-8443-exec-3] o.a.kafka.common.utils.AppInfoParser     : Kafka commitId: 70d6ff42debf7e17
 INFO 208 --- [gombi-kafka-producer] [nio-8443-exec-3] o.a.kafka.common.utils.AppInfoParser     : Kafka startTimeMs: 1738269081904
 INFO 208 --- [gombi-kafka-producer] [nio-8443-exec-3] c.r.g.s.m.p.c.KafkaConfiguration         : ProducerFactory > PostProcessor > apply
 INFO 208 --- [gombi-kafka-producer] [nio-8443-exec-3] c.r.g.s.m.p.c.KafkaConfiguration         : ProducerFactory > listener: message producer has been added, id: producerFactory.gombi-kafka-producer-producer-2
 INFO 208 --- [gombi-kafka-producer] [ucer-producer-2] o.a.k.c.p.internals.TransactionManager   : [Producer clientId=gombi-kafka-producer-producer-2] ProducerId set to 0 with epoch 0
 INFO 208 --- [gombi-kafka-producer] [ucer-producer-2] org.apache.kafka.clients.Metadata        : [Producer clientId=gombi-kafka-producer-producer-2] Cluster ID: Z3jqNJOGSde4C-WEbLVjHg
DEBUG 208 --- [gombi-kafka-producer] [nio-8443-exec-3] c.r.g.c.m.MethodStatisticsAspect         : registering the method call to Micrometer: {meter-name: "remal_method_calls", method: "KafkaProducerController.sendOneMessage", status: "ok"}
DEBUG 208 --- [gombi-kafka-producer] [nio-8443-exec-3] c.r.g.c.m.MethodStatisticsAspect         : < call ended: {name: KafkaProducerController.sendOneMessage, return: "A message has been sent to the <b>incoming</b> Kafka topic.", execution-in-ms: 19}
DEBUG 208 --- [gombi-kafka-producer] [nio-8443-exec-3] c.r.g.c.m.MethodStatisticsAspect         : registering the method execution time to Micrometer: {meter-name: "remal_method_execution_time", method: "KafkaProducerController.sendOneMessage", execution-time-in-ms: 19}...
DEBUG 208 --- [gombi-kafka-producer] [ucer-producer-2] c.r.g.s.m.p.s.KafkaProducerService       : sending a message to kafka has been finished
 INFO 208 --- [gombi-kafka-producer] [ucer-producer-2] c.r.g.s.m.p.s.KafkaProducerService       : message has been sent to Kafka successfully: {topic: "incoming", partition: 2, offset: 0, key: "null", value: "{sourceSystem: "payment-service", owner: "amelia", payload: "{"comment": "default message"}", createdInUtc: "2025-01-30 20:31:21.897""}
~~~
* Log of sending the 3rd message:
    ~~~
    DEBUG 208 --- [gombi-kafka-producer] [nio-8443-exec-7] c.r.g.c.m.MethodStatisticsAspect         : > calling the KafkaProducerController.sendOneMessage()...
    DEBUG 208 --- [gombi-kafka-producer] [nio-8443-exec-7] c.r.g.s.m.p.s.KafkaProducerService       : sending message to kafka: {topic: "incoming", payload: {sourceSystem: "payment-service", owner: "amelia", payload: "{"comment": "default message"}", createdInUtc: "2025-01-30 20:32:39.764"}
     INFO 208 --- [gombi-kafka-producer] [nio-8443-exec-7] o.a.k.clients.producer.ProducerConfig    : ProducerConfig values: 
        ...
        client.id = gombi-kafka-producer-producer-3
        ...
     INFO 208 --- [gombi-kafka-producer] [nio-8443-exec-7] o.a.k.c.t.i.KafkaMetricsCollector        : initializing Kafka metrics collector
     INFO 208 --- [gombi-kafka-producer] [nio-8443-exec-7] o.a.k.clients.producer.KafkaProducer     : [Producer clientId=gombi-kafka-producer-producer-3] Instantiated an idempotent producer.
     INFO 208 --- [gombi-kafka-producer] [nio-8443-exec-7] o.a.kafka.common.utils.AppInfoParser     : Kafka version: 3.8.1
     INFO 208 --- [gombi-kafka-producer] [nio-8443-exec-7] o.a.kafka.common.utils.AppInfoParser     : Kafka commitId: 70d6ff42debf7e17
     INFO 208 --- [gombi-kafka-producer] [nio-8443-exec-7] o.a.kafka.common.utils.AppInfoParser     : Kafka startTimeMs: 1738269159771
     INFO 208 --- [gombi-kafka-producer] [nio-8443-exec-7] c.r.g.s.m.p.c.KafkaConfiguration         : ProducerFactory > PostProcessor > apply
     INFO 208 --- [gombi-kafka-producer] [nio-8443-exec-7] c.r.g.s.m.p.c.KafkaConfiguration         : ProducerFactory > listener: message producer has been added, id: producerFactory.gombi-kafka-producer-producer-3
     INFO 208 --- [gombi-kafka-producer] [ucer-producer-3] org.apache.kafka.clients.Metadata        : [Producer clientId=gombi-kafka-producer-producer-3] Cluster ID: Z3jqNJOGSde4C-WEbLVjHg
     INFO 208 --- [gombi-kafka-producer] [ucer-producer-3] o.a.k.c.p.internals.TransactionManager   : [Producer clientId=gombi-kafka-producer-producer-3] ProducerId set to 1001 with epoch 0
    DEBUG 208 --- [gombi-kafka-producer] [nio-8443-exec-7] c.r.g.c.m.MethodStatisticsAspect         : registering the method call to Micrometer: {meter-name: "remal_method_calls", method: "KafkaProducerController.sendOneMessage", status: "ok"}
    DEBUG 208 --- [gombi-kafka-producer] [nio-8443-exec-7] c.r.g.c.m.MethodStatisticsAspect         : < call ended: {name: KafkaProducerController.sendOneMessage, return: "A message has been sent to the <b>incoming</b> Kafka topic.", execution-in-ms: 15}
    DEBUG 208 --- [gombi-kafka-producer] [nio-8443-exec-7] c.r.g.c.m.MethodStatisticsAspect         : registering the method execution time to Micrometer: {meter-name: "remal_method_execution_time", method: "KafkaProducerController.sendOneMessage", execution-time-in-ms: 15}...
    DEBUG 208 --- [gombi-kafka-producer] [ucer-producer-3] c.r.g.s.m.p.s.KafkaProducerService       : sending a message to kafka has been finished
     INFO 208 --- [gombi-kafka-producer] [ucer-producer-3] c.r.g.s.m.p.s.KafkaProducerService       : message has been sent to Kafka successfully: {topic: "incoming", partition: 1, offset: 0, key: "null", value: "{sourceSystem: "payment-service", owner: "amelia", payload: "{"comment": "default message"}", createdInUtc: "2025-01-30 20:32:39.764""}
    ~~~
