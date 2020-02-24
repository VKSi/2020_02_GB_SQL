CREATE DATABASE IF NOT EXISTS litres;

USE litres;
-- ------------------------------------------------------------------------------
-- Description
-- ------------------------------------------------------------------------------
/*
This code was prepared as a capstone project on the course DataBases AI faculty
of GeekBrains educational portal https://geekbrains.ru/geek_university/data-science

This base support the essencial features of the bookstore. However, considering the
given time for the task conpletion and the recomendation for the assignment it
includes only the 'stock' part of the store and doesn't include any features
related to the customers and sales.
This code includes the following parts:
	- Tables' creation
    - Constraints
    - Indexes
    - Scripts for filling the tables by data in regard to the given constraints
    - Trggers
    - Examples of most common inquires
*/
-- ------------------------------------------------------------------------------
-- Tables' creation
-- ------------------------------------------------------------------------------
DROP TABLE IF EXISTS authors;
CREATE TABLE authors(
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(100) NOT NULL,
	last_name VARCHAR(100) NOT NULL,
    description VARCHAR(250),
    photo_path VARCHAR(250),
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME DEFAULT NOW() ON UPDATE NOW()
) COMMENT = 'The most important information about authors';
INSERT INTO authors VALUE (1, 'Unknown', 'Unknown', NULL, NULL, DEFAULT, DEFAULT);

DROP TABLE IF EXISTS readers;
CREATE TABLE readers(
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(100) NOT NULL,
	last_name VARCHAR(100) NOT NULL,
    description VARCHAR(250),
    photo_path VARCHAR(250),
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME DEFAULT NOW() ON UPDATE NOW()
) COMMENT = 'The most important information about readers of audi books';

DROP TABLE IF EXISTS translators;
CREATE TABLE translators(
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(100) NOT NULL,
	last_name VARCHAR(100) NOT NULL,
    description VARCHAR(250),
    photo_path VARCHAR(250),
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME DEFAULT NOW() ON UPDATE NOW()
) COMMENT = 'The most important information about translators';

DROP TABLE IF EXISTS publishers;
CREATE TABLE publishers(
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
    description VARCHAR(250),
    logo_path VARCHAR(250),
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME DEFAULT NOW() ON UPDATE NOW()
) COMMENT = 'The most important information about publishers';

DROP TABLE IF EXISTS genres;
CREATE TABLE genres(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(150) NOT NULL UNIQUE
) COMMENT = 'The list of genres';
INSERT INTO genres VALUE (1, 'Others');

DROP TABLE IF EXISTS restrictions;
CREATE TABLE restrictions(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(50) NOT NULL UNIQUE
) COMMENT = 'The list of age restrictions';

DROP TABLE IF EXISTS original_languages;
CREATE TABLE original_languages(
	id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
) COMMENT = 'List of original languges for books';

DROP TABLE IF EXISTS books;
CREATE TABLE books(
	id SERIAL PRIMARY KEY,
	title VARCHAR(250) NOT NULL,
    description VARCHAR(250) NOT NULL,
	author_id BIGINT UNSIGNED NOT NULL DEFAULT(1),
	genre_id INT UNSIGNED NOT NULL DEFAULT(1),
	first_publication_year INT UNSIGNED NOT NULL,
    restriction_id INT UNSIGNED NOT NULL,
    original_language_id BIGINT UNSIGNED,
    translator_id BIGINT UNSIGNED,
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME DEFAULT NOW() ON UPDATE NOW()
) COMMENT = 'The most important information about books (not issues!)';

DROP TABLE IF EXISTS issues_pandel;
CREATE TABLE issues_pandel(
	id SERIAL PRIMARY KEY,
	book_id BIGINT UNSIGNED NOT NULL,
    publisher_id BIGINT UNSIGNED NOT NULL,
    publication_year INT UNSIGNED NOT NULL,
    isbn VARCHAR(13) NOT NULL,
    size FLOAT UNSIGNED NOT NULL,
    cover_path VARCHAR(250),
    issue_type ENUM('paper', 'electronic') NOT NULL DEFAULT('electronic'), 
	trial_media_id BIGINT UNSIGNED,
    full_media_id BIGINT UNSIGNED,
    price FLOAT UNSIGNED NOT NULL,
    rating FLOAT UNSIGNED,
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME DEFAULT NOW() ON UPDATE NOW()
) COMMENT = 'The most important information about paper electronic issue';

DROP TABLE IF EXISTS issues_aud;
CREATE TABLE issues_aud(
	id SERIAL PRIMARY KEY,
	book_id BIGINT UNSIGNED NOT NULL,
    reader_id BIGINT UNSIGNED NOT NULL,
    duration TIME NOT NULL,
    publisher_id BIGINT UNSIGNED NOT NULL,
    publication_year INT UNSIGNED NOT NULL,
    trial_media_id BIGINT UNSIGNED,
    full_media_id BIGINT UNSIGNED,
    price FLOAT UNSIGNED NOT NULL,
    rating FLOAT UNSIGNED,
	cover_path VARCHAR(250),
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME DEFAULT NOW() ON UPDATE NOW()
) COMMENT = 'The most important information about audio issue';

