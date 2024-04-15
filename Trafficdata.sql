  SELECT *
  FROM [PORTFOLIOPROJECT1].[dbo].[TrafficData]


  alter table TrafficData
  alter column [Date] date

  alter table TrafficData
  alter column [Time] time

  ALTER TABLE trafficdata
  ALTER COLUMN Time [time](6) 
  
  ALTER TABLE TrafficData 
  ADD total_automobiles int;

  UPDATE TrafficData
  SET total_automobiles = CarCount + BikeCount + BusCount + TruckCount;

  ALTER TABLE TrafficData 
  ADD time_frame varchar (50);

  ALTER TABLE TrafficData 
  DROP column time_frame 

  SELECT FORMAT(Time, 'HH:mm:ss') AS CleanTime
  FROM trafficdata;

	SELECT
	CarCount,
	BikeCount,
	BusCount,
	TruckCount,
	(CarCount + BikeCount + BusCount + TruckCount) AS total_automobiles
	FROM TrafficData;

	SELECT [Time],
	CASE 
    WHEN DATEPART(hour, [Time]) >= 5 AND DATEPART(hour, [Time]) < 12 THEN 'Morning'
    WHEN DATEPART(hour, [Time]) = 12 THEN 'Midday'
    WHEN DATEPART(hour, [Time]) >= 12 AND DATEPART(hour, [Time]) < 17 THEN 'Afternoon'
    WHEN DATEPART(hour, [Time]) >= 17 AND DATEPART(hour, [Time]) < 22 THEN 'Evening'
    WHEN DATEPART(hour, [Time]) >= 22 OR DATEPART(hour, [Time]) < 5 THEN 'Night'
	END AS TimeGroup
	FROM TrafficData;

--this aim of this analysis is understand the traffic situation across each day of the week, the usage distribution across vehicles types, and secific timeframe of high congestion
--how many autos are there in total for each type
	select sum(CarCount) total_cars,
	sum(BikeCount) total_bikes,
	sum(BusCount) total_buses,
	sum(TruckCount) total_trucks
	from TrafficData
	
--how many automobiles across each day of the week
	select [Day of the week], sum(total_automobiles) total_autos_per_day
	from TrafficData
	group by [Day of the week]
	order by total_autos_per_day desc;

--automobile type per each day
	select [Day of the week], 
	sum(CarCount) total_cars_per_day
	from TrafficData
	group by [Day of the week]
	order by total_cars_per_day desc;

	select [Day of the week], 
	sum(BikeCount) total_bikes_per_day
	from TrafficData
	group by [Day of the week]
	order by total_bikes_per_day desc;

	select [Day of the week], 
	sum(TruckCount) total_trucks_per_day
	from TrafficData
	group by [Day of the week]
	order by total_trucks_per_day desc;

	select [Day of the week], 
	sum(BusCount) total_buses_per_day
	from TrafficData
	group by [Day of the week]
	order by total_buses_per_day desc;

--traffic situation across each day of the week
	select [Day of the week], 
	[Traffic Situation], 
	count([Traffic Situation]) traffic_congestion
	from TrafficData
	group by [Day of the week], [Traffic Situation]
	order by [Traffic Situation], traffic_congestion desc;

--around what time frame does the traffic get congested the most
	with TimeGroup as
	(SELECT [Time],
	CASE 
    WHEN DATEPART(hour, [Time]) >= 5 AND DATEPART(hour, [Time]) < 12 THEN 'Morning'
    WHEN DATEPART(hour, [Time]) = 12 THEN 'Midday'
    WHEN DATEPART(hour, [Time]) >= 12 AND DATEPART(hour, [Time]) < 17 THEN 'Afternoon'
    WHEN DATEPART(hour, [Time]) >= 17 AND DATEPART(hour, [Time]) < 22 THEN 'Evening'
    WHEN DATEPART(hour, [Time]) >= 22 OR DATEPART(hour, [Time]) < 5 THEN 'Night'
	END AS Timeframe,
	total_automobiles
	FROM TrafficData
	group by [Time], 
	total_automobiles)

	select Timeframe,
	sum(total_automobiles) total_autos
	from TimeGroup
	group by Timeframe;


	with TimeGroup as
	(SELECT [Time],
	CASE 
    WHEN DATEPART(hour, [Time]) >= 5 AND DATEPART(hour, [Time]) < 12 THEN 'Morning'
    WHEN DATEPART(hour, [Time]) = 12 THEN 'Midday'
    WHEN DATEPART(hour, [Time]) >= 12 AND DATEPART(hour, [Time]) < 17 THEN 'Afternoon'
    WHEN DATEPART(hour, [Time]) >= 17 AND DATEPART(hour, [Time]) < 22 THEN 'Evening'
    WHEN DATEPART(hour, [Time]) >= 22 OR DATEPART(hour, [Time]) < 5 THEN 'Night'
	END AS Timeframe,
	total_automobiles, 
	[Day of the week]
	FROM TrafficData
	group by [Time], 
	total_automobiles,
	[Day of the week]
	)

	select Timeframe, [Day of the week],
	sum(total_automobiles) total_autos
	from TimeGroup
	group by Timeframe, [Day of the week]
	order by Timeframe, [Day of the week];