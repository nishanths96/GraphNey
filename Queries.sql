// Here you can find a sample of semantically equivalent queries in sql.

//Query 1
select count(distinct uid) from <table_name> = 'checkoutpage' and date(dt) = <sample_date>;


//Query 2
select count(distinct uid) from <table_name> where city = 'Seattle';


//Query 3
select count(distinct product_name) from <table_name> where uid = <sample_uid> and product_name is not NULL;


//Query 4
select count(distinct uid) from <table_name> where category = 'productpage';


//Query 5
select count(distinct uid) from <table_name> where category = 'checkoutpage';


//Query 6
select count(distinct u1) from
(
(select distinct uid as u1 from <table_name> where category = 'checkoutpage') A
inner join
(select distinct uid as u2 from <table_name> where category = 'cartpage') B
on
A.u1 = B.u2);


//Query 7 
select count(distinct u1) from
(
(select uid as u1 from <table_name> where category = 'checkoutpage') A
inner join
(select uid as u2 from <table_name> where search_keywords <> '') B
on A.u1 = B.u2);