DROP TABLE IF EXISTS media;
CREATE TABLE media(
	id SERIAL PRIMARY KEY,
    issue_id BIGINT UNSIGNED NOT NULL,
    issue_table ENUM ('issues_pandel', 'issues_aud') NOT NULL,
	media_type_id BIGINT UNSIGNED NOT NULL,
	description VARCHAR(250),
    name VARCHAR(100) NOT NULL,
    media_path VARCHAR(250) NOT NULL,
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME DEFAULT NOW() ON UPDATE NOW()
) COMMENT = 'Data of media files';

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
	id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
) COMMENT = 'Types media files';


-- ------------------------------------------------------------------------------
-- Constraints
-- ------------------------------------------------------------------------------
/* 
ALTER TABLE books DROP FOREIGN KEY books_author_id_fk;
ALTER TABLE books DROP FOREIGN KEY books_genre_id_fk;
ALTER TABLE books DROP FOREIGN KEY books_restriction_id_fk;
ALTER TABLE books DROP FOREIGN KEY books_translator_id_fk;
ALTER TABLE books DROP FOREIGN KEY books_original_language_id_fk;
ALTER TABLE issues_pandel DROP FOREIGN KEY issues_pandel_book_id_fk; 
ALTER TABLE issues_pandel DROP FOREIGN KEY issues_pandel_publisher_id_fk;
ALTER TABLE issues_pandel DROP FOREIGN KEY issues_pandel_trial_media_id_fk;
ALTER TABLE issues_pandel DROP FOREIGN KEY issues_pandel_full_media_id_fk;
ALTER TABLE issues_aud DROP FOREIGN KEY issues_aud_book_id_fk;
ALTER TABLE issues_aud DROP FOREIGN KEY issues_aud_reader_id_fk;
ALTER TABLE issues_aud DROP FOREIGN KEY issues_aud_publisher_id_fk;
ALTER TABLE issues_aud DROP FOREIGN KEY issues_aud_trial_media_id_fk;
ALTER TABLE issues_aud DROP FOREIGN KEY issues_aud_full_media_id_fk;
ALTER TABLE media DROP FOREIGN KEY media_media_type_id_fk; 
*/  

ALTER TABLE books
  ADD CONSTRAINT books_author_id_fk 
    FOREIGN KEY (author_id) REFERENCES authors(id)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
  ADD CONSTRAINT books_genre_id_fk
    FOREIGN KEY (genre_id) REFERENCES genres(id),
  ADD CONSTRAINT books_restriction_id_fk
    FOREIGN KEY (restriction_id) REFERENCES restrictions(id)
      ON UPDATE CASCADE,
  ADD CONSTRAINT books_translator_id_fk
    FOREIGN KEY (translator_id) REFERENCES translators(id)
      ON DELETE SET NULL
      ON UPDATE CASCADE,
  ADD CONSTRAINT books_original_language_id_fk 
    FOREIGN KEY (original_language_id) REFERENCES original_languages(id)
      ON DELETE SET NULL
      ON UPDATE CASCADE;
 
ALTER TABLE issues_pandel
  ADD CONSTRAINT issues_pandel_book_id_fk
    FOREIGN KEY (book_id) REFERENCES books(id)
	  ON DELETE CASCADE
      ON UPDATE CASCADE,
  ADD CONSTRAINT issues_pandel_publisher_id_fk 
    FOREIGN KEY (publisher_id) REFERENCES publishers(id)
      ON UPDATE CASCADE,
  ADD CONSTRAINT issues_pandel_trial_media_id_fk
    FOREIGN KEY (trial_media_id) REFERENCES media(id)
	  ON DELETE CASCADE
      ON UPDATE CASCADE,
  ADD CONSTRAINT issues_pandel_full_media_id_fk
    FOREIGN KEY (full_media_id) REFERENCES media(id)
	  ON DELETE CASCADE
      ON UPDATE CASCADE;

ALTER TABLE issues_aud
  ADD CONSTRAINT issues_aud_book_id_fk
    FOREIGN KEY (book_id) REFERENCES books(id)
	  ON DELETE CASCADE
      ON UPDATE CASCADE,
  ADD CONSTRAINT issues_aud_reader_id_fk
    FOREIGN KEY (reader_id) REFERENCES readers(id)
	  ON DELETE CASCADE
      ON UPDATE CASCADE,
  ADD CONSTRAINT issues_aud_publisher_id_fk 
    FOREIGN KEY (publisher_id) REFERENCES publishers(id)
      ON UPDATE CASCADE,
  ADD CONSTRAINT issues_aud_trial_media_id_fk
    FOREIGN KEY (trial_media_id) REFERENCES media(id)
	  ON DELETE CASCADE
      ON UPDATE CASCADE,
  ADD CONSTRAINT issues_aud_full_media_id_fk
    FOREIGN KEY (full_media_id) REFERENCES media(id)
	  ON DELETE CASCADE
      ON UPDATE CASCADE;

ALTER TABLE media
  ADD CONSTRAINT media_media_type_id_fk 
    FOREIGN KEY (media_type_id) REFERENCES media_types(id);
      
-- ------------------------------------------------------------------------------
-- Indexes
-- ------------------------------------------------------------------------------
-- Since there are lot of foreign keys I didn't create lots of indexes manualy.

