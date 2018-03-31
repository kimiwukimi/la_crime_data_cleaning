-- create crime 14 and 15 table
drop table if exists crime1415;
CREATE TABLE crime1415 AS
select crime.CrimeCodeDescription, crime.CrimeCode, crime.DateOccurred, crime.TimeOccurred,crime.CrimeCode1, crime.CrimeCode2, crime.CrimeCode3, crime.CrimeCode4, Location 
from crime
where substr(crime.DateOccurred,7)||substr(crime.DateOccurred,1,2)||substr(crime.DateOccurred,4,2) 
      between '20140701' and '20150630';

-- create crime table from 10 to 17
drop table if exists crime1017;
CREATE TABLE crime1017 AS
select crime.CrimeCodeDescription as crimeDescription, crime.CrimeCode as crimeCode,
 crime.DateOccurred, crime.TimeOccurred, Location 
from crime


---- create time
-- ALTER TABLE crime ADD COLUMN hour;
-- UPDATE crime SET Hour=substr(1,2);


-- count crime code freq
select crime.CrimeCode as CrimeCode, count(CrimeCode) as freq, crime.CrimeCodeDescription as CrimeCodeDescription
from crime
group by crime.CrimeCode
order by freq desc;


-- create latitude and longitude
ALTER table crime ADD COLUMN latitude;
UPDATE crime SET latitude = Substr(Location, 2, instr(Location, ',')-2);

ALTER table crime ADD COLUMN longitude;
UPDATE crime SET longitude = Substr(Location, instr(Location, ',') + 1, instr(Location, ')')-instr(Location, ',')-1 );


-- create time as 01-31-2015
create table crime2 as
select crime_code,
substr(crime1.date, 7, 4) || '-'  || 
substr(crime1.date, 4, 2) ||  '-' || 
substr(crime1.date, 1, 2)
 as date,
time, crime_code_description, longitude, latitude
from crime1
order by crime1.time asc;


-- add day_of_week
drop table if exists crime3;

create table crime3 as
select crime_code, 
substr(date, 7, 4) || '-' || 
substr(date, 1, 2) || '-' || 
substr(date, 4, 2) as date, time, crime_code_description, longitude, latitude
from crime2;

-- add day_of_week
drop table if exists crime4;

create table crime4 as
select crime_code, date, time, crime_code_description, longitude, latitude,
strftime('%w', crime3.date) as day_of_week
from crime3;







-- create crimeDegree
ALTER TABLE crime10to17 ADD COLUMN crimeDegree;

UPDATE crime10to17
    SET crimeDegree=CASE
        WHEN 
	        CrimeCode LIKE '753' or
	        CrimeCode LIKE '648' or
	        CrimeCode LIKE '110' or
	        CrimeCode LIKE '910' or
	        CrimeCode LIKE '922' or
	        CrimeCode LIKE '920'
        THEN 1

        WHEN 
			CrimeCode Like '860' or
			CrimeCode Like '121' or
			CrimeCode Like '815' or
			CrimeCode Like '763' or
			CrimeCode Like '820' or
			CrimeCode Like '821' or
			CrimeCode Like '932' or
			CrimeCode Like '122'
        THEN 2

        WHEN 
			CrimeCode Like '210' or
			CrimeCode Like '220' or
			CrimeCode Like '761' or
			CrimeCode Like '940' or
			CrimeCode Like '351'

        THEN 3

        WHEN 
			CrimeCode Like '624' or
			CrimeCode Like '230' or
			CrimeCode Like '236' or
			CrimeCode Like '627' or
			CrimeCode Like '625' or
			CrimeCode Like '235' or
			CrimeCode Like '231'

        THEN 4

        WHEN 
			CrimeCode Like '510' or
			CrimeCode Like '330' or
			CrimeCode Like '310' or
			CrimeCode Like '320' or
			CrimeCode Like '480' or
			CrimeCode Like '520' or
			CrimeCode Like '410'

        THEN 5

        WHEN 
			CrimeCode Like '951' or
			CrimeCode Like '441' or
			CrimeCode Like '440' or
			CrimeCode Like '420' or
			CrimeCode Like '341' or
			CrimeCode Like '442' or
			CrimeCode Like '331' or
			CrimeCode Like '350' or
			CrimeCode Like '664' or
			CrimeCode Like '343' or
			CrimeCode Like '421' or
			CrimeCode Like '352'

        THEN 6
    END;

-- filter out crimeDegree is null rows
create table crime as 
select * from crime10to17 where crimeDegree is not NULL;



