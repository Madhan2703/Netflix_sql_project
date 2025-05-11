# NETFLIX MOVIES AND TV SHOWS DATA ANALYSIS

![Netflix Logo](https://github.com/Madhan2703/Netflix_sql_project/blob/main/logo.png)

**Overview**
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

**Objectives**
Analyze the distribution of content types (movies vs TV shows).
Identify the most common ratings for movies and TV shows.
List and analyze content based on release years, countries, and durations.
Explore and categorize content based on specific criteria and keywords.
Dataset
The data for this project is sourced from the Kaggle dataset:

**Schema**

```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```

**Business Problems and Solutions**

**1. Count the Number of Movies vs TV Shows**
```sql
SELECT 
    type,
    COUNT(*)
FROM netflix
GROUP BY 1;
```

Objective: Determine the distribution of content types on Netflix.

**2. Find the Most Common Rating for Movies and TV Shows**
'''sql
select type,rating from
(select type,
       rating,
	   count(*),
	   rank() over(partition by type order by count(*) desc) as ranking
from netflix
group by 1,2) as sq
where ranking =1
'''

Objective: Identify the most frequently occurring rating for each type of content.

**3. List All Movies Released in a Specific Year (e.g., 2020)**
```sql
SELECT * 
FROM netflix
WHERE release_year = 2020;
```
Objective: Retrieve all movies released in a specific year.

**4. Find the Top 5 Countries with the Most Content on Netflix**

Objective: Identify the top 5 countries with the highest number of content items.
```sql
select unnest(string_to_array(country,',')),
       count(*)
from netflix
group by 1
order by 2 desc
limit 5
```
**5. Identify the Longest Movie**
```sql
select * from netflix
where 
    type = 'Movie'
	And
	duration = (select max(duration) from netflix)
```
Objective: Find the movie with the longest duration.

**6. Find Content Added in the Last 5 Years**
```sql
SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
Objective: Retrieve content added to Netflix in the last 5 years.
```

**7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'**
```sql
select * from netflix
where director ilike '%Rajiv Chilaka%'
```

**8. List All TV Shows with More Than 5 Seasons**
```sql
select *
from netflix 
        where
		type = 'TV Show' and
		split_part(duration, ' ',1)::numeric > 5
```

**9. Count the Number of Content Items in Each Genre**
```select unnest(string_to_array(listed_in,',')) as genre,
       count(*) as total_count
from netflix
group by 1
```
Objective: Count the number of content items in each genre.

**10.Find each year and the average numbers of content release in India on netflix.
return top 5 year with highest avg content release!**

```sql
select
      extract(Year from to_date(date_added,'Month DD,YYYY')) as year,
      count(*) as yearly_content,
	  Round(
      count(*)::numeric /(select count(*) from netflix where country ='India')::numeric * 100
	  ,2) as avg_content_eacg_year
from netflix
where country = 'India'
group by 1
```
Objective: Calculate and rank years by the average number of content releases by India.

**Findings and Conclusion**
Content Distribution: The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
Common Ratings: Insights into the most common ratings provide an understanding of the content's target audience.
Geographical Insights: The top countries and the average content releases by India highlight regional content distribution.
Content Categorization: Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.
This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.



