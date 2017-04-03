DROP TABLE IF EXISTS foreign_player CASCADE;
DROP TABLE IF EXISTS player_stats CASCADE;
DROP TABLE IF EXISTS team_attendence CASCADE;
DROP TABLE IF EXISTS player_salary CASCADE;
DROP TABLE IF EXISTS player_stats_full CASCADE;
DROP TABLE IF EXISTS team_foreign_percent CASCADE;

CREATE TABLE foreign_player (
    YEAR integer, 
    PLAYER character varying(100),
    POS character(5),
    COUNTRY character varying(100),
    PRIMARY KEY (YEAR, PLAYER)
);

CREATE TABLE player_stats (
	YEAR integer, 
    PLAYER character varying(100),
    GAMES integer,
    MPG double precision,
    TS double precision,
    AST double precision,
    TURN_OVER double precision,
    USG double precision,
    ORR double precision,
    DRR double precision,
    REBR double precision,
    PER double precision,
   	VA double precision,
   	EWA double precision,
    PRIMARY KEY (YEAR, PLAYER)
);

CREATE TABLE player_stats_full (
    PLAYER character varying(100),
    YEAR integer, 
    AGE integer,
    TEAM_ID character varying(100),
    GAMES integer,
    GAME_STARTED integer,
    MINUTES integer,
    FIELD_GOAL integer,
    TWO_POINT integer,
    THREE_POINT integer,
    FREE_THROW integer,
    FREE_THROW_ATTEM integer,
    AST integer,
    STEAL integer,
    BLOCK integer,
    TURN_OVER integer,
    FOULS integer,
    POINTS integer,
    PRIMARY KEY (YEAR, PLAYER, TEAM_ID)
);

CREATE TABLE team_attendence (
	YEAR integer,
	TEAM character varying(100),
	HOMEGAMES integer,
	TOTAL_ATTENDENCE integer,
	AVG_ATTENDENCE integer,
	PRIMARY KEY (YEAR, TEAM)
);

CREATE TABLE player_salary (
	YEAR integer,
	PLAYER character varying(100),
	TEAM character varying(100),
	SALARY integer,
 	PRIMARY KEY (YEAR, PLAYER)
);

CREATE TABLE team_foreign_percent (
    YEAR integer,
    TEAM character varying(100),
    FOREIGN_PERCENT double precision,
    PRIMARY KEY (YEAR, TEAM)
);


COPY foreign_player FROM '/Users/dzhong/Desktop/2017 Spring/CS480/project-nextnbastar/international_players.csv' 
DELIMITER ',' CSV HEADER;

COPY player_stats FROM '/Users/dzhong/Desktop/2017 Spring/CS480/project-nextnbastar/player_per.csv'
DELIMITER ',' CSV HEADER;

COPY team_attendence FROM '/Users/dzhong/Desktop/2017 Spring/CS480/project-nextnbastar/team_attendence.csv'
DELIMITER ',' CSV HEADER;

COPY player_salary FROM '/Users/dzhong/Desktop/2017 Spring/CS480/project-nextnbastar/player_salary.csv'
DELIMITER ',' CSV HEADER;

COPY player_stats_full FROM '/Users/dzhong/Desktop/2017 Spring/CS480/project-nextnbastar/player_stats_full.csv'
DELIMITER ',' CSV HEADER;

COPY team_foreign_percent FROM '/Users/dzhong/Desktop/2017 Spring/CS480/project-nextnbastar/team_foreign_percent.csv'
DELIMITER ',' CSV HEADER;
