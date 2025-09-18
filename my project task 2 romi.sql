WITH combined_ads AS (
SELECT ad_date, spend, value
FROM public.google_ads_basic_daily
WHERE ad_date IS NOT NULL

UNION ALL
SELECT ad_date, spend, value
FROM public.facebook_ads_basic_daily
WHERE ad_date IS NOT NULL
),
aggregated_ads AS (
select ad_date,
SUM(spend) AS total_spend,
SUM(value) AS total_value
FROM combined_ads
GROUP BY ad_date
),
romi_by_day AS (
select ad_date,
ROUND(total_value::numeric / NULLIF(total_spend, 0)::numeric * 100, 2) AS romi
FROM aggregated_ads
)
SELECT *
FROM romi_by_day
WHERE romi IS NOT NULL
ORDER BY romi DESC
LIMIT 5;