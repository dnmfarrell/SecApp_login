pragma foreign_keys = on;
create table user (
    id              integer primary key,
    username        text,
    password        text,
    name            text,
    email           text,
    set_password    integer,
    active          integer,
    created         timestamp,
    updated         timestamp
);
insert into user values(1, 'admin', '', 'David Farrell', 'perltricks.com@gmail.com', 1, 1, datetime('now'), datetime('now'));

