/* 

Data Exploration of the FDNY Incidents Report for 2021

Skills used: Create Table, Aggregate Functions, Joins, CTEs, Window Functions, CASE Statements, Transposition, Subqueries

*/



CREATE TABLE fire
(
    incident_key CHAR(8) PRIMARY KEY,
	incident_type_code CHAR(5),
    incident_date DATE NOT NULL,
	property_use_code CHAR(5),
	address VARCHAR(150),
    zip_code INT NOT NULL,
	borough VARCHAR(15)
);

CREATE TABLE incident
(
    incident_type_code CHAR(5) PRIMARY KEY,
	incident_type_desc VARCHAR(100)
);

CREATE TABLE property
(
    property_use_code CHAR(5) PRIMARY KEY,
	property_use_desc VARCHAR(100)
);



-- Total count of incidents reported for each borough 

SELECT borough, COUNT(incident_key) AS total_incidents
FROM fire
GROUP BY borough
ORDER BY total_incidents DESC;



-- Total count of incidents reported for each month 
	
SELECT 
TO_CHAR(DATE_TRUNC('Month', incident_date), 'Month') AS month, COUNT(incident_key) AS total_incidents
FROM fire
GROUP BY DATE_TRUNC('Month', incident_date)
ORDER BY DATE_TRUNC('Month', incident_date);



-- Total count of incidents for each incident type 

SELECT i.incident_type_desc, COUNT(f.incident_key)
FROM fire f
LEFT JOIN incident i
ON f.incident_type_code = i.incident_type_code
GROUP BY f.incident_type_code, i.incident_type_desc
ORDER BY COUNT(f.incident_key) DESC;



-- Grouping the incident types into categories (eg fire, EMS)  
-- Using CTE and transposition to show the categories with incident types listed 

WITH groups AS (
  	SELECT
		ROW_NUMBER () OVER (PARTITION BY r.incident_category) row_id,
		r.incident_type_code AS code,
		r.incident_type_desc AS description,
		r.incident_category AS category
	FROM
		(SELECT incident_type_code, incident_type_desc, 
			CASE
				WHEN incident_type_code BETWEEN '100' AND '164' THEN 'Fire'
				WHEN incident_type_code BETWEEN '200' AND '251' THEN 'Overpressure/Explosion/Blast'
				WHEN incident_type_code BETWEEN '300' AND '381' THEN 'EMS/Search & Rescue/Extrication'
				WHEN incident_type_code BETWEEN '400' AND '482' THEN 'Hazardous Conditions'
				WHEN incident_type_code BETWEEN '500' AND '572' THEN 'Police or Public Assistance'
				WHEN incident_type_code BETWEEN '600' AND '672' THEN 'Other'
				WHEN incident_type_code BETWEEN '700' AND '746' THEN 'Alarm/System/Detector Malfunctions'
		 		WHEN incident_type_code BETWEEN '800' AND '815' THEN 'Natural Disasters'
				ELSE ''
			END AS incident_category
 		FROM incident
		) r
)
SELECT 
    MAX(CASE WHEN code BETWEEN '100' AND '164' THEN description END) AS Fire,
	MAX(CASE WHEN code BETWEEN '200' AND '251' THEN description END) AS Overpressure_or_Explosion_or_Blast,
	MAX(CASE WHEN code BETWEEN '300' AND '381' THEN description END) AS EMS_or_Search_and_Rescue_or_Extrication,
	MAX(CASE WHEN code BETWEEN '400' AND '482' THEN description END) AS Hazardous_Conditions,
	MAX(CASE WHEN code BETWEEN '500' AND '572' THEN description END) AS Police_or_Public_Assistance,
	MAX(CASE WHEN code BETWEEN '600' AND '672' THEN description END) AS Other,
	MAX(CASE WHEN code BETWEEN '700' AND '746' THEN description END) AS Alarm_or_System_or_Detector_Malfunctions,
	MAX(CASE WHEN code BETWEEN '800' AND '815' THEN description END) AS Natural_Disasters
FROM groups
GROUP BY row_id
ORDER BY row_id;



-- Total count and percentage breakdown for each category of incidents

WITH groups AS(
		SELECT f.*, CASE
						WHEN f.incident_type_code BETWEEN '100' AND '164' THEN 'Fire'
						WHEN f.incident_type_code BETWEEN '200' AND '251' THEN 'Overpressure/Explosion/Blast'
						WHEN f.incident_type_code BETWEEN '300' AND '381' THEN 'EMS/Search & Rescue/Extrication'
						WHEN f.incident_type_code BETWEEN '400' AND '482' THEN 'Hazardous Conditions'
						WHEN f.incident_type_code BETWEEN '500' AND '572' THEN 'Police or Public Assistance'
						WHEN f.incident_type_code BETWEEN '600' AND '672' THEN 'Other'
						WHEN f.incident_type_code BETWEEN '700' AND '746' THEN 'Alarm/System/Detector Malfunctions'
						ELSE 'Natural Disasters'
					END AS incident_category
		FROM fire f
		LEFT JOIN incident i
		ON f.incident_type_code = i.incident_type_code		
)
SELECT incident_category, COUNT(incident_key), ROUND(100*COUNT(incident_key)/(SELECT COUNT(*) FROM fire), 2) as percentage
FROM groups
GROUP BY incident_category
ORDER BY COUNT(incident_key) DESC;



