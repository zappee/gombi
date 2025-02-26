# Empty


~~~
java -jar target/remal-gombi-kafka-player-0.4.0.jar \
    --sql-port 14415 \
    --sql-database postgres \
    --sql-command "SELECT user_id, payload FROM event WHERE topic = 'incoming' and created_in_utc BETWEEN '2025-03-01 00:00:00' AND '2025-03-01 23:59:59' ORDER BY id" \
    --sql-user application \
    --sql-password password \
    --kafka-host localhost \
    --kafka-port 13053 \
    --kafka-topic incoming
~~~