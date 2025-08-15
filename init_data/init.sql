-- create schema
CREATE SCHEMA IF NOT EXISTS library;

-- create tables

-- library.books
CREATE TABLE IF NOT EXISTS library.books (
    book_id 		BIGINT PRIMARY KEY,
    name 			VARCHAR(255) NOT NULL,
    year 			VARCHAR(4) NOT NULL,
	inserted_date 	DATE NOT NULL DEFAULT current_timestamp,
	updated_date 	DATE NOT NULL DEFAULT current_timestamp,
    UNIQUE (name, year)
);

COMMENT ON TABLE library.books IS 'Library book directory';
COMMENT ON COLUMN library.books.book_id IS 'Book ID';
COMMENT ON COLUMN library.books.name IS 'Book title';
COMMENT ON COLUMN library.books.year IS 'Year of publication';
COMMENT ON COLUMN library.books.inserted_date IS 'Technical field. Inserted date';
COMMENT ON COLUMN library.books.updated_date IS 'Technical field. Updated date';

-- library.articles
CREATE TABLE IF NOT EXISTS library.articles (
    article_id 		BIGINT PRIMARY KEY,
    name 			VARCHAR(255) NOT NULL,
    redaction 		VARCHAR(100) NOT NULL,
	inserted_date 	DATE NOT NULL DEFAULT current_timestamp,
	updated_date 	DATE NOT NULL DEFAULT current_timestamp,
    UNIQUE (name, redaction)
);

COMMENT ON TABLE library.articles IS 'Directory of literary works';
COMMENT ON COLUMN library.articles.article_id IS 'Article ID';
COMMENT ON COLUMN library.articles.name IS 'Title of a literary work';
COMMENT ON COLUMN library.articles.redaction IS 'Redaction';
COMMENT ON COLUMN library.articles.inserted_date IS 'Technical field. Inserted date';
COMMENT ON COLUMN library.articles.updated_date IS 'Technical field. Updated date';

-- library.genres
CREATE TABLE IF NOT EXISTS library.genres (
    genre_id 		BIGINT PRIMARY KEY,
    name 			VARCHAR(255) NOT NULL,
	inserted_date 	DATE NOT NULL DEFAULT current_timestamp,
	updated_date 	DATE NOT NULL DEFAULT current_timestamp,
    UNIQUE (name)
);

COMMENT ON TABLE library.genres IS 'Directory of literary genres';
COMMENT ON COLUMN library.genres.genre_id IS 'Genre ID';
COMMENT ON COLUMN library.genres.name IS 'Name of the genre';
COMMENT ON COLUMN library.genres.inserted_date IS 'Technical field. Inserted date';
COMMENT ON COLUMN library.genres.updated_date IS 'Technical field. Updated date';


-- library.persons
CREATE TABLE IF NOT EXISTS library.persons (
    person_id 		BIGINT PRIMARY KEY,
    last_name 		VARCHAR(50) NOT NULL,
    first_name 		VARCHAR(50) NOT NULL,
    second_name 	VARCHAR(50) NULL,
    dob 			DATE NOT NULL,
	inserted_date 	DATE NOT NULL DEFAULT current_timestamp,
	updated_date 	DATE NOT NULL DEFAULT current_timestamp
);

COMMENT ON TABLE library.persons IS 'Directory of persons';
COMMENT ON COLUMN library.persons.person_id IS 'Person ID';
COMMENT ON COLUMN library.persons.last_name IS 'Last name';
COMMENT ON COLUMN library.persons.first_name IS 'First name';
COMMENT ON COLUMN library.persons.second_name IS 'Second namt';
COMMENT ON COLUMN library.persons.dob IS 'Date of birth';
COMMENT ON COLUMN library.persons.inserted_date IS 'Technical field. Inserted date';
COMMENT ON COLUMN library.persons.updated_date IS 'Technical field. Updated date';

-- library.readers
CREATE TABLE IF NOT EXISTS library.readers (
    reader_id 				BIGINT PRIMARY KEY,
    registration_date 		DATE NOT NULL,
	inserted_date 			DATE NOT NULL DEFAULT current_timestamp,
	updated_date 			DATE NOT NULL DEFAULT current_timestamp,
    CONSTRAINT fk_reader_person
    FOREIGN KEY (reader_id)
    REFERENCES library.persons (person_id)
);

