with races as (

    select 

    raceId
    ,name as race_name
    ,TRIM(REGEXP_REPLACE(COALESCE(date, ''), r'\\N$', '')) as clean_date
    ,TRIM(REGEXP_REPLACE(COALESCE(time, ''), r'\\N$', '')) as clean_time
    ,circuitId

    from calcium-pod-483117-r5.f1_data.races 

    group by 

    raceId
    ,name
    ,TRIM(REGEXP_REPLACE(COALESCE(date, ''), r'\\N$', '')) 
    ,TRIM(REGEXP_REPLACE(COALESCE(time, ''), r'\\N$', ''))
    ,circuitId


),

circuits as (

  select 
    circuitId
    ,circuitRef 
    ,name as circuit_name 
    ,location as circuit_location
    ,country as circuit_country
    ,lat as circuit_lat
    ,lng as circuit_lon
    ,alt as circuit_alt

    from calcium-pod-483117-r5.f1_data.circuits

    group by 

    circuitId
    ,circuitRef 
    ,name 
    ,location 
    ,country 
    ,lat 
    ,lng 
    ,alt 

), 

drivers as (

    select
    driverId 
    ,driverRef
    ,number as driver_number
    ,code as driver_code
    ,forename as driver_first_name 
    ,surname as driver_last_name
    ,nationality as driver_nationality

    from calcium-pod-483117-r5.f1_data.drivers 

    group by 

    driverId 
    ,driverRef
    ,number
    ,code 
    ,forename  
    ,surname 
    ,nationality 



), 

constructors as (

    select 

    constructorId
    ,constructorRef 
    ,name as constructor_name
    ,nationality as constructor_nationality

    from calcium-pod-483117-r5.f1_data.constructors

    group by 

    constructorId
    ,constructorRef 
    ,name 
    ,nationality 

), 


results as ( 

    select 

    resultId
    ,raceId
    ,driverId
    ,constructorId 
    ,number as driver_car_number
    ,grid as start_position
    ,COALESCE( SAFE_CAST( REGEXP_REPLACE(COALESCE(position, ''), r'\\n|\n', '0')  AS INT64 ), 0) as end_position
    ,positionText as final_position_text 
    ,positionOrder
    ,points
    ,laps 
    ,time as time_in_text
    ,COALESCE( SAFE_CAST( REGEXP_REPLACE(COALESCE(milliseconds, ''), r'\\n|\n', '0')  AS INT64 ), 0) as milliseconds
    ,COALESCE( SAFE_CAST( REGEXP_REPLACE(COALESCE(fastestLap, ''), r'\\n|\n', '0')  AS INT64 ), 0) as fastest_lap_number 
    ,COALESCE( SAFE_CAST( REGEXP_REPLACE(COALESCE(rank, ''), r'\\n|\n', '0')  AS INT64 ), 0) as fastest_lap_rank
    ,fastestLapTime
    ,COALESCE( SAFE_CAST( REGEXP_REPLACE(COALESCE(fastestLapSpeed, ''), r'\\n|\n', '0')  AS FLOAT64 ), 0) as fastestLapSpeed

    ,a.statusId 
    ,b.status 
    ,"Grand Prix" as race_type

    from calcium-pod-483117-r5.f1_data.results a 

    left join calcium-pod-483117-r5.f1_data.status b 
    on a.statusId = b.statusId 


    group by 
    

    resultId
    ,raceId
    ,driverId
    ,constructorId 
    ,number 
    ,grid 
    ,COALESCE( SAFE_CAST( REGEXP_REPLACE(COALESCE(position, ''), r'\\n|\n', '0')  AS INT64 ), 0)
    ,positionText 
    ,positionOrder
    ,points
    ,laps 
    ,time 
    ,COALESCE( SAFE_CAST( REGEXP_REPLACE(COALESCE(milliseconds, ''), r'\\n|\n', '0')  AS INT64 ), 0) 
    ,COALESCE( SAFE_CAST( REGEXP_REPLACE(COALESCE(fastestLap, ''), r'\\n|\n', '0')  AS INT64 ), 0) 
    ,COALESCE( SAFE_CAST( REGEXP_REPLACE(COALESCE(rank, ''), r'\\n|\n', '0')  AS INT64 ), 0) 
    ,fastestLapTime
    ,COALESCE( SAFE_CAST( REGEXP_REPLACE(COALESCE(fastestLapSpeed, ''), r'\\n|\n', '0')  AS FLOAT64 ), 0) 
    ,a.statusId 
    ,b.status 


), 



