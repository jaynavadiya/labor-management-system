SET SEARCH_PATH TO laborlist_and_wages_db; 

-- 1st Query: Find out the labor id all the labors living in "city_name" 
SELECT labor_id,city,district FROM laborlist_and_wages_db.labor NATURAL JOIN laborlist_and_wages_db.location_info WHERE location_info.city='Ludvika';

-- 2nd Query: Find out the age of all of the labors 
SELECT name,age(current_date,labor.birth_date) as Age FROM personal_info INNER JOIN labor ON personal_info.labor_id = labor.labor_id;

-- 3rd Query: Find out the labors whose hourly wage is less than 100 rupees.
SELECT personal_info.name, hourly_wage FROM hourly_labors NATURAL JOIN labor INNER JOIN personal_info 
ON labor.labor_id = personal_info.labor_id WHERE (hourly_wage<100) ; 

-- 4th Query: Find out all the labors hired by the business…
[23:17, 11/16/2022] Jay Navadiya: SET SEARCH_PATH TO laborlist_and_wages_db; 

-- 1st Query: Find out the labor id all the labors living in "city_name" 
SELECT labor_id,city,district FROM laborlist_and_wages_db.labor NATURAL JOIN laborlist_and_wages_db.location_info WHERE location_info.city='Ludvika';

-- 2nd Query: Find out the age of all of the labors 
SELECT name,age(current_date,labor.birth_date) as Age FROM personal_info INNER JOIN labor ON personal_info.labor_id = labor.labor_id;

-- 3rd Query: Find out the labors whose hourly wage is less than 100 rupees.
SELECT personal_info.name, hourly_wage FROM hourly_labors NATURAL JOIN labor INNER JOIN personal_info 
ON labor.labor_id = personal_info.labor_id WHERE (hourly_wage<100) ; 

-- 4th Query: Find out all the labors hired by the business "business_name"
SELECT personal_info.name, hires.labor_id, business_info.name 
FROM business_info NATURAL JOIN hires INNER JOIN personal_info ON hires.labor_id = personal_info.labor_id WHERE (business_info.name = 'Zemlak Inc');

-- 5th Query: Count the number of Hourly Wage taking labors are there
SELECT COUNT (*) FROM hourly_labors;

-- 6th Query: Find out the details of labor who has highest hourly wage among others
SELECT hourly_labors.labor_id,personal_info.name,hourly_labors.hourly_wage 
FROM hourly_labors NATURAL JOIN personal_info WHERE hourly_wage in (SELECT MAX(hourly_wage) FROM hourly_labors);

-- 7th Query: find out name of all supervisors whose name starts from S.
SELECT supervisor_id, name FROM personal_info WHERE supervisor_id IS NOT NULL AND personal_info.name LIKE 'S%';

-- 8th Query: Find out all labors whose hourly wage is greater than 5 and whose age is higher than 30.
SELECT hourly_labors.labor_id,personal_info.name,age(current_date,labor.birth_date),hourly_labors.hourly_wage 
FROM hourly_labors NATURAL JOIN labor INNER JOIN personal_info ON labor.labor_id = personal_info.labor_id 
WHERE hourly_wage > 5 AND age(current_date,labor.birth_date) > INTERVAL '30Y';

-- 9th Query: Grouped by supervisor, printing sum of their labor's hourly wage so that the company can see their hourly expense on laborers per supervisor.
SELECT labor_supervisor.supervisor_id, personal_info.name, sum(hourly_labors.hourly_wage) 
FROM hourly_labors NATURAL JOIN labor INNER JOIN labor_supervisor ON labor.supervisor_id = labor_supervisor.supervisor_id 
INNER JOIN personal_info ON labor_supervisor.supervisor_id = personal_info.supervisor_id
GROUP BY labor_supervisor.supervisor_id,personal_info.name;

--10th Query: Find out all the supervisors who have paid labors till now.