COMMENT ON TABLE library.readers IS 'Library Readers Directory';
COMMENT ON COLUMN library.readers.reader_id IS 'Reader ID';
COMMENT ON COLUMN library.readers.registration_date IS 'Registration Date';
COMMENT ON COLUMN library.readers.inserted_date IS 'Technical field. Inserted date';
COMMENT ON COLUMN library.readers.updated_date IS 'Technical field. Updated date';

-- library.authors
CREATE TABLE IF NOT EXISTS library.authors (
    author_id 				BIGINT PRIMARY KEY,
    nick_name 				VARCHAR(100) NOT NULL,
	inserted_date 			DATE NOT NULL DEFAULT current_timestamp,
	updated_date 			DATE NOT NULL DEFAULT current_timestamp
);

COMMENT ON TABLE library.authors IS 'Authors Directory';
COMMENT ON COLUMN library.authors.author_id IS 'Author ID';
COMMENT ON COLUMN library.authors.nick_name IS 'Nickname';
COMMENT ON COLUMN library.authors.inserted_date IS 'Technical field. Inserted date';
COMMENT ON COLUMN library.authors.updated_date IS 'Technical field. Updated date';


-- library.book_instances
CREATE TABLE IF NOT EXISTS library.book_instances (
    book_instance_id 		BIGINT PRIMARY KEY,
    publisher 				VARCHAR(100) NOT NULL,
    book_id 				BIGINT NOT NULL,
	inserted_date 			DATE NOT NULL DEFAULT current_timestamp,
	updated_date 			DATE NOT NULL DEFAULT current_timestamp,
    CONSTRAINT fk_book_instance_book
    FOREIGN KEY (book_id)
    REFERENCES library.books (book_id)
);

COMMENT ON TABLE library.book_instances IS 'Data on book instances';
COMMENT ON COLUMN library.book_instances.book_instance_id IS 'Book Instance ID';
COMMENT ON COLUMN library.book_instances.publisher IS 'Publisher';
COMMENT ON COLUMN library.book_instances.book_id IS 'Book ID';
COMMENT ON COLUMN library.book_instances.inserted_date IS 'Technical field. Inserted date';
COMMENT ON COLUMN library.book_instances.updated_date IS 'Technical field. Updated date';

-- library.issue_return_books
CREATE TABLE IF NOT EXISTS library.issue_return_books (
    id 	                SERIAL PRIMARY KEY,
    book_instance_id 	INT NOT NULL REFERENCES library.book_instances (book_instance_id),
    reader_id 			INT NOT NULL REFERENCES library.readers (reader_id),
    issue_date 			DATE NOT NULL DEFAULT current_date,
    return_date 		DATE NULL,
	inserted_date 			DATE NOT NULL DEFAULT current_timestamp,
	updated_date 			DATE NOT NULL DEFAULT current_timestamp
);

COMMENT ON TABLE library.issue_return_books IS 'Данные о выдаче и возврате книг';
COMMENT ON COLUMN library.issue_return_books.id IS 'Key';
COMMENT ON COLUMN library.issue_return_books.book_instance_id IS 'Book Instance ID';
COMMENT ON COLUMN library.issue_return_books.reader_id IS 'Redared ID';
COMMENT ON COLUMN library.issue_return_books.issue_date IS 'Issue date';
COMMENT ON COLUMN library.issue_return_books.return_date IS 'Return date';
COMMENT ON COLUMN library.issue_return_books.inserted_date IS 'Technical field. Inserted date';
COMMENT ON COLUMN library.issue_return_books.updated_date IS 'Technical field. Updated date';

-- library.books_articles
CREATE TABLE IF NOT EXISTS library.books_articles (
    book_id 			BIGINT NOT NULL REFERENCES library.books (book_id),
    article_id 			BIGINT NOT NULL REFERENCES library.articles (article_id),
    PRIMARY KEY (book_id, article_id)
);

COMMENT ON TABLE library.books_articles IS 'Associative table books-articles';


-- library.persons_authors
CREATE TABLE IF NOT EXISTS library.persons_authors (
    person_id 			BIGINT NOT NULL REFERENCES library.persons (person_id),
    author_id 			BIGINT NOT NULL REFERENCES library.authors (author_id),
    PRIMARY KEY (person_id, author_id)
);

COMMENT ON TABLE library.persons_authors IS 'Associative table persons-authors';

-- library.articles_genres
CREATE TABLE IF NOT EXISTS library.articles_genres (
    article_id 			BIGINT NOT NULL REFERENCES library.articles (article_id),
    genre_id 			BIGINT NOT NULL REFERENCES library.genres (genre_id),
    PRIMARY KEY (article_id, genre_id)
);

