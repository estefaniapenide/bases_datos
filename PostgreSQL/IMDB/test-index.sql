/*
 * https://datasets.imdbws.com/
 * title.basics.tsv
 */

DROP TABLE IF EXISTS titles;
CREATE TABLE titles (
	tconst CHAR(9) NOT NULL,
	titleType VARCHAR(255) NOT NULL,
	primaryTitle VARCHAR(255) NOT NULL,
	originalTitle VARCHAR(255) NOT NULL,
	isAdult BOOLEAN NOT NULL,
	startYear INT,
	endYear INT,
	runtimeMinutes INT,
	genres VARCHAR(255)
)


SELECT count(*)
FROM titles;

SELECT startyear, round(avg(COALESCE(runtimeMinutes,0)))
FROM titles T1
GROUP BY startyear
ORDER BY startyear;

SELECT *, (SELECT originaltitle 
			FROM titles
			WHERE runtimeminutes=T1.runtimeminutes
			LIMIT 1)
FROM titles T1;

CREATE INDEX index2 ON titles(runtimeminutes);

/* https://www.tutorialspoint.com/postgresql/postgresql_indexes.htm */
