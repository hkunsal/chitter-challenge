DROP TABLE IF EXISTS makers, peeps; 

-- Create the table without the foreign key first.
CREATE TABLE makers (
  id SERIAL PRIMARY KEY,
  username text,
  password text,
  name text,
  email text unique
);

-- Then the table with the foreign key first.
CREATE TABLE peeps (
  id SERIAL PRIMARY KEY,
  content text,
  created_at date,
-- The foreign key name is always {other_table_singular}_id
  maker_id int,
  constraint fk_maker foreign key(maker_id)
    references makers(id)
    on delete cascade
);

INSERT INTO makers ("username", "password", "name", "email") VALUES
('sammorgan', 'sam123', 'Sam Morgan', 'sammorgan123@gmail.com'),
('johnappleseed', 'john777', 'John Appleseed', 'jappleseed@icloud.com'),
('dianap', 'diana70', 'Diana Pascal', 'dpascal70@gmail.com');

INSERT INTO peeps ("content", "created_at", "maker_id") VALUES
('Hi, this is my first peep!', '2022-01-05'::DATE, 1),
('Great day ahead', '2022-03-10'::DATE, 2),
('Hi dudes and dudettes!', '2022-09-18'::DATE, 3);