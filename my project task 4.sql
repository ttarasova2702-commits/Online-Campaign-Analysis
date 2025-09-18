with facebook_combined as (
select fabd.ad_date,
fc.campaign_name,
fabd.reach
from facebook_ads_basic_daily as fabd
left join facebook_campaign as fc
on fabd.campaign_id = fc.campaign_id
WHERE fabd.reach IS NOT NULL
AND fc.campaign_name IS NOT NULL),
combined_ads as (
select
ad_date, campaign_name, reach,
'Facebook ADS' as media_source
from facebook_combined
union all
select
ad_date,campaign_name,reach,
'Google ADS' as media_source
from google_ads_basic_daily
),
monthly_reach as
(select date_trunc('month',ad_date)::date as month_start,campaign_name,
sum(reach) as monthly_reach
from combined_ads
group by 1,2),
reach_wiht_diff as(
select campaign_name, month_start,monthly_reach,
lag(monthly_reach) over (partition by campaign_name order by month_start ) as prev_month_reach
from monthly_reach)
select campaign_name, month_start,monthly_reach,prev_month_reach,
abs(monthly_reach-prev_month_reach) as reach_growth
from reach_wiht_diff
WHERE monthly_reach > 0 AND prev_month_reach > 0
order by reach_growth desc
limit 1