CREATE INDEX authors_first_name_last_name_idx ON authors(first_name, last_name);    
CREATE INDEX books_title_idx ON books(title);
CREATE UNIQUE INDEX books_title_author_id_uq ON books(title, author_id);

-- ------------------------------------------------------------------------------
-- Tables' filling
-- ------------------------------------------------------------------------------

INSERT INTO media_types (name) VALUES
  ('mp3'), ('m4b'), ('zip'),
  ('txt'), ('rtf'), ('fb2'),
  ('fb3'), ('mobi'), ('pdf A4'),
  ('pdf A6'), ('ios.epub');
  
INSERT INTO restrictions (name) VALUES
  ('0+'), ('6+'), ('12+'), ('16+'), ('18+');
  
INSERT INTO original_languages (name) VALUES
  ('Russian'), ('English'), ('French'),
  ('Spanish'), ('Chinese'), ('German');
  
INSERT INTO genres(name) VALUES ('Art & Photography'), ('Biography'), ("Children's Books"), ('Crafts & Hobbies'), ('Crime & Thriller'), 
					('Fiction'), ('Food & Drink'), ('Graphic Novels, Anime & Manga'), ('History & Archaeology'), ('Mind, Body & Spirit'),
					('Science Fiction, Fantasy & Horror'), ('Business, Finance & Law'), ('Computing'), ('Dictionaries & Languages'),
					('Entertainment'), ('Health'), ('Home & Garden'), ('Humour'), ('Medical'), ('Natural History'), ('Personal Development'),
					('Poetry & Drama'), ('Reference'), ('Religion'), ('Romance'), ('Science & Geography'), ('Society & Social Sciences'),
					('Sport'), ('Stationery'), ('Teaching Resources & Education'), ('Technology & Engineering'), ('Teen & Young Adult'),
					('Transport'), ('Travel & Holiday Guides');

DROP TABLE IF EXISTS data_;
CREATE TEMPORARY TABLE data_ (
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(250),
    last_name VARCHAR(250),
    mail VARCHAR(250),
    phone VARCHAR(250),
    date1 DATETIME,
    date2 DATETIME);
    
