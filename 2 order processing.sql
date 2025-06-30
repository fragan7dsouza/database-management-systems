create database ord_proc
use ord_proc
drop database ord_proc
CREATE TABLE CUSTOMER (
custid int,
cname char(15) not null,
city varchar(30),
primary key (custid)
)
select * from CUSTOMER
select count(*) as No_Of_Emp from CUSTOMER
insert into CUSTOMER values (111,'John Smith', 'Karkala')
insert into CUSTOMER values (112,'Ramesh N', 'Nitte')
insert into CUSTOMER values (113,'Franklin', 'Karkala')
insert into CUSTOMER values (114,'Alica', 'mangalore')
insert into CUSTOMER values (115,'Raju', 'Udupi')
drop table customer
drop table c_order
drop table item
drop TABLE ORDER_ITEM
drop table shipment
drop table warehouse
CREATE TABLE C_ORDER (
orderid int,
odate datetime,
custid int,
ordamt int,
primary key (orderid) ,
foreign key(custid) references CUSTOMER(custid)on
delete cascade on update cascade
)
insert into C_ORDER values (201,'2001-08-03', 111,null)
insert into C_ORDER values (202,'2002-08-03', 111,null)
insert into C_ORDER values (203,'2001-08-04', 112,null)
insert into C_ORDER values (204,'2004-02-01', 113,null)
insert into C_ORDER values (205,'2001-04-02', 114,null)
insert into C_ORDER values (206,'2005-02-01', 115,null)
insert into C_ORDER values (207,'2008-04-01', 115,null)
insert into C_ORDER values (209,'2008-02-01', 114,null)
insert into C_ORDER values (208,'2008-12-01', 111,null)
insert into C_ORDER values (200,'2008-11-01', 111,null)
insert into C_ORDER values (210,'2008-10-01', 111,null)
delete from C_ORDER
select * from C_ORDER
select * from ITEM
CREATE TABLE ITEM (
itemid int,
price int,
primary key (itemid)
)
insert into ITEM values (301,2000)
insert into ITEM values (302,2000)
insert into ITEM values (303,1000)
insert into ITEM values (304,5000)
insert into ITEM values (305,4000)
CREATE TABLE ORDER_ITEM (
orderid int,
itemid int,
qty int,
primary key (orderid,itemid),
foreign key(orderid) references C_ORDER(orderid) on
delete cascade on update cascade,
foreign key(itemid) references ITEM(itemid) on delete
cascade on update cascade
)
insert into ORDER_ITEM values (201,301,2)
insert into ORDER_ITEM values (201,302,4)
insert into ORDER_ITEM values (201,303,4)
insert into ORDER_ITEM values (201,304,4)
insert into ORDER_ITEM values (201,305,3)
insert into ORDER_ITEM values (202,303,2)
insert into ORDER_ITEM values (202,305,4)
insert into ORDER_ITEM values (203,302,1)
insert into ORDER_ITEM values (204,305,2)
insert into ORDER_ITEM values (205,301,3)
insert into ORDER_ITEM values (206,301,5)
select * from ORDER_ITEM
CREATE TABLE WAREHOUSE (
warehouseid int,
city varchar(20)not null,
primary key (warehouseid)
)
insert into WAREHOUSE values (1,'MAGALORE')
insert into WAREHOUSE values (2,'MAGALORE')
insert into WAREHOUSE values (3,'MAGALORE')
insert into WAREHOUSE values (4,'UDUPI')
insert into WAREHOUSE values (5,'UDUPI')
insert into WAREHOUSE values (6,'KARKALA')
select count(*)
from SHIPMENT s,WAREHOUSE w
where w.warehouseid=s.warehouseid and city='MAGALORE'
select count(distinct city) from WAREHOUSE
select distinct city from WAREHOUSE
CREATE TABLE SHIPMENT (
orderid int,
warehouseid int,
ship_dt datetime,
primary key (orderid,warehouseid) ,
foreign key(orderid) references C_ORDER(orderid) on
delete cascade on update cascade,
foreign key(warehouseid) references
WAREHOUSE(warehouseid) on delete cascade on update cascade
)
SELECT * FROM CUSTOMER
SELECT * FROM SHIPMENT
insert into SHIPMENT values (201,1,'2001-04-02')
insert into SHIPMENT values (201,2,'2001-04-04')
insert into SHIPMENT values (202,1,'2001-05-02')
insert into SHIPMENT values (202,2,'2002-05-12')
insert into SHIPMENT values (202,3,'2003-06-01')
insert into SHIPMENT values (202,4,'2003-06-01')
insert into SHIPMENT values (203,1,'2004-02-01')
insert into SHIPMENT values (203,2,'2004-02-01')
insert into SHIPMENT values (203,3,'2004-02-01')
insert into SHIPMENT values (204,4,'2004-06-02')
insert into SHIPMENT values (204,2,'2004-06-02')
SELECT * FROM WAREHOUSE
SELECT * FROM SHIPMENT

/* 1 Produce a listing: CUSTNAME, #oforders, AVG_ORDER_AMT, where the
middle column is the total
numbers of orders by the customer and the last column is the average
order amount for that customer. */
select C.cname , count(O.orderid) as NO_OF_ORDR, avg(O.ordamt) as
AVG_ORD_AMT
from CUSTOMER C, C_ORDER O
where C.custid = O.custid group by C.cname

/* 2. For each item that has more than two orders , list the item, number of orders that are
shipped from atleast two warehouses and total quantity of items shipped*/

update C_ORDER set ordamt = (select sum(O.qty * T.price) from
ORDER_ITEM O, ITEM T
where O.itemid = T.itemid and O.orderid
= 201)
where orderid = 201

select itemid,count(*) as 'NO_OF_ORD',sum(qty) as 'TOTAL_QUANT' from 
ORDER_ITEM where orderid in (select orderid from
SHIPMENT group by orderid having count(*) >=2) group by
itemid having count(*) >=2

/* 3. List the customers who have ordered for every item that the company produces*/
select C.cname from CUSTOMER C where not exists(
(select itemid from ITEM)except (select distinct(OI.itemid) 
from C_ORDER O, ORDER_ITEM OI where O.orderid=
OI.orderid and O.custid=c.custid))
