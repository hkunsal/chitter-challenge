TRUNCATE TABLE makers RESTART IDENTITY; 

INSERT INTO makers ("username", "password", "name", "email") VALUES
('sammorgan', 'sam123', "Sam Morgan", "sammorgan123@gmail.com"),
('johnappleseed', 'john777', "John Appleseed", "jappleseed@icloud.com"),
('dianap', 'diana70', "Diana Pascal", "dpascal70@gmail.com");