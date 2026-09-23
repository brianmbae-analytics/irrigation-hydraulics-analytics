create database irrigation_hydraulic_perf_db;
select * from 02_irrigation_hydraulic_performance;

-- CHANGE TABLE NAME
alter table `02_irrigation_hydraulic_performance` rename to `irrigation_hydraulic_performance`;

select * from irrigation_hydraulic_performance;

-- AVERAGE FLOW
select
   round(avg(flow_lps),2) as average_flow
from irrigation_hydraulic_performance;
   
-- MAXIMUM AND MINIMUM FLOW
select
   round(max(flow_lps),2) as maximum_flow,
   round(min(flow_lps),2) as minimum_flow
from irrigation_hydraulic_performance;

-- WHAT IS THE AVERAGE FLOW FOR EACH OF THE SCHEMES
select
   scheme,
   round(avg(flow_lps),2) as average_flow_per_scheme
from irrigation_hydraulic_performance
group by 1
order by 2 desc;

-- AVERAGE EXPECTED PRESSURE VS AVERAGE MEASURED_PRESSURE
select
   round(avg(expected_pressure_m),2) as average_expected_pressure,
   round(avg(measured_pressure_m),2) as average_measured_pressure
from irrigation_hydraulic_performance;

-- MAXIMUM AND MINIMUM MEASURED PRESSURE
select
   round(max(measured_pressure_m),2) as maximum_measured_pressure,
   round(min(measured_pressure_m),2) as minimum_measured_pressure
from irrigation_hydraulic_performance;

-- WHATS THE AVERAGE EXPECTED PRESSURE AND AVERAGE MEASURED PRESSURE PER SCHEME
select
   scheme,
   round(avg(measured_pressure_m),2) as average_measured_pressure_per_scheme,
   round(avg(expected_pressure_m),2) as average_expected_pressure_per_scheme,
   round(avg(pressure_difference_m),2) as average_pressure_difference_per_scheme
from irrigation_hydraulic_performance
group by 1
order by 3 desc;

-- Negative → measured pressure generally falls below expected pressure for all the four schemes.

-- AVERAGE HEADLOSS
select
   round(avg(estimated_head_loss_m),2) as average_headloss
from irrigation_hydraulic_performance;

-- AVERAGE HEADLOSS PER SCHEME
select
   scheme,
   round(avg(estimated_head_loss_m),2) as average_headloss_per_scheme
from irrigation_hydraulic_performance
group by 1
order by 2 desc;

-- TOTAL PIPE LENGTH USED
select
  round(sum(pipe_length_m),2) as total_pipe_length_used
from irrigation_hydraulic_performance;

-- WHICH SCHEME HAS THE LONGEST PIPE LENGTH
select
  scheme,
  round(sum(pipe_length_m),2) as total_pipe_length_used
from irrigation_hydraulic_performance
group by 1
order by 2 desc;

-- WHICH PIPE MATERIAL WAS USED THE MOST
select 
   distinct pipe_material,
   count(*) as number_of_records
from irrigation_hydraulic_performance
group by 1
order by 2 desc;

-- WHICH PIPE MATERIAL WAS USED THE MOST BY EACH OF THE SCHEMES
select 
   scheme,
   pipe_material,
   count(*) as number_of_records
from irrigation_hydraulic_performance
group by 1,2
order by 3 desc;

-- PIPE DIAMETERS USED BY EACH SCHEME
select
    scheme,
    pipe_diameter_mm,
    count(*) as number_of_pipes
from irrigation_hydraulic_performance
group by 1,2
order by 2 desc;    
   
-- HOW MANY SCHEMES ARE IN THE DATASET
select distinct scheme from irrigation_hydraulic_performance;

-- HOW MANY BLOCKS DO THE SCHEMES SERVE
select distinct block from irrigation_hydraulic_performance;

select * from irrigation_hydraulic_performance;

-- TOTAL NUMBER OF OFFTAKES
select
   sum(number_of_offtakes) as total_offtakes
from irrigation_hydraulic_performance;
   