SELECT supervisor_id, personal_info.name FROM personal_info 
WHERE supervisor_id NOT IN (SELECT supervisor_id FROM pays);

-- 11th Query: Find out all users who have hired a labor sometime in their life.
SELECT hires.user_id, personal_info.name, hires.labor_id FROM hires INNER JOIN personal_info 
ON hires.user_id = personal_info.user_id ;

-- 12th Query: Show labors in company who have worked less than average working hours
SELECT labor.labor_id,personal_info.name FROM labor INNER JOIN personal_info ON labor.labor_id = personal_info.labor_id
WHERE labor.work_hours < (SELECT AVG(work_hours) FROM labor);

-- 13th Query: 
-- Trigger to check and preventing inserting into the labor table if duplicate labor is found

CREATE OR REPLACE FUNCTION check_labor_insert()
  RETURNS trigger AS
$$
BEGIN
IF EXISTS(SELECT COUNT(*) FROM labor WHERE labor_id = NEW.labor_id) THEN
	RAISE NOTICE'Duplicate Found (%)', NEW.labor_id;
	RETURN OLD;
	--IF DUPLICATE WILL BE FOUND THEN IT WILL RAISE NOTICE AND THEN RETURN OLD TABLE
END IF;
--ELSE BY DEFAULT IT WILL RETURN NEW TABLE
RETURN NEW;
END;

$$
LANGUAGE 'plpgsql';

DROP TRIGGER IF EXISTS check_labor_before_insert ON labor;
CREATE TRIGGER check_labor_before_insert
  BEFORE INSERT --BEFORE INSERTION THIS TRIGGER WILL RUN
  ON labor
  FOR EACH ROW --FOR EACH AFFECTED COLUMN THIS WILL RUN
  EXECUTE PROCEDURE check_labor_insert();

--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
INSERT INTO labor(labor_id,birth_date,work_hours,wage_remaining,rating,Type_of_work,supervisor_id,supervised_since,location_id,account_number) 
VALUES (61,'08-Nov-1961',49,'50',4,'Electrician',121,'29-Jun-2022',3114,827356014688);
--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

-- 14th Query:
-- Function to return 10 labors with maximum work hours per week

CREATE OR REPLACE FUNCTION max_work_hours() 
RETURNS TABLE(
		laborID integer,
		workHours integer
	)
LANGUAGE 'plpgsql'
AS $BODY$
	declare f record;
	begin
		CREATE TEMP TABLE test1(
			laborID integer,
			workHours integer
		) ON COMMIT DROP;

		for f in select labor_id, work_hours
			   from labor
			   order by work_hours DESC LIMIT 10
		loop 
		INSERT INTO test1(laborID,workHours)
			VALUES(f.labor_id,f.work_hours); --inserting those tuples into temp table
		end loop;
		return query table test1;
	end;
$BODY$;

--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
SELECT * FROM max_work_hours();
--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

-- 15th Query: find out bank information of all the business.
SELECT * FROM bank_info WHERE type_of_user = 'business';

-- 16th Query: find out all the government officials who have been monitoring the businesses.
SELECT DISTINCT business_info.official_id, personal_info.name FROM business_info INNER JOIN personal_info ON business_info.official_id = personal_info.official_id;

-- 17th Query: Show all the cities and districts in which the users live
SELECT city,district FROM location_info;

-- 18th Query: Show all weekly wage taking laborers in asceding order of the weekly wage
SELECT * FROM weekly_labors ORDER BY weekly_wage ASC;

-- 19th Query: count the number of labors under supervison by supervisors
SELECT labor.supervisor_id, personal_info.name, COUNT(*) FROM labor INNER JOIN personal_info ON labor.supervisor_id = personal_info.supervisor_id
GROUP BY labor.supervisor_id, personal_info.name;

-- 20th Query: find out labors labor id whose leave is not yet approved.
SELECT leave_id, supervisor_id, labor_id FROM takes_leave WHERE leave_id NOT IN (SELECT leave_id FROM approves);