INSERT INTO data_ VALUES (1,'Etha','Heathcote','towne.cary@example.com','1-436-176-8168','1973-09-21 06:53:41','2001-12-05 17:24:07'),(2,'Dell','O\'Kon','schultz.walton@example.net','07332358587','2017-04-26 15:55:04','1982-08-02 09:22:08'),(3,'Kory','Adams','kbayer@example.org','+83(5)7281335817','2007-07-09 10:28:23','2016-02-01 02:27:13'),(4,'Dallas','Gaylord','hgusikowski@example.com','1-079-083-0202x869','1988-05-05 20:15:33','1981-05-02 23:06:47'),(5,'Maximo','Berge','tharvey@example.com','283.870.2266x509','2017-11-24 00:10:29','2012-03-19 12:16:33'),(6,'Ryan','Koss','bernita97@example.com','(480)657-7910x1176','1985-06-19 02:25:54','1987-12-09 05:48:36'),(7,'Michaela','Lesch','pfeffer.cleta@example.org','1-322-053-2658','1986-05-24 03:33:16','2015-05-20 02:37:08'),(8,'Nathan','Muller','jewel69@example.org','1-596-816-3585x0044','2014-04-09 21:01:04','2019-03-06 18:44:26'),(9,'Lucie','Thiel','pcremin@example.org','838-721-2643x1665','1992-12-14 07:20:29','1973-08-10 18:37:40'),(10,'Tamia','McDermott','pabbott@example.org','(769)072-7598x32025','1998-06-29 11:24:11','1983-04-07 10:09:43'),(11,'Guido','Moen','lucinda.graham@example.org','1-140-973-2629','2012-10-22 17:50:18','1990-10-11 16:47:13'),(12,'Vern','Swaniawski','veum.kellie@example.com','780-532-4104','2006-10-14 12:35:10','1974-05-24 06:23:55'),(13,'Lenna','Renner','vrosenbaum@example.org','900.819.7531x21713','2006-06-17 20:26:06','1974-11-21 02:13:23'),(14,'Abner','Schuster','bahringer.jannie@example.com','302.796.9794x1463','1993-05-11 15:32:20','1971-12-20 08:15:02'),(15,'Sierra','Quitzon','itzel36@example.net','793-218-9798x9109','1995-09-20 16:22:41','1973-11-02 15:50:27'),(16,'Gayle','Hansen','crystel71@example.net','009-767-7683','1992-05-25 03:31:36','1991-01-17 21:50:34'),(17,'Anthony','Harris','erdman.rosamond@example.net','145-490-9765x0361','2015-01-14 18:00:44','1998-08-09 17:56:15'),(18,'Cory','Jenkins','lisandro.emard@example.net','02792281372','1999-09-02 04:00:35','1982-08-15 18:50:50'),(19,'Luis','Wisozk','ofisher@example.net','206-111-0641x13642','1972-07-31 16:04:00','2015-06-29 12:52:34'),(20,'Garret','Schultz','nicolas.eriberto@example.org','064-935-6966x3445','2004-07-15 00:34:00','1997-12-07 09:43:10'),(21,'Marilyne','McGlynn','king.edmund@example.org','(886)929-6816x5956','1979-07-24 11:17:23','2001-11-29 16:04:52'),(22,'Chad','Quitzon','reina88@example.net','08001720510','1976-01-07 18:06:27','2002-05-25 19:50:26'),(23,'Raheem','Morissette','garnet08@example.net','1-692-006-4842','1973-05-02 04:47:38','2005-11-16 16:49:54'),(24,'Emmett','Spinka','keshaun.wisozk@example.net','(947)420-2270x094','1998-07-27 00:37:37','2019-06-16 15:53:03'),(25,'Estrella','Aufderhar','dana10@example.com','1-871-994-3625','1992-09-26 18:55:45','1971-04-07 09:09:06'),(26,'Clint','Stamm','bethany.hessel@example.org','184-070-4715x40161','2007-09-30 09:27:59','2005-08-13 01:19:25'),(27,'Raleigh','Harris','spacocha@example.com','016-674-7761','2019-02-08 14:10:26','2019-08-12 07:32:03'),(28,'Eldon','West','edmund.johnston@example.org','242.492.1746x57966','1982-04-12 17:31:57','2001-07-25 14:44:03'),(29,'Leopold','Strosin','morar.jermaine@example.com','(433)866-5458x851','1981-12-30 06:21:17','2007-09-25 00:02:48'),(30,'Scarlett','Schinner','alize75@example.com','(602)228-3708','1976-11-11 06:03:50','1981-02-07 08:30:29'),(31,'Petra','Boyle','jerrod.funk@example.net','1-065-549-8866','2015-10-17 15:34:58','2017-10-11 06:29:09'),(32,'Avery','Olson','bauch.allie@example.org','(122)178-9569x0421','1989-12-05 18:16:45','2014-12-12 01:52:58'),(33,'Joey','Quigley','lacey.runolfsson@example.org','(015)342-8183','2019-12-15 02:30:25','1981-09-16 09:05:27'),(34,'Magdalena','Reilly','tanya.heller@example.net','(605)638-7779x563','1988-04-26 13:18:40','2011-07-23 13:27:43'),(35,'Steve','Bergnaum','sheathcote@example.net','1-420-408-5480x379','1996-04-10 11:51:29','2001-11-08 06:19:30'),(36,'Maxine','Schumm','ycormier@example.com','1-401-050-5600','1970-06-02 16:05:28','2004-01-16 02:04:27'),(37,'Michel','Miller','askiles@example.net','231.464.7956x486','1980-03-10 12:14:45','1993-12-08 01:26:10'),(38,'Greg','Williamson','christophe03@example.org','07791442742','2005-12-13 12:40:34','1991-02-13 22:43:31'),(39,'Lindsay','Feil','thiel.deshaun@example.org','1-475-349-6356','1970-04-15 00:35:34','2007-03-10 00:23:13'),(40,'Elisa','Lemke','tbrakus@example.net','1-979-983-5725x177','2016-11-12 02:11:58','1991-12-17 18:01:37'),(41,'Nikko','Denesik','noah.ledner@example.org','1-785-183-7993','2009-02-21 13:13:45','2003-10-28 14:32:40'),(42,'Rosalia','Pacocha','abbie43@example.com','(476)374-0506','2004-04-24 16:03:55','1982-09-17 17:48:41'),(43,'Gudrun','Walker','jhudson@example.com','1-712-356-3726x67400','1994-03-17 01:51:14','2002-09-21 04:43:29'),(44,'Wilford','Rosenbaum','thiel.pansy@example.net','728-536-8231','2006-08-07 14:35:25','1979-03-28 15:24:27'),(45,'Phyllis','Murray','lavon.white@example.com','854.690.4699','2015-01-09 22:20:24','2010-05-13 05:43:02'),(46,'Kory','Jacobson','bwyman@example.com','+27(3)8907550045','1988-06-07 09:14:09','2003-10-28 23:00:12'),(47,'Triston','Kessler','evelyn91@example.org','074.015.5389','1987-10-11 03:21:03','2007-03-18 07:34:50'),(48,'Pascale','Greenfelder','delphine.schultz@example.net','438-727-2362','2014-11-21 08:36:28','2006-10-14 19:03:42'),(49,'Name','Auer','prolfson@example.net','05566526275','1995-12-16 22:47:12','2007-02-11 23:55:46'),(50,'Erling','Barrows','lheaney@example.com','1-685-011-9959x42679','1985-01-09 00:18:54','2015-07-04 01:05:44'),(51,'Deonte','Breitenberg','qdeckow@example.net','(332)437-9669','1985-10-13 17:39:00','2007-02-12 21:13:58'),(52,'Effie','Kling','windler.jaleel@example.com','475-253-3638','1970-11-07 15:18:27','2000-02-29 12:09:42'),(53,'Corine','Ziemann','bailey.kari@example.com','121.750.6486x9772','2016-09-04 11:16:33','1973-02-14 17:35:17'),(54,'Kelley','Barrows','ollie.bayer@example.org','+59(0)2130812513','1985-12-18 13:16:19','1984-02-14 14:39:03'),(55,'Gus','Denesik','vgleichner@example.net','+35(8)8278407140','1980-04-20 18:52:11','2011-11-04 23:31:35'),(56,'Mitchel','Bernhard','cordelia92@example.com','711.468.3533x73135','1977-01-20 20:22:34','1992-02-08 09:44:20'),(57,'Caterina','Kuhn','bernadine58@example.org','351-827-2743','1986-12-16 10:35:16','2008-02-29 01:36:42'),(58,'Brielle','Cruickshank','america65@example.org','(628)052-0106x99494','1972-01-11 03:32:42','1973-03-01 02:26:32'),(59,'Jamar','Armstrong','druecker@example.com','1-097-325-7243x640','2010-08-25 01:55:11','1993-03-29 12:14:51'),(60,'Nettie','Kunde','brody.bashirian@example.net','(808)271-1629x267','2015-06-27 14:56:12','1973-02-12 00:55:12'),(61,'Michel','Parker','wisoky.candace@example.com','476.051.5307x48924','1997-03-31 10:27:47','2003-11-14 11:13:37'),(62,'Felipe','Kub','johnson.anjali@example.net','1-191-242-0750','1997-12-03 12:48:31','2002-06-09 12:21:04'),(63,'Kristin','Stoltenberg','hilpert.adelia@example.org','(970)413-8947','1973-07-30 09:05:08','2018-05-16 20:51:39'),(64,'Alisa','Rempel','carolina29@example.org','+52(2)9837863413','1988-10-19 09:50:13','2015-07-12 06:32:22'),(65,'Noel','Crona','sfeest@example.com','1-583-266-6473x2332','2010-12-02 01:48:56','1992-07-01 22:48:26'),(66,'Webster','Bins','roob.dawn@example.org','1-435-684-6533x624','2007-03-19 19:36:39','1971-04-22 19:32:42'),(67,'Moses','Considine','agnes88@example.org','(835)630-0795x2898','1986-11-15 08:48:15','1989-02-17 00:53:54'),(68,'Jadyn','Conroy','torp.valentin@example.net','631.280.3576','1998-07-06 00:38:23','2006-12-28 04:13:57'),(69,'Claud','O\'Hara','francesca.rohan@example.org','07158498622','1977-02-02 03:49:08','1995-07-10 15:28:06'),(70,'Harmon','Rice','kromaguera@example.org','1-269-207-4983x37523','1981-01-07 05:35:00','1983-09-06 08:19:49'),(71,'Harry','Bergstrom','alebsack@example.org','(226)916-6707x88793','1974-04-19 19:29:14','1987-08-17 06:55:39'),(72,'Pietro','Bogisich','zieme.kallie@example.com','+87(5)1432434606','1975-12-04 07:05:08','2005-07-13 21:56:46'),(73,'Issac','Lemke','crooks.eliseo@example.net','(947)556-6127','1996-10-17 22:34:37','1970-11-08 03:30:14'),(74,'Annamae','Lehner','huel.albina@example.com','1-810-574-4434','2002-09-25 19:26:49','2018-04-22 09:35:17'),(75,'Eva','Moen','ssipes@example.com','1-941-698-9659','1979-11-06 15:51:43','2001-08-06 01:10:50'),(76,'Florida','Emard','rbeer@example.com','(440)910-1125x9539','1978-01-23 21:28:56','2018-07-30 18:50:02'),(77,'Theo','Huel','daniel.palma@example.com','161.451.3764','1984-01-26 22:34:39','2007-10-02 07:20:34'),(78,'Sarah','Waelchi','alaina47@example.org','813.868.8837x43150','2009-06-30 06:11:10','2001-02-23 10:44:01'),(79,'Amaya','Boehm','zetta.mraz@example.org','04419161418','1989-06-12 17:03:59','2001-06-19 22:01:35'),(80,'Gregorio','Considine','rohan.eldridge@example.org','04267327617','2008-06-30 14:28:19','2000-06-13 19:58:03'),(81,'Loren','Grant','eino.koss@example.com','953.216.1876x04412','2012-07-22 17:25:05','2010-12-20 05:07:09'),(82,'Bernita','Kuhn','erica95@example.net','1-052-775-3366x747','2007-07-23 13:15:20','1970-12-21 14:00:19'),(83,'Freda','Skiles','crona.aubree@example.org','+27(5)9737622108','2010-04-03 16:47:37','1981-11-23 04:45:06'),(84,'Juana','Grady','lhomenick@example.com','048-025-5453','2014-09-26 20:31:34','1981-01-03 12:40:27'),(85,'Maria','Sawayn','zpollich@example.net','+91(2)1576895903','2013-02-14 01:20:49','1983-11-23 04:18:14'),(86,'Rosendo','Rutherford','balistreri.anais@example.org','1-083-143-1136x00264','1984-08-02 03:25:44','2007-08-11 05:09:16'),(87,'Gianni','Dickinson','godfrey67@example.net','768-849-1515x1098','2014-04-14 09:47:05','1975-08-26 05:48:59'),(88,'Vergie','Osinski','kertzmann.jadon@example.net','(787)041-6172x631','2000-04-10 19:43:05','1987-06-25 02:26:28'),(89,'Roy','Weimann','alexandre29@example.net','981.412.5917x44371','2000-01-12 17:30:37','2010-01-29 17:43:48'),(90,'Griffin','Bartoletti','walker.diana@example.com','+53(5)6987408732','2008-11-04 09:35:18','2010-09-19 05:22:47'),(91,'Tracy','Fisher','nick81@example.com','272-784-6530x03692','2003-03-17 15:54:45','2010-03-01 18:18:23'),(92,'Hipolito','Kovacek','stanton.britney@example.com','529-496-6295x422','1996-12-30 16:33:43','1994-05-26 11:21:26'),(93,'Thaddeus','Gottlieb','egrimes@example.net','(755)746-0605x47002','1971-06-17 21:57:07','1993-12-03 22:30:46'),(94,'Randall','Barton','fahey.loyce@example.com','(605)432-4878x88085','1976-05-05 07:48:00','2012-01-06 23:19:14'),(95,'Alexis','O\'Keefe','hayes.casandra@example.net','989.221.2455x77449','1971-02-06 15:16:12','1988-02-23 02:46:49'),(96,'Vella','Nienow','brandon.osinski@example.com','636-815-2248','1979-05-25 18:49:46','2019-01-23 04:35:53'),(97,'Kasey','Abbott','johnathan.corwin@example.org','07920012307','2010-04-23 04:32:43','1994-08-02 02:28:03'),(98,'Cleve','Koelpin','bins.brooks@example.org','245.009.5014','1980-03-18 11:42:16','1987-02-28 14:00:45'),(99,'Shayna','Ward','giuseppe19@example.org','(554)075-1787x62602','2016-11-22 06:43:48','1977-02-22 07:53:44'),(100,'Edwina','Wyman','hobart00@example.org','374-772-9993x7777','1986-08-10 23:48:01','2019-03-01 19:11:54');

