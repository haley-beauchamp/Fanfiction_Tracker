# Fanfiction_Tracker
A mobile fanfiction tracking app similar to Goodreads for my Database Design and Management course. When opening the project, the user is prompted to create an account. Once they have logged in, that state is persisted. On logged in, they are navigated to the home page, which allows users to input a link from Ao3. The app will either grab the details from the database or scrape the html of the linked Ao3 website. From there, the user can write a review, rate the fanfic, and add it to a list. Lists can be sorted by various fanfic attributes, and reviews edited or deleted from the lists tab.

## Technologies Used
- Frontend: Flutter
- Backend: Node.js with JavaScript
- Database: MySQL

## Setup Instructions
1. Backend Setup

    a. To run, create a .env file in the Backend folder with the following:
      - MYSQL_HOST = ''
      - MYSQL_USER = ''
      - MYSQL_PASSWORD = ''
      - MYSQL_DATABASE = 'Fanfiction_App'
      - TOKEN_SECRET = ''
  
    b. npm run dev in the Backend directory

3. Frontend Setup
   
   a. flutter pub get in the Flutter project directory

   b. To get the project to work on an Android emulator, edit global_variables.dart (located: Frontend/fanfiction_tracker_flutter/lib/constants/global_variables.dart). It's currently set to localhost, which only works for the iPhone emulator.
    - String uri = 'http://ipaddress:3000';

3. Database Setup
   
Run the Fanfiction_App.sql file included in the Database folder to set up the database.
