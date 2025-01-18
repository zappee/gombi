-- topic_user_messages table
CREATE SEQUENCE IF NOT EXISTS topic_user_messages_id_seq
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    START WITH 1;

CREATE TABLE IF NOT EXISTS topic_user_messages (
    id integer NOT NULL DEFAULT nextval('topic_user_messages_id_seq'),
    payload varchar,
    PRIMARY KEY (id)
    );

ALTER SEQUENCE topic_user_messages_id_seq OWNED BY topic_user_messages.id;
