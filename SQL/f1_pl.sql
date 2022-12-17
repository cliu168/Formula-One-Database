USE 22fa_cliu168_db
DELIMITER //

-- views
CREATE OR REPLACE VIEW RacePointsView AS
SELECT RR.driverID, RR.constructorID, R.circuitID, year, RR.points
FROM Races AS R, RaceResults AS RR
WHERE R.raceID = RR.raceID;

CREATE OR REPLACE VIEW AccidentsView AS
SELECT A.name, A.location, A.accidents, COUNT(R.circuitID) AS numRaces
FROM (
    SELECT C.circuitID, C.name, C.location, COUNT(C.circuitID) AS accidents
    FROM Circuits AS C, Races AS R, RaceResults AS RR
    WHERE C.circuitID = R.circuitID AND
        R.raceID = RR.raceID AND
        (RR.statusID = 3 OR RR.statusID = 4) 
    GROUP BY C.circuitID
) AS A, Races AS R
WHERE A.circuitID = R.circuitID
GROUP BY R.circuitID;

CREATE OR REPLACE VIEW RaceWinnersView AS
SELECT RR.raceID, RR.driverID, R.circuitID
FROM Races AS R, RaceResults AS RR
WHERE R.raceID = RR.raceID AND
    RR.finalPosition = 1;

-- Return nationalities and driver count. Order by descending number of drivers.
CREATE OR REPLACE PROCEDURE Q1()
BEGIN
    SELECT nationality, COUNT(driverID)
    FROM Drivers
    GROUP BY nationality
    ORDER BY COUNT(nationality) DESC;
END; //

-- Return the first name and last name of all drivers of a specific nationality.
CREATE OR REPLACE PROCEDURE Q2(IN na VARCHAR(100))
BEGIN
    SELECT fname, lname
    FROM Drivers
    WHERE nationality = na;
END; //

-- Return countries and circuit count. Order by descending number of circuits.
CREATE OR REPLACE PROCEDURE Q3()
BEGIN
    SELECT country, COUNT(circuitID)
    FROM Circuits
    GROUP BY country
    ORDER BY COUNT(country) DESC;
END; //

-- Return the name and location of all circuits in a specific country.
CREATE OR REPLACE PROCEDURE Q4(IN co VARCHAR(100))
BEGIN
    SELECT name, location
    FROM Circuits
    WHERE country =  co;
END; //

-- Return the first name and last name of all drivers who have won a race.
CREATE OR REPLACE PROCEDURE Q5()
BEGIN
    SELECT DISTINCT D.fname, D.lname
    FROM Drivers AS D, RaceResults AS RR
    WHERE D.driverID = RR.driverID AND
        RR.finalPosition = 1;
END; //

-- Return the first name and last name of all drivers who have gotten pole from qualifying.
CREATE OR REPLACE PROCEDURE Q6()
BEGIN
    SELECT DISTINCT D.fname, D.lname
    FROM Drivers AS D, Qualifying AS Q
    WHERE D.driverID = Q.driverID AND
        Q.finalPosition = 1;
END; //

-- Return the first name and last name of all drivers who have won a sprint race.
CREATE OR REPLACE PROCEDURE Q7()
BEGIN
    SELECT DISTINCT D.fname, D.lname
    FROM Drivers AS D, SprintRaces AS S
    WHERE D.driverID = S.driverID AND
        S.finalposition = 1;
END; //

-- Return the average number points for a specific circuit of each driver and the respective driver's first name and last name. Order by descending number of points.
-- Slow query
CREATE OR REPLACE PROCEDURE Q8(IN ci VARCHAR(100))
BEGIN
    SELECT D.fname, D.lname, AVG(R.points)
    FROM (
        SELECT P.driverID, P.points
        FROM RacePointsView AS P, Circuits AS C
        WHERE C.name = ci AND
            C.circuitID = P.circuitID
    ) AS R, Drivers AS D
    WHERE D.driverID = R.driverID
    GROUP BY R.driverID
    ORDER BY AVG(R.points) DESC;
END; //

-- Return the average number of points per season of each driver and the respective driver's first name and last name. Order by descending number of points.
CREATE OR REPLACE PROCEDURE Q9()
BEGIN
    SELECT D.fname, D.lname, AVG(R.seasonPts)
    FROM (
        SELECT driverID, year, SUM(points) AS seasonPts
        FROM RacePointsView
        GROUP BY driverID, year
    ) AS R, Drivers AS D
    WHERE D.driverID = R.driverID
    GROUP BY R.driverID
    ORDER BY AVG(R.seasonPts) DESC;
END; //   

-- Return the average number points for a specific circuit of each constructor and the respective constructor’s name. Order by descending number of points.
CREATE OR REPLACE PROCEDURE Q10(IN ci VARCHAR(100))
BEGIN
    SELECT CS.name, AVG(R.points)
    FROM (
        SELECT P.constructorID, P.points
        FROM RacePointsView AS P, Circuits AS C
        WHERE C.name = ci AND
            C.circuitID = P.circuitID
    ) AS R, Constructors AS CS
    WHERE CS.constructorID = R.constructorID 
    GROUP BY R.constructorID
    ORDER BY AVG(R.points) DESC;
END; //