INSERT INTO authors(first_name, last_name, description, photo_path)
	SELECT
		first_name,
		last_name,
		CONCAT('Description of author ', first_name, ' ', last_name),
		CONCAT('//my_path/authors/', id, '_', first_name, '_', last_name)
    FROM data_;
    
INSERT INTO readers(first_name, last_name, description, photo_path)
	SELECT
		CONCAT(first_name, '_r'),
        CONCAT(last_name, '_r'),
        CONCAT('Description of reader ', first_name, '_r', ' ', last_name, '_r'),
        CONCAT('//my_path/readers/', id, '_', first_name, '_r', '_', last_name, '_r')
	FROM data_;
    
INSERT INTO translators(first_name, last_name, description, photo_path)
	SELECT
		CONCAT(first_name, '_t'),
        CONCAT(last_name, '_t'),
        CONCAT('Description of translator ', first_name, '_t', ' ', last_name, '_t'),
        CONCAT('//my_path/translators/', id, '_', first_name, '_t', '_', last_name, '_t')
	FROM data_;
    
INSERT INTO publishers(name, description, logo_path)
	SELECT
		CONCAT(last_name, first_name, '_p'),
		CONCAT('Description of publisher ', last_name, first_name, '_p'),
        CONCAT('//my_path/publishers/', id, '_', last_name, first_name, '_p')
	FROM data_;

