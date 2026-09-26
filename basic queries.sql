  --- total premium in GBP by product name

select ip.product_name
  ,round(sum(pp.payment_amount * er.rate_to_gbp),2) as total_premium

from policies p 
  left join policy_payments pp
    on pp.policy_id = p.policy_id
  left join insurance_products ip
    on ip.product_id = p.product_id
  left join exchange_rates er
    on er.currency = p.currency
      and er.rate_date = pp.payment_date

group by ip.product_name

order by total_premium desc;

----- porfolio by country

select l.country
  ,count(distinct p.policy_id) as policy_count
  ,round(sum(pp.payment_amount * er.rate_to_gbp),2) as total_premium

from policies p 
  left join policy_payments pp
    on pp.policy_id = p.policy_id
  left join exchange_rates er
    on er.currency = p.currency
      and er.rate_date = pp.payment_date
  left join locations l
    on l.location_id = p.location_id

group by l.country

order by policy_count desc;

--- claims frequency per insurance products and countries
select l.country
,ip.product_name
,round(count(distinct c.claim_id)*1.00/count(distinct p.policy_id),2) as claim_frequency

from policies p 
  left join insurance_products ip
    on ip.product_id = p.product_id
  left join claims c
    on c.policy_id = p.policy_id
  left join locations l
    on l.location_id = p.location_id

group by l.country, ip.product_name

order by l.country,claim_frequency desc;

--- loss ratio per policy
with incurred as (
  select c.policy_id ,sum(c.incurred_amount) as incurred_total
  from claims c
  group by c.policy_id
)
select p.policy_id
,coalesce(i.incurred_total,0)*1.00/p.written_premium as loss_ratio
from policies p
left join incurred i
  on i.policy_id = p.policy_id


order by loss_ratio desc

--- What are the three largest claims within each insurance product
with ranking as (select ip.product_name
,rank() over(partition by ip.product_name order by c.incurred_amount desc) as top
,c.claim_id
,c.incurred_amount

from policies p 
left join insurance_products ip
  on ip.product_id = p.product_id
left join claims c
  on c.policy_id = p.policy_id
  
where c.claim_id is not null)


select *

from ranking

where top <= 3

--- How does the amount paid for each claim develop over time?
select cp.claim_id
,cp.payment_date
,cp.payment_amount
,sum(cp.payment_amount) over(partition by cp.claim_id order by cp.payment_date asc ) as cummulative

from claim_payments cp;

--- How has written premium changed year over year for each insurer
with cte as (select insurer_name
,extract(year from p.inception_date) as year
, round(sum(p.written_premium * er.rate_to_gbp),2) as GBPpremium

from policies p
left join exchange_rates er
  on er.currency= p.currency
    and er.rate_date = p.inception_date
left join insurer_info i
  on i.insurer_id = p.insurer_id
  
group by i.insurer_name, year)

select insurer_name
,year
,GBPpremium
,lag(GBPpremium, 1) over(partition by insurer_name order by year asc) as last_year

from cte
