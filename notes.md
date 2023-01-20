Home - GET /
Has all peeps, has user login

Sign in - GET /signin

Sign up - GET /signup

Specific peep - GET /:id

Post peep - GET /post

Peep posted - POST /



CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username text,
  password text,
  name text,
  email text
);

CREATE TABLE peeps (
  id SERIAL PRIMARY KEY,
  title text,
  content text,
  time timestamp,
  user_id int,
  constraint fk_user foreign key(user_id)
    references users(id)
    on delete cascade
);

CREATE TABLE comments (
  id SERIAL PRIMARY KEY,
  user_id int,
  content text,
  peep_id int,
  constraint fk_peep foreign key(peep_id)
    references peeps(id)
    on delete cascade
);