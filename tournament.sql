-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

-- drop old tables.
DROP DATABASE IF EXISTS tournament CASCADE;
DROP TABLE IF EXISTS players CASCADE;
DROP TABLE IF EXISTS matches CASCADE;
Drop VIEW IF EXISTS standings CASCADE;
DROP VIEW If EXISTS wins_by_player CASCADE;
DROP VIEW IF EXISTS match_count CASCADE

-- create a database named 'tournament'
CREATE DATABASE tournament;
-- connect to the database 'tournament'
\c tournament;

--Behavior of Table 'players': creates an id as a primary key and Name of player
--INPUTS: 
--OUTPUTS: unique id for each player and then their name
CREATE TABLE players(
id serial primary key,
name VARCHAR(100)
);

--Behavior of Table 'matches': creates match_id as a primary key, a winner_id, loser_id and result
--INPUTS: 
--OUTPUTS: unique id for each match. A winner id, loser id and a score for the winner and loser.
CREATE TABLE matches(
match_id serial primary key,
winner_id integer references players(id),
loser_id integer references players(id),
score integer
);

--Behavior of VIEW: keeps track of wins for each player
--INPUTS: TABLE players and matches
--OUTPUTS:number of wins for each player
CREATE VIEW wins_by_player AS
select players.id, players.name, count(matches.winner_id) AS wins
from players left join( SELECT * from matches WHERE score>0) as matches
on players.id = matches.winner_id
group by players.id;


--Behavior of VIEW: keeps track of matches for each player
--INPUTS: TABLE players and matches. 
--OUTPUTS: number of matches for each player
CREATE VIEW match_count AS
select players.id, count(matches.loser_id) AS losses
from players left join matches
on players.id = matches.winner_id
group by players.id;

--Behavior of VIEW: keeps track of wins and matches for each player
--INPUTS: TABLE players, VIEW wins_by_player, and match_count
--OUTPUTS: number wins and matches for each player
CREATE VIEW standings AS 
select players.id, players.name, wins_by_player.wins as wins, match_count.losses as matches
FROM players, match_count, wins_by_player
WHERE players.id = wins_by_player.id and wins_by_player.id = match_count.id;


