--Recyclable and Low Fat Products

select product_id
from products
where 
    low_fats = 'Y'
    and recyclable = 'Y';

--Find Customer Referee

select name
from Customer
where referee_id != 2 
    OR referee_id IS NULL;

--Big Countries

select name, population, area
from World
where area >= 3000000
    OR population >= 25000000;

-- Article Views I

select author_id as id
from Views
where author_id = viewer_id
GROUP BY author_id
ORDER BY author_id ASC; 

-- Invalid Tweets

select tweet_id
from Tweets
where LENGTH(content) > 15;

--Replace Employee ID With The Unique Identifier

select u.unique_id, e.name
from Employees as e
Left join EmployeeUNI as u
on e.id = u.id;


--Product Sales Analysis I

select p.product_name, s.year, s.price
from Sales as s
left join Product as p
on s.product_id = p.product_id;


--1581. Customer Who Visited but Did Not Make Any Transactions

select v.customer_id,
COUNT(*) as count_no_trans
from Visits as v
Left join Transactions as t
ON v.visit_id = t.visit_id
WHERE t.transaction_id IS NULL 
GROUP BY v.customer_id;


--197. Rising Temperature

WITH temperature_previous AS (
    select id, temperature, LAG(temperature, 1) OVER(ORDER BY recordDate) as temperature_previous
    from Weather
)
select id
from temperature_previous
where temperature > temperature_previous;


--1661. Average Time of Process per Machine

SELECT 
    machine_id
    , ROUND(AVG(
        CASE 
        WHEN activity_type = 'end' 
        THEN timestamp - (
            SELECT timestamp
            FROM Activity as a2
            WHERE a1.machine_id = a2.machine_id
            AND a1.process_id = a2.process_id
            AND a2.activity_type = 'start'
        )
        END
    ), 3)
    AS processing_time
from Activity as a1
where a1.activity_type = 'end'
group by machine_id;


--Employee Bonus


select 
    e.name
    , b.bonus
from  Employee as e
Left join Bonus as b
on e.empId = b.empId
where b.bonus < 1000
    OR b.bonus is null;


--1280. Students and Examinations

select 
    st.student_id
    , st.student_name
    , s.subject_name
    , COUNT(e.subject_name) as attended_exams
from Students as st
cross join Subjects as s
left join Examinations as e
on st.student_id = e.student_id
    and e.subject_name = s.subject_name
group by e.subject_name, st.student_name
order by st.student_id, s.subject_name, attended_exams DESC;


--570. Managers with at Least 5 Direct Reports
with count_m as (
    select name
    , COUNT(*) OVER(partition managerId) as count_manager
from Employee as e
)
select name 
from count_m
where count_manager >= 5;

--OR

select name 
from Employee as e
where id in (
    select managerId
    from Employee as e2
    where managerId is not null
    group by managerId
    having count(*) >= 5
)


--1934. Confirmation Rate

SELECT
  s.user_id,
  ROUND(
    IF(
      COUNT(c.action) = 0, 
      0,
      SUM(CASE WHEN c.action = 'confirmed' THEN 1 ELSE 0 END) / COUNT(c.action)
    ),
    2
  ) AS confirmation_rate
FROM Signups s
LEFT JOIN Confirmations c
  ON s.user_id = c.user_id
GROUP BY s.user_id
ORDER BY confirmation_rate;



--Not Boring Movies
select *
from Cinema
where id%2 != 0
    AND description NOT LIKE 'boring'
order by rating DESC;



-- Average Selling Price

with g as (
    select p.product_id, p.price, u.units
    from Prices as p
    left join UnitsSold as u
    on p.product_id = u.product_id
      and u.purchase_date between p.start_date and p.end_date
)
select product_id,
    ROUND(
        IFNULL(SUM(price * units) / SUM(units), 0),
        2)
         as average_price
from g
group by product_id; 


--Project Employees I
select 
    p.project_id
    , ROUND(AVG(e.experience_years), 2) as average_years
from Project as p
left join Employee as e
on p.employee_id = e.employee_id
group by p.project_id;


