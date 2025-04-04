-- Установка расширения для UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Создание последовательностей
CREATE SEQUENCE bound_communities_id_seq;
CREATE SEQUENCE giveaways_id_seq;
CREATE SEQUENCE congratulations_id_seq;
CREATE SEQUENCE giveaway_communities_id_seq;
CREATE SEQUENCE giveaway_winners_id_seq;
CREATE SEQUENCE participations_id_seq;
CREATE SEQUENCE users_id_seq;

-- Создание таблиц без внешних ключей (users, giveaways)
CREATE TABLE users (
    id                  INTEGER PRIMARY KEY DEFAULT nextval('users_id_seq'),
    user_id             BIGINT,
    payment_status      VARCHAR,
    payment_amount      NUMERIC,
    created_at          TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    payment_currency    VARCHAR,
    subscription_status VARCHAR,
    telegram_username   VARCHAR
);

CREATE TABLE giveaways (
    id                        VARCHAR(8) PRIMARY KEY DEFAULT nextval('giveaways_id_seq'),
    user_id                   BIGINT,
    name                      TEXT,
    description               TEXT,
    end_time                  TIMESTAMP WITH TIME ZONE,
    winner_count              INTEGER,
    is_active                 TEXT DEFAULT 'false',
    media_type                TEXT,
    media_file_id             TEXT,
    created_at                TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at                TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    participant_counter_tasks JSONB DEFAULT '{}',
    published_messages        JSONB DEFAULT '{}',
    invite                    BOOLEAN DEFAULT FALSE,
    quantity_invite           INTEGER DEFAULT 0,
    is_completed              BOOLEAN DEFAULT FALSE
);

-- Создание таблиц с внешними ключами
CREATE TABLE bound_communities (
    id                 INTEGER PRIMARY KEY DEFAULT nextval('bound_communities_id_seq'),
    user_id            BIGINT,
    community_username TEXT,
    community_id       BIGINT,
    created_at         TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    community_type     TEXT,
    community_name     TEXT,
    media_file_ava     TEXT
);

CREATE TABLE congratulations (
    id          INTEGER PRIMARY KEY DEFAULT nextval('congratulations_id_seq'),
    giveaway_id VARCHAR(8) REFERENCES giveaways(id),
    place       INTEGER,
    message     TEXT,
    created_at  TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at  TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE giveaway_communities (
    id                 INTEGER PRIMARY KEY DEFAULT nextval('giveaway_communities_id_seq'),
    giveaway_id        VARCHAR(8) REFERENCES giveaways(id),
    community_id       BIGINT,
    community_username TEXT,
    community_type     TEXT,
    user_id            BIGINT,
    community_name     TEXT,
    media_file_ava     TEXT
);

CREATE TABLE giveaway_winners (
    id          INTEGER PRIMARY KEY DEFAULT nextval('giveaway_winners_id_seq'),
    giveaway_id VARCHAR(8) REFERENCES giveaways(id),
    user_id     BIGINT,
    username    TEXT,
    created_at  TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    place       INTEGER,
    name        TEXT
);

CREATE TABLE invitations (
    id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    inviting_id TEXT,
    giveaway_id VARCHAR(8) REFERENCES giveaways(id),
    invited_id  TEXT,
    created_at  TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE participations (
    id          INTEGER PRIMARY KEY DEFAULT nextval('participations_id_seq'),
    user_id     BIGINT,
    giveaway_id VARCHAR(8) REFERENCES giveaways(id),
    created_at  TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_user_giveaway UNIQUE (user_id, giveaway_id)
);

-- Установка владельца для всех таблиц
ALTER TABLE bound_communities OWNER TO postgres;
ALTER TABLE giveaways OWNER TO postgres;
ALTER TABLE congratulations OWNER TO postgres;
ALTER TABLE giveaway_communities OWNER TO postgres;
ALTER TABLE giveaway_winners OWNER TO postgres;
ALTER TABLE invitations OWNER TO postgres;
ALTER TABLE participations OWNER TO postgres;
ALTER TABLE users OWNER TO postgres;

-- Применение прав доступа
GRANT DELETE, INSERT, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON bound_communities TO app_user;
GRANT DELETE, INSERT, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON bound_communities TO new_user;

GRANT DELETE, INSERT, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON giveaways TO app_user;
GRANT DELETE, INSERT, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON giveaways TO new_user;

GRANT DELETE, INSERT, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON congratulations TO app_user;
GRANT DELETE, INSERT, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON congratulations TO new_user;

GRANT DELETE, INSERT, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON giveaway_communities TO app_user;
GRANT DELETE, INSERT, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON giveaway_communities TO new_user;

GRANT DELETE, INSERT, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON giveaway_winners TO app_user;
GRANT DELETE, INSERT, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON giveaway_winners TO new_user;

GRANT DELETE, INSERT, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON invitations TO app_user;
GRANT DELETE, INSERT, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON invitations TO new_user;

GRANT DELETE, INSERT, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON participations TO app_user;
GRANT DELETE, INSERT, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON participations TO new_user;

GRANT DELETE, INSERT, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON users TO app_user;
GRANT DELETE, INSERT, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON users TO new_user;
