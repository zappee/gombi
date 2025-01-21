-- event table
CREATE SEQUENCE IF NOT EXISTS event_id_seq
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    START WITH 1;

CREATE TABLE IF NOT EXISTS event (
    id integer NOT NULL DEFAULT nextval('event_id_seq'),
    source varchar(30),
    owner varchar(50),
    payload varchar,
    created_in_utc timestamp without time zone,
    PRIMARY KEY (id)
    );

ALTER SEQUENCE event_id_seq OWNED BY event.id;
