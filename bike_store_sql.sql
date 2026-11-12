create database bike_store;
use bike_store; 
# Brands #
create table brands
(brand_id int primary key, 
brand_name varchar (100));

# Categories #
create table categories
(category_id int primary key,
 category_name varchar (100));

# Stores #
create table stores
(store_id int primary key,
store_name varchar(100),
phone varchar(50),
email varchar(100),
street varchar (100),
city varchar(50),
state varchar(50),
zip_code varchar (10));

# Customer #
create table customer
(customer_id int primary key,
first_name varchar(50),
last_name varchar(50),
phone varchar(50),
email varchar(100),
street varchar (50),
city varchar (50),
state varchar(50),
zip_code varchar(10));

# Products #
create table products
(product_id int primary key,
product_name varchar (250),
brand_id int,
category_id int,
 model_year int, 
 list_price decimal(10,2),
 foreign key (brand_id) references brands (brand_id),
 foreign key (category_id)references categories (category_id));
 
# Staffs #
create table staffs
(staff_id int primary key,
first_name varchar (50),
last_name varchar(50),
email varchar(100),
phone varchar(50),
active int,
store_id int,
manager_id int,
foreign key (store_id)references stores (store_id));

# Stocks #
create table stocks
(store_id int, 
product_id int,
quantity int,
primary key (store_id,product_id),
foreign key (store_id)references stores (store_id),
foreign key (product_id)references products (product_id));

# Orders # 
create table orders
(order_id int primary key,
customer_id int,
order_status int,
order_date date,
required_date date,
shipped_date date,
store_id int,
staff_id int,
foreign key (customer_id) references customer(customer_id),
foreign key (store_id)references stores (store_id),
foreign key (staff_id) references staffs (staff_id)); 

# Order items #
create table order_items
(order_id int,
item_id int,
product_id int,
quantity int,
list_price decimal(10,2),
discount decimal(4,2),
total_price decimal (10,2),
product_name varchar(300),
primary key (order_id,item_id),
foreign key (order_id) references orders(order_id),
foreign key (product_id) references products(product_id));

select count(*)as total_rows
from orders;


# 3. INNER JOIN FOR ORDER DETAILS

select o.order_id,
       o.order_date,
       oi.item_id,
       p.product_name,
       oi.quantity,
       oi.list_price,
       oi.discount,
       oi.total_price
from orders o
inner join order_items oi on o.order_id = oi.order_id
inner join products p on oi.product_id = p.product_id;


# 4. TOTAL SALES BY STORE

select o.store_id,
       sum(oi.total_price) as total_sales
from orders o
inner join order_items oi on o.order_id = oi.order_id
group by o.store_id;

# 5. TOP 5 SELLING PRODUCTS

select p.product_id,
       p.product_name,
       sum(oi.quantity) as total_quantity
from products p
inner join order_items oi on p.product_id = oi.product_id
group by p.product_id, p.product_name
order by total_quantity desc
limit 5;


# 6. CUSTOMER PURCHASE SUMMARY

# 6. CUSTOMER PURCHASE SUMMARY

select c.customer_id,
       c.first_name,
       c.last_name,
       count(distinct o.order_id) as total_orders,
       sum(oi.quantity) as total_items_purchased,
       sum(oi.quantity * oi.list_price * (1 - oi.discount)) as total_revenue
from customer c
inner join orders o on c.customer_id = o.customer_id
inner join order_items oi on o.order_id = oi.order_id
group by c.customer_id, c.first_name, c.last_name;

## 7 .Customer Spending Segmentation

select c.customer_id,
       concat(c.first_name, ' ', c.last_name) as customer_name,
       sum(oi.total_price) as total_spend,
       case
           when sum(oi.total_price) < 1000 then 'Low'
           when sum(oi.total_price) < 5000 then 'Medium'
           else 'High'
       end as spending_segment
from customer c
join orders o on c.customer_id = o.customer_id
join order_items oi on o.order_id = oi.order_id
group by c.customer_id, c.first_name, c.last_name
order by total_spend desc;
   


# 8. STAFF PERFORMANCE ANALYSIS

select st.staff_id,
       st.first_name,
       st.last_name,
       sum(oi.total_price) as total_revenue
from staffs st
inner join orders o on st.staff_id = o.staff_id
inner join order_items oi on o.order_id = oi.order_id
group by st.staff_id, st.first_name, st.last_name
order by total_revenue desc;

# 9. STOCK ALERT QUERY

select p.product_id,
       p.product_name,
       s.store_id,
       s.quantity
from stocks s
inner join products p on s.product_id = p.product_id
where s.quantity < 10
order by s.quantity asc;


# CUSTOMER_SEGMENTS

create table customer_segments
 (customer_id INT primary key,
    customer_segment VARCHAR(50));

SELECT COUNT(*) 
FROM customer_segments;
SELECT * FROM customer_segments LIMIT 10;


