DROP DATABASE IF EXISTS Fanfiction_App;
CREATE DATABASE Fanfiction_App;
USE Fanfiction_App;

CREATE TABLE users (
	user_id INT AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    hashed_password VARCHAR(100) NOT NULL,
    PRIMARY KEY (user_id)
);

CREATE TABLE fanfic_objective (
	fanfic_id INT AUTO_INCREMENT,
    link VARCHAR(500) NOT NULL,
    fandom VARCHAR(200),
    title VARCHAR(100),
    author VARCHAR(100),
    summary VARCHAR(2000),
    PRIMARY KEY (fanfic_id)
);

CREATE TABLE tags (
	tag_id INT AUTO_INCREMENT,
    tag_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (tag_id)
);

CREATE TABLE fanfic_tags (
	fanfic_id INT,
    tag_id INT,
    PRIMARY KEY (fanfic_id, tag_id),
    FOREIGN KEY (fanfic_id) REFERENCES fanfic_objective(fanfic_id),
    FOREIGN KEY (tag_id) REFERENCES tags(tag_id)
);

CREATE TABLE fanfic_subjective (
	user_id INT,
    fanfic_id INT,
    rating DOUBLE NULL CHECK (rating >= 1 AND rating <= 5),
    review VARCHAR(1000),
    favorite_moments VARCHAR(1000),
    assigned_list ENUM('Read', 'To-Read'),
    PRIMARY KEY (user_id, fanfic_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (fanfic_id) REFERENCES fanfic_objective(fanfic_id)
);

CREATE TABLE user_favorite_tags (
	user_id INT,
    fanfic_id INT,
    tag_id INT,
    PRIMARY KEY (user_id, fanfic_id, tag_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (fanfic_id) REFERENCES fanfic_objective(fanfic_id),
    FOREIGN KEY (tag_id) REFERENCES tags(tag_id)
);