-- Pivot table showing the total count of incidents for each borough grouped by month

SELECT TO_CHAR(DATE_TRUNC('Month', incident_date), 'Month') AS Month,
	COUNT(CASE WHEN borough = 'Brooklyn' THEN incident_key ELSE NULL END) AS Brooklyn,
	COUNT(CASE WHEN borough = 'Manhattan' THEN incident_key ELSE NULL END) AS Manhattan,
	COUNT(CASE WHEN borough = 'Bronx' THEN incident_key ELSE NULL END) AS Bronx,
	COUNT(CASE WHEN borough = 'Queens' THEN incident_key ELSE NULL END) AS Queens,
	COUNT(CASE WHEN borough = 'Staten Island' THEN incident_key ELSE NULL END) AS Staten_Island
FROM fire
GROUP BY date_trunc('Month', incident_date)
ORDER BY date_trunc('Month', incident_date);



-- Pivot table showing total count of incidents for each borough grouped by incident category

SELECT r.incident_category,
	COUNT(CASE WHEN r.borough = 'Brooklyn' THEN r.incident_key ELSE NULL END) AS Brooklyn,
	COUNT(CASE WHEN r.borough = 'Manhattan' THEN r.incident_key ELSE NULL END) AS Manhattan,
	COUNT(CASE WHEN r.borough = 'Bronx' THEN r.incident_key ELSE NULL END) AS Bronx,
	COUNT(CASE WHEN r.borough = 'Queens' THEN r.incident_key ELSE NULL END) AS Queens,
	COUNT(CASE WHEN r.borough = 'Staten Island' THEN r.incident_key ELSE NULL END) AS Staten_Island
FROM(
	SELECT  incident_key, 
			incident_date,
			borough, 
			incident_type_code,
			CASE
				WHEN incident_type_code BETWEEN '100' AND '164' THEN 'Fire'
				WHEN incident_type_code BETWEEN '200' AND '251' THEN 'Overpressure/Explosion/Blast'
				WHEN incident_type_code BETWEEN '300' AND '381' THEN 'EMS/Search & Rescue/Extrication'
				WHEN incident_type_code BETWEEN '400' AND '482' THEN 'Hazardous Conditions'
				WHEN incident_type_code BETWEEN '500' AND '572' THEN 'Police or Public Assistance'
				WHEN incident_type_code BETWEEN '600' AND '672' THEN 'Other'
				WHEN incident_type_code BETWEEN '700' AND '746' THEN 'Alarm/System/Detector Malfunctions'
				ELSE 'Natural Disasters'
			END AS incident_category
	FROM fire
) r
GROUP BY r.incident_category
ORDER BY r.incident_category;



-- Further insight into fire related incidents (category) 
-- Top 15 zipcodes with the largest count of fire related incidents

WITH groups AS(
		SELECT f.*, CASE
						WHEN f.incident_type_code BETWEEN '100' AND '164' THEN 'Fire'
						WHEN f.incident_type_code BETWEEN '200' AND '251' THEN 'Overpressure/Explosion/Blast'
						WHEN f.incident_type_code BETWEEN '300' AND '381' THEN 'EMS/Search & Rescue/Extrication'
						WHEN f.incident_type_code BETWEEN '400' AND '482' THEN 'Hazardous Conditions'
						WHEN f.incident_type_code BETWEEN '500' AND '572' THEN 'Police or Public Assistance'
						WHEN f.incident_type_code BETWEEN '600' AND '672' THEN 'Other'
						WHEN f.incident_type_code BETWEEN '700' AND '746' THEN 'Alarm/System/Detector Malfunctions'
						ELSE 'Natural Disasters'
					END AS incident_category
		FROM fire f
		LEFT JOIN incident i
		ON f.incident_type_code = i.incident_type_code		
)
SELECT zip_code, MAX(borough), COUNT(*)
FROM groups
WHERE incident_category = 'Fire'
GROUP BY zip_code
ORDER BY COUNT(*) DESC
LIMIT 15;



-- Top 15 property types with the largest count of fire related incidents

WITH groups AS(
		SELECT f.*, p.*, CASE
						WHEN f.incident_type_code BETWEEN '100' AND '164' THEN 'Fire'
						WHEN f.incident_type_code BETWEEN '200' AND '251' THEN 'Overpressure/Explosion/Blast'
						WHEN f.incident_type_code BETWEEN '300' AND '381' THEN 'EMS/Search & Rescue/Extrication'
						WHEN f.incident_type_code BETWEEN '400' AND '482' THEN 'Hazardous Conditions'
						WHEN f.incident_type_code BETWEEN '500' AND '572' THEN 'Police or Public Assistance'
						WHEN f.incident_type_code BETWEEN '600' AND '672' THEN 'Other'
						WHEN f.incident_type_code BETWEEN '700' AND '746' THEN 'Alarm/System/Detector Malfunctions'
						ELSE 'Natural Disasters'
					END AS incident_category
		FROM fire f
		LEFT JOIN incident i
		ON f.incident_type_code = i.incident_type_code
		LEFT JOIN property p
		ON f.property_use_code = p.property_use_code
)
SELECT property_use_desc, COUNT(*)
FROM groups
WHERE incident_category = 'Fire'
GROUP BY property_use_desc
ORDER BY COUNT(*) DESC
LIMIT 15;
