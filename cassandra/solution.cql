describe cluster;

create keyspace my_ks with replication = {'class': 'SimpleStrategy', 'replication_factor': 1};
use my_ks;

-- Первая таблица - для запросов №1-3
drop table if exists user_post;
create table user_post (
    user_id int,
    user_name text,
    user_email text,
    post_id int,
    post_topic_id int,
    content text,
    created_at timestamp,
    PRIMARY KEY (user_id, created_at)
) with clustering order by (created_at desc);

-- Заполнение первой таблицы
insert into user_post (user_id, user_name, user_email,
                       post_id, post_topic_id, content, created_at)
values (1, 'Max', 'akademuk97@gmail.com', 1, 1, 'post1', '2023-12-21 12:00+0000');
insert into user_post (user_id, user_name, user_email,
                       post_id, post_topic_id, content, created_at)
values (1, 'Max', 'akademuk97@gmail.com', 2, 1, 'post2', '2023-12-21 09:00+0000');
insert into user_post (user_id, user_name, user_email,
                       post_id, post_topic_id, content, created_at)
values (1, 'Max', 'akademuk97@gmail.com', 3, 1, 'post3', '2023-12-21 11:00+0000');
insert into user_post (user_id, user_name, user_email,
                       post_id, post_topic_id, content, created_at)
values (1, 'Max', 'akademuk97@gmail.com', 4, 1, 'post4', '2023-12-21 10:00+0000');
insert into user_post (user_id, user_name, user_email,
                       post_id, post_topic_id, content, created_at)
values (2, 'Alex', 'a.krasovskii@hh.ru', 5, 1, 'post5', '2023-12-21 12:00+0000');
insert into user_post (user_id, user_name, user_email,
                       post_id, post_topic_id, content, created_at)
values (2, 'Alex', 'a.krasovskii@hh.ru', 6, 1, 'post6', '2023-12-21 09:00+0000');
insert into user_post (user_id, user_name, user_email,
                       post_id, post_topic_id, content, created_at)
values (2, 'Alex', 'a.krasovskii@hh.ru', 7, 1, 'post7', '2023-12-21 11:00+0000');
insert into user_post (user_id, user_name, user_email,
                       post_id, post_topic_id, content, created_at)
values (2, 'Alex', 'a.krasovskii@hh.ru', 8, 1, 'post8', '2023-12-21 10:00+0000');

select * from user_post;

-- Вторая таблица - для запроса №4
drop table if exists user_post_with_topics;
create table user_post_with_topics (
    user_id int,
    user_name text,
    user_email text,
    post_id int,
    post_topic_id int,
    content text,
    created_at timestamp,
    date timestamp,
    PRIMARY KEY ((date, post_topic_id), created_at)
) with clustering order by (created_at desc);

-- Заполнение второй таблицы
insert into user_post_with_topics (user_id, user_name, user_email,
                                   post_id, post_topic_id, content, date, created_at)
values (1, 'Max', 'akademuk97@gmail.com', 1, 1, 'post1', '2023-12-21', '2023-12-21 12:00+0000');
insert into user_post_with_topics (user_id, user_name, user_email,
                                   post_id, post_topic_id, content, date, created_at)
values (2, 'Alex', 'a.krasovskii@hh.ru', 2, 2, 'post2', '2023-12-21', '2023-12-21 09:00+0000');
insert into user_post_with_topics (user_id, user_name, user_email,
                                   post_id, post_topic_id, content, date, created_at)
values (1, 'Max', 'akademuk97@gmail.com', 3, 2, 'post3', '2023-12-21', '2023-12-21 11:00+0000');
insert into user_post_with_topics (user_id, user_name, user_email,
                                   post_id, post_topic_id, content, date, created_at)
values (2, 'Alex', 'a.krasovskii@hh.ru', 4, 1, 'post4', '2023-12-21', '2023-12-21 10:00+0000');
insert into user_post_with_topics (user_id, user_name, user_email,
                                   post_id, post_topic_id, content, date, created_at)
values (1, 'Max', 'akademuk97@gmail.com', 5, 1, 'post5', '2023-12-22', '2023-12-22 12:00+0000');
insert into user_post_with_topics (user_id, user_name, user_email,
                                   post_id, post_topic_id, content, date, created_at)
values (2, 'Alex', 'a.krasovskii@hh.ru', 6, 2, 'post6', '2023-12-22', '2023-12-22 09:00+0000');
insert into user_post_with_topics (user_id, user_name, user_email,
                                   post_id, post_topic_id, content, date, created_at)
values (1, 'Max', 'akademuk97@gmail.com', 7, 2, 'post7', '2023-12-22', '2023-12-22 11:00+0000');
insert into user_post_with_topics (user_id, user_name, user_email,
                                   post_id, post_topic_id, content, date, created_at)
values (2, 'Alex', 'a.krasovskii@hh.ru', 8, 1, 'post8', '2023-12-22', '2023-12-22 10:00+0000');

select * from user_post_with_topics;

-- Запрос, который бы доставал посты заданного пользователя
-- упорядоченные по времени создания поста - сначала новые.
-- Запрос должен возвращать post_id, content, дату создания поста.
select post_id, content, created_at
from user_post
where user_id=2
order by created_at desc;

-- Запрос, который бы доставал последний пост заданного пользователя.
-- Запрос должен возвращать post_id, content, дату создания поста, username.
select post_id, content, created_at, user_name
from user_post
where user_id=1
order by created_at desc
limit 1;

-- Запрос, который бы доставал посты заданного пользователя, опубликованные после заданной даты.
-- Запрос должен возвращать post_id, content, дату создания поста.
select post_id, content, created_at
from user_post
where user_id=1 and created_at > '2023-12-21 10:59+0000';

-- Запрос, который бы доставал пользователей, которые сделали пост
-- в заданный день по заданной теме, упорядоченные по времени - сначала новые.
-- Запрос должен возвращать user_id, username, post_id, время создания поста.
select user_id, user_name, post_id, created_at
from user_post_with_topics
where date='2023-12-21' and post_topic_id=2
order by created_at desc;

