TRUNCATE TABLE users, peeps, current, comments RESTART IDENTITY;

INSERT INTO users (username, password, name, email) VALUES ('Doug1234', 'Vkpe3623?', 'Doug', 'Doug@gmail.com'), ('stinky', 'Zrrujma0372&', 'Kevin', 'email@gmail.com'), ('Melody', '?969ov', 'Melody', 'Mels@gmail.com');

INSERT INTO peeps (title, content, time, user_id) VALUES ('My day', 'My day was okay, thank you for asking everyone.', '2022-01-01 19:10:32', 1), ('This website sucks', 'I tried to hack it and they changed my username to stinky :(', '2022-02-22 03:01:09', 2), ('Promotion!', 'it happened at 12:21:12 it must be my lucky day!', '2022-03-06 15:51:15', 3), ('My day', 'My day was good, I won the lottery. Thank you for asking everyone.', '2022-05-10 19:10:32', 1), ('Apologies everyone!', 'I turned over a new leaf, stopped hacking, started showering. Im gonna keep the old username still :)', '2022-07-03 19:22:18', 2), ('I have made a decision', 'I have decided that I got the promotion because I worked hard, I will not discount the hard work and effort I put in to achieve it', '2022-09-09 15:51:15', 3);

INSERT INTO current (current_user_id) VALUES (0);

INSERT INTO comments (user_id, content, peep_id) VALUES (3, 'Seems like thats what you get, stinky.', 2), (1, 'Congratulations Melody.', 3), (3, 'Thanks Doug!!', 3), (2, 'Woah! Way to go! Quick question whats the last 3 digits of your card number? XD', 4), (1, '462, why?', 4), (3, 'Stinky! Dont be mean!', 4), (1, 'Hey, can I get that money back then?', 5), (3, 'Good job stinky!', 5), (1, 'Congratulations Melody.', 6), (3, 'Thanks Doug!!!', 6);