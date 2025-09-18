with facebook_combined as (
select fabd.ad_date,
fa.adset_name,
fabd.value
from facebook_ads_basic_daily as fabd
left join facebook_adset as fa
on fabd.adset_id = fa.adset_id
WHERE fa.adset_name IS NOT null),
combined_ads as (
select
ad_date, adset_name,
'Facebook ADS' as media_source
from facebook_combined
union all
select
ad_date, null as adset_name,
'Google ADS' as media_source
from google_ads_basic_daily),
numbered_date as
(select ad_date, adset_name,
ad_date - interval '1 day' * row_number() over(partition by adset_name order by ad_date) as group_date
from combined_ads
where adset_name is not null),
duration_groups as
(select adset_name,
min(ad_date) as start_date,
max(ad_date) as end_date,
count(*) as duration_date
from numbered_date
group by adset_name, group_date),
longest_running_abset as
(select *,
rank() over(order by duration_date desc) as rnk
from duration_groups)
select adset_name, start_date,end_date,duration_date
from longest_running_abset
where rnk=1;
