ALTER TABLE PLAYER_STATS
ADD COLUMN FOREIGN_PLAYER INTEGER;

ALTER TABLE PLAYER_STATS_FULL
ADD COLUMN FOREIGN_PLAYER INTEGER;


UPDATE PLAYER_STATS as ps 
	SET foreign_player = 1
	where ps.player in (select player from foreign_player);

UPDATE PLAYER_STATS as ps 
	SET foreign_player = 0
	where ps.player not in (select player from foreign_player);

UPDATE PLAYER_STATS_FULL as ps 
	SET foreign_player = 1
	where ps.player in (select player from foreign_player);

UPDATE PLAYER_STATS_FULL as ps 
	SET foreign_player = 0
	where ps.player not in (select player from foreign_player);


COPY (select ps.*,pa.team,pa.salary from player_stats as ps join player_salary as pa on ps.player = pa.player and ps.year = pa.year order by ps.year) TO './CSVresults/player_stats_and_salary.csv' DELIMITER ',' CSV HEADER;
COPY (WITH temp as (select ps.*,pa.team,pa.salary from player_stats as ps join player_salary as pa on ps.player = pa.player and ps.year = pa.year order by ps.year)
select temp.*,ta.homegames,ta.total_attendence,ta.avg_attendence from temp left join team_attendence as ta on ta.team = temp.team and ta.year = temp.year order by ta.year, ta.team) TO './CSVresults/player_everything.csv' DELIMITER ',' CSV HEADER;

COPY (select psf.*,pa.team,pa.salary from player_stats_full as psf join player_salary as pa on psf.player = pa.player and psf.year = pa.year order by psf.year) TO './CSVresults/player_stats_and_salary_second.csv' DELIMITER ',' CSV HEADER;
COPY (WITH temp as (select ps.*,pa.team,pa.salary from player_stats_full as ps join player_salary as pa on ps.player = pa.player and ps.year = pa.year order by ps.year)
select temp.*,ta.homegames,ta.total_attendence,ta.avg_attendence from temp left join team_attendence as ta on ta.team = temp.team and ta.year = temp.year order by ta.year, ta.team) TO './CSVresults/player_everything_second.csv' DELIMITER ',' CSV HEADER;

COPY (select tp.*,ta.homegames, ta.total_attendence, ta.avg_attendence from 
team_foreign_percent as tp, team_attendence as ta
where tp.year = ta.year and tp.team = ta.team) TO './CSVresults/team_foreign_percent_and_attendence.csv' DELIMITER ',' CSV HEADER;
-- COPY ((WITH team_foreign_players as (WITH temp as (select ps.*,pa.team,pa.salary from player_stats_full as ps join player_salary as pa on ps.player = pa.player and ps.year = pa.year order by ps.year)
-- select temp2.team,temp2.year,count(*) as num from (select temp.*,ta.homegames,ta.total_attendence,ta.avg_attendence from temp left join team_attendence as ta on ta.team = temp.team and ta.year = temp.year 
-- where temp.foreign_player = 1
-- order by ta.year, ta.team) as temp2
-- group by temp2.year, temp2.team
-- order by temp2.year, temp2.team),

-- team_players as (WITH temp as (select ps.*,pa.team,pa.salary from player_stats_full as ps join player_salary as pa on ps.player = pa.player and ps.year = pa.year order by ps.year)
-- select temp2.team,temp2.year,count(*) as num from (select temp.*,ta.homegames,ta.total_attendence,ta.avg_attendence from temp left join team_attendence as ta on ta.team = temp.team and ta.year = temp.year order by ta.year, ta.team) as temp2
-- group by temp2.year, temp2.team
-- order by temp2.year, temp2.team)

-- select tp.year, tp.team,ROUND(((100.0*tfp.num) / tp.num),1) AS percent_of_foreign
-- from team_foreign_players as tfp, team_players as tp
-- where tfp.year = tp.year and tfp.team = tp.team)) TO '/Users/dzhong/Desktop/2017 Spring/CS480/project-nextnbastar/team_foreign_percent.csv' DELIMITER ',' CSV HEADER;