-- Return the average number of points per season of each constructor and the respective constructor’s name. Order by descending number of points.
CREATE OR REPLACE PROCEDURE Q11()
BEGIN
    SELECT CS.name, AVG(R.seasonPts)
    FROM (
        SELECT constructorID, year, SUM(points) AS seasonPts
        FROM RacePointsView
        GROUP BY constructorID, year
    ) AS R, Constructors AS CS
    WHERE CS.constructorID = R.constructorID 
    GROUP BY R.constructorID
    ORDER BY AVG(R.seasonPts) DESC;
END; //

-- Return driver first name and last names, and their respective number of wins in a specific circuit. Order by descending number of wins.
CREATE OR REPLACE PROCEDURE Q12(IN ci VARCHAR(100))
BEGIN
    SELECT D.fname, D.lname, R.numWins
    FROM (
        SELECT W.driverID, COUNT(W.raceID) AS numWins
        FROM RaceWinnersView AS W, Circuits AS C
        WHERE C.name = ci AND
            C.circuitID = W.circuitID
        GROUP BY W.driverID
    ) AS R, Drivers AS D
    WHERE D.driverID = R.driverID
    ORDER BY R.numWins DESC;
END; //

-- Return driver first name and last names, and their respective fastest lap time in a specific circuit. Order by ascending all time fastest lap time.
-- Missing data
CREATE OR REPLACE PROCEDURE Q13(IN ci VARCHAR(100))
BEGIN
    SELECT D.fname, D.lname, R.fastestLap
    FROM (
        SELECT F.driverID, MIN(F.fastestLapTime) AS fastestLap
        FROM (
            SELECT RR.driverID, R.circuitID, RR.fastestLapTime
            FROM Races AS R, RaceResults AS RR
            WHERE R.raceID = RR.raceID
        ) AS F, Circuits AS C
        WHERE C.name = ci AND
            C.circuitID = F.circuitID
        GROUP BY F.driverID
    ) AS R, Drivers AS D
    WHERE D.driverID = R.driverID AND
        R.fastestLap IS NOT NULL
    ORDER BY R.fastestLap ASC;
END; //

-- Return the name and location of all circuits and it's all time total race accidents/collisions. Order by descending accidents.
CREATE OR REPLACE PROCEDURE Q14()
BEGIN
    SELECT name, location, accidents
    FROM AccidentsView
    ORDER BY accidents DESC;
END; //

-- Return the name and location of all circuits and its average accidents/collisions per race. Order by descending average accidents.
CREATE OR REPLACE PROCEDURE Q15()
BEGIN
    SELECT name, location, accidents / numRaces
    FROM AccidentsView
    ORDER BY accidents / numRaces DESC;
END; //

-- Return first name and last name of all drivers who have ever had an accident/collision in a specific circuit.
CREATE OR REPLACE PROCEDURE Q16(IN ci VARCHAR(100))
BEGIN
    SELECT DISTINCT D.fname, D.lname
    FROM Drivers AS D, Circuits AS C, Races AS R, RaceResults AS RR
    WHERE C.name = ci AND
        C.circuitID = R.circuitID AND
        R.raceID = RR.raceID AND
        D.driverID = RR.driverID AND
        (RR.statusID = 3 OR RR.statusID = 4);
END; //

-- Return the first name and last name of all drivers, and their all time number of races with issues (status not equal to one). Order by descending number of races with issues.
CREATE OR REPLACE PROCEDURE Q17()
BEGIN
    SELECT D.fname, D.lname, COUNT(RR.driverID) AS racesWithIssues
    FROM Drivers AS D, RaceResults AS RR
    WHERE D.driverID = RR.driverID AND
        RR.statusID > 1
    GROUP BY D.fname, D.lname
    ORDER BY COUNT(RR.driverID) DESC;
END; //

-- Return average number of pit stops of all drivers that have won at a specific circuit. Order by ascending pit stops.
-- Missing data
CREATE OR REPLACE PROCEDURE Q18(IN ci VARCHAR(100))
BEGIN
    SELECT D.fname, D.lname, AVG(P.numPitStops)
    FROM (
        SELECT W.raceID, W.driverID
        FROM RaceWinnersView AS W, Circuits AS C
        WHERE C.name = ci AND
            C.circuitID = W.circuitID
    ) AS R, Drivers AS D, PitStops AS P
    WHERE D.driverID = R.driverID AND
        P.driverID = R.driverID AND
        P.raceID = R.raceID
    GROUP BY R.driverID
    ORDER BY AVG(P.numPitStops) ASC;
END; //

-- Return nationalities and all its drivers’ average number of points per season. Order by descending points.
CREATE OR REPLACE PROCEDURE Q19()
BEGIN
    SELECT D.nationality, AVG(R.seasonPts)
    FROM (
        SELECT driverID, year, SUM(points) AS seasonPts
        FROM RacePointsView
        GROUP BY driverID, year
    ) AS R, Drivers AS D
    WHERE D.driverID = R.driverID
    GROUP BY D.nationality
    ORDER BY AVG(R.seasonPts) DESC;
END; //

-- Return year of birth and all its drivers’ average number of points per season. Order by descending points.
CREATE OR REPLACE PROCEDURE Q20()
BEGIN
    SELECT YEAR(D.dob), AVG(R.seasonPts)
    FROM (
        SELECT driverID, year, SUM(points) AS seasonPts
        FROM RacePointsView
        GROUP BY driverID, year
    ) AS R, Drivers AS D
    WHERE D.driverID = R.driverID
    GROUP BY YEAR(D.dob)
    ORDER BY AVG(R.seasonPts) DESC;
END; //