sprints as ( 

    select 

    resultId
    ,raceId
    ,driverId
    ,constructorId 
    ,number as driver_car_number
    ,grid as start_position
    ,COALESCE( SAFE_CAST( REGEXP_REPLACE(COALESCE(position, ''), r'\\n|\n', '0')  AS INT64 ), 0) as end_position
    ,positionText as final_position_text 
    ,positionOrder
    ,points
    ,laps 
    ,time as time_in_text
    ,COALESCE( SAFE_CAST( REGEXP_REPLACE(COALESCE(milliseconds, ''), r'\\n|\n', '0')  AS INT64 ), 0) as milliseconds
    ,COALESCE( SAFE_CAST( REGEXP_REPLACE(COALESCE(fastestLap, ''), r'\\n|\n', '0')  AS INT64 ), 0) as fastest_lap_number 
    ,fastestLapTime

    ,a.statusId 
    ,b.status 
    ,"Sprint" as race_type

    from calcium-pod-483117-r5.f1_data.sprint_results a 

    left join calcium-pod-483117-r5.f1_data.status b 
    on a.statusId = b.statusId 


    group by 
    

    resultId
    ,raceId
    ,driverId
    ,constructorId 
    ,number 
    ,grid 
    ,COALESCE( SAFE_CAST( REGEXP_REPLACE(COALESCE(position, ''), r'\\n|\n', '0')  AS INT64 ), 0)
    ,positionText 
    ,positionOrder
    ,points
    ,laps 
    ,time 
    ,COALESCE( SAFE_CAST( REGEXP_REPLACE(COALESCE(milliseconds, ''), r'\\n|\n', '0')  AS INT64 ), 0) 
    ,COALESCE( SAFE_CAST( REGEXP_REPLACE(COALESCE(fastestLap, ''), r'\\n|\n', '0')  AS INT64 ), 0) 
    ,fastestLapTime
    ,a.statusId 
    ,b.status 


), 

result_table as (
    
select 


    a.resultId
    ,a.raceId
    ,a.driverId
    ,a.constructorId 
    ,a.statusId
    ,a.driver_car_number
    ,a.start_position
    ,a.end_position
    ,a.final_position_text 
    ,a.positionOrder
    ,a.points
    ,a.laps 
    ,a.time_in_text
    ,a.milliseconds
    ,a.fastest_lap_number 
    ,a.fastest_lap_rank
    ,a.fastestLapTime
    ,a.fastestLapSpeed
    ,a.status 

    ,b.constructorId
    ,b.constructorRef 
    ,b.constructor_name
    ,b.constructor_nationality

    ,c.driverId 
    ,c.driverRef
    ,c.driver_number
    ,c.driver_code
    ,c.driver_first_name 
    ,c.driver_last_name
    ,c.driver_nationality

    ,SAFE.PARSE_DATETIME('%Y-%m-%d %H:%M:%S', CONCAT(d.clean_date, ' ', d.clean_time)) as race_date_time
    ,d.race_name


    ,e.circuitRef 
    ,e.circuit_name 
    ,e.circuit_location
    ,e.circuit_country
    ,e.circuit_lat
    ,e.circuit_lon
    ,e.circuit_alt


from results a 

left JOIN constructors b 
on a.constructorId = b.constructorId

LEFT JOIN drivers c 
on a.driverId = c.driverId


LEFT JOIN races d 
on a.raceId = d.raceId

LEFT JOIN circuits e 
on d.circuitId = e.circuitId

where d.clean_date >= '2010-01-01'

group by 


   a.resultId
    ,a.raceId
    ,a.driverId
    ,a.constructorId 
    ,a.statusId
    ,a.driver_car_number
    ,a.start_position
    ,a.end_position
    ,a.final_position_text 
    ,a.positionOrder
    ,a.points
    ,a.laps 
    ,a.time_in_text
    ,a.milliseconds
    ,a.fastest_lap_number 
    ,a.fastest_lap_rank
    ,a.fastestLapTime
    ,a.fastestLapSpeed
    ,a.status 

    ,b.constructorId
    ,b.constructorRef 
    ,b.constructor_name
    ,b.constructor_nationality

    ,c.driverId 
    ,c.driverRef
    ,c.driver_number
    ,c.driver_code
    ,c.driver_first_name 
    ,c.driver_last_name
    ,c.driver_nationality

    ,SAFE.PARSE_DATETIME('%Y-%m-%d %H:%M:%S', CONCAT(d.clean_date, ' ', d.clean_time)) 
    ,d.race_name


    ,e.circuitRef 
    ,e.circuit_name 
    ,e.circuit_location
    ,e.circuit_country
    ,e.circuit_lat
    ,e.circuit_lon
    ,e.circuit_alt
), 

