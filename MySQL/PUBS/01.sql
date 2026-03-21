create schema pubs;
use pubs;

# Query Stores -> Discount - > Sales:
select * from discounts;
select * from stores;
select * from sales;

select a.stor_id, a.stor_name, a.stor_address, b.lowqty
	from stores a
	inner join discounts b
	on a.stor_id = b.stor_id;

select b.ord_num, a.stor_name, b.qty ,b.ord_date
	from stores a
	inner join sales b
	on a.stor_id = b.stor_id
where b.ord_num = "P2121";

select distinct a.ord_num, a.ord_date, b.stor_name, b.city
	from sales a
	inner join stores b
	on a.stor_id = b.stor_id
	inner join roysched c
	on a.title_id = c.title_id;






