drop table Circuits;
create table Circuits (
       circuitID 	       INTEGER,
       name		       VARCHAR(100),
       location		VARCHAR(100),
       country		VARCHAR(100)
);

drop table Constructors;
create table Constructors (
       constructorID 	INTEGER,
       name		       VARCHAR(100),
       nationality		VARCHAR(100)
);

drop table Drivers;
create table Drivers (
       driverID 	       INTEGER,
       fName		       VARCHAR(100),
       lName		       VARCHAR(100),
       dob                  DATE,
       nationality          VARCHAR(100)
);

drop table RaceResults;
create table RaceResults (
       raceID 	       INTEGER,
       driverID		INTEGER,
       constructorID		INTEGER,
       startPosition        INTEGER,
       finalPosition        INTEGER,
       points               INTEGER,
       fastestLapTime       TIME,
       statusID             INTEGER
);

drop table Qualifying;
create table Qualifying (
       raceID 	       INTEGER,
       driverID		INTEGER,
       constructorID		INTEGER,
       finalPosition        INTEGER
);

drop table SprintRaces;
create table SprintRaces (
       raceID 	       INTEGER,
       driverID		INTEGER,
       constructorID		INTEGER,
       startPosition        INTEGER,
       finalPosition        INTEGER,
       points               INTEGER,
       statusID             INTEGER
);

drop table Status;
create table Status (
       statusID 	       INTEGER,
       description		VARCHAR(100)
);

drop table PitStops;
create table PitStops (
       raceID 	       INTEGER,
       driverID		INTEGER,
       numPitStops          INTEGER
);

drop table Races;
create table Races (
       raceID 	       INTEGER,
       year		       INTEGER,
       round                INTEGER,
       circuitID            INTEGER,
       date                 DATE
);