--  The table books_names was created using Workbench import feature from csv file with the names of books in the column 'Title'

INSERT INTO books(title, description, author_id, genre_id, first_publication_year, restriction_id, original_language_id, translator_id)
	SELECT
		DISTINCT Title,
		CONCAT('Description of the book ', Title),
        1, 1, 2000, 1, 1, 1
	FROM books_names LIMIT 200;

SELECT COUNT(*) FROM books INTO @length;    
UPDATE books SET
	author_id = FLOOR(1 + (RAND() * (SELECT COUNT(id) FROM authors))),
	genre_id = FLOOR(1 + (RAND() * (SELECT COUNT(id) FROM genres))),
	first_publication_year = FLOOR(1800 + (RAND() * 219)),
	restriction_id = FLOOR(1 + (RAND() * (SELECT COUNT(id) FROM restrictions))),
	original_language_id = FLOOR(1 + (RAND() * (SELECT COUNT(id) FROM original_languages))),
	translator_id = FLOOR(1 + (RAND() * (SELECT COUNT(id) FROM translators)))
WHERE id < @length + 1;

INSERT INTO issues_pandel(book_id, publisher_id, publication_year, isbn, size, price)
	SELECT
		1, 1, 2000, 1234567891011, 1, 100
	FROM books_names LIMIT 200;
    
-- executed twice:
INSERT INTO issues_pandel(book_id, publisher_id, publication_year, isbn, size, price)
	SELECT
		1, 1, 2000, 1234567891011, 1, 100
	FROM books_names LIMIT 200;

SELECT COUNT(*) FROM issues_pandel INTO @length;    
UPDATE issues_pandel SET
	book_id = FLOOR(1 + (RAND() * (SELECT COUNT(id) FROM books))),
	publisher_id = FLOOR(1 + (RAND() * (SELECT COUNT(id) FROM publishers))),
	publication_year = FLOOR(2000 + (RAND() * 19)),
    isbn = FLOOR(1 + (RAND() * 10^13-1)),
	size = FLOOR(1 + (RAND() * 1000)),
    cover_path = CONCAT('//my_paths/covers/', id, (SELECT title FROM books WHERE books.id = id LIMIT 1)),
    issue_type = IF(RAND()>0.5, 'electronic', 'paper'),
    -- trial_media_id and full_media_id should be defind after the filling of media table
    price = FLOOR(10 + (RAND() * 10000)),
    rating = FLOOR(1 + (RAND() * 50))/10
