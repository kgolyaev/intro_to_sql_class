-- create invoices table
drop table if exists dim_invoices cascade;
create table dim_invoices 
(
    invoice_number_id integer
    , invoice_number varchar(7)
    , invoice_status varchar(8)
    , primary key (invoice_number_id)
)
;
-- load data into invoices table
\copy dim_invoices ( invoice_number_id, invoice_number, invoice_status ) from './dim_invoices.csv' delimiter ',' csv header;
-----------------------------------------------------
-- create product codes table
drop table if exists dim_product_codes cascade;
create table dim_product_codes 
(
    product_code_id integer
    , product_code varchar(12)
    , primary key (product_code_id)
)
;
-- load data into product codes table
\copy dim_product_codes ( product_code_id, product_code ) from './dim_product_codes.csv' delimiter ',' csv header;
-----------------------------------------------------
-- create product descriptions table
drop table if exists dim_product_descriptions cascade;
create table dim_product_descriptions 
(
    product_description_id integer
    , product_description varchar(35)
    , primary key (product_description_id)
)
;
-- load data into product descriptions table
\copy dim_product_descriptions ( product_description_id, product_description ) from './dim_product_descriptions.csv' delimiter ',' csv header;
-----------------------------------------------------
-- create countries table
drop table if exists dim_countries cascade;
create table dim_countries 
(
    country_name_id integer
    , country_name varchar(20)
    , primary key (country_name_id)
)
;
-- load data into countries table
\copy dim_countries ( country_name_id , country_name ) from './dim_countries.csv' delimiter ',' csv header ;
-----------------------------------------------------
-- create customer details table
drop table if exists dim_customer_details cascade;
create table dim_customer_details 
(
    customer_id integer
    , customer_country_name varchar(20)
    , customer_gender varchar(6)
    , customer_age real
    , primary key (customer_id)
)
;
-- load data into customer details table
\copy dim_customer_details ( customer_id , customer_country_name , customer_gender , customer_age ) from './dim_customer_details.csv' delimiter ',' csv header ;
-----------------------------------------------------
-- create transactions table
drop table if exists customer_transactions cascade;
create table customer_transactions 
(
    customer_transaction_id integer
    , invoice_date timestamp without time zone
    , customer_id integer references dim_customer_details
    , quantity integer
    , unit_price real
    , invoice_number_id integer references dim_invoices
    , product_code_id integer references dim_product_codes
    , product_description_id integer references dim_product_descriptions
    , country_name_id integer references dim_countries
    , primary key (customer_transaction_id)
)
;
-- load data into customer_transactions table
\copy customer_transactions ( customer_transaction_id, invoice_date, customer_id, quantity, unit_price, invoice_number_id, product_code_id, product_description_id, country_name_id ) from './customer_transactions.csv' delimiter ',' csv header ;
/* -------------------------------------- 
   -- Now let's load the auctions data -- 
   --------------------------------------
 */  
drop table if exists auctions cascade;
create table auctions
(
    auction_id  integer 
  , volume      integer not null
  , district    integer not null
  , date	    date    not null
  , primary key (auction_id)
)
;

\copy auctions ( auction_id, volume, district, date ) from './auctions.csv' delimiter ',' csv header;

drop table if exists bidders cascade;
create table bidders 
(
    bidder_id    integer 
  , first_name   varchar(7) not null
  , last_name    varchar(9) not null
  , address1     varchar(11) not null
  , address2     varchar(2) default null
  , town         varchar(9) not null
  , province     varchar(2) not null
  , postal_code  varchar(7) not null
  , telephone    varchar(10) not null
  , email        varchar(20) default null
  , preferred    varchar(3)
  , primary key (bidder_id)
)
;

\copy bidders ( bidder_id, first_name, last_name, address1, address2, town, province, postal_code, telephone, email, preferred ) from './bidders.csv' delimiter ',' csv header;

drop table if exists bids cascade;
create table bids 
(
    bid_id       integer  
  , auction_id   integer not null references auctions
  , bidder_id    integer not null references bidders
  , bid          real
  , primary key (bid_id)
)
;

\copy bids ( bid_id, auction_id, bidder_id, bid ) from './bids.csv' delimiter ',' csv header;

-------------------------------------------------------
drop table if exists demo_nulls cascade;
create table demo_nulls (user_name varchar(4), user_age integer);
insert into demo_nulls (user_name, user_age) values ('Ann', 20);
insert into demo_nulls (user_name, user_age) values ('Bob', NULL);
insert into demo_nulls (user_name, user_age) values ('Cole', 50);
