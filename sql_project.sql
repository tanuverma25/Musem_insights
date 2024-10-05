use painting

select * from artist
select * from canvas_size
select * from museum
select * from museum_hours
select * from product_size
select * from subject
select * from work

-- Identify the museums which are open on both sunday and monday.

SELECT
mh.museum_id, m.name, m.city
FROM museum_hours mh
JOIN museum m 
ON mh.museum_id = m.museum_id
WHERE day = 'Sunday' 
AND mh.museum_id IN (SELECT museum_id FROM museum_hours WHERE day = 'Monday'); 

-- Which are the top 5 most popular museums? (popularity is based on maximum number of paintings in a museum)

SELECT
m.museum_id, m.name, count(w.work_id) as number_of_paintings
from museum m
join
work w on m.museum_id = w.museum_id 
group by m.museum_id, m.name
order by number_of_paintings desc
limit 5

-- Who are the top 5 popular artist? (popularity is based on most number of paintings made by an artist)

SELECT
a.artist_id, a.full_name, count(w.work_id) as number_of_paintings
from artist a
join 
work w on a.artist_id = w.artist_id
group by a.artist_id, a.full_name
order by number_of_paintings desc
limit 5

-- Which museum is opened for the longest hour during a day?

SELECT
m.name, m.city, mh.day, (mh.open - mh.close) as hours_opened
from museum m 
join 
museum_hours mh
on m.museum_id = mh.museum_id
order by hours_opened desc
limit 5
 
-- Which artists have created works in multiple styles?

SELECT
a.artist_id, a.full_name, 
group_concat(distinct w.style) as styles,
count(distinct w.style) as num_styles
from
artist a
join 
work w 
on a.artist_id = w.artist_id
group by a.artist_id, a.full_name
having num_styles > 1

-- Which artists share the same birth year?

select
a1.full_name, a2.full_name, a1.birth
from 
artist a1
join 
artist a2
on a1.birth = a2.birth
where a1.artist_id<>a2.artist_id

-- What are the names of artists who have created more than 100 works?

SELECT  
a.full_name, a.artist_id, COUNT(DISTINCT work_id) AS work_count
FROM 
artist a
join
work w 
on a.artist_id = w.artist_id 
GROUP BY a.artist_id, a.full_name
having work_count > 100

-- How many museums are open every single day?

select 
m.name, count(mh.day) as day
from museum m
join
museum_hours mh
on m.museum_id=mh.museum_id
group by m.name, m.museum_id
having day =7

-- Display three least popular canva size

select 
cs.size_id, cs.label , count(w.work_id) as no_of_paintings 
from canvas_size cs
join 
product_size ps
on cs.size_id = ps.size_id 
join 
work w 
on ps.work_id = w.work_id
group by cs.size_id, cs.label
order by no_of_paintings asc
limit 3

-- Which city has more than one museum featuring works from the 18th century?

SELECT 
m.city, COUNT(DISTINCT m.museum_id) AS museum_count, 
MIN(a.full_name) AS first_artist_name, 
MIN(a.birth) AS first_artist_birth
FROM 
museum m
JOIN 
work w ON m.museum_id = w.museum_id
JOIN 
artist a ON w.artist_id = a.artist_id
WHERE a.birth BETWEEN 1701 AND 1800  -- Artists born in the 18th century
GROUP BY m.city
HAVING COUNT(DISTINCT m.museum_id) > 1;




 