WHERE id < @length + 1;

-- The following block is dedicated to changing the values of published_year. It should be more or equal to first_published_year of the book

CREATE OR REPLACE VIEW temp(id, field) AS
	SELECT i.id, IF(i.publication_year > b.first_publication_year, i.publication_year, b.first_publication_year)
		FROM issues_pandel AS i
		JOIN books AS b
			ON i.book_id = b.id;

UPDATE issues_pandel, temp SET
	issues_pandel.publication_year = temp.field
WHERE temp.id = issues_pandel.id and issues_pandel.id < @length + 1;

INSERT INTO issues_aud(book_id, reader_id, duration, publisher_id, publication_year, price)
	SELECT
		1, 1, 1, 1, 2000, 100
	FROM books_names LIMIT 200;
    
-- executed twice:
INSERT INTO issues_aud(book_id, reader_id, duration, publisher_id, publication_year, price)
	SELECT
		1, 1, 1, 1, 2000, 100
	FROM books_names LIMIT 200;

SELECT COUNT(*) FROM issues_aud INTO @length;  
UPDATE issues_aud SET
	book_id = FLOOR(1 + (RAND() * (SELECT COUNT(id) FROM books))),
    reader_id = FLOOR(1 + (RAND() * (SELECT COUNT(id) FROM readers))),
	publisher_id = FLOOR(1 + (RAND() * (SELECT COUNT(id) FROM publishers))),
	publication_year = FLOOR(2000 + (RAND() * 19)),
	duration = SEC_TO_TIME(FLOOR(1 + (RAND() * 100000))),
    cover_path = CONCAT('//my_paths/covers/', id, (SELECT title FROM books WHERE books.id = id LIMIT 1)),
    -- trial_media_id and full_media_id should be defind after the filling of media table
    price = FLOOR(10 + (RAND() * 10000)),
    rating = FLOOR(1 + (RAND() * 50))/10
WHERE id < @length + 1;
   
CREATE OR REPLACE VIEW temp(id, field) AS
	SELECT i.id, IF(i.publication_year > b.first_publication_year, i.publication_year, b.first_publication_year)
		FROM issues_aud AS i
		JOIN books AS b
			ON i.book_id = b.id;

UPDATE issues_aud, temp SET
	issues_aud.publication_year = temp.field
WHERE temp.id = issues_aud.id  and issues_aud.id < @length + 1;

INSERT INTO media(issue_id, issue_table, media_type_id, description, name, media_path)
	SELECT
		1, 'issues_pandel', 1, '', '', ''
	FROM issues_aud 
    LIMIT 400;
    
-- executed twice:
INSERT INTO media(issue_id, issue_table, media_type_id, description, name, media_path)
	SELECT
		1, 'issues_pandel', 1, '', '', ''
	FROM issues_aud 
    LIMIT 400;

SELECT COUNT(*) FROM media INTO @length;
UPDATE media SET
    issue_table  = IF(RAND()>0.5, 'issues_pandel', 'issues_aud')
WHERE id < @length + 1;

UPDATE media SET
	issue_id = IF(
		issue_table = 'issues_pandel',
        FLOOR(1 + RAND() * (SELECT COUNT(id) FROM issues_pandel)),
        FLOOR(1 + (RAND() * (SELECT COUNT(id) FROM issues_aud)))
        ),
	media_type_id = IF(
		issue_table = 'issues_aud',
        FLOOR(1 + RAND() * 3),
        FLOOR(4 + RAND() * 8)
        ),
    description = CONCAT('Description of media ', id, ', issue_id = ', issue_id, ', issue_table = ', issue_table, ', media_type_id = ', media_type_id),
	name = description,   -- to improve: name should describe the product
    media_path = CONCAT('//my_paths/media/', media_type_id, '/', id)
WHERE id < @length + 1;

-- The following block is dedicated to filling trial_media_id and full_media_id since their id in issues tables should be equal to issue_id in media table

CREATE OR REPLACE VIEW temp(id, trial, full) AS
	SELECT DISTINCT m.issue_id,
		FIRST_VALUE(m.id) OVER issue,   -- use the first media for the given issue as the trial 
		LAST_VALUE(m.id) OVER issue   -- use the last media for the given issue as the full media
		FROM issues_pandel AS i
		LEFT JOIN media AS m
			ON m.issue_id = i.id
		WHERE m.issue_table = 'issues_pandel'
		WINDOW issue AS (PARTITION BY m.issue_id);

UPDATE issues_pandel, temp SET
	issues_pandel.trial_media_id = temp.trial,
    issues_pandel.full_media_id = temp.full
    WHERE issues_pandel.id = temp.id AND issues_pandel.id < @length + 1;