sprint_table as (
select 


    a.resultId
    ,a.raceId
    ,a.driverId
    ,a.constructorId 
    ,a.statusId
    ,a.driver_car_number
    ,a.start_position
    ,a.end_position
    ,a.final_position_text 
    ,a.positionOrder
    ,a.points
    ,a.laps 
    ,a.time_in_text
    ,a.milliseconds
    ,a.fastest_lap_number 
    ,0 as fastest_lap_rank
    ,a.fastestLapTime
    ,0 as fastestLapSpeed
    ,a.status 

    ,b.constructorId
    ,b.constructorRef 
    ,b.constructor_name
    ,b.constructor_nationality

    ,c.driverId 
    ,c.driverRef
    ,c.driver_number
    ,c.driver_code
    ,c.driver_first_name 
    ,c.driver_last_name
    ,c.driver_nationality

    ,SAFE.PARSE_DATETIME('%Y-%m-%d %H:%M:%S', CONCAT(d.clean_date, ' ', d.clean_time)) as race_date_time
    ,d.race_name


    ,e.circuitRef 
    ,e.circuit_name 
    ,e.circuit_location
    ,e.circuit_country
    ,e.circuit_lat
    ,e.circuit_lon
    ,e.circuit_alt


from sprints a 

left JOIN constructors b 
on a.constructorId = b.constructorId

LEFT JOIN drivers c 
on a.driverId = c.driverId


LEFT JOIN races d 
on a.raceId = d.raceId

LEFT JOIN circuits e 
on d.circuitId = e.circuitId

where d.clean_date >= '2010-01-01'

group by 


   a.resultId
    ,a.raceId
    ,a.driverId
    ,a.constructorId 
    ,a.statusId
    ,a.driver_car_number
    ,a.start_position
    ,a.end_position
    ,a.final_position_text 
    ,a.positionOrder
    ,a.points
    ,a.laps 
    ,a.time_in_text
    ,a.milliseconds
    ,a.fastest_lap_number 
    ,a.fastestLapTime
    ,a.status 

    ,b.constructorId
    ,b.constructorRef 
    ,b.constructor_name
    ,b.constructor_nationality

    ,c.driverId 
    ,c.driverRef
    ,c.driver_number
    ,c.driver_code
    ,c.driver_first_name 
    ,c.driver_last_name
    ,c.driver_nationality

    ,SAFE.PARSE_DATETIME('%Y-%m-%d %H:%M:%S', CONCAT(d.clean_date, ' ', d.clean_time)) 
    ,d.race_name


    ,e.circuitRef 
    ,e.circuit_name 
    ,e.circuit_location
    ,e.circuit_country
    ,e.circuit_lat
    ,e.circuit_lon
    ,e.circuit_alt
)


select 


    resultId
    ,raceId
    ,driverId
    ,constructorId 
    ,statusId
    ,driver_car_number
    ,start_position
    ,end_position
    ,final_position_text 
    ,positionOrder
    ,points
    ,laps 
    ,time_in_text
    ,milliseconds
    ,fastest_lap_number 
    ,fastest_lap_rank
    ,fastestLapTime
    ,fastestLapSpeed
    ,status 
    ,constructorId
    ,constructorRef 
    ,constructor_name
    ,constructor_nationality
    ,driverId 
    ,driverRef
    ,driver_number
    ,driver_code
    ,driver_first_name 
    ,driver_last_name
    ,driver_nationality
    ,race_date_time
    ,race_name
    ,circuitRef 
    ,circuit_name 
    ,circuit_location
    ,circuit_country
    ,circuit_lat
    ,circuit_lon
    ,circuit_alt

    from result_table

    UNION 


    resultId
    ,raceId
    ,driverId
    ,constructorId 
    ,statusId
    ,driver_car_number
    ,start_position
    ,end_position
    ,final_position_text 
    ,positionOrder
    ,points
    ,laps 
    ,time_in_text
    ,milliseconds
    ,fastest_lap_number 
    ,fastest_lap_rank
    ,fastestLapTime
    ,fastestLapSpeed
    ,status 
    ,constructorId
    ,constructorRef 
    ,constructor_name
    ,constructor_nationality
    ,driverId 
    ,driverRef
    ,driver_number
    ,driver_code
    ,driver_first_name 
    ,driver_last_name
    ,driver_nationality
    ,race_date_time
    ,race_name
    ,circuitRef 
    ,circuit_name 
    ,circuit_location
    ,circuit_country
    ,circuit_lat
    ,circuit_lon
    ,circuit_alt

    from sprint_table






