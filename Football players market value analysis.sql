#MOST VALUABLE PLAYER
SELECT Name, MarketValue
FROM players
ORDER BY MarketValue DESC
LIMIT 1

#COUNT ALL THE PLAYERS WORTH 100 MILLION OR MORE
SELECT COUNT(*)
FROM players
WHERE MarketValue >= 100
ORDER BY MarketValue DESC
LIMIT 1

#THE AVERAGE MARKETVALUE OF ALL PLAYERS
SELECT AVG(Marketvalue) AS AVG_MARKETVALUE
FROM players

#TOP 3 PLAYERS WHO HAVE THE HIGHEST GOAL RATIOS PER GAME
SELECT Name, Goals/Matches AS GoalRatio
FROM players
ORDER BY GoalRatio DESC
LIMIT 3

#THE CLUB ON AVERAGE THAT HAS THE MOST VALUABLE PLAYERS
SELECT Club, AVG(MarketValue) AS AVG_MARKETVALUE
FROM players
GROUP BY Club
ORDER BY AVG_MARKETVALUE DESC
LIMIT 1

#THE TOP 5 COUNTRIES WHICH ON AVERAGE PRODUCE THE MOST VALUABLE PLAYERS
SELECT Country, AVG(MarketValue) AS AVG_MARKETVALUE
FROM players
GROUP BY Country
ORDER BY AVG_MARKETVALUE DESC
LIMIT 5

#THE MOST VALUABLE PLAYER IN EACH POSITION
SELECT Name, Position, MarketValue
FROM players
WHERE  MarketValue=(SELECT MAX(s2.MarketValue)
              FROM sys.players_2 s2
              WHERE s1.Position = s2.Position)

#GOAL CONTRIBUTIONS FOR EACH PLAYER
SELECT Name, (Goals + Assists) AS GOAL_CONTRIBUTIONS
FROM players
ORDER BY GOAL_CONTRIBUTIONS DESC

#COUNT THE NUMBER OF PLAYERS WHOSE NAMES DOES NOT START WITH A VOWEL
SELECT COUNT(DISTINCT Name)
FROM players
WHERE Name NOT RLIKE '^[aeiouAEIOU].*$'

#CATEGORIZE PLAYERS BY THEIR AGE AND GET AVERAGE MARKET VALUE FOR A PLAYER IN THAT CATEGORY
WITH AGE_CATEGORY AS(
SELECT Name, Age, Marketvalue,
CASE
    WHEN AGE >= 35 THEN "Late 30s"
	WHEN AGE >= 30 THEN "Early 30s"
	WHEN AGE >= 25 THEN "Late 20s"
	WHEN AGE >= 20 THEN "Early 20s"
	ELSE "Teenage years"
END AS AGE_GROUP
FROM players)
SELECT AGE_GROUP, AVG(Marketvalue)
FROM AGE_CATEGORY
GROUP BY AGE_GROUP
ORDER BY AVG(Marketvalue) DESC
