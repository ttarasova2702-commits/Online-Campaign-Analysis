with facebook_combined as (
select fabd.ad_date,
fc.campaign_name,
fabd.value
from facebook_ads_basic_daily as fabd
left join facebook_campaign as fc
on fabd.campaign_id = fc.campaign_id
WHERE fabd.value IS NOT NULL
AND fc.campaign_name IS NOT NULL),
combined_ads as (
select
ad_date, campaign_name, value,
'Facebook ADS' as media_source
from facebook_combined
union all
select
ad_date,campaign_name,value,
'Google ADS' as media_source
from google_ads_basic_daily),
weekly_values as
(select date_trunc('week',ad_date)::date as week_start,campaign_name,
sum(value) as total_value
from combined_ads
group by 1,2)
select week_start, campaign_name,total_value
from weekly_values
order by total_value desc
limit 1