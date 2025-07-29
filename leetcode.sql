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


--1633. Percentage of Users Attended a Contest
select r.contest_id, ROUND((COUNT(r.user_id) / 3 * 100), 2) as percentage
from Users as u
left join Register as r
on u.user_id = r.user_id
group by r.contest_id
order by percentage DESC, r.contest_id ASC;


--1211. Queries Quality and Percentage
select query_name
    , ROUND((SUM(rating / position) / COUNT(query_name)), 2) as quality
    , ROUND((SUM(CASE
    WHEN rating < 3 THEN 1 ELSE 0
    END) / COUNT(query_name) * 100.0), 2)
    as poor_query_percentage
from Queries
group by query_name;


--1193. Monthly Transactions I
select 
    DATE_FORMAT(trans_date, '%Y-%m') as month
    , country
    , COUNT(*) as trans_count
    , SUM(state = 'approved') as approved_count
    , SUM(amount) as trans_total_amount
    , SUM(
        CASE WHEN state = 'approved' THEN amount ELSE 0 END
    ) as approved_total_amount
from Transactions
group by month, country;



--1174. Immediate Food Delivery II
with first_orders as (
    select *
    from Delivery as d
    where order_date = (
        select MIN(order_date)
        from Delivery
        where customer_id = d.customer_id
    )
)
select ROUND(SUM(order_date = customer_pref_delivery_date) / COUNT(*) * 100.0, 2) as immediate_percentage
from first_orders;



--Game Play Analysis IV
with first_login as (
   select player_id, MIN(event_date) as first_day
   from Activity
   group by player_id
),
next_day_login as (
    select distinct a.player_id
    from Activity as a
    join first_login as f
    on f.player_id = a.player_id
        and a.event_date = DATE_ADD(f.first_day, INTERVAL 1 DAY)
)
SELECT 
  ROUND(COUNT(n.player_id) * 1.0 / (SELECT COUNT(*) FROM first_login), 2) AS fraction
FROM next_day_login n;



--2356. Number of Unique Subjects Taught by Each Teacher
select teacher_id, COUNT(DISTINCT subject_id) as cnt
from Teacher
group by teacher_id;


--1141. User Activity for the Past 30 Days I
select 
    activity_date as day
    , COUNT(DISTINCT user_id) as active_users
from Activity
where activity_date BETWEEN DATE_SUB('2019-07-27', INTERVAL 29 DAY) AND '2019-07-27'
group by day;


--1070. Product Sales Analysis III
select 
    product_id
    , MIN(year) as first_year
    , quantity
    , price
from Sales
group by product_id;


--596. Classes With at Least 5 Students
with cte as (
   select 
    class
    , COUNT(DISTINCT student) as count_student
from Courses
group by class 
)
select class
from cte
where count_student > 5;


--1729. Find followers count
select 
    user_id
    , COUNT(DISTINCT follower_id) as followers_count
from Followers
group by user_id;


--619. Biggest Single Number
select MAX(new_num) as num
from (select num as new_num
    from MyNumbers
    group by num
    having COUNT(num) = 1
) as singles;


--1045. Customers Who Bought All Products
select 
    customer_id
from Customer
group by customer_id
having COUNT(product_key) = (
    select COUNT(DISTINCT product_key) as all_products
    from Product);


--1731. The Number of Employees Which Report to Each Employee
select 
    a.employee_id
    , a.name
    , count(b.employee_id) as reports_count
    , round(avg(b.age), 0) as average_age
from Employees as a
inner join Employees as b
on a.employee_id = b.reports_to
group by a.employee_id
having reports_count > 0;


--1789. Primary Department for Each Employee
select 
    employee_id
    , department_id
from Employee
where primary_flag = 'Y' 
    or employee_id in (
        select employee_id
        from Employee
        group by employee_id
        having count(*) = 1
    );


--610. Triangle Judgement
select *
    , case when (x + y) > z and (x + z) > y and (y + z) > x then 'Yes' else 'No'
    end as triangle
from Triangle;


--180.Consecutive numbers
with find_num as (
    select num
    , lag(num, 1) OVER(order by id) as prev_num
    , lead(num, 1) OVER(order by id) as next_num
from Logs
)
select num as ConsecutiveNums
from find_num
where num = prev_num and num = next_num;