COMMENT ON TABLE library.articles_genres IS 'Associative table articles-genres';

-- library.authors_articles
CREATE TABLE IF NOT EXISTS library.authors_articles (
    author_id 			BIGINT NOT NULL REFERENCES library.authors (author_id),
    article_id 			BIGINT NOT NULL REFERENCES library.articles (article_id),
    PRIMARY KEY (author_id, article_id)
);

COMMENT ON TABLE library.authors_articles IS 'Associative table authors-articles';

-- view library.v_find_books_issued
CREATE OR REPLACE VIEW library.v_find_books_issued AS
SELECT 
	b.name AS book,
	irb.issue_date,
	(irb.issue_date::date + interval '14 days')::date AS estimated_return_date
FROM library.issue_return_books AS irb
JOIN library.book_instances AS bi ON irb.book_instance_id = bi.book_instance_id
JOIN library.books AS b ON bi.book_id = b.book_id
WHERE return_date IS NULL;

COMMENT ON VIEW library.v_find_books_issued IS 'Data on issued books';

-- create procedures

-- procedure "library".insert_book
CREATE PROCEDURE "library".insert_book (
	id "library".books.book_id%TYPE, 
	book_name "library".books.name%TYPE, 
	book_year "library".books.year%TYPE
	)
LANGUAGE plpgsql
AS $$
	BEGIN

		INSERT INTO library.books (book_id, "name", "year") 
		VALUES	(id, book_name, book_year);

		EXCEPTION
			WHEN OTHERS THEN
				RAISE NOTICE 'При добавлении новой записи в таблицу library.books возникла ошибка : % - %', SQLSTATE, SQLERRM;
				RAISE;
	END;
$$;


-- procedure "library".update_book
CREATE PROCEDURE "library".update_book (
	id "library".books.book_id%TYPE, 
	book_name "library".books.name%TYPE, 
	book_year "library".books.year%TYPE
	)
LANGUAGE plpgsql
AS $$
	BEGIN

		UPDATE "library".books
		SET 
			"name" = book_name, 
			"year" = book_year,
			updated_date = current_timestamp
		WHERE "book_id" = id;

		IF NOT FOUND THEN
				RAISE EXCEPTION 'Книга с ID % не найдена', id;
			END IF;

		EXCEPTION
			WHEN OTHERS THEN
				RAISE NOTICE 'При обновлении записи для book_id = % в таблице library.books возникла ошибка : % - %', id, SQLSTATE, SQLERRM;
				RAISE;
	END;
$$;


-- procedure "library".delete_book
CREATE PROCEDURE "library".delete_book(id "library".books.book_id%TYPE)
LANGUAGE plpgsql
AS $$
DECLARE err_tables VARCHAR;
	BEGIN

		DELETE FROM "library".books WHERE book_id=id;

		IF NOT FOUND THEN
				RAISE EXCEPTION 'Книга с ID % не найдена', id;
			END IF;

		EXCEPTION
			WHEN foreign_key_violation THEN

				SELECT
					STRING_AGG(CONCAT(tc.table_schema, '.', tc.table_name), ', ') INTO err_tables
				FROM
					information_schema.table_constraints tc
				JOIN
					information_schema.constraint_column_usage ccu ON ccu.constraint_name = tc.constraint_name
				WHERE
					tc.constraint_type = 'FOREIGN KEY'
					AND ccu.table_name = 'books'
					AND ccu.table_schema = 'library';

				RAISE EXCEPTION 'Невозможно удалить запись, так как существуют ссылки на данный айди - %. Проверьте таблицы (%). Сначала удалите записи из этих таблиц.', id, err_tables;

			WHEN OTHERS THEN

				RAISE NOTICE 'При удалении записи для book_id = % в таблице library.books возникла ошибка : % - %', id, SQLSTATE, SQLERRM;
				RAISE;
	END;
$$;


-- procedure "library".insert_person

CREATE PROCEDURE "library".insert_person (
	id "library".persons.person_id%TYPE, 
	last_n "library".persons.last_name%TYPE, 
	first_n "library".persons.first_name%TYPE, 
	second_n "library".persons.second_name%TYPE, 
	person_dob "library".persons.dob%TYPE
	)
