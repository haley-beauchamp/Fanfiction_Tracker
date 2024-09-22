DROP DATABASE IF EXISTS Fanfiction_App;
CREATE DATABASE Fanfiction_App;
USE Fanfiction_App;

CREATE TABLE users (
	user_id INT AUTO_INCREMENT,
    email VARCHAR(100),
    hashed_password VARCHAR(100),
    PRIMARY KEY (user_id)
);

CREATE TABLE fanfic_objective (
	fanfic_id INT AUTO_INCREMENT,
    link VARCHAR(500),
    fandom VARCHAR(50),
    title VARCHAR(100),
    author VARCHAR(100),
    PRIMARY KEY (fanfic_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);