CREATE OR REPLACE VIEW temp(id, trial, full) AS
	SELECT DISTINCT m.issue_id,
		FIRST_VALUE(m.id) OVER issue,   -- use the first media for the given issue as the trial 
		LAST_VALUE(m.id) OVER issue   -- use the last media for the given issue as the full media
		FROM issues_aud AS i
		LEFT JOIN media AS m
			ON m.issue_id = i.id
		WHERE m.issue_table = 'issues_aud'
		WINDOW issue AS (PARTITION BY m.issue_id);

UPDATE issues_aud, temp SET
	issues_aud.trial_media_id = temp.trial,
    issues_aud.full_media_id = temp.full
    WHERE issues_aud.id = temp.id AND issues_aud.id < @length + 1;
 
-- ------------------------------------------------------------------------------
-- Inquiries
-- ------------------------------------------------------------------------------
-- Fetch all books (with authors) in the given genre (Computing)
SELECT b.title AS 'Title',
		CONCAT(a.first_name, ' ', a.last_name) AS 'Author'
	FROM books AS b
    LEFT JOIN authors AS a
		ON b.author_id = a.id
	JOIN  genres AS g
		ON b.genre_id = g.id
	WHERE g.name = 'Computing';

-- Fetch all audio issues of books (title, authors, publisher of audio issue, price, rating)
-- with title included given patern (python)    

PREPARE audi_issue FROM "
SELECT b.title AS 'Title',
		CONCAT(a.first_name, ' ', a.last_name) AS 'Author',
        p.name AS 'Publisher',
        iaud.price AS 'Price',
        iaud.rating AS 'Rating'
	FROM issues_aud AS iaud
    LEFT JOIN publishers AS p
		ON iaud.publisher_id = p.id
	LEFT JOIN books AS b
		ON iaud.book_id = b.id
	LEFT JOIN authors AS a
		ON b.author_id = a.id
	WHERE b.title LIKE ? LIMIT 5";
    
SET @pattern = '%python%';
EXECUTE audi_issue USING @pattern;
DROP PREPARE audi_issue;
  
-- ------------------------------------------------------------------------------
-- Triggers
-- ------------------------------------------------------------------------------ 
-- The first two triggers check that the publication_year value for the new issue
-- is grater of equal to the first_publication_year of the book
 
DROP TRIGGER IF EXISTS check_publiсation_year_pandel_insert;  
DELIMITER //
CREATE TRIGGER check_publiсation_year_pandel_insert BEFORE INSERT ON issues_pandel
FOR EACH ROW
BEGIN
	DECLARE y INT;
    SELECT books.first_publication_year INTO y
		FROM books
        WHERE books.id = NEW.book_id
        LIMIT 1;
	IF NEW.publication_year < y THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "The issue's publiсation year could not be less than the first publiсation year of the book";
	END IF;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS check_publiсation_year_aud_insert;  
DELIMITER //
CREATE TRIGGER check_publiсation_year_aud_insert BEFORE INSERT ON issues_aud
FOR EACH ROW
BEGIN
	DECLARE y INT;
    SELECT books.first_publication_year INTO y
		FROM books
        WHERE books.id = NEW.book_id
        LIMIT 1;
	IF NEW.publication_year < y THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "The issue's publiсation year could not be less than the first publiсation year of the book";
	END IF;
END //
DELIMITER ;

-- This trigger sets the trial_media_id and full_media_id values into the issues_pandel and
-- issues_aud tables if the insert into the media table mentions this issue the first or the second time.
-- Firstly, the new media.id sets to both fields into issues table.
-- Secondly, it changes only the 'full' value.

DROP TRIGGER IF EXISTS add_trial_and_media_id_on_media_insert;  
DELIMITER //
CREATE TRIGGER add_trial_and_media_id_on_media_insert AFTER INSERT ON media
FOR EACH ROW
BEGIN
	IF (NEW.issue_table = 'issues_pandel') THEN
		IF
			(SELECT COUNT(id)
				FROM media AS m
                WHERE m.issue_id = NEW.issue_id) = 1
		THEN
            UPDATE issues_pandel SET
				issues_pandel.trial_id = NEW.id,
                issues_pandel.full_id = NEW.id
                WHERE issues_pandel.id = NEW.issue_id;
		ELSEIF
			(SELECT COUNT(id)
				FROM media AS m
                WHERE m.issue_id = NEW.issue_id) = 2
		THEN
            UPDATE issues_pandel SET
                issues_pandel.full_id = NEW.id
                WHERE issues_pandel.id = NEW.issue_id;
		END IF;
    ELSE 
		IF
			(SELECT COUNT(id)
				FROM media AS m
                WHERE m.issue_id = NEW.issue_id) = 1
		THEN
            UPDATE issues_aud SET
				issues_aud.trial_id = NEW.id,
                issues_aud.full_id = NEW.id
                WHERE issues_aud.id = NEW.issue_id;
		ELSEIF
			(SELECT COUNT(id)
				FROM media AS m
                WHERE m.issue_id = NEW.issue_id) = 2
		THEN
            UPDATE issues_aud SET
                issues_aud.full_id = NEW.id
                WHERE issues_aud.id = NEW.issue_id;
		END IF;
	END IF;
END //
DELIMITER ;

-- ----------------------------------------------------------------------------------------------------------------------------------

select *
	from information_schema.referential_constraints
	where constraint_schema = 'litres';