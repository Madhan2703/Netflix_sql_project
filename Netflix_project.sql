--Create table.
DROP TABLE IF EXISTS netflix;
create table netflix(show_id varchar(7),
                      type varchar(10),
					  title varchar(150),
					  director varchar(210),
					  casts varchar(1000),
					  country varchar(150),
					  date_added varchar(50),
					  release_year int,
					  rating varchar(10),
					  duration varchar(15),	
					  listed_in varchar(100),
					  description varchar(250)
                    );

select * from netflix
limit 50

select
    count(*) as total_content
from netflix

-- Solving 10 Business Problems.

--1. Count the number of Movies vs TV Shows

select type,
       count(*) as total_content
from netflix
group by 1

-- 2. Find the most common rating for movies and TV shows

select type,rating from
(select type,
       rating,
	   count(*),
	   rank() over(partition by type order by count(*) desc) as ranking
from netflix
group by 1,2) as sq
where ranking =1

-- 3. List all movies released in a specific year (e.g., 2020)

select *
from netflix
where type = 'Movie' and
release_year = 2020

-- 4. Find the top 5 countries with the most content on Netflix

select unnest(string_to_array(country,',')),
       count(*)
from netflix
group by 1
order by 2 desc
limit 5

-- 5. Identify the longest movie

select * from netflix
where 
    type = 'Movie'
	And
	duration = (select max(duration) from netflix)

-- 6. Find content added in the last 5 years

select *
from netflix
where 
    to_date(date_added, 'Month DD,YYYY') >= current_date - Interval '5 years'

--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

select * from netflix
where director ilike '%Rajiv Chilaka%'

-- 8.List all TV shows with more than 5 seasons

select *
from netflix 
        where
		type = 'TV Show' and
		split_part(duration, ' ',1)::numeric > 5

-- 9. Count the number of content items in each genre

select unnest(string_to_array(listed_in,',')) as genre,
       count(*) as total_count
from netflix
group by 1

-- 10.Find each year and the average numbers of content release in India on netflix. 
--return top 5 year with highest avg content release!

select
      extract(Year from to_date(date_added,'Month DD,YYYY')) as year,
      count(*) as yearly_content,
	  Round(
      count(*)::numeric /(select count(*) from netflix where country ='India')::numeric * 100
	  ,2) as avg_content_eacg_year
from netflix
where country = 'India'
group by 1






























