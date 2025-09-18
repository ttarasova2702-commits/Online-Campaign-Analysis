
select ad_date,
'Google' as platform,
round(AVG(spend),2) as avg_spend,
round(MAX(spend),2) as max_spend,
round(MIN(spend),2) as min_spend
from public.google_ads_basic_daily
group by ad_date

union all
select ad_date,
'Facebook' as platform,
round(AVG(spend),2) as avg_spend,
round(MAX(spend),2) as max_spend,
round(MIN(spend),2) as min_spend
from public.facebook_ads_basic_daily
group by ad_date
order by ad_date, platform