LANGUAGE plpgsql
AS $$
	BEGIN

		INSERT INTO "library".persons
		(person_id, last_name, first_name, second_name, dob)
		VALUES(id, last_n, first_n, second_n, person_dob);

		EXCEPTION
			WHEN OTHERS THEN
				RAISE NOTICE 'При добавлении новой записи в таблицу library.persons возникла ошибка : % - %', SQLSTATE, SQLERRM;
				RAISE;
	END;
$$;

-- procedure "library".update_person
CREATE PROCEDURE "library".update_person (
	id "library".persons.person_id%TYPE, 
	last_n "library".persons.last_name%TYPE, 
	first_n "library".persons.first_name%TYPE, 
	second_n "library".persons.second_name%TYPE, 
	person_dob "library".persons.dob%TYPE
	)
LANGUAGE plpgsql
AS $$
	BEGIN

		UPDATE "library".persons
		SET 
			last_name=last_n, 
			first_name=first_n, 
			second_name=second_n, 
			dob=person_dob,
			updated_date = current_timestamp
		WHERE "person_id" = id;

		IF NOT FOUND THEN
				RAISE EXCEPTION 'Человек с ID % не найден', id;
			END IF;

		EXCEPTION
			WHEN OTHERS THEN
				RAISE NOTICE 'При обновлении записи для person_id = % в таблице library.persons возникла ошибка : % - %', id, SQLSTATE, SQLERRM;
				RAISE;
	END;
$$;


-- procedure "library".delete_person
CREATE PROCEDURE "library".delete_person(id "library".persons.person_id%TYPE)
LANGUAGE plpgsql
AS $$
DECLARE err_tables VARCHAR;

	BEGIN

		DELETE FROM "library".persons WHERE person_id=id;

		IF NOT FOUND THEN
				RAISE EXCEPTION 'Человек с ID % не найден', id;
			END IF;

		EXCEPTION
			WHEN foreign_key_violation THEN

				SELECT
					STRING_AGG(CONCAT(tc.table_schema, '.', tc.table_name), ', ') INTO err_tables
				FROM
					information_schema.table_constraints tc
				JOIN
					information_schema.constraint_column_usage ccu ON ccu.constraint_name = tc.constraint_name
				WHERE
					tc.constraint_type = 'FOREIGN KEY'
					AND ccu.table_name = 'persons'
					AND ccu.table_schema = 'library';

				RAISE EXCEPTION 'Невозможно удалить запись, так как существуют ссылки на данный айди - (%). Проверьте таблицы (%). Сначала удалите записи из этих таблиц.', id, err_tables;
			WHEN OTHERS THEN
				RAISE NOTICE 'При удалении записи для person_id = % в таблице library.persons возникла ошибка : % - %', id, SQLSTATE, SQLERRM;
				RAISE;
	END;
$$;


-- procedure "library".issue_and_return_books
CREATE PROCEDURE "library".issue_and_return_books( 
	book_name "library".books.name%TYPE, 
	book_year "library".books.year%TYPE, 
	last_n "library".persons.last_name%TYPE, 
	first_n"library".persons.first_name%TYPE, 
	second_n "library".persons.second_name%TYPE,
	person_dob "library".persons.dob%TYPE
	)
LANGUAGE plpgsql
AS $$
	DECLARE
		data_id "library".issue_return_books.id%TYPE;
		book_inst_id "library".book_instances.book_instance_id%TYPE;
		read_id "library".readers.reader_id%TYPE;

	BEGIN

		SELECT 
			irb.id INTO data_id
		FROM "library".issue_return_books AS irb
		JOIN "library".readers AS r ON irb.reader_id = r.reader_id
		JOIN "library".persons AS p ON r.reader_id = p.person_id
		JOIN "library".book_instances AS bi ON irb.book_instance_id = bi.book_instance_id
		JOIN "library".books AS b ON bi.book_id = b.book_id
		WHERE p.last_name = last_n 
			AND p.first_name = first_n 
			AND p.second_name = second_n 
			AND p.dob = person_dob
			AND b.name = book_name
			AND b.year = book_year
			AND irb.return_date IS NULL;


		IF NOT FOUND THEN	

			SELECT 
				bi.book_instance_id INTO book_inst_id
			FROM "library".books AS b
			JOIN "library".book_instances AS bi ON b.book_id = bi.book_id
			LEFT JOIN "library".issue_return_books AS irb ON bi.book_instance_id = irb.book_instance_id 
				AND irb.return_date IS NULL
			WHERE b.name = book_name
				AND b.year = book_year
				AND irb.book_instance_id IS NULL;
			
			IF NOT FOUND THEN
				RAISE NOTICE 'Свободных книг нет';
			ELSE 
				
				SELECT 
					r.reader_id INTO read_id 
				FROM "library".readers AS r
				JOIN "library".persons AS p on r.reader_id = p.person_id
				WHERE p.last_name = last_n 
					AND p.first_name = first_n 
					AND p.second_name = second_n 
					AND p.dob = person_dob;			

				INSERT INTO "library".issue_return_books (book_instance_id, reader_id, issue_date, return_date)
				VALUES( book_inst_id, read_id, CURRENT_DATE, NULL);
				RAISE NOTICE 'Книга была выдана';
			END IF;
		
		ELSE
			UPDATE "library".issue_return_books 
			SET 
				return_date = CURRENT_DATE, 
				updated_date = current_timestamp
			WHERE id = data_id;
			RAISE NOTICE 'Книга была возвращена';
	END IF;
	
	END;