-- NUMBER OF OFFTAKES PER SCHEME
select
   scheme,
   sum(number_of_offtakes) as offtakes_per_scheme
from irrigation_hydraulic_performance
group by 1
order by 2 desc;
   
-- NUMBER OF OFFTAKES PER BLOCK
select
   block,
   sum(number_of_offtakes) as offtakes_per_block
from irrigation_hydraulic_performance
group by 1
order by 2 desc;

-- HOW MANY MEMBERS DOES EACH SCHEME SERVE IN ALL THE BLOCKS
select * from(
select
   scheme,
   block,
   sum(number_of_offtakes) as members,
   case 
       when block = 'A' then round((sum(number_of_offtakes) / '5434') * 100, 2)
       when block = 'B' then round(( sum(number_of_offtakes) / '5268') * 100, 2)
       when block = 'C' then round((sum(number_of_offtakes) / '4998') * 100, 2)
       when block = 'D' then round(( sum(number_of_offtakes) / '5095') * 100, 2)
       when block = 'E' then round(( sum(number_of_offtakes) / '5043') * 100, 2)
       when block = 'F' then round(( sum(number_of_offtakes) / '5438') * 100, 2)
       when block = 'G' then round(( sum(number_of_offtakes) / '5490') * 100, 2)
       when block = 'H' then round((sum(number_of_offtakes) / '5118') * 100, 2) end as member_percentage_served_by_each_scheme_per_block,
    rank() over(partition by block order by sum(number_of_offtakes) desc) as rnk   
from irrigation_hydraulic_performance
group by 1,2)t;

-- AVERAGE IRRIGATION DURATION PER SCHEME
select
   scheme,
   round(avg(irrigation_duration_hr), 2) as scheme_avg_irrigation_duration_hr
from irrigation_hydraulic_performance
group by 1
order by 2 desc;

-- AVERAGE IRRIGATION DURATION PER BLOCK
select
  block,
  round(avg(irrigation_duration_hr), 2) as avg_irrigation_duration_per_block_hr
from irrigation_hydraulic_performance
group by 1
order by 2 desc;
  
-- WHAT IS THE AVERAGE FLOW PER BLOCK
select
   block,
   round(avg(flow_lps), 2) as avg_flow_per_block_lps
from irrigation_hydraulic_performance
group by 1
order by 2 desc;
   
-- AVERAGE MEASURED PRESSURE VS AVERAGE EXPECTED PRESSURE PER BLOCK
select
   block,
   round(avg(measured_pressure_m), 2) as avg_measured_pressure_m,
   round(avg(expected_pressure_m), 2) as avg_expected_pressure_m,
   round(avg(pressure_difference_m), 2) as avg_pressure_difference_m
from irrigation_hydraulic_performance
group by 1
order by 4 asc;
    
-- AVERAGE HEADLOSS PER BLOCK
select
  block,
  round(avg(estimated_head_loss_m),2) as avg_headloss_per_block
from irrigation_hydraulic_performance
group by 1
order by 2 desc;  

select * from irrigation_hydraulic_performance;
-- CHAINAGES MARKED WITH HIGH PRESSURE HYDRAULIC STATUS.
select
   scheme,
   block,
   chainage_m,
   pipe_diameter_mm,
   measured_pressure_m,
   expected_pressure_m,
   pressure_difference_m,
   hydraulic_status
from irrigation_hydraulic_performance
where hydraulic_status = 'High Pressure'
group by 1,2,3,4,5,6,7
order by 7 desc
limit 10;
   
-- UNDERSIZED PIPE CARRYING DISPROPORTIONATE LOAD
select
   scheme,
   block,
   chainage_m,
   pipe_diameter_mm,
   pipe_length_m,
   expected_pressure_m,
   measured_pressure_m,
   pressure_difference_m,
   number_of_offtakes,
   hydraulic_status
from irrigation_hydraulic_performance
where pipe_diameter_mm <= 32
group by 1,2,3,4,5,6,7,8,9,10
order by 9 desc     
limit 10;   