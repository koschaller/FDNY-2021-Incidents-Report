# New York City Fire Department Incidents Report for 2021

### The National Fire Incident Reporting System (NFIRS), created by the U.S Fire Administration, is a modular all-incident reporting system used to collect basic information on all incidents in which fire units respond. The New York Incident Reporting System (NYFIRS), utilized by the Fire Department of New York City, collects information about the kind of incidents, locations, and resources used for each incident.
***
##### 
Data Source: https://data.cityofnewyork.us/Public-Safety/Incidents-Responded-to-by-Fire-Companies/tm6d-hbzd
***
### Overview:
##### 
This is an exploratory data analysis of the incidents responded to by the FDNY for the year 2021. A goal for this analysis is to not only understand the specific incidents they handled in 2021 but to get a better understanding of how extensive their responsibilities are beyond just fighting fires. I will utilize PostgreSQL to answer the following questions:
###### 
- How many incidents do they respond to? Per month? Per borough?
- What kind of incidents do they respond to?
- Which kind of incident do they respond to most frequently?
- What kind of locations do these incidents take place?
- For fire incidents specifically, which zip code has the most reported incidents and which property type/structure has had the most fire related incidents?
***
### Data:
##### 
Data: Incident Key, Incident Code and Types, Date, Property Code and Types, Location, Zip Code, and Borough

Data cleaning: Deleting unused columns, formatting dates and strings, removing duplicate values and filling in missing values

***Due to the global pandemic, the number of EMS incidents are expected to be higher overall and in areas with a larger population. This analysis focuses on 2021 only and is not representative of the average occurances over the years. Zip codes and property types were not submitted into the system on occasion which may affect the actual count but not the overall pattern.***
***
### Analysis:
##### 
Tools:
- MS Excel
- PostgreSQL
- Tableau

SQL Skills: 
- Table Creation
- Aggregate Functions
- Joins
- CTEs
- Window Functions
- CASE Statements
- Transposition
- Subqueries
***
### Findings:
#####
The boroughs with the most number of incidents are Brooklyn and Manhattan. 

The month with the highest number of incidents is August, with another peak in December.

The catgegory with the most number of incidents is EMS/Search&Rescue/Extrication. The incident type with the most recorded incidents is 'Rescue, EMS incident, other'.

For category 'Fire' specifically, the top 5 zip codes with the most incidents are locatied in Staten Island, Bronx, and Brooklyn. The top 5 property types are multi-family dwellings, 1or 2 family dwellings, street, residential street/road, commercial street/road.
***
### Tableau Visualization:
#####
https://public.tableau.com/app/profile/kathryn.schaller/viz/FDNYIncidentsin2021/FDNY