$$;


-- function "library".get_articles_by_author
CREATE FUNCTION "library".get_articles_by_author ( 
	last_n "library".persons.last_name%TYPE, 
	first_n "library".persons.first_name%TYPE, 
	second_n "library".persons.second_name%TYPE
	)
RETURNS TABLE (
	article_id "library".articles.article_id%TYPE, 
	article_name "library".articles.name%TYPE
	)
LANGUAGE plpgsql
AS $$
	BEGIN

		RETURN QUERY 
		SELECT 
			a.article_id,
			a."name" AS article_name
		FROM "library".articles AS a
		JOIN "library".authors_articles AS aa ON a.article_id = aa.article_id
		JOIN "library".authors AS au ON aa.author_id = au.author_id
		JOIN "library".persons_authors AS pa ON au.author_id = pa.author_id
		JOIN "library".persons AS p ON pa.person_id = p.person_id
		WHERE p.last_name = last_n AND p.first_name = first_n AND p.second_name = second_n;

		IF NOT FOUND THEN
			RAISE NOTICE 'Произведения не найдены';
		END IF;

	END;
$$;


-- function "library".get_books_by_author
CREATE FUNCTION "library".get_books_by_author ( 
	last_n "library".persons.last_name%TYPE, 
	first_n "library".persons.first_name%TYPE, 
	second_n "library".persons.second_name%TYPE
	)
RETURNS TABLE (
	book_id "library".books.book_id%TYPE, 
	books_name "library".books.name%TYPE, 
	"year" "library".books.year%TYPE,
	count_instances BIGINT
	)
LANGUAGE plpgsql
AS $$
	BEGIN

		RETURN QUERY 
		SELECT 
			DISTINCT
				b.book_id,
				b."name" AS book_name,
				b."year",
				count(DISTINCT bi.book_instance_id) AS count_instances
		FROM "library".books AS b
		JOIN "library".book_instances AS bi ON b.book_id = bi.book_id
		JOIN "library".books_articles AS ba ON b.book_id= ba.book_id
		JOIN "library".articles AS a ON ba.article_id= a.article_id
		JOIN "library".authors_articles AS aa ON a.article_id = aa.article_id
		JOIN "library".authors AS au ON aa.author_id = au.author_id
		JOIN "library".persons_authors AS pa ON au.author_id = pa.author_id
		JOIN "library".persons AS p ON pa.person_id = p.person_id
		WHERE p.last_name = last_n AND p.first_name = first_n AND p.second_name = second_n
		GROUP BY b.book_id, b."name", b."year";

		IF NOT FOUND THEN
			RAISE NOTICE 'Книги не найдены';
		END IF;

	END;
$$;


-- function "library".get_books_by_article
CREATE FUNCTION "library".get_books_by_article ( 
	article_name "library".persons.last_name%TYPE, 
	article_redaction "library".persons.first_name%TYPE DEFAULT NULL
	)
RETURNS TABLE (
	book_id "library".books.book_id%TYPE, 
	books_name "library".books.name%TYPE, 
	"year" "library".books.year%TYPE,
	count_instances BIGINT
	)
