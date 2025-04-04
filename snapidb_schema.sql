create table bound_communities
(
    id                 integer                  default nextval('bound_communities_id_seq'::regclass) not null
        primary key,
    user_id            bigint,
    community_username text,
    community_id       bigint,
    created_at         timestamp with time zone default CURRENT_TIMESTAMP,
    community_type     text,
    community_name     text,
    media_file_ava     text
);

alter table bound_communities
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on bound_communities to app_user;

grant delete, insert, references, select, trigger, truncate, update on bound_communities to new_user;

create table giveaways
(
    id                        varchar(8)               default nextval('giveaways_id_seq'::regclass) not null
        primary key,
    user_id                   bigint,
    name                      text,
    description               text,
    end_time                  timestamp with time zone,
    winner_count              integer,
    is_active                 text                     default 'false'::text,
    media_type                text,
    media_file_id             text,
    created_at                timestamp with time zone default CURRENT_TIMESTAMP,
    updated_at                timestamp with time zone default CURRENT_TIMESTAMP,
    participant_counter_tasks jsonb                    default '{}'::jsonb,
    published_messages        jsonb                    default '{}'::jsonb,
    invite                    boolean                  default false,
    quantity_invite           integer                  default 0,
    is_completed              boolean                  default false
);

alter table giveaways
    owner to postgres;

create table congratulations
(
    id          integer                  default nextval('congratulations_id_seq'::regclass) not null
        primary key,
    giveaway_id varchar(8)
        references giveaways,
    place       integer,
    message     text,
    created_at  timestamp with time zone default now(),
    updated_at  timestamp with time zone default now()
);

alter table congratulations
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on congratulations to app_user;

grant delete, insert, references, select, trigger, truncate, update on congratulations to new_user;

create table giveaway_communities
(
    id                 integer default nextval('giveaway_communities_id_seq'::regclass) not null
        primary key,
    giveaway_id        varchar(8)
        references giveaways,
    community_id       bigint,
    community_username text,
    community_type     text,
    user_id            bigint,
    community_name     text,
    media_file_ava     text
);

alter table giveaway_communities
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on giveaway_communities to app_user;

grant delete, insert, references, select, trigger, truncate, update on giveaway_communities to new_user;

create table giveaway_winners
(
    id          integer                  default nextval('giveaway_winners_id_seq'::regclass) not null
        primary key,
    giveaway_id varchar(8)
        references giveaways,
    user_id     bigint,
    username    text,
    created_at  timestamp with time zone default now(),
    place       integer,
    name        text
);

alter table giveaway_winners
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on giveaway_winners to app_user;

grant delete, insert, references, select, trigger, truncate, update on giveaway_winners to new_user;

grant delete, insert, references, select, trigger, truncate, update on giveaways to app_user;

grant delete, insert, references, select, trigger, truncate, update on giveaways to new_user;

create table invitations
(
    id          uuid                     default uuid_generate_v4() not null
        primary key,
    inviting_id text,
    giveaway_id varchar(8)
        references giveaways,
    invited_id  text,
    created_at  timestamp with time zone default now()
);

alter table invitations
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on invitations to app_user;

grant delete, insert, references, select, trigger, truncate, update on invitations to new_user;

create table participations
(
    id          integer                  default nextval('participations_id_seq'::regclass) not null
        primary key,
    user_id     bigint,
    giveaway_id varchar(8)
        references giveaways,
    created_at  timestamp with time zone default CURRENT_TIMESTAMP,
    constraint unique_user_giveaway
        unique (user_id, giveaway_id)
);

alter table participations
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on participations to app_user;

grant delete, insert, references, select, trigger, truncate, update on participations to new_user;

create table users
(
    id                  integer                  default nextval('users_id_seq'::regclass) not null
        primary key,
    user_id             bigint,
    payment_status      varchar,
    payment_amount      numeric,
    created_at          timestamp with time zone default CURRENT_TIMESTAMP,
    updated_at          timestamp with time zone default CURRENT_TIMESTAMP,
    payment_currency    varchar,
    subscription_status varchar,
    telegram_username   varchar
);

alter table users
    owner to postgres;

grant delete, insert, references, select, trigger, truncate, update on users to app_user;

grant delete, insert, references, select, trigger, truncate, update on users to new_user;