LANGUAGE plpgsql
AS $$
	BEGIN

		IF article_redaction IS NULL THEN
			RETURN QUERY 
			SELECT 
				DISTINCT
					b.book_id,
					b."name" AS book_name,
					b."year",
					count(DISTINCT bi.book_instance_id) AS count_instances
			FROM "library".books AS b
			JOIN "library".book_instances AS bi ON b.book_id = bi.book_id
			JOIN "library".books_articles AS ba ON b.book_id= ba.book_id
			JOIN "library".articles AS a ON ba.article_id= a.article_id
			WHERE a.name = article_name
			GROUP BY b.book_id, b."name", b."year";

		ELSE
			RETURN QUERY 
			SELECT 
				DISTINCT
					b.book_id,
					b."name" AS book_name,
					b."year",
					count(DISTINCT bi.book_instance_id) AS count_instances
			FROM "library".books AS b
			JOIN "library".book_instances AS bi ON b.book_id = bi.book_id
			JOIN "library".books_articles AS ba ON b.book_id= ba.book_id
			JOIN "library".articles AS a ON ba.article_id= a.article_id
			WHERE a.name = article_name AND a.redaction = article_redaction
			GROUP BY b.book_id, b."name", b."year";

		END IF;

		IF NOT FOUND THEN
			RAISE NOTICE 'Книги не найдены';
		END IF;

	END;
$$;


-- insert data

-- insert into library.persons
CALL "library".insert_person(1, 'Пушкин', 'Александр', 'Сергеевич',  '18370526');
CALL "library".insert_person(2, 'Булгаков', 'Михаил', 'Афанасьевич',  '18910503');
CALL "library".insert_person(3, 'Толстой', 'Лев', 'Николаевич', '19101107');
CALL "library".insert_person(4, 'Грибоедов', 'Александр', 'Сергеевич', '17950104');
CALL "library".insert_person(5, 'Иванов', 'Иван', 'Иванович', '19851012');
CALL "library".insert_person(6, 'Петров', 'Петр', 'Петрович', '19700405');
CALL "library".insert_person(7, 'Васильева', 'Мария', 'Ивановна', '19990101');


-- insert into "library".books
CALL "library".insert_book(1, 'Сказки А.С. Пушника', '2001');
CALL "library".insert_book(2, 'Произведения Михаила Булгакова', '2005');
CALL "library".insert_book(3, 'Война и мир', '2010');
CALL "library".insert_book(4, 'Горе от ума', '2021');
CALL "library".insert_book(5, 'Евгений Онегин', '2003');
CALL "library".insert_book(6, 'Мастер и Маргарита', '1997');
CALL "library".insert_book(7, 'Собачье сердце', '1995');


INSERT INTO "library".genres (genre_id, "name")
VALUES	(1, 'Роман'),
		(2, 'Сказка'),
		(3, 'Повесть'),
		(4, 'Комедия'),
		(5, 'Драма');


INSERT INTO "library".articles (article_id, "name", redaction)
VALUES	(1, 'Евгений Онегин', 'Эксмо'),
		(2, 'Мастер и Маргарита', 'Альпина Паблишер'),
		(3, 'Война и мир', 'Альпина Паблишер'),
		(4, 'Сказка о рыбаке и рыбке', 'АСТ'),
		(5, 'Сказка о царе Салтане', 'Эксмо'),
		(6, 'Собачье сердце', 'АСТ'),
		(7, 'Горе от ума', 'Эксмо');


INSERT INTO "library".articles_genres (article_id, genre_id)
VALUES (1, 1), (2, 1), (3, 1), (4, 2), (4, 3), (5, 2), (6, 3), (7, 4), (7, 5);


INSERT INTO "library".authors (author_id, nick_name)
VALUES (1, 'Александр Пушкин'),
(2, 'Михаил Булгаков'),
(3, 'Лев Толстой'),
(4, 'Александр Грибоедов');


INSERT INTO "library".readers (reader_id, registration_date)
VALUES (5, '20240607'), (6, '20220821'), (7, '20250201');


INSERT INTO "library".persons_authors
(person_id, author_id)
VALUES (1, 1), (2, 2), (3, 3), (4, 4);


INSERT INTO "library".authors_articles (author_id, article_id)
VALUES (1, 1), (2, 2), (3, 3), (1, 4), (1, 5), (2, 6), (4, 7);


INSERT INTO "library".book_instances (book_instance_id, publisher, book_id)
VALUES (1, 'Феникс', 1),
(2, 'Феникс', 1),
(3, 'Проспект', 2),
(4, 'Проспект', 3),
(5, 'Питер', 3),
(6, 'Питер', 4),
(7, 'Феникс', 5),
(8, 'Питер', 6),
(9, 'Проспект', 7);


INSERT INTO "library".books_articles (book_id, article_id)
VALUES (1, 4), (1, 5), (2, 2), (2, 6), (3, 3), (4, 7), (5, 1), (6, 2), (7, 6);