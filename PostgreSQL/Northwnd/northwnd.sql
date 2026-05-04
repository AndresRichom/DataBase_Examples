--
-- PostgreSQL database dump
--

-- Dumped from database version 12.22 (Ubuntu 12.22-0ubuntu0.20.04.4)
-- Dumped by pg_dump version 12.22 (Ubuntu 12.22-0ubuntu0.20.04.4)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: employee_sales_by_country(timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.employee_sales_by_country(beginning_date timestamp without time zone, ending_date timestamp without time zone) RETURNS TABLE(country text, last_name text, first_name text, shipped_date timestamp without time zone, order_id integer, sale_amount numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        e.Country,
        e.LastName,
        e.FirstName,
        o.ShippedDate,
        o.OrderID,
        os.Subtotal AS sale_amount
    FROM employees e
    JOIN orders o 
        ON e.EmployeeID = o.EmployeeID
    JOIN "Order Subtotals" os 
        ON o.OrderID = os.OrderID
    WHERE o.ShippedDate >= beginning_date
      AND o.ShippedDate < ending_date;
END;
$$;


ALTER FUNCTION public.employee_sales_by_country(beginning_date timestamp without time zone, ending_date timestamp without time zone) OWNER TO postgres;

--
-- Name: sales_by_year(timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sales_by_year(beginning_date timestamp without time zone, ending_date timestamp without time zone) RETURNS TABLE(shipped_date timestamp without time zone, order_id integer, subtotal numeric, year text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        o.ShippedDate,
        o.OrderID,
        os.Subtotal,
        TO_CHAR(o.ShippedDate, 'YYYY') AS year
    FROM orders o
    JOIN "Order Subtotals" os 
        ON o.OrderID = os.OrderID
    WHERE o.ShippedDate >= beginning_date
      AND o.ShippedDate < ending_date;
END;
$$;


ALTER FUNCTION public.sales_by_year(beginning_date timestamp without time zone, ending_date timestamp without time zone) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    categoryid integer NOT NULL,
    categoryname character varying(15) NOT NULL,
    description character varying(200),
    picture bytea
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    productid integer NOT NULL,
    productname character varying(40) NOT NULL,
    supplierid integer,
    categoryid integer,
    quantityperunit character varying(20),
    unitprice numeric DEFAULT 0,
    unitsinstock smallint DEFAULT 0,
    unitsonorder smallint DEFAULT 0,
    reorderlevel smallint DEFAULT 0,
    discontinued boolean
);


ALTER TABLE public.products OWNER TO postgres;

--
-- Name: alphabetical_list_of_products; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.alphabetical_list_of_products AS
 SELECT products.productid,
    products.productname,
    products.supplierid,
    products.categoryid,
    products.quantityperunit,
    products.unitprice,
    products.unitsinstock,
    products.unitsonorder,
    products.reorderlevel,
    products.discontinued,
    categories.categoryname
   FROM (public.categories
     JOIN public.products ON ((categories.categoryid = products.categoryid)))
  WHERE (products.discontinued = false);


ALTER TABLE public.alphabetical_list_of_products OWNER TO postgres;

--
-- Name: categories_categoryid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.categories ALTER COLUMN categoryid ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.categories_categoryid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: order_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_details (
    orderid integer,
    productid integer,
    unitprice numeric,
    quantity smallint,
    discount boolean
);


ALTER TABLE public.order_details OWNER TO postgres;

--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    orderid integer NOT NULL,
    customerid character(5),
    employeeid integer,
    orderdate date,
    requireddate date,
    shippeddate date,
    shipvia integer,
    freight money,
    shipname character varying(40),
    shipaddress character varying(60),
    shipcity character varying(15),
    shipregion character varying(15),
    shippostalcode character varying(10),
    shipcountry character varying(15)
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- Name: product_sales_for_1997; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.product_sales_for_1997 AS
 SELECT categories.categoryname,
    products.productname,
    sum((order_details.unitprice * (order_details.quantity)::numeric)) AS productsales
   FROM (((public.categories
     JOIN public.products ON ((categories.categoryid = products.categoryid)))
     JOIN public.orders ON ((orders.orderid = orders.orderid)))
     JOIN public.order_details ON ((order_details.productid = products.productid)))
  WHERE ((orders.shippeddate >= '1997-01-01'::date) AND (orders.shippeddate <= '1997-12-31'::date))
  GROUP BY categories.categoryname, products.productname;


ALTER TABLE public.product_sales_for_1997 OWNER TO postgres;

--
-- Name: category_sales_for_1997; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.category_sales_for_1997 AS
 SELECT product_sales_for_1997.categoryname,
    sum(product_sales_for_1997.productsales) AS categorysales
   FROM public.product_sales_for_1997
  GROUP BY product_sales_for_1997.categoryname;


ALTER TABLE public.category_sales_for_1997 OWNER TO postgres;

--
-- Name: current_product_list; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.current_product_list AS
 SELECT product_list.productid,
    product_list.productname
   FROM public.products product_list
  WHERE (product_list.discontinued = false)
  ORDER BY product_list.productname;


ALTER TABLE public.current_product_list OWNER TO postgres;

--
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    customerid character varying(5) NOT NULL,
    companyname character varying(40) NOT NULL,
    contactname character varying(30),
    contacttitle character varying(30),
    address character varying(60),
    city character varying(15),
    region character varying(15),
    postalcode character varying(10),
    country character varying(15),
    phone character varying(24),
    fax character varying(24)
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- Name: suppliers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.suppliers (
    supplierid integer NOT NULL,
    companyname character varying(40) NOT NULL,
    contactname character varying(30),
    contacttitle character varying(30),
    address character varying(60),
    city character varying(15),
    region character varying(15),
    postalcode character varying(10),
    country character varying(15),
    phone character varying(24),
    fax character varying(24),
    homepage character varying(100)
);


ALTER TABLE public.suppliers OWNER TO postgres;

--
-- Name: customer_and_suppliers_by_city; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.customer_and_suppliers_by_city AS
 SELECT customers.city,
    customers.companyname,
    customers.contactname,
    'Customers'::text AS relationship
   FROM public.customers
UNION
 SELECT suppliers.city,
    suppliers.companyname,
    suppliers.contactname,
    'Suppliers'::text AS relationship
   FROM public.suppliers
  ORDER BY 1, 2;


ALTER TABLE public.customer_and_suppliers_by_city OWNER TO postgres;

--
-- Name: employees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employees (
    employeeid integer NOT NULL,
    lastname character varying(20) NOT NULL,
    firstname character varying(10) NOT NULL,
    title character varying(30),
    titleofcourtesy character varying(25),
    birthdate date,
    hiredate date,
    address character varying(60),
    city character varying(15),
    region character varying(15),
    postalcode character varying(10),
    country character varying(15),
    homephone character varying(24),
    extensions character varying(4),
    photo bytea,
    notes character varying(500),
    reportsto integer,
    photopath character varying(255),
    CONSTRAINT "CK_Birthdate" CHECK ((birthdate < CURRENT_DATE))
);


ALTER TABLE public.employees OWNER TO postgres;

--
-- Name: employees_employeeid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.employees ALTER COLUMN employeeid ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.employees_employeeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: shippers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shippers (
    shipperid integer NOT NULL,
    companyname character varying(40) NOT NULL,
    phone character varying(24)
);


ALTER TABLE public.shippers OWNER TO postgres;

--
-- Name: invoices; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.invoices AS
 SELECT o.shipname,
    o.shipaddress,
    o.shipcity,
    o.shipregion,
    o.shippostalcode,
    o.shipcountry,
    o.customerid,
    c.companyname AS customername,
    c.address,
    c.city,
    c.region,
    c.postalcode,
    c.country,
    (((e.firstname)::text || ' '::text) || (e.lastname)::text) AS salesperson,
    o.orderid,
    o.orderdate,
    o.requireddate,
    o.shippeddate,
    s.companyname AS shippername,
    od.productid,
    p.productname,
    od.unitprice,
    od.quantity,
    od.discount,
    (od.unitprice * (od.quantity)::numeric) AS extendedprice,
    o.freight
   FROM (((((public.shippers s
     JOIN public.orders o ON ((s.shipperid = o.shipvia)))
     JOIN public.customers c ON (((c.customerid)::bpchar = o.customerid)))
     JOIN public.employees e ON ((e.employeeid = o.employeeid)))
     JOIN public.order_details od ON ((o.orderid = od.orderid)))
     JOIN public.products p ON ((p.productid = od.productid)));


ALTER TABLE public.invoices OWNER TO postgres;

--
-- Name: order_details_extended; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.order_details_extended AS
 SELECT order_details.orderid,
    order_details.productid,
    products.productname,
    order_details.unitprice,
    order_details.quantity,
    order_details.discount,
    (order_details.unitprice * (order_details.quantity)::numeric) AS extendedprice
   FROM (public.products
     JOIN public.order_details ON ((products.productid = order_details.productid)))
  ORDER BY order_details.orderid;


ALTER TABLE public.order_details_extended OWNER TO postgres;

--
-- Name: order_subtotals; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.order_subtotals AS
 SELECT order_details.orderid,
    sum((order_details.unitprice * (order_details.quantity)::numeric)) AS subtotal
   FROM public.order_details
  GROUP BY order_details.orderid;


ALTER TABLE public.order_subtotals OWNER TO postgres;

--
-- Name: orders_orderid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.orders ALTER COLUMN orderid ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.orders_orderid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: orders_qry; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.orders_qry AS
 SELECT orders.orderid,
    orders.customerid,
    orders.employeeid,
    orders.orderdate,
    orders.requireddate,
    orders.shippeddate,
    orders.shipvia,
    orders.freight,
    orders.shipname,
    orders.shipaddress,
    orders.shipcity,
    orders.shipregion,
    orders.shippostalcode,
    orders.shipcountry,
    customers.companyname,
    customers.address,
    customers.city,
    customers.region,
    customers.postalcode,
    customers.country
   FROM (public.customers
     JOIN public.orders ON (((customers.customerid)::bpchar = orders.customerid)));


ALTER TABLE public.orders_qry OWNER TO postgres;

--
-- Name: products_above_average_price; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.products_above_average_price AS
 SELECT products.productname,
    products.unitprice
   FROM public.products
  WHERE (products.unitprice > ( SELECT avg(products_1.unitprice) AS avg
           FROM public.products products_1))
  ORDER BY products.unitprice DESC;


ALTER TABLE public.products_above_average_price OWNER TO postgres;

--
-- Name: products_by_category; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.products_by_category AS
 SELECT c.categoryname,
    p.productname,
    p.quantityperunit,
    p.unitsinstock,
    p.discontinued
   FROM (public.categories c
     JOIN public.products p ON ((c.categoryid = p.categoryid)))
  WHERE (p.discontinued <> true);


ALTER TABLE public.products_by_category OWNER TO postgres;

--
-- Name: products_productid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.products ALTER COLUMN productid ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.products_productid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: quarterly_orders; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.quarterly_orders AS
 SELECT DISTINCT customers.customerid,
    customers.companyname,
    customers.city,
    customers.country
   FROM (public.customers
     RIGHT JOIN public.orders ON (((customers.customerid)::bpchar = orders.customerid)))
  WHERE ((orders.orderdate >= '1997-01-01'::date) AND (orders.orderdate <= '1997-12-31'::date));


ALTER TABLE public.quarterly_orders OWNER TO postgres;

--
-- Name: sales_by_category; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.sales_by_category AS
 SELECT c.categoryid,
    c.categoryname,
    p.productname,
    sum(odx.extendedprice) AS productsales
   FROM (((public.categories c
     JOIN public.products p ON ((c.categoryid = p.categoryid)))
     JOIN public.order_details_extended odx ON ((p.productid = odx.productid)))
     JOIN public.orders o ON ((o.orderid = odx.orderid)))
  WHERE ((o.orderdate >= '1997-01-01'::date) AND (o.orderdate < '1998-01-01'::date))
  GROUP BY c.categoryid, c.categoryname, p.productname
  ORDER BY p.productname;


ALTER TABLE public.sales_by_category OWNER TO postgres;

--
-- Name: sales_totals_by_amount; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.sales_totals_by_amount AS
 SELECT order_subtotals.subtotal AS saleamount,
    orders.orderid,
    customers.companyname,
    orders.shippeddate
   FROM (public.customers
     JOIN (public.orders
     JOIN public.order_subtotals ON ((orders.orderid = order_subtotals.orderid))) ON (((customers.customerid)::bpchar = orders.customerid)))
  WHERE ((order_subtotals.subtotal > (2500)::numeric) AND ((orders.shippeddate >= '1997-01-01'::date) AND (orders.shippeddate <= '1997-12-31'::date)));


ALTER TABLE public.sales_totals_by_amount OWNER TO postgres;

--
-- Name: shippers_shipperid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.shippers ALTER COLUMN shipperid ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.shippers_shipperid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: summary_of_sales_by_quarter; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.summary_of_sales_by_quarter AS
 SELECT orders.shippeddate,
    orders.orderid,
    order_subtotals.subtotal
   FROM (public.orders
     JOIN public.order_subtotals ON ((orders.orderid = order_subtotals.orderid)))
  WHERE (orders.shippeddate IS NOT NULL)
  ORDER BY orders.shippeddate;


ALTER TABLE public.summary_of_sales_by_quarter OWNER TO postgres;

--
-- Name: summary_of_sales_by_year; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.summary_of_sales_by_year AS
 SELECT orders.shippeddate,
    orders.orderid,
    order_subtotals.subtotal
   FROM (public.orders
     JOIN public.order_subtotals ON ((orders.orderid = order_subtotals.orderid)))
  WHERE (orders.shippeddate IS NOT NULL)
  ORDER BY orders.shippeddate;


ALTER TABLE public.summary_of_sales_by_year OWNER TO postgres;

--
-- Name: suppliers_supplierid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.suppliers ALTER COLUMN supplierid ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.suppliers_supplierid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ten_most_expensive_products; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.ten_most_expensive_products AS
 SELECT p.productname AS ten_most_expensive_products,
    p.unitprice
   FROM public.products p
  ORDER BY p.unitprice DESC
 LIMIT 10;


ALTER TABLE public.ten_most_expensive_products OWNER TO postgres;

--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categories (categoryid, categoryname, description, picture) FROM stdin;
1	Beverages	Soft drinks, coffees, teas, beers, and ales	\N
2	Condiments	Sweet and savory sauces, relishes, spreads, and seasonings	\N
3	Confections	Desserts, candies, and sweet breads	\N
4	Dairy Products	Cheeses	\N
5	Grains/Cereals	Breads, crackers, pasta, and cereal	\N
6	Meat/Poultry	Prepared meats	\N
7	Produce	Dried fruit and bean curd	\N
8	Seafood	Seaweed and fish	\N
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers (customerid, companyname, contactname, contacttitle, address, city, region, postalcode, country, phone, fax) FROM stdin;
ALFKI	Alfreds Futterkiste	Maria Anders	Sales Representative	Obere Str. 57	Berlin	\N	12209	Germany	030-0074321	030-0076545
ANATR	Ana Trujillo Emparedados y helados	Ana Trujillo	Owner	Avda. de la Constitución 2222	México D.F.	\N	5021	Mexico	(5) 555-4729	(5) 555-3745
ANTON	Antonio Moreno Taquería	Antonio Moreno	Owner	Mataderos  2312	México D.F.	\N	5023	Mexico	(5) 555-3932	\N
AROUT	Around the Horn	Thomas Hardy	Sales Representative	120 Hanover Sq.	London	\N	WA1 1DP	UK	(171) 555-7788	(171) 555-6750
BERGS	Berglunds snabbköp	Christina Berglund	Order Administrator	Berguvsvägen  8	Luleå	\N	S-958 22	Sweden	0921-12 34 65	0921-12 34 67
BLAUS	Blauer See Delikatessen	Hanna Moos	Sales Representative	Forsterstr. 57	Mannheim	\N	68306	Germany	0621-08460	0621-08924
BLONP	Blondesddsl père et fils	Frédérique Citeaux	Marketing Manager	24, place Kléber	Strasbourg	\N	67000	France	88.60.15.31	88.60.15.32
BOLID	Bólido Comidas preparadas	Martín Sommer	Owner	C/ Araquil, 67	Madrid	\N	28023	Spain	(91) 555 22 82	(91) 555 91 99
BONAP	Bon app'	Laurence Lebihan	Owner	12, rue des Bouchers	Marseille	\N	13008	France	91.24.45.40	91.24.45.41
BOTTM	Bottom-Dollar Markets	Elizabeth Lincoln	Accounting Manager	23 Tsawassen Blvd.	Tsawassen	BC	T2F 8M4	Canada	(604) 555-4729	(604) 555-3745
BSBEV	B's Beverages	Victoria Ashworth	Sales Representative	Fauntleroy Circus	London	\N	EC2 5NT	UK	(171) 555-1212	\N
CACTU	Cactus Comidas para llevar	Patricio Simpson	Sales Agent	Cerrito 333	Buenos Aires	\N	1010	Argentina	(1) 135-5555	(1) 135-4892
CENTC	Centro comercial Moctezuma	Francisco Chang	Marketing Manager	Sierras de Granada 9993	México D.F.	\N	5022	Mexico	(5) 555-3392	(5) 555-7293
CHOPS	Chop-suey Chinese	Yang Wang	Owner	Hauptstr. 29	Bern	\N	3012	Switzerland	0452-076545	\N
COMMI	Comércio Mineiro	Pedro Afonso	Sales Associate	Av. dos Lusíadas, 23	Sao Paulo	SP	05432-043	Brazil	(11) 555-7647	\N
CONSH	Consolidated Holdings	Elizabeth Brown	Sales Representative	Berkeley Gardens 12  Brewery	London	\N	WX1 6LT	UK	(171) 555-2282	(171) 555-9199
DRACD	Drachenblut Delikatessen	Sven Ottlieb	Order Administrator	Walserweg 21	Aachen	\N	52066	Germany	0241-039123	0241-059428
DUMON	Du monde entier	Janine Labrune	Owner	67, rue des Cinquante Otages	Nantes	\N	44000	France	40.67.88.88	40.67.89.89
EASTC	Eastern Connection	Ann Devon	Sales Agent	35 King George	London	\N	WX3 6FW	UK	(171) 555-0297	(171) 555-3373
ERNSH	Ernst Handel	Roland Mendel	Sales Manager	Kirchgasse 6	Graz	\N	8010	Austria	7675-3425	7675-3426
FAMIA	Familia Arquibaldo	Aria Cruz	Marketing Assistant	Rua Orós, 92	Sao Paulo	SP	05442-030	Brazil	(11) 555-9857	\N
FISSA	FISSA Fabrica Inter. Salchichas S.A.	Diego Roel	Accounting Manager	C/ Moralzarzal, 86	Madrid	\N	28034	Spain	(91) 555 94 44	(91) 555 55 93
FOLIG	Folies gourmandes	Martine Rancé	Assistant Sales Agent	184, chaussée de Tournai	Lille	\N	59000	France	20.16.10.16	20.16.10.17
FOLKO	Folk och fä HB	Maria Larsson	Owner	Åkergatan 24	Bräcke	\N	S-844 67	Sweden	0695-34 67 21	\N
FRANK	Frankenversand	Peter Franken	Marketing Manager	Berliner Platz 43	München	\N	80805	Germany	089-0877310	089-0877451
FRANR	France restauration	Carine Schmitt	Marketing Manager	54, rue Royale	Nantes	\N	44000	France	40.32.21.21	40.32.21.20
FRANS	Franchi S.p.A.	Paolo Accorti	Sales Representative	Via Monte Bianco 34	Torino	\N	10100	Italy	011-4988260	011-4988261
FURIB	Furia Bacalhau e Frutos do Mar	Lino Rodriguez	Sales Manager	Jardim das rosas n. 32	Lisboa	\N	1675	Portugal	(1) 354-2534	(1) 354-2535
GALED	Galería del gastrónomo	Eduardo Saavedra	Marketing Manager	Rambla de Cataluña, 23	Barcelona	\N	8022	Spain	(93) 203 4560	(93) 203 4561
GODOS	Godos Cocina Típica	José Pedro Freyre	Sales Manager	C/ Romero, 33	Sevilla	\N	41101	Spain	(95) 555 82 82	\N
GOURL	Gourmet Lanchonetes	André Fonseca	Sales Associate	Av. Brasil, 442	Campinas	SP	04876-786	Brazil	(11) 555-9482	\N
GREAL	Great Lakes Food Market	Howard Snyder	Marketing Manager	2732 Baker Blvd.	Eugene	OR	97403	USA	(503) 555-7555	\N
GROSR	GROSELLA-Restaurante	Manuel Pereira	Owner	5ª Ave. Los Palos Grandes	Caracas	DF	1081	Venezuela	(2) 283-2951	(2) 283-3397
HANAR	Hanari Carnes	Mario Pontes	Accounting Manager	Rua do Paço, 67	Rio de Janeiro	RJ	05454-876	Brazil	(21) 555-0091	(21) 555-8765
HILAA	HILARION-Abastos	Carlos Hernández	Sales Representative	Carrera 22 con Ave. Carlos Soublette #8-35	San Cristóbal	Táchira	5022	Venezuela	(5) 555-1340	(5) 555-1948
HUNGC	Hungry Coyote Import Store	Yoshi Latimer	Sales Representative	City Center Plaza 516 Main St.	Elgin	OR	97827	USA	(503) 555-6874	(503) 555-2376
HUNGO	Hungry Owl All-Night Grocers	Patricia McKenna	Sales Associate	8 Johnstown Road	Cork	Co. Cork	\N	Ireland	2967 542	2967 3333
ISLAT	Island Trading	Helen Bennett	Marketing Manager	Garden House Crowther Way	Cowes	Isle of Wight	PO31 7PJ	UK	(198) 555-8888	\N
KOENE	Königlich Essen	Philip Cramer	Sales Associate	Maubelstr. 90	Brandenburg	\N	14776	Germany	0555-09876	\N
LACOR	La corne d'abondance	Daniel Tonini	Sales Representative	67, avenue de l'Europe	Versailles	\N	78000	France	30.59.84.10	30.59.85.11
LAMAI	La maison d'Asie	Annette Roulet	Sales Manager	1 rue Alsace-Lorraine	Toulouse	\N	31000	France	61.77.61.10	61.77.61.11
LAUGB	Laughing Bacchus Wine Cellars	Yoshi Tannamuri	Marketing Assistant	1900 Oak St.	Vancouver	BC	V3F 2K1	Canada	(604) 555-3392	(604) 555-7293
LAZYK	Lazy K Kountry Store	John Steel	Marketing Manager	12 Orchestra Terrace	Walla Walla	WA	99362	USA	(509) 555-7969	(509) 555-6221
LEHMS	Lehmanns Marktstand	Renate Messner	Sales Representative	Magazinweg 7	Frankfurt a.M.	\N	60528	Germany	069-0245984	069-0245874
LETSS	Let's Stop N Shop	Jaime Yorres	Owner	87 Polk St. Suite 5	San Francisco	CA	94117	USA	(415) 555-5938	\N
LILAS	LILA-Supermercado	Carlos González	Accounting Manager	Carrera 52 con Ave. Bolívar #65-98 Llano Largo	Barquisimeto	Lara	3508	Venezuela	(9) 331-6954	(9) 331-7256
LINOD	LINO-Delicateses	Felipe Izquierdo	Owner	Ave. 5 de Mayo Porlamar	I. de Margarita	Nueva Esparta	4980	Venezuela	(8) 34-56-12	(8) 34-93-93
LONEP	Lonesome Pine Restaurant	Fran Wilson	Sales Manager	89 Chiaroscuro Rd.	Portland	OR	97219	USA	(503) 555-9573	(503) 555-9646
MAGAA	Magazzini Alimentari Riuniti	Giovanni Rovelli	Marketing Manager	Via Ludovico il Moro 22	Bergamo	\N	24100	Italy	035-640230	035-640231
MAISD	Maison Dewey	Catherine Dewey	Sales Agent	Rue Joseph-Bens 532	Bruxelles	\N	B-1180	Belgium	(02) 201 24 67	(02) 201 24 68
MEREP	Mère Paillarde	Jean Fresnière	Marketing Assistant	43 rue St. Laurent	Montréal	Québec	H1J 1C3	Canada	(514) 555-8054	(514) 555-8055
MORGK	Morgenstern Gesundkost	Alexander Feuer	Marketing Assistant	Heerstr. 22	Leipzig	\N	4179	Germany	0342-023176	\N
NORTS	North/South	Simon Crowther	Sales Associate	South House 300 Queensbridge	London	\N	SW7 1RZ	UK	(171) 555-7733	(171) 555-2530
OCEAN	Océano Atlántico Ltda.	Yvonne Moncada	Sales Agent	Ing. Gustavo Moncada 8585 Piso 20-A	Buenos Aires	\N	1010	Argentina	(1) 135-5333	(1) 135-5535
OLDWO	Old World Delicatessen	Rene Phillips	Sales Representative	2743 Bering St.	Anchorage	AK	99508	USA	(907) 555-7584	(907) 555-2880
OTTIK	Ottilies Käseladen	Henriette Pfalzheim	Owner	Mehrheimerstr. 369	Köln	\N	50739	Germany	0221-0644327	0221-0765721
PARIS	Paris spécialités	Marie Bertrand	Owner	265, boulevard Charonne	Paris	\N	75012	France	(1) 42.34.22.66	(1) 42.34.22.77
PERIC	Pericles Comidas clásicas	Guillermo Fernández	Sales Representative	Calle Dr. Jorge Cash 321	México D.F.	\N	5033	Mexico	(5) 552-3745	(5) 545-3745
PICCO	Piccolo und mehr	Georg Pipps	Sales Manager	Geislweg 14	Salzburg	\N	5020	Austria	6562-9722	6562-9723
PRINI	Princesa Isabel Vinhos	Isabel de Castro	Sales Representative	Estrada da saúde n. 58	Lisboa	\N	1756	Portugal	(1) 356-5634	\N
QUEDE	Que Delícia	Bernardo Batista	Accounting Manager	Rua da Panificadora, 12	Rio de Janeiro	RJ	02389-673	Brazil	(21) 555-4252	(21) 555-4545
QUEEN	Queen Cozinha	Lúcia Carvalho	Marketing Assistant	Alameda dos Canàrios, 891	Sao Paulo	SP	05487-020	Brazil	(11) 555-1189	\N
QUICK	QUICK-Stop	Horst Kloss	Accounting Manager	Taucherstraße 10	Cunewalde	\N	1307	Germany	0372-035188	\N
RANCH	Rancho grande	Sergio Gutiérrez	Sales Representative	Av. del Libertador 900	Buenos Aires	\N	1010	Argentina	(1) 123-5555	(1) 123-5556
RATTC	Rattlesnake Canyon Grocery	Paula Wilson	Assistant Sales Representative	2817 Milton Dr.	Albuquerque	NM	87110	USA	(505) 555-5939	(505) 555-3620
REGGC	Reggiani Caseifici	Maurizio Moroni	Sales Associate	Strada Provinciale 124	Reggio Emilia	\N	42100	Italy	0522-556721	0522-556722
RICAR	Ricardo Adocicados	Janete Limeira	Assistant Sales Agent	Av. Copacabana, 267	Rio de Janeiro	RJ	02389-890	Brazil	(21) 555-3412	\N
RICSU	Richter Supermarkt	Michael Holz	Sales Manager	Grenzacherweg 237	Genève	\N	1203	Switzerland	0897-034214	\N
ROMEY	Romero y tomillo	Alejandra Camino	Accounting Manager	Gran Vía, 1	Madrid	\N	28001	Spain	(91) 745 6200	(91) 745 6210
SANTG	Santé Gourmet	Jonas Bergulfsen	Owner	Erling Skakkes gate 78	Stavern	\N	4110	Norway	07-98 92 35	07-98 92 47
SAVEA	Save-a-lot Markets	Jose Pavarotti	Sales Representative	187 Suffolk Ln.	Boise	ID	83720	USA	(208) 555-8097	\N
SEVES	Seven Seas Imports	Hari Kumar	Sales Manager	90 Wadhurst Rd.	London	\N	OX15 4NB	UK	(171) 555-1717	(171) 555-5646
SIMOB	Simons bistro	Jytte Petersen	Owner	Vinbæltet 34	Kobenhavn	\N	1734	Denmark	31 12 34 56	31 13 35 57
SPECD	Spécialités du monde	Dominique Perrier	Marketing Manager	25, rue Lauriston	Paris	\N	75016	France	(1) 47.55.60.10	(1) 47.55.60.20
SPLIR	Split Rail Beer & Ale	Art Braunschweiger	Sales Manager	P.O. Box 555	Lander	WY	82520	USA	(307) 555-4680	(307) 555-6525
SUPRD	Suprêmes délices	Pascale Cartrain	Accounting Manager	Boulevard Tirou, 255	Charleroi	\N	B-6000	Belgium	(071) 23 67 22 20	(071) 23 67 22 21
THEBI	The Big Cheese	Liz Nixon	Marketing Manager	89 Jefferson Way Suite 2	Portland	OR	97201	USA	(503) 555-3612	\N
THECR	The Cracker Box	Liu Wong	Marketing Assistant	55 Grizzly Peak Rd.	Butte	MT	59801	USA	(406) 555-5834	(406) 555-8083
TOMSP	Toms Spezialitäten	Karin Josephs	Marketing Manager	Luisenstr. 48	Münster	\N	44087	Germany	0251-031259	0251-035695
TORTU	Tortuga Restaurante	Miguel Angel Paolino	Owner	Avda. Azteca 123	México D.F.	\N	5033	Mexico	(5) 555-2933	\N
TRADH	Tradição Hipermercados	Anabela Domingues	Sales Representative	Av. Inês de Castro, 414	Sao Paulo	SP	05634-030	Brazil	(11) 555-2167	(11) 555-2168
TRAIH	Trail's Head Gourmet Provisioners	Helvetius Nagy	Sales Associate	722 DaVinci Blvd.	Kirkland	WA	98034	USA	(206) 555-8257	(206) 555-2174
VAFFE	Vaffeljernet	Palle Ibsen	Sales Manager	Smagsloget 45	Århus	\N	8200	Denmark	86 21 32 43	86 22 33 44
VICTE	Victuailles en stock	Mary Saveley	Sales Agent	2, rue du Commerce	Lyon	\N	69004	France	78.32.54.86	78.32.54.87
VINET	Vins et alcools Chevalier	Paul Henriot	Accounting Manager	59 rue de l'Abbaye	Reims	\N	51100	France	26.47.15.10	26.47.15.11
WANDK	Die Wandernde Kuh	Rita Müller	Sales Representative	Adenauerallee 900	Stuttgart	\N	70563	Germany	0711-020361	0711-035428
WARTH	Wartian Herkku	Pirkko Koskitalo	Accounting Manager	Torikatu 38	Oulu	\N	90110	Finland	981-443655	981-443655
WELLI	Wellington Importadora	Paula Parente	Sales Manager	Rua do Mercado, 12	Resende	SP	08737-363	Brazil	(14) 555-8122	\N
WHITC	White Clover Markets	Karl Jablonski	Owner	305 - 14th Ave. S. Suite 3B	Seattle	WA	98128	USA	(206) 555-4112	(206) 555-4115
WILMK	Wilman Kala	Matti Karttunen	Owner/Marketing Assistant	Keskuskatu 45	Helsinki	\N	21240	Finland	90-224 8858	90-224 8858
WOLZA	Wolski  Zajazd	Zbyszek Piestrzeniewicz	Owner	ul. Filtrowa 68	Warszawa	\N	01-012	Poland	(26) 642-7012	(26) 642-7012
\.


--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employees (employeeid, lastname, firstname, title, titleofcourtesy, birthdate, hiredate, address, city, region, postalcode, country, homephone, extensions, photo, notes, reportsto, photopath) FROM stdin;
1	Davolio	Nancy	Sales Representative	Ms.	1948-12-08	1992-05-01	507 - 20th Ave. E.\nApt. 2A	Seattle	WA	98122	USA	(206) 555-9857	5467	\N	Education includes a BA in psychology from Colorado State University in 1970.  She also completed "The Art of the Cold Call."  Nancy is a member of Toastmasters International.	2	http://accweb/emmployees/davolio.bmp
2	Fuller	Andrew	Vice President, Sales	Dr.	1952-02-19	1992-08-14	908 W. Capital Way	Tacoma	WA	98401	USA	(206) 555-9482	3457	\N	Andrew received his BTS commercial in 1974 and a Ph.D. in international marketing from the University of Dallas in 1981.  He is fluent in French and Italian and reads German.  He joined the company as a sales representative, was promoted to sales manager in January 1992 and to vice president of sales in March 1993.  Andrew is a member of the Sales Management Roundtable, the Seattle Chamber of Commerce, and the Pacific Rim Importers Association.	\N	http://accweb/emmployees/fuller.bmp
3	Leverling	Janet	Sales Representative	Ms.	1963-08-30	1992-04-01	722 Moss Bay Blvd.	Kirkland	WA	98033	USA	(206) 555-3412	3355	\N	Janet has a BS degree in chemistry from Boston College (1984).  She has also completed a certificate program in food retailing management.  Janet was hired as a sales associate in 1991 and promoted to sales representative in February 1992.	2	http://accweb/emmployees/leverling.bmp
4	Peacock	Margaret	Sales Representative	Mrs.	1937-09-19	1993-05-03	4110 Old Redmond Rd.	Redmond	WA	98052	USA	(206) 555-8122	5176	\N	Margaret holds a BA in English literature from Concordia College (1958) and an MA from the American Institute of Culinary Arts (1966).  She was assigned to the London office temporarily from July through November 1992.	2	http://accweb/emmployees/peacock.bmp
5	Buchanan	Steven	Sales Manager	Mr.	1955-03-04	1993-10-17	14 Garrett Hill	London	NULL	SW1 8JR	UK	(71) 555-4848	3453	\N	Steven Buchanan graduated from St. Andrews University, Scotland, with a BSC degree in 1976.  Upon joining the company as a sales representative in 1992, he spent 6 months in an orientation program at the Seattle office and then returned to his permanent post in London.  He was promoted to sales manager in March 1993.  Mr. Buchanan has completed the courses "Successful Telemarketing" and "International Sales Management."  He is fluent in French.	2	http://accweb/emmployees/buchanan.bmp
6	Suyama	Michael	Sales Representative	Mr.	1963-07-02	1993-10-17	Coventry House\nMiner Rd.	London	NULL	EC2 7JR	UK	(71) 555-7773	428	\N	Michael is a graduate of Sussex University (MA, economics, 1983) and the University of California at Los Angeles (MBA, marketing, 1986).  He has also taken the courses "Multi-Cultural Selling" and "Time Management for the Sales Professional."  He is fluent in Japanese and can read and write French, Portuguese, and Spanish.	5	http://accweb/emmployees/davolio.bmp
7	King	Robert	Sales Representative	Mr.	1960-05-29	1994-01-02	Edgeham Hollow\nWinchester Way	London	NULL	RG1 9SP	UK	(71) 555-5598	465	\N	Robert King served in the Peace Corps and traveled extensively before completing his degree in English at the University of Michigan in 1992, the year he joined the company.  After completing a course entitled "Selling in Europe," he was transferred to the London office in March 1993.	5	http://accweb/emmployees/davolio.bmp
8	Callahan	Laura	Inside Sales Coordinator	Ms.	1958-01-09	1994-03-05	4726 - 11th Ave. N.E.	Seattle	WA	98105	USA	(206) 555-1189	2344	\N	Laura received a BA in psychology from the University of Washington.  She has also completed a course in business French.  She reads and writes French.	2	http://accweb/emmployees/davolio.bmp
9	Dodsworth	Anne	Sales Representative	Ms.	1966-01-27	1994-11-15	7 Houndstooth Rd.	London	NULL	WG2 7LT	UK	(71) 555-4444	452	\N	Anne has a BA degree in English from St. Lawrence College.  She is fluent in French and German.	5	http://accweb/emmployees/davolio.bmp
\.


--
-- Data for Name: order_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_details (orderid, productid, unitprice, quantity, discount) FROM stdin;
10248	11	14.0	12	f
10248	42	9.8	10	f
10248	72	34.8	5	f
10249	14	18.6	9	f
10249	51	42.4	40	f
10250	41	7.7	10	f
10250	51	42.4	35	f
10250	65	16.8	15	f
10251	22	16.8	6	f
10251	57	15.6	15	f
10251	65	16.8	20	f
10252	20	64.8	40	f
10252	33	2.0	25	f
10252	60	27.2	40	f
10253	31	10.0	20	f
10253	39	14.4	42	f
10253	49	16.0	40	f
10254	24	3.6	15	f
10254	55	19.2	21	f
10254	74	8.0	21	f
10255	2	15.2	20	f
10255	16	13.9	35	f
10255	36	15.2	25	f
10255	59	44.0	30	f
10256	53	26.2	15	f
10256	77	10.4	12	f
10257	27	35.1	25	f
10257	39	14.4	6	f
10257	77	10.4	15	f
10258	2	15.2	50	f
10258	5	17.0	65	f
10258	32	25.6	6	f
10259	21	8.0	10	f
10259	37	20.8	1	f
10260	41	7.7	16	f
10260	57	15.6	50	f
10260	62	39.4	15	f
10260	70	12.0	21	f
10261	21	8.0	20	f
10261	35	14.4	20	f
10262	5	17.0	12	f
10262	7	24.0	15	f
10262	56	30.4	2	f
10263	16	13.9	60	f
10263	24	3.6	28	f
10263	30	20.7	60	f
10263	74	8.0	36	f
10264	2	15.2	35	f
10264	41	7.7	25	f
10265	17	31.2	30	f
10265	70	12.0	20	f
10266	12	30.4	12	f
10267	40	14.7	50	f
10267	59	44.0	70	f
10267	76	14.4	15	f
10268	29	99.0	10	f
10268	72	27.8	4	f
10269	33	2.0	60	f
10269	72	27.8	20	f
10270	36	15.2	30	f
10270	43	36.8	25	f
10271	33	2.0	24	f
10272	20	64.8	6	f
10272	31	10.0	40	f
10272	72	27.8	24	f
10273	10	24.8	24	f
10273	31	10.0	15	f
10273	33	2.0	20	f
10273	40	14.7	60	f
10273	76	14.4	33	f
10274	71	17.2	20	f
10274	72	27.8	7	f
10275	24	3.6	12	f
10275	59	44.0	6	f
10276	10	24.8	15	f
10276	13	4.8	10	f
10277	28	36.4	20	f
10277	62	39.4	12	f
10278	44	15.5	16	f
10278	59	44.0	15	f
10278	63	35.1	8	f
10278	73	12.0	25	f
10279	17	31.2	15	f
10280	24	3.6	12	f
10280	55	19.2	20	f
10280	75	6.2	30	f
10281	19	7.3	1	f
10281	24	3.6	6	f
10281	35	14.4	4	f
10282	30	20.7	6	f
10282	57	15.6	2	f
10283	15	12.4	20	f
10283	19	7.3	18	f
10283	60	27.2	35	f
10283	72	27.8	3	f
10284	27	35.1	15	f
10284	44	15.5	21	f
10284	60	27.2	20	f
10284	67	11.2	5	f
10285	1	14.4	45	f
10285	40	14.7	40	f
10285	53	26.2	36	f
10286	35	14.4	100	f
10286	62	39.4	40	f
10287	16	13.9	40	f
10287	34	11.2	20	f
10287	46	9.6	15	f
10288	54	5.9	10	f
10288	68	10.0	3	f
10289	3	8.0	30	f
10289	64	26.6	9	f
10290	5	17.0	20	f
10290	29	99.0	15	f
10290	49	16.0	15	f
10290	77	10.4	10	f
10291	13	4.8	20	f
10291	44	15.5	24	f
10291	51	42.4	2	f
10292	20	64.8	20	f
10293	18	50.0	12	f
10293	24	3.6	10	f
10293	63	35.1	5	f
10293	75	6.2	6	f
10294	1	14.4	18	f
10294	17	31.2	15	f
10294	43	36.8	15	f
10294	60	27.2	21	f
10294	75	6.2	6	f
10295	56	30.4	4	f
10296	11	16.8	12	f
10296	16	13.9	30	f
10296	69	28.8	15	f
10297	39	14.4	60	f
10297	72	27.8	20	f
10298	2	15.2	40	f
10298	36	15.2	40	f
10298	59	44.0	30	f
10298	62	39.4	15	f
10299	19	7.3	15	f
10299	70	12.0	20	f
10300	66	13.6	30	f
10300	68	10.0	20	f
10301	40	14.7	10	f
10301	56	30.4	20	f
10302	17	31.2	40	f
10302	28	36.4	28	f
10302	43	36.8	12	f
10303	40	14.7	40	f
10303	65	16.8	30	f
10303	68	10.0	15	f
10304	49	16.0	30	f
10304	59	44.0	10	f
10304	71	17.2	2	f
10305	18	50.0	25	f
10305	29	99.0	25	f
10305	39	14.4	30	f
10306	30	20.7	10	f
10306	53	26.2	10	f
10306	54	5.9	5	f
10307	62	39.4	10	f
10307	68	10.0	3	f
10308	69	28.8	1	f
10308	70	12.0	5	f
10309	4	17.6	20	f
10309	6	20.0	30	f
10309	42	11.2	2	f
10309	43	36.8	20	f
10309	71	17.2	3	f
10310	16	13.9	10	f
10310	62	39.4	5	f
10311	42	11.2	6	f
10311	69	28.8	7	f
10312	28	36.4	4	f
10312	43	36.8	24	f
10312	53	26.2	20	f
10312	75	6.2	10	f
10313	36	15.2	12	f
10314	32	25.6	40	f
10314	58	10.6	30	f
10314	62	39.4	25	f
10315	34	11.2	14	f
10315	70	12.0	30	f
10316	41	7.7	10	f
10316	62	39.4	70	f
10317	1	14.4	20	f
10318	41	7.7	20	f
10318	76	14.4	6	f
10319	17	31.2	8	f
10319	28	36.4	14	f
10319	76	14.4	30	f
10320	71	17.2	30	f
10321	35	14.4	10	f
10322	52	5.6	20	f
10323	15	12.4	5	f
10323	25	11.2	4	f
10323	39	14.4	4	f
10324	16	13.9	21	f
10324	35	14.4	70	f
10324	46	9.6	30	f
10324	59	44.0	40	f
10324	63	35.1	80	f
10325	6	20.0	6	f
10325	13	4.8	12	f
10325	14	18.6	9	f
10325	31	10.0	4	f
10325	72	27.8	40	f
10326	4	17.6	24	f
10326	57	15.6	16	f
10326	75	6.2	50	f
10327	2	15.2	25	f
10327	11	16.8	50	f
10327	30	20.7	35	f
10327	58	10.6	30	f
10328	59	44.0	9	f
10328	65	16.8	40	f
10328	68	10.0	10	f
10329	19	7.3	10	f
10329	30	20.7	8	f
10329	38	210.8	20	f
10329	56	30.4	12	f
10330	26	24.9	50	f
10330	72	27.8	25	f
10331	54	5.9	15	f
10332	18	50.0	40	f
10332	42	11.2	10	f
10332	47	7.6	16	f
10333	14	18.6	10	f
10333	21	8.0	10	f
10333	71	17.2	40	f
10334	52	5.6	8	f
10334	68	10.0	10	f
10335	2	15.2	7	f
10335	31	10.0	25	f
10335	32	25.6	6	f
10335	51	42.4	48	f
10336	4	17.6	18	f
10337	23	7.2	40	f
10337	26	24.9	24	f
10337	36	15.2	20	f
10337	37	20.8	28	f
10337	72	27.8	25	f
10338	17	31.2	20	f
10338	30	20.7	15	f
10339	4	17.6	10	f
10339	17	31.2	70	f
10339	62	39.4	28	f
10340	18	50.0	20	f
10340	41	7.7	12	f
10340	43	36.8	40	f
10341	33	2.0	8	f
10341	59	44.0	9	f
10342	2	15.2	24	f
10342	31	10.0	56	f
10342	36	15.2	40	f
10342	55	19.2	40	f
10343	64	26.6	50	f
10343	68	10.0	4	f
10343	76	14.4	15	f
10344	4	17.6	35	f
10344	8	32.0	70	f
10345	8	32.0	70	f
10345	19	7.3	80	f
10345	42	11.2	9	f
10346	17	31.2	36	f
10346	56	30.4	20	f
10347	25	11.2	10	f
10347	39	14.4	50	f
10347	40	14.7	4	f
10347	75	6.2	6	f
10348	1	14.4	15	f
10348	23	7.2	25	f
10349	54	5.9	24	f
10350	50	13.0	15	f
10350	69	28.8	18	f
10351	38	210.8	20	f
10351	41	7.7	13	f
10351	44	15.5	77	f
10351	65	16.8	10	f
10352	24	3.6	10	f
10352	54	5.9	20	f
10353	11	16.8	12	f
10353	38	210.8	50	f
10354	1	14.4	12	f
10354	29	99.0	4	f
10355	24	3.6	25	f
10355	57	15.6	25	f
10356	31	10.0	30	f
10356	55	19.2	12	f
10356	69	28.8	20	f
10357	10	24.8	30	f
10357	26	24.9	16	f
10357	60	27.2	8	f
10358	24	3.6	10	f
10358	34	11.2	10	f
10358	36	15.2	20	f
10359	16	13.9	56	f
10359	31	10.0	70	f
10359	60	27.2	80	f
10360	28	36.4	30	f
10360	29	99.0	35	f
10360	38	210.8	10	f
10360	49	16.0	35	f
10360	54	5.9	28	f
10361	39	14.4	54	f
10361	60	27.2	55	f
10362	25	11.2	50	f
10362	51	42.4	20	f
10362	54	5.9	24	f
10363	31	10.0	20	f
10363	75	6.2	12	f
10363	76	14.4	12	f
10364	69	28.8	30	f
10364	71	17.2	5	f
10365	11	16.8	24	f
10366	65	16.8	5	f
10366	77	10.4	5	f
10367	34	11.2	36	f
10367	54	5.9	18	f
10367	65	16.8	15	f
10367	77	10.4	7	f
10368	21	8.0	5	f
10368	28	36.4	13	f
10368	57	15.6	25	f
10368	64	26.6	35	f
10369	29	99.0	20	f
10369	56	30.4	18	f
10370	1	14.4	15	f
10370	64	26.6	30	f
10370	74	8.0	20	f
10371	36	15.2	6	f
10372	20	64.8	12	f
10372	38	210.8	40	f
10372	60	27.2	70	f
10372	72	27.8	42	f
10373	58	10.6	80	f
10373	71	17.2	50	f
10374	31	10.0	30	f
10374	58	10.6	15	f
10375	14	18.6	15	f
10375	54	5.9	10	f
10376	31	10.0	42	f
10377	28	36.4	20	f
10377	39	14.4	20	f
10378	71	17.2	6	f
10379	41	7.7	8	f
10379	63	35.1	16	f
10379	65	16.8	20	f
10380	30	20.7	18	f
10380	53	26.2	20	f
10380	60	27.2	6	f
10380	70	12.0	30	f
10381	74	8.0	14	f
10382	5	17.0	32	f
10382	18	50.0	9	f
10382	29	99.0	14	f
10382	33	2.0	60	f
10382	74	8.0	50	f
10383	13	4.8	20	f
10383	50	13.0	15	f
10383	56	30.4	20	f
10384	20	64.8	28	f
10384	60	27.2	15	f
10385	7	24.0	10	f
10385	60	27.2	20	f
10385	68	10.0	8	f
10386	24	3.6	15	f
10386	34	11.2	10	f
10387	24	3.6	15	f
10387	28	36.4	6	f
10387	59	44.0	12	f
10387	71	17.2	15	f
10388	45	7.6	15	f
10388	52	5.6	20	f
10388	53	26.2	40	f
10389	10	24.8	16	f
10389	55	19.2	15	f
10389	62	39.4	20	f
10389	70	12.0	30	f
10390	31	10.0	60	f
10390	35	14.4	40	f
10390	46	9.6	45	f
10390	72	27.8	24	f
10391	13	4.8	18	f
10392	69	28.8	50	f
10393	2	15.2	25	f
10393	14	18.6	42	f
10393	25	11.2	7	f
10393	26	24.9	70	f
10393	31	10.0	32	f
10394	13	4.8	10	f
10394	62	39.4	10	f
10395	46	9.6	28	f
10395	53	26.2	70	f
10395	69	28.8	8	f
10396	23	7.2	40	f
10396	71	17.2	60	f
10396	72	27.8	21	f
10397	21	8.0	10	f
10397	51	42.4	18	f
10398	35	14.4	30	f
10398	55	19.2	120	f
10399	68	10.0	60	f
10399	71	17.2	30	f
10399	76	14.4	35	f
10399	77	10.4	14	f
10400	29	99.0	21	f
10400	35	14.4	35	f
10400	49	16.0	30	f
10401	30	20.7	18	f
10401	56	30.4	70	f
10401	65	16.8	20	f
10401	71	17.2	60	f
10402	23	7.2	60	f
10402	63	35.1	65	f
10403	16	13.9	21	f
10403	48	10.2	70	f
10404	26	24.9	30	f
10404	42	11.2	40	f
10404	49	16.0	30	f
10405	3	8.0	50	f
10406	1	14.4	10	f
10406	21	8.0	30	f
10406	28	36.4	42	f
10406	36	15.2	5	f
10406	40	14.7	2	f
10407	11	16.8	30	f
10407	69	28.8	15	f
10407	71	17.2	15	f
10408	37	20.8	10	f
10408	54	5.9	6	f
10408	62	39.4	35	f
10409	14	18.6	12	f
10409	21	8.0	12	f
10410	33	2.0	49	f
10410	59	44.0	16	f
10411	41	7.7	25	f
10411	44	15.5	40	f
10411	59	44.0	9	f
10412	14	18.6	20	f
10413	1	14.4	24	f
10413	62	39.4	40	f
10413	76	14.4	14	f
10414	19	7.3	18	f
10414	33	2.0	50	f
10415	17	31.2	2	f
10415	33	2.0	20	f
10416	19	7.3	20	f
10416	53	26.2	10	f
10416	57	15.6	20	f
10417	38	210.8	50	f
10417	46	9.6	2	f
10417	68	10.0	36	f
10417	77	10.4	35	f
10418	2	15.2	60	f
10418	47	7.6	55	f
10418	61	22.8	16	f
10418	74	8.0	15	f
10419	60	27.2	60	f
10419	69	28.8	20	f
10420	9	77.6	20	f
10420	13	4.8	2	f
10420	70	12.0	8	f
10420	73	12.0	20	f
10421	19	7.3	4	f
10421	26	24.9	30	f
10421	53	26.2	15	f
10421	77	10.4	10	f
10422	26	24.9	2	f
10423	31	10.0	14	f
10423	59	44.0	20	f
10424	35	14.4	60	f
10424	38	210.8	49	f
10424	68	10.0	30	f
10425	55	19.2	10	f
10425	76	14.4	20	f
10426	56	30.4	5	f
10426	64	26.6	7	f
10427	14	18.6	35	f
10428	46	9.6	20	f
10429	50	13.0	40	f
10429	63	35.1	35	f
10430	17	31.2	45	f
10430	21	8.0	50	f
10430	56	30.4	30	f
10430	59	44.0	70	f
10431	17	31.2	50	f
10431	40	14.7	50	f
10431	47	7.6	30	f
10432	26	24.9	10	f
10432	54	5.9	40	f
10433	56	30.4	28	f
10434	11	16.8	6	f
10434	76	14.4	18	f
10435	2	15.2	10	f
10435	22	16.8	12	f
10435	72	27.8	10	f
10436	46	9.6	5	f
10436	56	30.4	40	f
10436	64	26.6	30	f
10436	75	6.2	24	f
10437	53	26.2	15	f
10438	19	7.3	15	f
10438	34	11.2	20	f
10438	57	15.6	15	f
10439	12	30.4	15	f
10439	16	13.9	16	f
10439	64	26.6	6	f
10439	74	8.0	30	f
10440	2	15.2	45	f
10440	16	13.9	49	f
10440	29	99.0	24	f
10440	61	22.8	90	f
10441	27	35.1	50	f
10442	11	16.8	30	f
10442	54	5.9	80	f
10442	66	13.6	60	f
10443	11	16.8	6	f
10443	28	36.4	12	f
10444	17	31.2	10	f
10444	26	24.9	15	f
10444	35	14.4	8	f
10444	41	7.7	30	f
10445	39	14.4	6	f
10445	54	5.9	15	f
10446	19	7.3	12	f
10446	24	3.6	20	f
10446	31	10.0	3	f
10446	52	5.6	15	f
10447	19	7.3	40	f
10447	65	16.8	35	f
10447	71	17.2	2	f
10448	26	24.9	6	f
10448	40	14.7	20	f
10449	10	24.8	14	f
10449	52	5.6	20	f
10449	62	39.4	35	f
10450	10	24.8	20	f
10450	54	5.9	6	f
10451	55	19.2	120	f
10451	64	26.6	35	f
10451	65	16.8	28	f
10451	77	10.4	55	f
10452	28	36.4	15	f
10452	44	15.5	100	f
10453	48	10.2	15	f
10453	70	12.0	25	f
10454	16	13.9	20	f
10454	33	2.0	20	f
10454	46	9.6	10	f
10455	39	14.4	20	f
10455	53	26.2	50	f
10455	61	22.8	25	f
10455	71	17.2	30	f
10456	21	8.0	40	f
10456	49	16.0	21	f
10457	59	44.0	36	f
10458	26	24.9	30	f
10458	28	36.4	30	f
10458	43	36.8	20	f
10458	56	30.4	15	f
10458	71	17.2	50	f
10459	7	24.0	16	f
10459	46	9.6	20	f
10459	72	27.8	40	f
10460	68	10.0	21	f
10460	75	6.2	4	f
10461	21	8.0	40	f
10461	30	20.7	28	f
10461	55	19.2	60	f
10462	13	4.8	1	f
10462	23	7.2	21	f
10463	19	7.3	21	f
10463	42	11.2	50	f
10464	4	17.6	16	f
10464	43	36.8	3	f
10464	56	30.4	30	f
10464	60	27.2	20	f
10465	24	3.6	25	f
10465	29	99.0	18	f
10465	40	14.7	20	f
10465	45	7.6	30	f
10465	50	13.0	25	f
10466	11	16.8	10	f
10466	46	9.6	5	f
10467	24	3.6	28	f
10467	25	11.2	12	f
10468	30	20.7	8	f
10468	43	36.8	15	f
10469	2	15.2	40	f
10469	16	13.9	35	f
10469	44	15.5	2	f
10470	18	50.0	30	f
10470	23	7.2	15	f
10470	64	26.6	8	f
10471	7	24.0	30	f
10471	56	30.4	20	f
10472	24	3.6	80	f
10472	51	42.4	18	f
10473	33	2.0	12	f
10473	71	17.2	12	f
10474	14	18.6	12	f
10474	28	36.4	18	f
10474	40	14.7	21	f
10474	75	6.2	10	f
10475	31	10.0	35	f
10475	66	13.6	60	f
10475	76	14.4	42	f
10476	55	19.2	2	f
10476	70	12.0	12	f
10477	1	14.4	15	f
10477	21	8.0	21	f
10477	39	14.4	20	f
10478	10	24.8	20	f
10479	38	210.8	30	f
10479	53	26.2	28	f
10479	59	44.0	60	f
10479	64	26.6	30	f
10480	47	7.6	30	f
10480	59	44.0	12	f
10481	49	16.0	24	f
10481	60	27.2	40	f
10482	40	14.7	10	f
10483	34	11.2	35	f
10483	77	10.4	30	f
10484	21	8.0	14	f
10484	40	14.7	10	f
10484	51	42.4	3	f
10485	2	15.2	20	f
10485	3	8.0	20	f
10485	55	19.2	30	f
10485	70	12.0	60	f
10486	11	16.8	5	f
10486	51	42.4	25	f
10486	74	8.0	16	f
10487	19	7.3	5	f
10487	26	24.9	30	f
10487	54	5.9	24	f
10488	59	44.0	30	f
10488	73	12.0	20	f
10489	11	16.8	15	f
10489	16	13.9	18	f
10490	59	44.0	60	f
10490	68	10.0	30	f
10490	75	6.2	36	f
10491	44	15.5	15	f
10491	77	10.4	7	f
10492	25	11.2	60	f
10492	42	11.2	20	f
10493	65	16.8	15	f
10493	66	13.6	10	f
10493	69	28.8	10	f
10494	56	30.4	30	f
10495	23	7.2	10	f
10495	41	7.7	20	f
10495	77	10.4	5	f
10496	31	10.0	20	f
10497	56	30.4	14	f
10497	72	27.8	25	f
10497	77	10.4	25	f
10498	24	4.5	14	f
10498	40	18.4	5	f
10498	42	14.0	30	f
10499	28	45.6	20	f
10499	49	20.0	25	f
10500	15	15.5	12	f
10500	28	45.6	8	f
10501	54	7.45	20	f
10502	45	9.5	21	f
10502	53	32.8	6	f
10502	67	14.0	30	f
10503	14	23.25	70	f
10503	65	21.05	20	f
10504	2	19.0	12	f
10504	21	10.0	12	f
10504	53	32.8	10	f
10504	61	28.5	25	f
10505	62	49.3	3	f
10506	25	14.0	18	f
10506	70	15.0	14	f
10507	43	46.0	15	f
10507	48	12.75	15	f
10508	13	6.0	10	f
10508	39	18.0	10	f
10509	28	45.6	3	f
10510	29	123.79	36	f
10510	75	7.75	36	f
10511	4	22.0	50	f
10511	7	30.0	50	f
10511	8	40.0	10	f
10512	24	4.5	10	f
10512	46	12.0	9	f
10512	47	9.5	6	f
10512	60	34.0	12	f
10513	21	10.0	40	f
10513	32	32.0	50	f
10513	61	28.5	15	f
10514	20	81.0	39	f
10514	28	45.6	35	f
10514	56	38.0	70	f
10514	65	21.05	39	f
10514	75	7.75	50	f
10515	9	97.0	16	f
10515	16	17.45	50	f
10515	27	43.9	120	f
10515	33	2.5	16	f
10515	60	34.0	84	f
10516	18	62.5	25	f
10516	41	9.65	80	f
10516	42	14.0	20	f
10517	52	7.0	6	f
10517	59	55.0	4	f
10517	70	15.0	6	f
10518	24	4.5	5	f
10518	38	263.5	15	f
10518	44	19.45	9	f
10519	10	31.0	16	f
10519	56	38.0	40	f
10519	60	34.0	10	f
10520	24	4.5	8	f
10520	53	32.8	5	f
10521	35	18.0	3	f
10521	41	9.65	10	f
10521	68	12.5	6	f
10522	1	18.0	40	f
10522	8	40.0	24	f
10522	30	25.89	20	f
10522	40	18.4	25	f
10523	17	39.0	25	f
10523	20	81.0	15	f
10523	37	26.0	18	f
10523	41	9.65	6	f
10524	10	31.0	2	f
10524	30	25.89	10	f
10524	43	46.0	60	f
10524	54	7.45	15	f
10525	36	19.0	30	f
10525	40	18.4	15	f
10526	1	18.0	8	f
10526	13	6.0	10	f
10526	56	38.0	30	f
10527	4	22.0	50	f
10527	36	19.0	30	f
10528	11	21.0	3	f
10528	33	2.5	8	f
10528	72	34.8	9	f
10529	55	24.0	14	f
10529	68	12.5	20	f
10529	69	36.0	10	f
10530	17	39.0	40	f
10530	43	46.0	25	f
10530	61	28.5	20	f
10530	76	18.0	50	f
10531	59	55.0	2	f
10532	30	25.89	15	f
10532	66	17.0	24	f
10533	4	22.0	50	f
10533	72	34.8	24	f
10533	73	15.0	24	f
10534	30	25.89	10	f
10534	40	18.4	10	f
10534	54	7.45	10	f
10535	11	21.0	50	f
10535	40	18.4	10	f
10535	57	19.5	5	f
10535	59	55.0	15	f
10536	12	38.0	15	f
10536	31	12.5	20	f
10536	33	2.5	30	f
10536	60	34.0	35	f
10537	31	12.5	30	f
10537	51	53.0	6	f
10537	58	13.25	20	f
10537	72	34.8	21	f
10537	73	15.0	9	f
10538	70	15.0	7	f
10538	72	34.8	1	f
10539	13	6.0	8	f
10539	21	10.0	15	f
10539	33	2.5	15	f
10539	49	20.0	6	f
10540	3	10.0	60	f
10540	26	31.23	40	f
10540	38	263.5	30	f
10540	68	12.5	35	f
10541	24	4.5	35	f
10541	38	263.5	4	f
10541	65	21.05	36	f
10541	71	21.5	9	f
10542	11	21.0	15	f
10542	54	7.45	24	f
10543	12	38.0	30	f
10543	23	9.0	70	f
10544	28	45.6	7	f
10544	67	14.0	7	f
10545	11	21.0	10	f
10546	7	30.0	10	f
10546	35	18.0	30	f
10546	62	49.3	40	f
10547	32	32.0	24	f
10547	36	19.0	60	f
10548	34	14.0	10	f
10548	41	9.65	14	f
10549	31	12.5	55	f
10549	45	9.5	100	f
10549	51	53.0	48	f
10550	17	39.0	8	f
10550	19	9.2	10	f
10550	21	10.0	6	f
10550	61	28.5	10	f
10551	16	17.45	40	f
10551	35	18.0	20	f
10551	44	19.45	40	f
10552	69	36.0	18	f
10552	75	7.75	30	f
10553	11	21.0	15	f
10553	16	17.45	14	f
10553	22	21.0	24	f
10553	31	12.5	30	f
10553	35	18.0	6	f
10554	16	17.45	30	f
10554	23	9.0	20	f
10554	62	49.3	20	f
10554	77	13.0	10	f
10555	14	23.25	30	f
10555	19	9.2	35	f
10555	24	4.5	18	f
10555	51	53.0	20	f
10555	56	38.0	40	f
10556	72	34.8	24	f
10557	64	33.25	30	f
10557	75	7.75	20	f
10558	47	9.5	25	f
10558	51	53.0	20	f
10558	52	7.0	30	f
10558	53	32.8	18	f
10558	73	15.0	3	f
10559	41	9.65	12	f
10559	55	24.0	18	f
10560	30	25.89	20	f
10560	62	49.3	15	f
10561	44	19.45	10	f
10561	51	53.0	50	f
10562	33	2.5	20	f
10562	62	49.3	10	f
10563	36	19.0	25	f
10563	52	7.0	70	f
10564	17	39.0	16	f
10564	31	12.5	6	f
10564	55	24.0	25	f
10565	24	4.5	25	f
10565	64	33.25	18	f
10566	11	21.0	35	f
10566	18	62.5	18	f
10566	76	18.0	10	f
10567	31	12.5	60	f
10567	51	53.0	3	f
10567	59	55.0	40	f
10568	10	31.0	5	f
10569	31	12.5	35	f
10569	76	18.0	30	f
10570	11	21.0	15	f
10570	56	38.0	60	f
10571	14	23.25	11	f
10571	42	14.0	28	f
10572	16	17.45	12	f
10572	32	32.0	10	f
10572	40	18.4	50	f
10572	75	7.75	15	f
10573	17	39.0	18	f
10573	34	14.0	40	f
10573	53	32.8	25	f
10574	33	2.5	14	f
10574	40	18.4	2	f
10574	62	49.3	10	f
10574	64	33.25	6	f
10575	59	55.0	12	f
10575	63	43.9	6	f
10575	72	34.8	30	f
10575	76	18.0	10	f
10576	1	18.0	10	f
10576	31	12.5	20	f
10576	44	19.45	21	f
10577	39	18.0	10	f
10577	75	7.75	20	f
10577	77	13.0	18	f
10578	35	18.0	20	f
10578	57	19.5	6	f
10579	15	15.5	10	f
10579	75	7.75	21	f
10580	14	23.25	15	f
10580	41	9.65	9	f
10580	65	21.05	30	f
10581	75	7.75	50	f
10582	57	19.5	4	f
10582	76	18.0	14	f
10583	29	123.79	10	f
10583	60	34.0	24	f
10583	69	36.0	10	f
10584	31	12.5	50	f
10585	47	9.5	15	f
10586	52	7.0	4	f
10587	26	31.23	6	f
10587	35	18.0	20	f
10587	77	13.0	20	f
10588	18	62.5	40	f
10588	42	14.0	100	f
10589	35	18.0	4	f
10590	1	18.0	20	f
10590	77	13.0	60	f
10591	3	10.0	14	f
10591	7	30.0	10	f
10591	54	7.45	50	f
10592	15	15.5	25	f
10592	26	31.23	5	f
10593	20	81.0	21	f
10593	69	36.0	20	f
10593	76	18.0	4	f
10594	52	7.0	24	f
10594	58	13.25	30	f
10595	35	18.0	30	f
10595	61	28.5	120	f
10595	69	36.0	65	f
10596	56	38.0	5	f
10596	63	43.9	24	f
10596	75	7.75	30	f
10597	24	4.5	35	f
10597	57	19.5	20	f
10597	65	21.05	12	f
10598	27	43.9	50	f
10598	71	21.5	9	f
10599	62	49.3	10	f
10600	54	7.45	4	f
10600	73	15.0	30	f
10601	13	6.0	60	f
10601	59	55.0	35	f
10602	77	13.0	5	f
10603	22	21.0	48	f
10603	49	20.0	25	f
10604	48	12.75	6	f
10604	76	18.0	10	f
10605	16	17.45	30	f
10605	59	55.0	20	f
10605	60	34.0	70	f
10605	71	21.5	15	f
10606	4	22.0	20	f
10606	55	24.0	20	f
10606	62	49.3	10	f
10607	7	30.0	45	f
10607	17	39.0	100	f
10607	33	2.5	14	f
10607	40	18.4	42	f
10607	72	34.8	12	f
10608	56	38.0	28	f
10609	1	18.0	3	f
10609	10	31.0	10	f
10609	21	10.0	6	f
10610	36	19.0	21	f
10611	1	18.0	6	f
10611	2	19.0	10	f
10611	60	34.0	15	f
10612	10	31.0	70	f
10612	36	19.0	55	f
10612	49	20.0	18	f
10612	60	34.0	40	f
10612	76	18.0	80	f
10613	13	6.0	8	f
10613	75	7.75	40	f
10614	11	21.0	14	f
10614	21	10.0	8	f
10614	39	18.0	5	f
10615	55	24.0	5	f
10616	38	263.5	15	f
10616	56	38.0	14	f
10616	70	15.0	15	f
10616	71	21.5	15	f
10617	59	55.0	30	f
10618	6	25.0	70	f
10618	56	38.0	20	f
10618	68	12.5	15	f
10619	21	10.0	42	f
10619	22	21.0	40	f
10620	24	4.5	5	f
10620	52	7.0	5	f
10621	19	9.2	5	f
10621	23	9.0	10	f
10621	70	15.0	20	f
10621	71	21.5	15	f
10622	2	19.0	20	f
10622	68	12.5	18	f
10623	14	23.25	21	f
10623	19	9.2	15	f
10623	21	10.0	25	f
10623	24	4.5	3	f
10623	35	18.0	30	f
10624	28	45.6	10	f
10624	29	123.79	6	f
10624	44	19.45	10	f
10625	14	23.25	3	f
10625	42	14.0	5	f
10625	60	34.0	10	f
10626	53	32.8	12	f
10626	60	34.0	20	f
10626	71	21.5	20	f
10627	62	49.3	15	f
10627	73	15.0	35	f
10628	1	18.0	25	f
10629	29	123.79	20	f
10629	64	33.25	9	f
10630	55	24.0	12	f
10630	76	18.0	35	f
10631	75	7.75	8	f
10632	2	19.0	30	f
10632	33	2.5	20	f
10633	12	38.0	36	f
10633	13	6.0	13	f
10633	26	31.23	35	f
10633	62	49.3	80	f
10634	7	30.0	35	f
10634	18	62.5	50	f
10634	51	53.0	15	f
10634	75	7.75	2	f
10635	4	22.0	10	f
10635	5	21.35	15	f
10635	22	21.0	40	f
10636	4	22.0	25	f
10636	58	13.25	6	f
10637	11	21.0	10	f
10637	50	16.25	25	f
10637	56	38.0	60	f
10638	45	9.5	20	f
10638	65	21.05	21	f
10638	72	34.8	60	f
10639	18	62.5	8	f
10640	69	36.0	20	f
10640	70	15.0	15	f
10641	2	19.0	50	f
10641	40	18.4	60	f
10642	21	10.0	30	f
10642	61	28.5	20	f
10643	28	45.6	15	f
10643	39	18.0	21	f
10643	46	12.0	2	f
10644	18	62.5	4	f
10644	43	46.0	20	f
10644	46	12.0	21	f
10645	18	62.5	20	f
10645	36	19.0	15	f
10646	1	18.0	15	f
10646	10	31.0	18	f
10646	71	21.5	30	f
10646	77	13.0	35	f
10647	19	9.2	30	f
10647	39	18.0	20	f
10648	22	21.0	15	f
10648	24	4.5	15	f
10649	28	45.6	20	f
10649	72	34.8	15	f
10650	30	25.89	30	f
10650	53	32.8	25	f
10650	54	7.45	30	f
10651	19	9.2	12	f
10651	22	21.0	20	f
10652	30	25.89	2	f
10652	42	14.0	20	f
10653	16	17.45	30	f
10653	60	34.0	20	f
10654	4	22.0	12	f
10654	39	18.0	20	f
10654	54	7.45	6	f
10655	41	9.65	20	f
10656	14	23.25	3	f
10656	44	19.45	28	f
10656	47	9.5	6	f
10657	15	15.5	50	f
10657	41	9.65	24	f
10657	46	12.0	45	f
10657	47	9.5	10	f
10657	56	38.0	45	f
10657	60	34.0	30	f
10658	21	10.0	60	f
10658	40	18.4	70	f
10658	60	34.0	55	f
10658	77	13.0	70	f
10659	31	12.5	20	f
10659	40	18.4	24	f
10659	70	15.0	40	f
10660	20	81.0	21	f
10661	39	18.0	3	f
10661	58	13.25	49	f
10662	68	12.5	10	f
10663	40	18.4	30	f
10663	42	14.0	30	f
10663	51	53.0	20	f
10664	10	31.0	24	f
10664	56	38.0	12	f
10664	65	21.05	15	f
10665	51	53.0	20	f
10665	59	55.0	1	f
10665	76	18.0	10	f
10666	29	123.79	36	f
10666	65	21.05	10	f
10667	69	36.0	45	f
10667	71	21.5	14	f
10668	31	12.5	8	f
10668	55	24.0	4	f
10668	64	33.25	15	f
10669	36	19.0	30	f
10670	23	9.0	32	f
10670	46	12.0	60	f
10670	67	14.0	25	f
10670	73	15.0	50	f
10670	75	7.75	25	f
10671	16	17.45	10	f
10671	62	49.3	10	f
10671	65	21.05	12	f
10672	38	263.5	15	f
10672	71	21.5	12	f
10673	16	17.45	3	f
10673	42	14.0	6	f
10673	43	46.0	6	f
10674	23	9.0	5	f
10675	14	23.25	30	f
10675	53	32.8	10	f
10675	58	13.25	30	f
10676	10	31.0	2	f
10676	19	9.2	7	f
10676	44	19.45	21	f
10677	26	31.23	30	f
10677	33	2.5	8	f
10678	12	38.0	100	f
10678	33	2.5	30	f
10678	41	9.65	120	f
10678	54	7.45	30	f
10679	59	55.0	12	f
10680	16	17.45	50	f
10680	31	12.5	20	f
10680	42	14.0	40	f
10681	19	9.2	30	f
10681	21	10.0	12	f
10681	64	33.25	28	f
10682	33	2.5	30	f
10682	66	17.0	4	f
10682	75	7.75	30	f
10683	52	7.0	9	f
10684	40	18.4	20	f
10684	47	9.5	40	f
10684	60	34.0	30	f
10685	10	31.0	20	f
10685	41	9.65	4	f
10685	47	9.5	15	f
10686	17	39.0	30	f
10686	26	31.23	15	f
10687	9	97.0	50	f
10687	29	123.79	10	f
10687	36	19.0	6	f
10688	10	31.0	18	f
10688	28	45.6	60	f
10688	34	14.0	14	f
10689	1	18.0	35	f
10690	56	38.0	20	f
10690	77	13.0	30	f
10691	1	18.0	30	f
10691	29	123.79	40	f
10691	43	46.0	40	f
10691	44	19.45	24	f
10691	62	49.3	48	f
10692	63	43.9	20	f
10693	9	97.0	6	f
10693	54	7.45	60	f
10693	69	36.0	30	f
10693	73	15.0	15	f
10694	7	30.0	90	f
10694	59	55.0	25	f
10694	70	15.0	50	f
10695	8	40.0	10	f
10695	12	38.0	4	f
10695	24	4.5	20	f
10696	17	39.0	20	f
10696	46	12.0	18	f
10697	19	9.2	7	f
10697	35	18.0	9	f
10697	58	13.25	30	f
10697	70	15.0	30	f
10698	11	21.0	15	f
10698	17	39.0	8	f
10698	29	123.79	12	f
10698	65	21.05	65	f
10698	70	15.0	8	f
10699	47	9.5	12	f
10700	1	18.0	5	f
10700	34	14.0	12	f
10700	68	12.5	40	f
10700	71	21.5	60	f
10701	59	55.0	42	f
10701	71	21.5	20	f
10701	76	18.0	35	f
10702	3	10.0	6	f
10702	76	18.0	15	f
10703	2	19.0	5	f
10703	59	55.0	35	f
10703	73	15.0	35	f
10704	4	22.0	6	f
10704	24	4.5	35	f
10704	48	12.75	24	f
10705	31	12.5	20	f
10705	32	32.0	4	f
10706	16	17.45	20	f
10706	43	46.0	24	f
10706	59	55.0	8	f
10707	55	24.0	21	f
10707	57	19.5	40	f
10707	70	15.0	28	f
10708	5	21.35	4	f
10708	36	19.0	5	f
10709	8	40.0	40	f
10709	51	53.0	28	f
10709	60	34.0	10	f
10710	19	9.2	5	f
10710	47	9.5	5	f
10711	19	9.2	12	f
10711	41	9.65	42	f
10711	53	32.8	120	f
10712	53	32.8	3	f
10712	56	38.0	30	f
10713	10	31.0	18	f
10713	26	31.23	30	f
10713	45	9.5	110	f
10713	46	12.0	24	f
10714	2	19.0	30	f
10714	17	39.0	27	f
10714	47	9.5	50	f
10714	56	38.0	18	f
10714	58	13.25	12	f
10715	10	31.0	21	f
10715	71	21.5	30	f
10716	21	10.0	5	f
10716	51	53.0	7	f
10716	61	28.5	10	f
10717	21	10.0	32	f
10717	54	7.45	15	f
10717	69	36.0	25	f
10718	12	38.0	36	f
10718	16	17.45	20	f
10718	36	19.0	40	f
10718	62	49.3	20	f
10719	18	62.5	12	f
10719	30	25.89	3	f
10719	54	7.45	40	f
10720	35	18.0	21	f
10720	71	21.5	8	f
10721	44	19.45	50	f
10722	2	19.0	3	f
10722	31	12.5	50	f
10722	68	12.5	45	f
10722	75	7.75	42	f
10723	26	31.23	15	f
10724	10	31.0	16	f
10724	61	28.5	5	f
10725	41	9.65	12	f
10725	52	7.0	4	f
10725	55	24.0	6	f
10726	4	22.0	25	f
10726	11	21.0	5	f
10727	17	39.0	20	f
10727	56	38.0	10	f
10727	59	55.0	10	f
10728	30	25.89	15	f
10728	40	18.4	6	f
10728	55	24.0	12	f
10728	60	34.0	15	f
10729	1	18.0	50	f
10729	21	10.0	30	f
10729	50	16.25	40	f
10730	16	17.45	15	f
10730	31	12.5	3	f
10730	65	21.05	10	f
10731	21	10.0	40	f
10731	51	53.0	30	f
10732	76	18.0	20	f
10733	14	23.25	16	f
10733	28	45.6	20	f
10733	52	7.0	25	f
10734	6	25.0	30	f
10734	30	25.89	15	f
10734	76	18.0	20	f
10735	61	28.5	20	f
10735	77	13.0	2	f
10736	65	21.05	40	f
10736	75	7.75	20	f
10737	13	6.0	4	f
10737	41	9.65	12	f
10738	16	17.45	3	f
10739	36	19.0	6	f
10739	52	7.0	18	f
10740	28	45.6	5	f
10740	35	18.0	35	f
10740	45	9.5	40	f
10740	56	38.0	14	f
10741	2	19.0	15	f
10742	3	10.0	20	f
10742	60	34.0	50	f
10742	72	34.8	35	f
10743	46	12.0	28	f
10744	40	18.4	50	f
10745	18	62.5	24	f
10745	44	19.45	16	f
10745	59	55.0	45	f
10745	72	34.8	7	f
10746	13	6.0	6	f
10746	42	14.0	28	f
10746	62	49.3	9	f
10746	69	36.0	40	f
10747	31	12.5	8	f
10747	41	9.65	35	f
10747	63	43.9	9	f
10747	69	36.0	30	f
10748	23	9.0	44	f
10748	40	18.4	40	f
10748	56	38.0	28	f
10749	56	38.0	15	f
10749	59	55.0	6	f
10749	76	18.0	10	f
10750	14	23.25	5	f
10750	45	9.5	40	f
10750	59	55.0	25	f
10751	26	31.23	12	f
10751	30	25.89	30	f
10751	50	16.25	20	f
10751	73	15.0	15	f
10752	1	18.0	8	f
10752	69	36.0	3	f
10753	45	9.5	4	f
10753	74	10.0	5	f
10754	40	18.4	3	f
10755	47	9.5	30	f
10755	56	38.0	30	f
10755	57	19.5	14	f
10755	69	36.0	25	f
10756	18	62.5	21	f
10756	36	19.0	20	f
10756	68	12.5	6	f
10756	69	36.0	20	f
10757	34	14.0	30	f
10757	59	55.0	7	f
10757	62	49.3	30	f
10757	64	33.25	24	f
10758	26	31.23	20	f
10758	52	7.0	60	f
10758	70	15.0	40	f
10759	32	32.0	10	f
10760	25	14.0	12	f
10760	27	43.9	40	f
10760	43	46.0	30	f
10761	25	14.0	35	f
10761	75	7.75	18	f
10762	39	18.0	16	f
10762	47	9.5	30	f
10762	51	53.0	28	f
10762	56	38.0	60	f
10763	21	10.0	40	f
10763	22	21.0	6	f
10763	24	4.5	20	f
10764	3	10.0	20	f
10764	39	18.0	130	f
10765	65	21.05	80	f
10766	2	19.0	40	f
10766	7	30.0	35	f
10766	68	12.5	40	f
10767	42	14.0	2	f
10768	22	21.0	4	f
10768	31	12.5	50	f
10768	60	34.0	15	f
10768	71	21.5	12	f
10769	41	9.65	30	f
10769	52	7.0	15	f
10769	61	28.5	20	f
10769	62	49.3	15	f
10770	11	21.0	15	f
10771	71	21.5	16	f
10772	29	123.79	18	f
10772	59	55.0	25	f
10773	17	39.0	33	f
10773	31	12.5	70	f
10773	75	7.75	7	f
10774	31	12.5	2	f
10774	66	17.0	50	f
10775	10	31.0	6	f
10775	67	14.0	3	f
10776	31	12.5	16	f
10776	42	14.0	12	f
10776	45	9.5	27	f
10776	51	53.0	120	f
10777	42	14.0	20	f
10778	41	9.65	10	f
10779	16	17.45	20	f
10779	62	49.3	20	f
10780	70	15.0	35	f
10780	77	13.0	15	f
10781	54	7.45	3	f
10781	56	38.0	20	f
10781	74	10.0	35	f
10782	31	12.5	1	f
10783	31	12.5	10	f
10783	38	263.5	5	f
10784	36	19.0	30	f
10784	39	18.0	2	f
10784	72	34.8	30	f
10785	10	31.0	10	f
10785	75	7.75	10	f
10786	8	40.0	30	f
10786	30	25.89	15	f
10786	75	7.75	42	f
10787	2	19.0	15	f
10787	29	123.79	20	f
10788	19	9.2	50	f
10788	75	7.75	40	f
10789	18	62.5	30	f
10789	35	18.0	15	f
10789	63	43.9	30	f
10789	68	12.5	18	f
10790	7	30.0	3	f
10790	56	38.0	20	f
10791	29	123.79	14	f
10791	41	9.65	20	f
10792	2	19.0	10	f
10792	54	7.45	3	f
10792	68	12.5	15	f
10793	41	9.65	14	f
10793	52	7.0	8	f
10794	14	23.25	15	f
10794	54	7.45	6	f
10795	16	17.45	65	f
10795	17	39.0	35	f
10796	26	31.23	21	f
10796	44	19.45	10	f
10796	64	33.25	35	f
10796	69	36.0	24	f
10797	11	21.0	20	f
10798	62	49.3	2	f
10798	72	34.8	10	f
10799	13	6.0	20	f
10799	24	4.5	20	f
10799	59	55.0	25	f
10800	11	21.0	50	f
10800	51	53.0	10	f
10800	54	7.45	7	f
10801	17	39.0	40	f
10801	29	123.79	20	f
10802	30	25.89	25	f
10802	51	53.0	30	f
10802	55	24.0	60	f
10802	62	49.3	5	f
10803	19	9.2	24	f
10803	25	14.0	15	f
10803	59	55.0	15	f
10804	10	31.0	36	f
10804	28	45.6	24	f
10804	49	20.0	4	f
10805	34	14.0	10	f
10805	38	263.5	10	f
10806	2	19.0	20	f
10806	65	21.05	2	f
10806	74	10.0	15	f
10807	40	18.4	1	f
10808	56	38.0	20	f
10808	76	18.0	50	f
10809	52	7.0	20	f
10810	13	6.0	7	f
10810	25	14.0	5	f
10810	70	15.0	5	f
10811	19	9.2	15	f
10811	23	9.0	18	f
10811	40	18.4	30	f
10812	31	12.5	16	f
10812	72	34.8	40	f
10812	77	13.0	20	f
10813	2	19.0	12	f
10813	46	12.0	35	f
10814	41	9.65	20	f
10814	43	46.0	20	f
10814	48	12.75	8	f
10814	61	28.5	30	f
10815	33	2.5	16	f
10816	38	263.5	30	f
10816	62	49.3	20	f
10817	26	31.23	40	f
10817	38	263.5	30	f
10817	40	18.4	60	f
10817	62	49.3	25	f
10818	32	32.0	20	f
10818	41	9.65	20	f
10819	43	46.0	7	f
10819	75	7.75	20	f
10820	56	38.0	30	f
10821	35	18.0	20	f
10821	51	53.0	6	f
10822	62	49.3	3	f
10822	70	15.0	6	f
10823	11	21.0	20	f
10823	57	19.5	15	f
10823	59	55.0	40	f
10823	77	13.0	15	f
10824	41	9.65	12	f
10824	70	15.0	9	f
10825	26	31.23	12	f
10825	53	32.8	20	f
10826	31	12.5	35	f
10826	57	19.5	15	f
10827	10	31.0	15	f
10827	39	18.0	21	f
10828	20	81.0	5	f
10828	38	263.5	2	f
10829	2	19.0	10	f
10829	8	40.0	20	f
10829	13	6.0	10	f
10829	60	34.0	21	f
10830	6	25.0	6	f
10830	39	18.0	28	f
10830	60	34.0	30	f
10830	68	12.5	24	f
10831	19	9.2	2	f
10831	35	18.0	8	f
10831	38	263.5	8	f
10831	43	46.0	9	f
10832	13	6.0	3	f
10832	25	14.0	10	f
10832	44	19.45	16	f
10832	64	33.25	3	f
10833	7	30.0	20	f
10833	31	12.5	9	f
10833	53	32.8	9	f
10834	29	123.79	8	f
10834	30	25.89	20	f
10835	59	55.0	15	f
10835	77	13.0	2	f
10836	22	21.0	52	f
10836	35	18.0	6	f
10836	57	19.5	24	f
10836	60	34.0	60	f
10836	64	33.25	30	f
10837	13	6.0	6	f
10837	40	18.4	25	f
10837	47	9.5	40	f
10837	76	18.0	21	f
10838	1	18.0	4	f
10838	18	62.5	25	f
10838	36	19.0	50	f
10839	58	13.25	30	f
10839	72	34.8	15	f
10840	25	14.0	6	f
10840	39	18.0	10	f
10841	10	31.0	16	f
10841	56	38.0	30	f
10841	59	55.0	50	f
10841	77	13.0	15	f
10842	11	21.0	15	f
10842	43	46.0	5	f
10842	68	12.5	20	f
10842	70	15.0	12	f
10843	51	53.0	4	f
10844	22	21.0	35	f
10845	23	9.0	70	f
10845	35	18.0	25	f
10845	42	14.0	42	f
10845	58	13.25	60	f
10845	64	33.25	48	f
10846	4	22.0	21	f
10846	70	15.0	30	f
10846	74	10.0	20	f
10847	1	18.0	80	f
10847	19	9.2	12	f
10847	37	26.0	60	f
10847	45	9.5	36	f
10847	60	34.0	45	f
10847	71	21.5	55	f
10848	5	21.35	30	f
10848	9	97.0	3	f
10849	3	10.0	49	f
10849	26	31.23	18	f
10850	25	14.0	20	f
10850	33	2.5	4	f
10850	70	15.0	30	f
10851	2	19.0	5	f
10851	25	14.0	10	f
10851	57	19.5	10	f
10851	59	55.0	42	f
10852	2	19.0	15	f
10852	17	39.0	6	f
10852	62	49.3	50	f
10853	18	62.5	10	f
10854	10	31.0	100	f
10854	13	6.0	65	f
10855	16	17.45	50	f
10855	31	12.5	14	f
10855	56	38.0	24	f
10855	65	21.05	15	f
10856	2	19.0	20	f
10856	42	14.0	20	f
10857	3	10.0	30	f
10857	26	31.23	35	f
10857	29	123.79	10	f
10858	7	30.0	5	f
10858	27	43.9	10	f
10858	70	15.0	4	f
10859	24	4.5	40	f
10859	54	7.45	35	f
10859	64	33.25	30	f
10860	51	53.0	3	f
10860	76	18.0	20	f
10861	17	39.0	42	f
10861	18	62.5	20	f
10861	21	10.0	40	f
10861	33	2.5	35	f
10861	62	49.3	3	f
10862	11	21.0	25	f
10862	52	7.0	8	f
10863	1	18.0	20	f
10863	58	13.25	12	f
10864	35	18.0	4	f
10864	67	14.0	15	f
10865	38	263.5	60	f
10865	39	18.0	80	f
10866	2	19.0	21	f
10866	24	4.5	6	f
10866	30	25.89	40	f
10867	53	32.8	3	f
10868	26	31.23	20	f
10868	35	18.0	30	f
10868	49	20.0	42	f
10869	1	18.0	40	f
10869	11	21.0	10	f
10869	23	9.0	50	f
10869	68	12.5	20	f
10870	35	18.0	3	f
10870	51	53.0	2	f
10871	6	25.0	50	f
10871	16	17.45	12	f
10871	17	39.0	16	f
10872	55	24.0	10	f
10872	62	49.3	20	f
10872	64	33.25	15	f
10872	65	21.05	21	f
10873	21	10.0	20	f
10873	28	45.6	3	f
10874	10	31.0	10	f
10875	19	9.2	25	f
10875	47	9.5	21	f
10875	49	20.0	15	f
10876	46	12.0	21	f
10876	64	33.25	20	f
10877	16	17.45	30	f
10877	18	62.5	25	f
10878	20	81.0	20	f
10879	40	18.4	12	f
10879	65	21.05	10	f
10879	76	18.0	10	f
10880	23	9.0	30	f
10880	61	28.5	30	f
10880	70	15.0	50	f
10881	73	15.0	10	f
10882	42	14.0	25	f
10882	49	20.0	20	f
10882	54	7.45	32	f
10883	24	4.5	8	f
10884	21	10.0	40	f
10884	56	38.0	21	f
10884	65	21.05	12	f
10885	2	19.0	20	f
10885	24	4.5	12	f
10885	70	15.0	30	f
10885	77	13.0	25	f
10886	10	31.0	70	f
10886	31	12.5	35	f
10886	77	13.0	40	f
10887	25	14.0	5	f
10888	2	19.0	20	f
10888	68	12.5	18	f
10889	11	21.0	40	f
10889	38	263.5	40	f
10890	17	39.0	15	f
10890	34	14.0	10	f
10890	41	9.65	14	f
10891	30	25.89	15	f
10892	59	55.0	40	f
10893	8	40.0	30	f
10893	24	4.5	10	f
10893	29	123.79	24	f
10893	30	25.89	35	f
10893	36	19.0	20	f
10894	13	6.0	28	f
10894	69	36.0	50	f
10894	75	7.75	120	f
10895	24	4.5	110	f
10895	39	18.0	45	f
10895	40	18.4	91	f
10895	60	34.0	100	f
10896	45	9.5	15	f
10896	56	38.0	16	f
10897	29	123.79	80	f
10897	30	25.89	36	f
10898	13	6.0	5	f
10899	39	18.0	8	f
10900	70	15.0	3	f
10901	41	9.65	30	f
10901	71	21.5	30	f
10902	55	24.0	30	f
10902	62	49.3	6	f
10903	13	6.0	40	f
10903	65	21.05	21	f
10903	68	12.5	20	f
10904	58	13.25	15	f
10904	62	49.3	35	f
10905	1	18.0	20	f
10906	61	28.5	15	f
10907	75	7.75	14	f
10908	7	30.0	20	f
10908	52	7.0	14	f
10909	7	30.0	12	f
10909	16	17.45	15	f
10909	41	9.65	5	f
10910	19	9.2	12	f
10910	49	20.0	10	f
10910	61	28.5	5	f
10911	1	18.0	10	f
10911	17	39.0	12	f
10911	67	14.0	15	f
10912	11	21.0	40	f
10912	29	123.79	60	f
10913	4	22.0	30	f
10913	33	2.5	40	f
10913	58	13.25	15	f
10914	71	21.5	25	f
10915	17	39.0	10	f
10915	33	2.5	30	f
10915	54	7.45	10	f
10916	16	17.45	6	f
10916	32	32.0	6	f
10916	57	19.5	20	f
10917	30	25.89	1	f
10917	60	34.0	10	f
10918	1	18.0	60	f
10918	60	34.0	25	f
10919	16	17.45	24	f
10919	25	14.0	24	f
10919	40	18.4	20	f
10920	50	16.25	24	f
10921	35	18.0	10	f
10921	63	43.9	40	f
10922	17	39.0	15	f
10922	24	4.5	35	f
10923	42	14.0	10	f
10923	43	46.0	10	f
10923	67	14.0	24	f
10924	10	31.0	20	f
10924	28	45.6	30	f
10924	75	7.75	6	f
10925	36	19.0	25	f
10925	52	7.0	12	f
10926	11	21.0	2	f
10926	13	6.0	10	f
10926	19	9.2	7	f
10926	72	34.8	10	f
10927	20	81.0	5	f
10927	52	7.0	5	f
10927	76	18.0	20	f
10928	47	9.5	5	f
10928	76	18.0	5	f
10929	21	10.0	60	f
10929	75	7.75	49	f
10929	77	13.0	15	f
10930	21	10.0	36	f
10930	27	43.9	25	f
10930	55	24.0	25	f
10930	58	13.25	30	f
10931	13	6.0	42	f
10931	57	19.5	30	f
10932	16	17.45	30	f
10932	62	49.3	14	f
10932	72	34.8	16	f
10932	75	7.75	20	f
10933	53	32.8	2	f
10933	61	28.5	30	f
10934	6	25.0	20	f
10935	1	18.0	21	f
10935	18	62.5	4	f
10935	23	9.0	8	f
10936	36	19.0	30	f
10937	28	45.6	8	f
10937	34	14.0	20	f
10938	13	6.0	20	f
10938	43	46.0	24	f
10938	60	34.0	49	f
10938	71	21.5	35	f
10939	2	19.0	10	f
10939	67	14.0	40	f
10940	7	30.0	8	f
10940	13	6.0	20	f
10941	31	12.5	44	f
10941	62	49.3	30	f
10941	68	12.5	80	f
10941	72	34.8	50	f
10942	49	20.0	28	f
10943	13	6.0	15	f
10943	22	21.0	21	f
10943	46	12.0	15	f
10944	11	21.0	5	f
10944	44	19.45	18	f
10944	56	38.0	18	f
10945	13	6.0	20	f
10945	31	12.5	10	f
10946	10	31.0	25	f
10946	24	4.5	25	f
10946	77	13.0	40	f
10947	59	55.0	4	f
10948	50	16.25	9	f
10948	51	53.0	40	f
10948	55	24.0	4	f
10949	6	25.0	12	f
10949	10	31.0	30	f
10949	17	39.0	6	f
10949	62	49.3	60	f
10950	4	22.0	5	f
10951	33	2.5	15	f
10951	41	9.65	6	f
10951	75	7.75	50	f
10952	6	25.0	16	f
10952	28	45.6	2	f
10953	20	81.0	50	f
10953	31	12.5	50	f
10954	16	17.45	28	f
10954	31	12.5	25	f
10954	45	9.5	30	f
10954	60	34.0	24	f
10955	75	7.75	12	f
10956	21	10.0	12	f
10956	47	9.5	14	f
10956	51	53.0	8	f
10957	30	25.89	30	f
10957	35	18.0	40	f
10957	64	33.25	8	f
10958	5	21.35	20	f
10958	7	30.0	6	f
10958	72	34.8	5	f
10959	75	7.75	20	f
10960	24	4.5	10	f
10960	41	9.65	24	f
10961	52	7.0	6	f
10961	76	18.0	60	f
10962	7	30.0	45	f
10962	13	6.0	77	f
10962	53	32.8	20	f
10962	69	36.0	9	f
10962	76	18.0	44	f
10963	60	34.0	2	f
10964	18	62.5	6	f
10964	38	263.5	5	f
10964	69	36.0	10	f
10965	51	53.0	16	f
10966	37	26.0	8	f
10966	56	38.0	12	f
10966	62	49.3	12	f
10967	19	9.2	12	f
10967	49	20.0	40	f
10968	12	38.0	30	f
10968	24	4.5	30	f
10968	64	33.25	4	f
10969	46	12.0	9	f
10970	52	7.0	40	f
10971	29	123.79	14	f
10972	17	39.0	6	f
10972	33	2.5	7	f
10973	26	31.23	5	f
10973	41	9.65	6	f
10973	75	7.75	10	f
10974	63	43.9	10	f
10975	8	40.0	16	f
10975	75	7.75	10	f
10976	28	45.6	20	f
10977	39	18.0	30	f
10977	47	9.5	30	f
10977	51	53.0	10	f
10977	63	43.9	20	f
10978	8	40.0	20	f
10978	21	10.0	40	f
10978	40	18.4	10	f
10978	44	19.45	6	f
10979	7	30.0	18	f
10979	12	38.0	20	f
10979	24	4.5	80	f
10979	27	43.9	30	f
10979	31	12.5	24	f
10979	63	43.9	35	f
10980	75	7.75	40	f
10981	38	263.5	60	f
10982	7	30.0	20	f
10982	43	46.0	9	f
10983	13	6.0	84	f
10983	57	19.5	15	f
10984	16	17.45	55	f
10984	24	4.5	20	f
10984	36	19.0	40	f
10985	16	17.45	36	f
10985	18	62.5	8	f
10985	32	32.0	35	f
10986	11	21.0	30	f
10986	20	81.0	15	f
10986	76	18.0	10	f
10986	77	13.0	15	f
10987	7	30.0	60	f
10987	43	46.0	6	f
10987	72	34.8	20	f
10988	7	30.0	60	f
10988	62	49.3	40	f
10989	6	25.0	40	f
10989	11	21.0	15	f
10989	41	9.65	4	f
10990	21	10.0	65	f
10990	34	14.0	60	f
10990	55	24.0	65	f
10990	61	28.5	66	f
10991	2	19.0	50	f
10991	70	15.0	20	f
10991	76	18.0	90	f
10992	72	34.8	2	f
10993	29	123.79	50	f
10993	41	9.65	35	f
10994	59	55.0	18	f
10995	51	53.0	20	f
10995	60	34.0	4	f
10996	42	14.0	40	f
10997	32	32.0	50	f
10997	46	12.0	20	f
10997	52	7.0	20	f
10998	24	4.5	12	f
10998	61	28.5	7	f
10998	74	10.0	20	f
10998	75	7.75	30	f
10999	41	9.65	20	f
10999	51	53.0	15	f
10999	77	13.0	21	f
11000	4	22.0	25	f
11000	24	4.5	30	f
11000	77	13.0	30	f
11001	7	30.0	60	f
11001	22	21.0	25	f
11001	46	12.0	25	f
11001	55	24.0	6	f
11002	13	6.0	56	f
11002	35	18.0	15	f
11002	42	14.0	24	f
11002	55	24.0	40	f
11003	1	18.0	4	f
11003	40	18.4	10	f
11003	52	7.0	10	f
11004	26	31.23	6	f
11004	76	18.0	6	f
11005	1	18.0	2	f
11005	59	55.0	10	f
11006	1	18.0	8	f
11006	29	123.79	2	f
11007	8	40.0	30	f
11007	29	123.79	10	f
11007	42	14.0	14	f
11008	28	45.6	70	f
11008	34	14.0	90	f
11008	71	21.5	21	f
11009	24	4.5	12	f
11009	36	19.0	18	f
11009	60	34.0	9	f
11010	7	30.0	20	f
11010	24	4.5	10	f
11011	58	13.25	40	f
11011	71	21.5	20	f
11012	19	9.2	50	f
11012	60	34.0	36	f
11012	71	21.5	60	f
11013	23	9.0	10	f
11013	42	14.0	4	f
11013	45	9.5	20	f
11013	68	12.5	2	f
11014	41	9.65	28	f
11015	30	25.89	15	f
11015	77	13.0	18	f
11016	31	12.5	15	f
11016	36	19.0	16	f
11017	3	10.0	25	f
11017	59	55.0	110	f
11017	70	15.0	30	f
11018	12	38.0	20	f
11018	18	62.5	10	f
11018	56	38.0	5	f
11019	46	12.0	3	f
11019	49	20.0	2	f
11020	10	31.0	24	f
11021	2	19.0	11	f
11021	20	81.0	15	f
11021	26	31.23	63	f
11021	51	53.0	44	f
11021	72	34.8	35	f
11022	19	9.2	35	f
11022	69	36.0	30	f
11023	7	30.0	4	f
11023	43	46.0	30	f
11024	26	31.23	12	f
11024	33	2.5	30	f
11024	65	21.05	21	f
11024	71	21.5	50	f
11025	1	18.0	10	f
11025	13	6.0	20	f
11026	18	62.5	8	f
11026	51	53.0	10	f
11027	24	4.5	30	f
11027	62	49.3	21	f
11028	55	24.0	35	f
11028	59	55.0	24	f
11029	56	38.0	20	f
11029	63	43.9	12	f
11030	2	19.0	100	f
11030	5	21.35	70	f
11030	29	123.79	60	f
11030	59	55.0	100	f
11031	1	18.0	45	f
11031	13	6.0	80	f
11031	24	4.5	21	f
11031	64	33.25	20	f
11031	71	21.5	16	f
11032	36	19.0	35	f
11032	38	263.5	25	f
11032	59	55.0	30	f
11033	53	32.8	70	f
11033	69	36.0	36	f
11034	21	10.0	15	f
11034	44	19.45	12	f
11034	61	28.5	6	f
11035	1	18.0	10	f
11035	35	18.0	60	f
11035	42	14.0	30	f
11035	54	7.45	10	f
11036	13	6.0	7	f
11036	59	55.0	30	f
11037	70	15.0	4	f
11038	40	18.4	5	f
11038	52	7.0	2	f
11038	71	21.5	30	f
11039	28	45.6	20	f
11039	35	18.0	24	f
11039	49	20.0	60	f
11039	57	19.5	28	f
11040	21	10.0	20	f
11041	2	19.0	30	f
11041	63	43.9	30	f
11042	44	19.45	15	f
11042	61	28.5	4	f
11043	11	21.0	10	f
11044	62	49.3	12	f
11045	33	2.5	15	f
11045	51	53.0	24	f
11046	12	38.0	20	f
11046	32	32.0	15	f
11046	35	18.0	18	f
11047	1	18.0	25	f
11047	5	21.35	30	f
11048	68	12.5	42	f
11049	2	19.0	10	f
11049	12	38.0	4	f
11050	76	18.0	50	f
11051	24	4.5	10	f
11052	43	46.0	30	f
11052	61	28.5	10	f
11053	18	62.5	35	f
11053	32	32.0	20	f
11053	64	33.25	25	f
11054	33	2.5	10	f
11054	67	14.0	20	f
11055	24	4.5	15	f
11055	25	14.0	15	f
11055	51	53.0	20	f
11055	57	19.5	20	f
11056	7	30.0	40	f
11056	55	24.0	35	f
11056	60	34.0	50	f
11057	70	15.0	3	f
11058	21	10.0	3	f
11058	60	34.0	21	f
11058	61	28.5	4	f
11059	13	6.0	30	f
11059	17	39.0	12	f
11059	60	34.0	35	f
11060	60	34.0	4	f
11060	77	13.0	10	f
11061	60	34.0	15	f
11062	53	32.8	10	f
11062	70	15.0	12	f
11063	34	14.0	30	f
11063	40	18.4	40	f
11063	41	9.65	30	f
11064	17	39.0	77	f
11064	41	9.65	12	f
11064	53	32.8	25	f
11064	55	24.0	4	f
11064	68	12.5	55	f
11065	30	25.89	4	f
11065	54	7.45	20	f
11066	16	17.45	3	f
11066	19	9.2	42	f
11066	34	14.0	35	f
11067	41	9.65	9	f
11068	28	45.6	8	f
11068	43	46.0	36	f
11068	77	13.0	28	f
11069	39	18.0	20	f
11070	1	18.0	40	f
11070	2	19.0	20	f
11070	16	17.45	30	f
11070	31	12.5	20	f
11071	7	30.0	15	f
11071	13	6.0	10	f
11072	2	19.0	8	f
11072	41	9.65	40	f
11072	50	16.25	22	f
11072	64	33.25	130	f
11073	11	21.0	10	f
11073	24	4.5	20	f
11074	16	17.45	14	f
11075	2	19.0	10	f
11075	46	12.0	30	f
11075	76	18.0	2	f
11076	6	25.0	20	f
11076	14	23.25	20	f
11076	19	9.2	10	f
11077	2	19.0	24	f
11077	3	10.0	4	f
11077	4	22.0	1	f
11077	6	25.0	1	f
11077	7	30.0	1	f
11077	8	40.0	2	f
11077	10	31.0	1	f
11077	12	38.0	2	f
11077	13	6.0	4	f
11077	14	23.25	1	f
11077	16	17.45	2	f
11077	20	81.0	1	f
11077	23	9.0	2	f
11077	32	32.0	1	f
11077	39	18.0	2	f
11077	41	9.65	3	f
11077	46	12.0	3	f
11077	52	7.0	2	f
11077	55	24.0	2	f
11077	60	34.0	2	f
11077	64	33.25	2	f
11077	66	17.0	1	f
11077	73	15.0	2	f
11077	75	7.75	4	f
11077	77	13.0	2	f
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (orderid, customerid, employeeid, orderdate, requireddate, shippeddate, shipvia, freight, shipname, shipaddress, shipcity, shipregion, shippostalcode, shipcountry) FROM stdin;
10248	VINET	5	1996-07-04	1996-08-01	1996-07-16	3	$ 3.238,00	Vins et alcools Chevalier	59 rue de l'Abbaye	Reims	\N	51100	France
10249	TOMSP	6	1996-07-05	1996-08-16	1996-07-10	1	$ 1.161,00	Toms Spezialitäten	Luisenstr. 48	Münster	\N	44087	Germany
10250	HANAR	4	1996-07-08	1996-08-05	1996-07-12	2	$ 6.583,00	Hanari Carnes	Rua do Paço, 67	Rio de Janeiro	RJ	05454-876	Brazil
10251	VICTE	3	1996-07-08	1996-08-05	1996-07-15	1	$ 4.134,00	Victuailles en stock	2, rue du Commerce	Lyon	\N	69004	France
10252	SUPRD	4	1996-07-09	1996-08-06	1996-07-11	2	$ 513,00	Suprêmes délices	Boulevard Tirou, 255	Charleroi	\N	B-6000	Belgium
10253	HANAR	3	1996-07-10	1996-07-24	1996-07-16	2	$ 5.817,00	Hanari Carnes	Rua do Paço, 67	Rio de Janeiro	RJ	05454-876	Brazil
10254	CHOPS	5	1996-07-11	1996-08-08	1996-07-23	2	$ 2.298,00	Chop-suey Chinese	Hauptstr. 31	Bern	\N	3012	Switzerland
10255	RICSU	9	1996-07-12	1996-08-09	1996-07-15	3	$ 14.833,00	Richter Supermarkt	Starenweg 5	Genève	\N	1204	Switzerland
10256	WELLI	3	1996-07-15	1996-08-12	1996-07-17	2	$ 1.397,00	Wellington Importadora	Rua do Mercado, 12	Resende	SP	08737-363	Brazil
10257	HILAA	4	1996-07-16	1996-08-13	1996-07-22	3	$ 8.191,00	HILARION-Abastos	Carrera 22 con Ave. Carlos Soublette #8-35	San Cristóbal	Táchira	5022	Venezuela
10258	ERNSH	1	1996-07-17	1996-08-14	1996-07-23	1	$ 14.051,00	Ernst Handel	Kirchgasse 6	Graz	\N	8010	Austria
10259	CENTC	4	1996-07-18	1996-08-15	1996-07-25	3	$ 325,00	Centro comercial Moctezuma	Sierras de Granada 9993	México D.F.	\N	5022	Mexico
10260	OTTIK	4	1996-07-19	1996-08-16	1996-07-29	1	$ 5.509,00	Ottilies Käseladen	Mehrheimerstr. 369	Köln	\N	50739	Germany
10261	QUEDE	4	1996-07-19	1996-08-16	1996-07-30	2	$ 305,00	Que Delícia	Rua da Panificadora, 12	Rio de Janeiro	RJ	02389-673	Brazil
10262	RATTC	8	1996-07-22	1996-08-19	1996-07-25	3	$ 4.829,00	Rattlesnake Canyon Grocery	2817 Milton Dr.	Albuquerque	NM	87110	USA
10263	ERNSH	9	1996-07-23	1996-08-20	1996-07-31	3	$ 14.606,00	Ernst Handel	Kirchgasse 6	Graz	\N	8010	Austria
10264	FOLKO	6	1996-07-24	1996-08-21	1996-08-23	3	$ 367,00	Folk och fä HB	Åkergatan 24	Bräcke	\N	S-844 67	Sweden
10265	BLONP	2	1996-07-25	1996-08-22	1996-08-12	1	$ 5.528,00	Blondel père et fils	24, place Kléber	Strasbourg	\N	67000	France
10266	WARTH	3	1996-07-26	1996-09-06	1996-07-31	3	$ 2.573,00	Wartian Herkku	Torikatu 38	Oulu	\N	90110	Finland
10267	FRANK	4	1996-07-29	1996-08-26	1996-08-06	1	$ 20.858,00	Frankenversand	Berliner Platz 43	München	\N	80805	Germany
10268	GROSR	8	1996-07-30	1996-08-27	1996-08-02	3	$ 6.629,00	GROSELLA-Restaurante	5ª Ave. Los Palos Grandes	Caracas	DF	1081	Venezuela
10269	WHITC	5	1996-07-31	1996-08-14	1996-08-09	1	$ 456,00	White Clover Markets	1029 - 12th Ave. S.	Seattle	WA	98124	USA
10270	WARTH	1	1996-08-01	1996-08-29	1996-08-02	1	$ 13.654,00	Wartian Herkku	Torikatu 38	Oulu	\N	90110	Finland
10271	SPLIR	6	1996-08-01	1996-08-29	1996-08-30	2	$ 454,00	Split Rail Beer & Ale	P.O. Box 555	Lander	WY	82520	USA
10272	RATTC	6	1996-08-02	1996-08-30	1996-08-06	2	$ 9.803,00	Rattlesnake Canyon Grocery	2817 Milton Dr.	Albuquerque	NM	87110	USA
10273	QUICK	3	1996-08-05	1996-09-02	1996-08-12	3	$ 7.607,00	QUICK-Stop	Taucherstraße 10	Cunewalde	\N	1307	Germany
10274	VINET	6	1996-08-06	1996-09-03	1996-08-16	1	$ 601,00	Vins et alcools Chevalier	59 rue de l'Abbaye	Reims	\N	51100	France
10275	MAGAA	1	1996-08-07	1996-09-04	1996-08-09	1	$ 2.693,00	Magazzini Alimentari Riuniti	Via Ludovico il Moro 22	Bergamo	\N	24100	Italy
10276	TORTU	8	1996-08-08	1996-08-22	1996-08-14	3	$ 1.384,00	Tortuga Restaurante	Avda. Azteca 123	México D.F.	\N	5033	Mexico
10277	MORGK	2	1996-08-09	1996-09-06	1996-08-13	3	$ 12.577,00	Morgenstern Gesundkost	Heerstr. 22	Leipzig	\N	4179	Germany
10278	BERGS	8	1996-08-12	1996-09-09	1996-08-16	2	$ 9.269,00	Berglunds snabbköp	Berguvsvägen  8	Luleå	\N	S-958 22	Sweden
10279	LEHMS	8	1996-08-13	1996-09-10	1996-08-16	2	$ 2.583,00	Lehmanns Marktstand	Magazinweg 7	Frankfurt a.M.	\N	60528	Germany
10280	BERGS	2	1996-08-14	1996-09-11	1996-09-12	1	$ 898,00	Berglunds snabbköp	Berguvsvägen  8	Luleå	\N	S-958 22	Sweden
10281	ROMEY	4	1996-08-14	1996-08-28	1996-08-21	1	$ 294,00	Romero y tomillo	Gran Vía, 1	Madrid	\N	28001	Spain
10282	ROMEY	4	1996-08-15	1996-09-12	1996-08-21	1	$ 1.269,00	Romero y tomillo	Gran Vía, 1	Madrid	\N	28001	Spain
10283	LILAS	3	1996-08-16	1996-09-13	1996-08-23	3	$ 8.481,00	LILA-Supermercado	Carrera 52 con Ave. Bolívar #65-98 Llano Largo	Barquisimeto	Lara	3508	Venezuela
10284	LEHMS	4	1996-08-19	1996-09-16	1996-08-27	1	$ 7.656,00	Lehmanns Marktstand	Magazinweg 7	Frankfurt a.M.	\N	60528	Germany
10285	QUICK	1	1996-08-20	1996-09-17	1996-08-26	2	$ 7.683,00	QUICK-Stop	Taucherstraße 10	Cunewalde	\N	1307	Germany
10286	QUICK	8	1996-08-21	1996-09-18	1996-08-30	3	$ 22.924,00	QUICK-Stop	Taucherstraße 10	Cunewalde	\N	1307	Germany
10287	RICAR	8	1996-08-22	1996-09-19	1996-08-28	3	$ 1.276,00	Ricardo Adocicados	Av. Copacabana, 267	Rio de Janeiro	RJ	02389-890	Brazil
10288	REGGC	4	1996-08-23	1996-09-20	1996-09-03	1	$ 745,00	Reggiani Caseifici	Strada Provinciale 124	Reggio Emilia	\N	42100	Italy
10289	BSBEV	7	1996-08-26	1996-09-23	1996-08-28	3	$ 2.277,00	B's Beverages	Fauntleroy Circus	London	\N	EC2 5NT	UK
10290	COMMI	8	1996-08-27	1996-09-24	1996-09-03	1	$ 797,00	Comércio Mineiro	Av. dos Lusíadas, 23	Sao Paulo	SP	05432-043	Brazil
10291	QUEDE	6	1996-08-27	1996-09-24	1996-09-04	2	$ 64,00	Que Delícia	Rua da Panificadora, 12	Rio de Janeiro	RJ	02389-673	Brazil
10292	TRADH	1	1996-08-28	1996-09-25	1996-09-02	2	$ 135,00	Tradiçao Hipermercados	Av. Inês de Castro, 414	Sao Paulo	SP	05634-030	Brazil
10293	TORTU	1	1996-08-29	1996-09-26	1996-09-11	3	$ 2.118,00	Tortuga Restaurante	Avda. Azteca 123	México D.F.	\N	5033	Mexico
10294	RATTC	4	1996-08-30	1996-09-27	1996-09-05	2	$ 14.726,00	Rattlesnake Canyon Grocery	2817 Milton Dr.	Albuquerque	NM	87110	USA
10295	VINET	2	1996-09-02	1996-09-30	1996-09-10	2	$ 115,00	Vins et alcools Chevalier	59 rue de l'Abbaye	Reims	\N	51100	France
10296	LILAS	6	1996-09-03	1996-10-01	1996-09-11	1	$ 12,00	LILA-Supermercado	Carrera 52 con Ave. Bolívar #65-98 Llano Largo	Barquisimeto	Lara	3508	Venezuela
10297	BLONP	5	1996-09-04	1996-10-16	1996-09-10	2	$ 574,00	Blondel père et fils	24, place Kléber	Strasbourg	\N	67000	France
10298	HUNGO	6	1996-09-05	1996-10-03	1996-09-11	2	$ 16.822,00	Hungry Owl All-Night Grocers	8 Johnstown Road	Cork	Co. Cork	\N	Ireland
10299	RICAR	4	1996-09-06	1996-10-04	1996-09-13	2	$ 2.976,00	Ricardo Adocicados	Av. Copacabana, 267	Rio de Janeiro	RJ	02389-890	Brazil
10300	MAGAA	2	1996-09-09	1996-10-07	1996-09-18	2	$ 1.768,00	Magazzini Alimentari Riuniti	Via Ludovico il Moro 22	Bergamo	\N	24100	Italy
10301	WANDK	8	1996-09-09	1996-10-07	1996-09-17	2	$ 4.508,00	Die Wandernde Kuh	Adenauerallee 900	Stuttgart	\N	70563	Germany
10302	SUPRD	4	1996-09-10	1996-10-08	1996-10-09	2	$ 627,00	Suprêmes délices	Boulevard Tirou, 255	Charleroi	\N	B-6000	Belgium
10303	GODOS	7	1996-09-11	1996-10-09	1996-09-18	2	$ 10.783,00	Godos Cocina Típica	C/ Romero, 33	Sevilla	\N	41101	Spain
10304	TORTU	1	1996-09-12	1996-10-10	1996-09-17	2	$ 6.379,00	Tortuga Restaurante	Avda. Azteca 123	México D.F.	\N	5033	Mexico
10305	OLDWO	8	1996-09-13	1996-10-11	1996-10-09	3	$ 25.762,00	Old World Delicatessen	2743 Bering St.	Anchorage	AK	99508	USA
10306	ROMEY	1	1996-09-16	1996-10-14	1996-09-23	3	$ 756,00	Romero y tomillo	Gran Vía, 1	Madrid	\N	28001	Spain
10307	LONEP	2	1996-09-17	1996-10-15	1996-09-25	2	$ 56,00	Lonesome Pine Restaurant	89 Chiaroscuro Rd.	Portland	OR	97219	USA
10308	ANATR	7	1996-09-18	1996-10-16	1996-09-24	3	$ 161,00	Ana Trujillo Emparedados y helados	Avda. de la Constitución 2222	México D.F.	\N	5021	Mexico
10309	HUNGO	3	1996-09-19	1996-10-17	1996-10-23	1	$ 473,00	Hungry Owl All-Night Grocers	8 Johnstown Road	Cork	Co. Cork	\N	Ireland
10310	THEBI	8	1996-09-20	1996-10-18	1996-09-27	2	$ 1.752,00	The Big Cheese	89 Jefferson Way Suite 2	Portland	OR	97201	USA
10311	DUMON	1	1996-09-20	1996-10-04	1996-09-26	3	$ 2.469,00	Du monde entier	67, rue des Cinquante Otages	Nantes	\N	44000	France
10312	WANDK	2	1996-09-23	1996-10-21	1996-10-03	2	$ 4.026,00	Die Wandernde Kuh	Adenauerallee 900	Stuttgart	\N	70563	Germany
10313	QUICK	2	1996-09-24	1996-10-22	1996-10-04	2	$ 196,00	QUICK-Stop	Taucherstraße 10	Cunewalde	\N	1307	Germany
10314	RATTC	1	1996-09-25	1996-10-23	1996-10-04	2	$ 7.416,00	Rattlesnake Canyon Grocery	2817 Milton Dr.	Albuquerque	NM	87110	USA
10315	ISLAT	4	1996-09-26	1996-10-24	1996-10-03	2	$ 4.176,00	Island Trading	Garden House Crowther Way	Cowes	Isle of Wight	PO31 7PJ	UK
10316	RATTC	1	1996-09-27	1996-10-25	1996-10-08	3	$ 15.015,00	Rattlesnake Canyon Grocery	2817 Milton Dr.	Albuquerque	NM	87110	USA
10317	LONEP	6	1996-09-30	1996-10-28	1996-10-10	1	$ 1.269,00	Lonesome Pine Restaurant	89 Chiaroscuro Rd.	Portland	OR	97219	USA
10318	ISLAT	8	1996-10-01	1996-10-29	1996-10-04	2	$ 473,00	Island Trading	Garden House Crowther Way	Cowes	Isle of Wight	PO31 7PJ	UK
10319	TORTU	7	1996-10-02	1996-10-30	1996-10-11	3	$ 645,00	Tortuga Restaurante	Avda. Azteca 123	México D.F.	\N	5033	Mexico
10320	WARTH	5	1996-10-03	1996-10-17	1996-10-18	3	$ 3.457,00	Wartian Herkku	Torikatu 38	Oulu	\N	90110	Finland
10321	ISLAT	3	1996-10-03	1996-10-31	1996-10-11	2	$ 343,00	Island Trading	Garden House Crowther Way	Cowes	Isle of Wight	PO31 7PJ	UK
10322	PERIC	7	1996-10-04	1996-11-01	1996-10-23	3	$ 4,00	Pericles Comidas clásicas	Calle Dr. Jorge Cash 321	México D.F.	\N	5033	Mexico
10323	KOENE	4	1996-10-07	1996-11-04	1996-10-14	1	$ 488,00	Königlich Essen	Maubelstr. 90	Brandenburg	\N	14776	Germany
10324	SAVEA	9	1996-10-08	1996-11-05	1996-10-10	1	$ 21.427,00	Save-a-lot Markets	187 Suffolk Ln.	Boise	ID	83720	USA
10325	KOENE	1	1996-10-09	1996-10-23	1996-10-14	3	$ 6.486,00	Königlich Essen	Maubelstr. 90	Brandenburg	\N	14776	Germany
10326	BOLID	4	1996-10-10	1996-11-07	1996-10-14	2	$ 7.792,00	Bólido Comidas preparadas	C/ Araquil, 67	Madrid	\N	28023	Spain
10327	FOLKO	2	1996-10-11	1996-11-08	1996-10-14	1	$ 6.336,00	Folk och fä HB	Åkergatan 24	Bräcke	\N	S-844 67	Sweden
10328	FURIB	4	1996-10-14	1996-11-11	1996-10-17	3	$ 8.703,00	Furia Bacalhau e Frutos do Mar	Jardim das rosas n. 32	Lisboa	\N	1675	Portugal
10329	SPLIR	4	1996-10-15	1996-11-26	1996-10-23	2	$ 19.167,00	Split Rail Beer & Ale	P.O. Box 555	Lander	WY	82520	USA
10330	LILAS	3	1996-10-16	1996-11-13	1996-10-28	1	$ 1.275,00	LILA-Supermercado	Carrera 52 con Ave. Bolívar #65-98 Llano Largo	Barquisimeto	Lara	3508	Venezuela
10331	BONAP	9	1996-10-16	1996-11-27	1996-10-21	1	$ 1.019,00	Bon app'	12, rue des Bouchers	Marseille	\N	13008	France
10332	MEREP	3	1996-10-17	1996-11-28	1996-10-21	2	$ 5.284,00	Mère Paillarde	43 rue St. Laurent	Montréal	Québec	H1J 1C3	Canada
10333	WARTH	5	1996-10-18	1996-11-15	1996-10-25	3	$ 59,00	Wartian Herkku	Torikatu 38	Oulu	\N	90110	Finland
10334	VICTE	8	1996-10-21	1996-11-18	1996-10-28	2	$ 856,00	Victuailles en stock	2, rue du Commerce	Lyon	\N	69004	France
10335	HUNGO	7	1996-10-22	1996-11-19	1996-10-24	2	$ 4.211,00	Hungry Owl All-Night Grocers	8 Johnstown Road	Cork	Co. Cork	\N	Ireland
10336	PRINI	7	1996-10-23	1996-11-20	1996-10-25	2	$ 1.551,00	Princesa Isabel Vinhos	Estrada da saúde n. 58	Lisboa	\N	1756	Portugal
10337	FRANK	4	1996-10-24	1996-11-21	1996-10-29	3	$ 10.826,00	Frankenversand	Berliner Platz 43	München	\N	80805	Germany
10338	OLDWO	4	1996-10-25	1996-11-22	1996-10-29	3	$ 8.421,00	Old World Delicatessen	2743 Bering St.	Anchorage	AK	99508	USA
10339	MEREP	2	1996-10-28	1996-11-25	1996-11-04	2	$ 1.566,00	Mère Paillarde	43 rue St. Laurent	Montréal	Québec	H1J 1C3	Canada
10340	BONAP	1	1996-10-29	1996-11-26	1996-11-08	3	$ 16.631,00	Bon app'	12, rue des Bouchers	Marseille	\N	13008	France
10341	SIMOB	7	1996-10-29	1996-11-26	1996-11-05	3	$ 2.678,00	Simons bistro	Vinbæltet 34	Kobenhavn	\N	1734	Denmark
10342	FRANK	4	1996-10-30	1996-11-13	1996-11-04	2	$ 5.483,00	Frankenversand	Berliner Platz 43	München	\N	80805	Germany
10343	LEHMS	4	1996-10-31	1996-11-28	1996-11-06	1	$ 11.037,00	Lehmanns Marktstand	Magazinweg 7	Frankfurt a.M.	\N	60528	Germany
10344	WHITC	4	1996-11-01	1996-11-29	1996-11-05	2	$ 2.329,00	White Clover Markets	1029 - 12th Ave. S.	Seattle	WA	98124	USA
10345	QUICK	2	1996-11-04	1996-12-02	1996-11-11	2	$ 24.906,00	QUICK-Stop	Taucherstraße 10	Cunewalde	\N	1307	Germany
10346	RATTC	3	1996-11-05	1996-12-17	1996-11-08	3	$ 14.208,00	Rattlesnake Canyon Grocery	2817 Milton Dr.	Albuquerque	NM	87110	USA
10347	FAMIA	4	1996-11-06	1996-12-04	1996-11-08	3	$ 31,00	Familia Arquibaldo	Rua Orós, 92	Sao Paulo	SP	05442-030	Brazil
10348	WANDK	4	1996-11-07	1996-12-05	1996-11-15	2	$ 78,00	Die Wandernde Kuh	Adenauerallee 900	Stuttgart	\N	70563	Germany
10349	SPLIR	7	1996-11-08	1996-12-06	1996-11-15	1	$ 863,00	Split Rail Beer & Ale	P.O. Box 555	Lander	WY	82520	USA
10350	LAMAI	6	1996-11-11	1996-12-09	1996-12-03	2	$ 6.419,00	La maison d'Asie	1 rue Alsace-Lorraine	Toulouse	\N	31000	France
10351	ERNSH	1	1996-11-11	1996-12-09	1996-11-20	1	$ 16.233,00	Ernst Handel	Kirchgasse 6	Graz	\N	8010	Austria
10352	FURIB	3	1996-11-12	1996-11-26	1996-11-18	3	$ 13,00	Furia Bacalhau e Frutos do Mar	Jardim das rosas n. 32	Lisboa	\N	1675	Portugal
10353	PICCO	7	1996-11-13	1996-12-11	1996-11-25	3	$ 36.063,00	Piccolo und mehr	Geislweg 14	Salzburg	\N	5020	Austria
10354	PERIC	8	1996-11-14	1996-12-12	1996-11-20	3	$ 538,00	Pericles Comidas clásicas	Calle Dr. Jorge Cash 321	México D.F.	\N	5033	Mexico
10355	AROUT	6	1996-11-15	1996-12-13	1996-11-20	1	$ 4.195,00	Around the Horn	Brook Farm Stratford St. Mary	Colchester	Essex	CO7 6JX	UK
10356	WANDK	6	1996-11-18	1996-12-16	1996-11-27	2	$ 3.671,00	Die Wandernde Kuh	Adenauerallee 900	Stuttgart	\N	70563	Germany
10357	LILAS	1	1996-11-19	1996-12-17	1996-12-02	3	$ 3.488,00	LILA-Supermercado	Carrera 52 con Ave. Bolívar #65-98 Llano Largo	Barquisimeto	Lara	3508	Venezuela
10358	LAMAI	5	1996-11-20	1996-12-18	1996-11-27	1	$ 1.964,00	La maison d'Asie	1 rue Alsace-Lorraine	Toulouse	\N	31000	France
10359	SEVES	5	1996-11-21	1996-12-19	1996-11-26	3	$ 28.843,00	Seven Seas Imports	90 Wadhurst Rd.	London	\N	OX15 4NB	UK
10360	BLONP	4	1996-11-22	1996-12-20	1996-12-02	3	$ 1.317,00	Blondel père et fils	24, place Kléber	Strasbourg	\N	67000	France
10361	QUICK	1	1996-11-22	1996-12-20	1996-12-03	2	$ 18.317,00	QUICK-Stop	Taucherstraße 10	Cunewalde	\N	1307	Germany
10362	BONAP	3	1996-11-25	1996-12-23	1996-11-28	1	$ 9.604,00	Bon app'	12, rue des Bouchers	Marseille	\N	13008	France
10363	DRACD	4	1996-11-26	1996-12-24	1996-12-04	3	$ 3.054,00	Drachenblut Delikatessen	Walserweg 21	Aachen	\N	52066	Germany
10364	EASTC	1	1996-11-26	1997-01-07	1996-12-04	1	$ 7.197,00	Eastern Connection	35 King George	London	\N	WX3 6FW	UK
10365	ANTON	3	1996-11-27	1996-12-25	1996-12-02	2	$ 220,00	Antonio Moreno Taquería	Mataderos  2312	México D.F.	\N	5023	Mexico
10366	GALED	8	1996-11-28	1997-01-09	1996-12-30	2	$ 1.014,00	Galería del gastronómo	Rambla de Cataluña, 23	Barcelona	\N	8022	Spain
10367	VAFFE	7	1996-11-28	1996-12-26	1996-12-02	3	$ 1.355,00	Vaffeljernet	Smagsloget 45	Århus	\N	8200	Denmark
10368	ERNSH	2	1996-11-29	1996-12-27	1996-12-02	2	$ 10.195,00	Ernst Handel	Kirchgasse 6	Graz	\N	8010	Austria
10369	SPLIR	8	1996-12-02	1996-12-30	1996-12-09	2	$ 19.568,00	Split Rail Beer & Ale	P.O. Box 555	Lander	WY	82520	USA
10370	CHOPS	6	1996-12-03	1996-12-31	1996-12-27	2	$ 117,00	Chop-suey Chinese	Hauptstr. 31	Bern	\N	3012	Switzerland
10371	LAMAI	1	1996-12-03	1996-12-31	1996-12-24	1	$ 45,00	La maison d'Asie	1 rue Alsace-Lorraine	Toulouse	\N	31000	France
10372	QUEEN	5	1996-12-04	1997-01-01	1996-12-09	2	$ 89.078,00	Queen Cozinha	Alameda dos Canàrios, 891	Sao Paulo	SP	05487-020	Brazil
10373	HUNGO	4	1996-12-05	1997-01-02	1996-12-11	3	$ 12.412,00	Hungry Owl All-Night Grocers	8 Johnstown Road	Cork	Co. Cork	\N	Ireland
10374	WOLZA	1	1996-12-05	1997-01-02	1996-12-09	3	$ 394,00	Wolski Zajazd	ul. Filtrowa 68	Warszawa	\N	01-012	Poland
10375	HUNGC	3	1996-12-06	1997-01-03	1996-12-09	2	$ 2.012,00	Hungry Coyote Import Store	City Center Plaza 516 Main St.	Elgin	OR	97827	USA
10376	MEREP	1	1996-12-09	1997-01-06	1996-12-13	2	$ 2.039,00	Mère Paillarde	43 rue St. Laurent	Montréal	Québec	H1J 1C3	Canada
10377	SEVES	1	1996-12-09	1997-01-06	1996-12-13	3	$ 2.221,00	Seven Seas Imports	90 Wadhurst Rd.	London	\N	OX15 4NB	UK
10378	FOLKO	5	1996-12-10	1997-01-07	1996-12-19	3	$ 544,00	Folk och fä HB	Åkergatan 24	Bräcke	\N	S-844 67	Sweden
10379	QUEDE	2	1996-12-11	1997-01-08	1996-12-13	1	$ 4.503,00	Que Delícia	Rua da Panificadora, 12	Rio de Janeiro	RJ	02389-673	Brazil
10380	HUNGO	8	1996-12-12	1997-01-09	1997-01-16	3	$ 3.503,00	Hungry Owl All-Night Grocers	8 Johnstown Road	Cork	Co. Cork	\N	Ireland
10381	LILAS	3	1996-12-12	1997-01-09	1996-12-13	3	$ 799,00	LILA-Supermercado	Carrera 52 con Ave. Bolívar #65-98 Llano Largo	Barquisimeto	Lara	3508	Venezuela
10382	ERNSH	4	1996-12-13	1997-01-10	1996-12-16	1	$ 9.477,00	Ernst Handel	Kirchgasse 6	Graz	\N	8010	Austria
10383	AROUT	8	1996-12-16	1997-01-13	1996-12-18	3	$ 3.424,00	Around the Horn	Brook Farm Stratford St. Mary	Colchester	Essex	CO7 6JX	UK
10384	BERGS	3	1996-12-16	1997-01-13	1996-12-20	3	$ 16.864,00	Berglunds snabbköp	Berguvsvägen  8	Luleå	\N	S-958 22	Sweden
10385	SPLIR	1	1996-12-17	1997-01-14	1996-12-23	2	$ 3.096,00	Split Rail Beer & Ale	P.O. Box 555	Lander	WY	82520	USA
10386	FAMIA	9	1996-12-18	1997-01-01	1996-12-25	3	$ 1.399,00	Familia Arquibaldo	Rua Orós, 92	Sao Paulo	SP	05442-030	Brazil
10387	SANTG	1	1996-12-18	1997-01-15	1996-12-20	2	$ 9.363,00	Santé Gourmet	Erling Skakkes gate 78	Stavern	\N	4110	Norway
10388	SEVES	2	1996-12-19	1997-01-16	1996-12-20	1	$ 3.486,00	Seven Seas Imports	90 Wadhurst Rd.	London	\N	OX15 4NB	UK
10389	BOTTM	4	1996-12-20	1997-01-17	1996-12-24	2	$ 4.742,00	Bottom-Dollar Markets	23 Tsawassen Blvd.	Tsawassen	BC	T2F 8M4	Canada
10390	ERNSH	6	1996-12-23	1997-01-20	1996-12-26	1	$ 12.638,00	Ernst Handel	Kirchgasse 6	Graz	\N	8010	Austria
10391	DRACD	3	1996-12-23	1997-01-20	1996-12-31	3	$ 545,00	Drachenblut Delikatessen	Walserweg 21	Aachen	\N	52066	Germany
10392	PICCO	2	1996-12-24	1997-01-21	1997-01-01	3	$ 12.246,00	Piccolo und mehr	Geislweg 14	Salzburg	\N	5020	Austria
10393	SAVEA	1	1996-12-25	1997-01-22	1997-01-03	3	$ 12.656,00	Save-a-lot Markets	187 Suffolk Ln.	Boise	ID	83720	USA
10394	HUNGC	1	1996-12-25	1997-01-22	1997-01-03	3	$ 3.034,00	Hungry Coyote Import Store	City Center Plaza 516 Main St.	Elgin	OR	97827	USA
10395	HILAA	6	1996-12-26	1997-01-23	1997-01-03	1	$ 18.441,00	HILARION-Abastos	Carrera 22 con Ave. Carlos Soublette #8-35	San Cristóbal	Táchira	5022	Venezuela
10396	FRANK	1	1996-12-27	1997-01-10	1997-01-06	3	$ 13.535,00	Frankenversand	Berliner Platz 43	München	\N	80805	Germany
10397	PRINI	5	1996-12-27	1997-01-24	1997-01-02	1	$ 6.026,00	Princesa Isabel Vinhos	Estrada da saúde n. 58	Lisboa	\N	1756	Portugal
10398	SAVEA	2	1996-12-30	1997-01-27	1997-01-09	3	$ 8.916,00	Save-a-lot Markets	187 Suffolk Ln.	Boise	ID	83720	USA
10399	VAFFE	8	1996-12-31	1997-01-14	1997-01-08	3	$ 2.736,00	Vaffeljernet	Smagsloget 45	Århus	\N	8200	Denmark
10400	EASTC	1	1997-01-01	1997-01-29	1997-01-16	3	$ 8.393,00	Eastern Connection	35 King George	London	\N	WX3 6FW	UK
10401	RATTC	1	1997-01-01	1997-01-29	1997-01-10	1	$ 1.251,00	Rattlesnake Canyon Grocery	2817 Milton Dr.	Albuquerque	NM	87110	USA
10402	ERNSH	8	1997-01-02	1997-02-13	1997-01-10	2	$ 6.788,00	Ernst Handel	Kirchgasse 6	Graz	\N	8010	Austria
10403	ERNSH	4	1997-01-03	1997-01-31	1997-01-09	3	$ 7.379,00	Ernst Handel	Kirchgasse 6	Graz	\N	8010	Austria
10404	MAGAA	2	1997-01-03	1997-01-31	1997-01-08	1	$ 15.597,00	Magazzini Alimentari Riuniti	Via Ludovico il Moro 22	Bergamo	\N	24100	Italy
10405	LINOD	1	1997-01-06	1997-02-03	1997-01-22	1	$ 3.482,00	LINO-Delicateses	Ave. 5 de Mayo Porlamar	I. de Margarita	Nueva Esparta	4980	Venezuela
10406	QUEEN	7	1997-01-07	1997-02-18	1997-01-13	1	$ 10.804,00	Queen Cozinha	Alameda dos Canàrios, 891	Sao Paulo	SP	05487-020	Brazil
10407	OTTIK	2	1997-01-07	1997-02-04	1997-01-30	2	$ 9.148,00	Ottilies Käseladen	Mehrheimerstr. 369	Köln	\N	50739	Germany
10408	FOLIG	8	1997-01-08	1997-02-05	1997-01-14	1	$ 1.126,00	Folies gourmandes	184, chaussée de Tournai	Lille	\N	59000	France
10409	OCEAN	3	1997-01-09	1997-02-06	1997-01-14	1	$ 2.983,00	Océano Atlántico Ltda.	Ing. Gustavo Moncada 8585 Piso 20-A	Buenos Aires	\N	1010	Argentina
10410	BOTTM	3	1997-01-10	1997-02-07	1997-01-15	3	$ 24,00	Bottom-Dollar Markets	23 Tsawassen Blvd.	Tsawassen	BC	T2F 8M4	Canada
10411	BOTTM	9	1997-01-10	1997-02-07	1997-01-21	3	$ 2.365,00	Bottom-Dollar Markets	23 Tsawassen Blvd.	Tsawassen	BC	T2F 8M4	Canada
10412	WARTH	8	1997-01-13	1997-02-10	1997-01-15	2	$ 377,00	Wartian Herkku	Torikatu 38	Oulu	\N	90110	Finland
10413	LAMAI	3	1997-01-14	1997-02-11	1997-01-16	2	$ 9.566,00	La maison d'Asie	1 rue Alsace-Lorraine	Toulouse	\N	31000	France
10414	FAMIA	2	1997-01-14	1997-02-11	1997-01-17	3	$ 2.148,00	Familia Arquibaldo	Rua Orós, 92	Sao Paulo	SP	05442-030	Brazil
10415	HUNGC	3	1997-01-15	1997-02-12	1997-01-24	1	$ 2,00	Hungry Coyote Import Store	City Center Plaza 516 Main St.	Elgin	OR	97827	USA
10416	WARTH	8	1997-01-16	1997-02-13	1997-01-27	3	$ 2.272,00	Wartian Herkku	Torikatu 38	Oulu	\N	90110	Finland
10417	SIMOB	4	1997-01-16	1997-02-13	1997-01-28	3	$ 7.029,00	Simons bistro	Vinbæltet 34	Kobenhavn	\N	1734	Denmark
10418	QUICK	4	1997-01-17	1997-02-14	1997-01-24	1	$ 1.755,00	QUICK-Stop	Taucherstraße 10	Cunewalde	\N	1307	Germany
10419	RICSU	4	1997-01-20	1997-02-17	1997-01-30	2	$ 13.735,00	Richter Supermarkt	Starenweg 5	Genève	\N	1204	Switzerland
10420	WELLI	3	1997-01-21	1997-02-18	1997-01-27	1	$ 4.412,00	Wellington Importadora	Rua do Mercado, 12	Resende	SP	08737-363	Brazil
10421	QUEDE	8	1997-01-21	1997-03-04	1997-01-27	1	$ 9.923,00	Que Delícia	Rua da Panificadora, 12	Rio de Janeiro	RJ	02389-673	Brazil
10422	FRANS	2	1997-01-22	1997-02-19	1997-01-31	1	$ 302,00	Franchi S.p.A.	Via Monte Bianco 34	Torino	\N	10100	Italy
10423	GOURL	6	1997-01-23	1997-02-06	1997-02-24	3	$ 245,00	Gourmet Lanchonetes	Av. Brasil, 442	Campinas	SP	04876-786	Brazil
10424	MEREP	7	1997-01-23	1997-02-20	1997-01-27	2	$ 37.061,00	Mère Paillarde	43 rue St. Laurent	Montréal	Québec	H1J 1C3	Canada
10425	LAMAI	6	1997-01-24	1997-02-21	1997-02-14	2	$ 793,00	La maison d'Asie	1 rue Alsace-Lorraine	Toulouse	\N	31000	France
10426	GALED	4	1997-01-27	1997-02-24	1997-02-06	1	$ 1.869,00	Galería del gastronómo	Rambla de Cataluña, 23	Barcelona	\N	8022	Spain
10427	PICCO	4	1997-01-27	1997-02-24	1997-03-03	2	$ 3.129,00	Piccolo und mehr	Geislweg 14	Salzburg	\N	5020	Austria
10428	REGGC	7	1997-01-28	1997-02-25	1997-02-04	1	$ 1.109,00	Reggiani Caseifici	Strada Provinciale 124	Reggio Emilia	\N	42100	Italy
10429	HUNGO	3	1997-01-29	1997-03-12	1997-02-07	2	$ 5.663,00	Hungry Owl All-Night Grocers	8 Johnstown Road	Cork	Co. Cork	\N	Ireland
10430	ERNSH	4	1997-01-30	1997-02-13	1997-02-03	1	$ 45.878,00	Ernst Handel	Kirchgasse 6	Graz	\N	8010	Austria
10431	BOTTM	4	1997-01-30	1997-02-13	1997-02-07	2	$ 4.417,00	Bottom-Dollar Markets	23 Tsawassen Blvd.	Tsawassen	BC	T2F 8M4	Canada
10432	SPLIR	3	1997-01-31	1997-02-14	1997-02-07	2	$ 434,00	Split Rail Beer & Ale	P.O. Box 555	Lander	WY	82520	USA
10433	PRINI	3	1997-02-03	1997-03-03	1997-03-04	3	$ 7.383,00	Princesa Isabel Vinhos	Estrada da saúde n. 58	Lisboa	\N	1756	Portugal
10434	FOLKO	3	1997-02-03	1997-03-03	1997-02-13	2	$ 1.792,00	Folk och fä HB	Åkergatan 24	Bräcke	\N	S-844 67	Sweden
10435	CONSH	8	1997-02-04	1997-03-18	1997-02-07	2	$ 921,00	Consolidated Holdings	Berkeley Gardens 12  Brewery	London	\N	WX1 6LT	UK
10436	BLONP	3	1997-02-05	1997-03-05	1997-02-11	2	$ 15.666,00	Blondel père et fils	24, place Kléber	Strasbourg	\N	67000	France
10437	WARTH	8	1997-02-05	1997-03-05	1997-02-12	1	$ 1.997,00	Wartian Herkku	Torikatu 38	Oulu	\N	90110	Finland
10438	TOMSP	3	1997-02-06	1997-03-06	1997-02-14	2	$ 824,00	Toms Spezialitäten	Luisenstr. 48	Münster	\N	44087	Germany
10439	MEREP	6	1997-02-07	1997-03-07	1997-02-10	3	$ 407,00	Mère Paillarde	43 rue St. Laurent	Montréal	Québec	H1J 1C3	Canada
10440	SAVEA	4	1997-02-10	1997-03-10	1997-02-28	2	$ 8.653,00	Save-a-lot Markets	187 Suffolk Ln.	Boise	ID	83720	USA
10441	OLDWO	3	1997-02-10	1997-03-24	1997-03-14	2	$ 7.302,00	Old World Delicatessen	2743 Bering St.	Anchorage	AK	99508	USA
10442	ERNSH	3	1997-02-11	1997-03-11	1997-02-18	2	$ 4.794,00	Ernst Handel	Kirchgasse 6	Graz	\N	8010	Austria
10443	REGGC	8	1997-02-12	1997-03-12	1997-02-14	1	$ 1.395,00	Reggiani Caseifici	Strada Provinciale 124	Reggio Emilia	\N	42100	Italy
10444	BERGS	3	1997-02-12	1997-03-12	1997-02-21	3	$ 35,00	Berglunds snabbköp	Berguvsvägen  8	Luleå	\N	S-958 22	Sweden
10445	BERGS	3	1997-02-13	1997-03-13	1997-02-20	1	$ 93,00	Berglunds snabbköp	Berguvsvägen  8	Luleå	\N	S-958 22	Sweden
10446	TOMSP	6	1997-02-14	1997-03-14	1997-02-19	1	$ 1.468,00	Toms Spezialitäten	Luisenstr. 48	Münster	\N	44087	Germany
10447	RICAR	4	1997-02-14	1997-03-14	1997-03-07	2	$ 6.866,00	Ricardo Adocicados	Av. Copacabana, 267	Rio de Janeiro	RJ	02389-890	Brazil
10448	RANCH	4	1997-02-17	1997-03-17	1997-02-24	2	$ 3.882,00	Rancho grande	Av. del Libertador 900	Buenos Aires	\N	1010	Argentina
10449	BLONP	3	1997-02-18	1997-03-18	1997-02-27	2	$ 533,00	Blondel père et fils	24, place Kléber	Strasbourg	\N	67000	France
10450	VICTE	8	1997-02-19	1997-03-19	1997-03-11	2	$ 723,00	Victuailles en stock	2, rue du Commerce	Lyon	\N	69004	France
10451	QUICK	4	1997-02-19	1997-03-05	1997-03-12	3	$ 18.909,00	QUICK-Stop	Taucherstraße 10	Cunewalde	\N	1307	Germany
10452	SAVEA	8	1997-02-20	1997-03-20	1997-02-26	1	$ 14.026,00	Save-a-lot Markets	187 Suffolk Ln.	Boise	ID	83720	USA
10453	AROUT	1	1997-02-21	1997-03-21	1997-02-26	2	$ 2.536,00	Around the Horn	Brook Farm Stratford St. Mary	Colchester	Essex	CO7 6JX	UK
10454	LAMAI	4	1997-02-21	1997-03-21	1997-02-25	3	$ 274,00	La maison d'Asie	1 rue Alsace-Lorraine	Toulouse	\N	31000	France
10455	WARTH	8	1997-02-24	1997-04-07	1997-03-03	2	$ 18.045,00	Wartian Herkku	Torikatu 38	Oulu	\N	90110	Finland
10456	KOENE	8	1997-02-25	1997-04-08	1997-02-28	2	$ 812,00	Königlich Essen	Maubelstr. 90	Brandenburg	\N	14776	Germany
10457	KOENE	2	1997-02-25	1997-03-25	1997-03-03	1	$ 1.157,00	Königlich Essen	Maubelstr. 90	Brandenburg	\N	14776	Germany
10458	SUPRD	7	1997-02-26	1997-03-26	1997-03-04	3	$ 14.706,00	Suprêmes délices	Boulevard Tirou, 255	Charleroi	\N	B-6000	Belgium
10459	VICTE	4	1997-02-27	1997-03-27	1997-02-28	2	$ 2.509,00	Victuailles en stock	2, rue du Commerce	Lyon	\N	69004	France
10460	FOLKO	8	1997-02-28	1997-03-28	1997-03-03	1	$ 1.627,00	Folk och fä HB	Åkergatan 24	Bräcke	\N	S-844 67	Sweden
10461	LILAS	1	1997-02-28	1997-03-28	1997-03-05	3	$ 14.861,00	LILA-Supermercado	Carrera 52 con Ave. Bolívar #65-98 Llano Largo	Barquisimeto	Lara	3508	Venezuela
10462	CONSH	2	1997-03-03	1997-03-31	1997-03-18	1	$ 617,00	Consolidated Holdings	Berkeley Gardens 12  Brewery	London	\N	WX1 6LT	UK
10463	SUPRD	5	1997-03-04	1997-04-01	1997-03-06	3	$ 1.478,00	Suprêmes délices	Boulevard Tirou, 255	Charleroi	\N	B-6000	Belgium
10464	FURIB	4	1997-03-04	1997-04-01	1997-03-14	2	$ 890,00	Furia Bacalhau e Frutos do Mar	Jardim das rosas n. 32	Lisboa	\N	1675	Portugal
10465	VAFFE	1	1997-03-05	1997-04-02	1997-03-14	3	$ 14.504,00	Vaffeljernet	Smagsloget 45	Århus	\N	8200	Denmark
10466	COMMI	4	1997-03-06	1997-04-03	1997-03-13	1	$ 1.193,00	Comércio Mineiro	Av. dos Lusíadas, 23	Sao Paulo	SP	05432-043	Brazil
10467	MAGAA	8	1997-03-06	1997-04-03	1997-03-11	2	$ 493,00	Magazzini Alimentari Riuniti	Via Ludovico il Moro 22	Bergamo	\N	24100	Italy
10468	KOENE	3	1997-03-07	1997-04-04	1997-03-12	3	$ 4.412,00	Königlich Essen	Maubelstr. 90	Brandenburg	\N	14776	Germany
10469	WHITC	1	1997-03-10	1997-04-07	1997-03-14	1	$ 6.018,00	White Clover Markets	1029 - 12th Ave. S.	Seattle	WA	98124	USA
10470	BONAP	4	1997-03-11	1997-04-08	1997-03-14	2	$ 6.456,00	Bon app'	12, rue des Bouchers	Marseille	\N	13008	France
10471	BSBEV	2	1997-03-11	1997-04-08	1997-03-18	3	$ 4.559,00	B's Beverages	Fauntleroy Circus	London	\N	EC2 5NT	UK
10472	SEVES	8	1997-03-12	1997-04-09	1997-03-19	1	$ 42,00	Seven Seas Imports	90 Wadhurst Rd.	London	\N	OX15 4NB	UK
10473	ISLAT	1	1997-03-13	1997-03-27	1997-03-21	3	$ 1.637,00	Island Trading	Garden House Crowther Way	Cowes	Isle of Wight	PO31 7PJ	UK
10474	PERIC	5	1997-03-13	1997-04-10	1997-03-21	2	$ 8.349,00	Pericles Comidas clásicas	Calle Dr. Jorge Cash 321	México D.F.	\N	5033	Mexico
10475	SUPRD	9	1997-03-14	1997-04-11	1997-04-04	1	$ 6.852,00	Suprêmes délices	Boulevard Tirou, 255	Charleroi	\N	B-6000	Belgium
10476	HILAA	8	1997-03-17	1997-04-14	1997-03-24	3	$ 441,00	HILARION-Abastos	Carrera 22 con Ave. Carlos Soublette #8-35	San Cristóbal	Táchira	5022	Venezuela
10477	PRINI	5	1997-03-17	1997-04-14	1997-03-25	2	$ 1.302,00	Princesa Isabel Vinhos	Estrada da saúde n. 58	Lisboa	\N	1756	Portugal
10478	VICTE	2	1997-03-18	1997-04-01	1997-03-26	3	$ 481,00	Victuailles en stock	2, rue du Commerce	Lyon	\N	69004	France
10479	RATTC	3	1997-03-19	1997-04-16	1997-03-21	3	$ 70.895,00	Rattlesnake Canyon Grocery	2817 Milton Dr.	Albuquerque	NM	87110	USA
10480	FOLIG	6	1997-03-20	1997-04-17	1997-03-24	2	$ 135,00	Folies gourmandes	184, chaussée de Tournai	Lille	\N	59000	France
10481	RICAR	8	1997-03-20	1997-04-17	1997-03-25	2	$ 6.433,00	Ricardo Adocicados	Av. Copacabana, 267	Rio de Janeiro	RJ	02389-890	Brazil
10482	LAZYK	1	1997-03-21	1997-04-18	1997-04-10	3	$ 748,00	Lazy K Kountry Store	12 Orchestra Terrace	Walla Walla	WA	99362	USA
10483	WHITC	7	1997-03-24	1997-04-21	1997-04-25	2	$ 1.528,00	White Clover Markets	1029 - 12th Ave. S.	Seattle	WA	98124	USA
10484	BSBEV	3	1997-03-24	1997-04-21	1997-04-01	3	$ 688,00	B's Beverages	Fauntleroy Circus	London	\N	EC2 5NT	UK
10485	LINOD	4	1997-03-25	1997-04-08	1997-03-31	2	$ 6.445,00	LINO-Delicateses	Ave. 5 de Mayo Porlamar	I. de Margarita	Nueva Esparta	4980	Venezuela
10486	HILAA	1	1997-03-26	1997-04-23	1997-04-02	2	$ 3.053,00	HILARION-Abastos	Carrera 22 con Ave. Carlos Soublette #8-35	San Cristóbal	Táchira	5022	Venezuela
10487	QUEEN	2	1997-03-26	1997-04-23	1997-03-28	2	$ 7.107,00	Queen Cozinha	Alameda dos Canàrios, 891	Sao Paulo	SP	05487-020	Brazil
10488	FRANK	8	1997-03-27	1997-04-24	1997-04-02	2	$ 493,00	Frankenversand	Berliner Platz 43	München	\N	80805	Germany
10489	PICCO	6	1997-03-28	1997-04-25	1997-04-09	2	$ 529,00	Piccolo und mehr	Geislweg 14	Salzburg	\N	5020	Austria
10490	HILAA	7	1997-03-31	1997-04-28	1997-04-03	2	$ 21.019,00	HILARION-Abastos	Carrera 22 con Ave. Carlos Soublette #8-35	San Cristóbal	Táchira	5022	Venezuela
10491	FURIB	8	1997-03-31	1997-04-28	1997-04-08	3	$ 1.696,00	Furia Bacalhau e Frutos do Mar	Jardim das rosas n. 32	Lisboa	\N	1675	Portugal
10492	BOTTM	3	1997-04-01	1997-04-29	1997-04-11	1	$ 6.289,00	Bottom-Dollar Markets	23 Tsawassen Blvd.	Tsawassen	BC	T2F 8M4	Canada
10493	LAMAI	4	1997-04-02	1997-04-30	1997-04-10	3	$ 1.064,00	La maison d'Asie	1 rue Alsace-Lorraine	Toulouse	\N	31000	France
10494	COMMI	4	1997-04-02	1997-04-30	1997-04-09	2	$ 6.599,00	Comércio Mineiro	Av. dos Lusíadas, 23	Sao Paulo	SP	05432-043	Brazil
10495	LAUGB	3	1997-04-03	1997-05-01	1997-04-11	3	$ 465,00	Laughing Bacchus Wine Cellars	2319 Elm St.	Vancouver	BC	V3F 2K1	Canada
10496	TRADH	7	1997-04-04	1997-05-02	1997-04-07	2	$ 4.677,00	Tradiçao Hipermercados	Av. Inês de Castro, 414	Sao Paulo	SP	05634-030	Brazil
10497	LEHMS	7	1997-04-04	1997-05-02	1997-04-07	1	$ 3.621,00	Lehmanns Marktstand	Magazinweg 7	Frankfurt a.M.	\N	60528	Germany
10498	HILAA	8	1997-04-07	1997-05-05	1997-04-11	2	$ 2.975,00	HILARION-Abastos	Carrera 22 con Ave. Carlos Soublette #8-35	San Cristóbal	Táchira	5022	Venezuela
10499	LILAS	4	1997-04-08	1997-05-06	1997-04-16	2	$ 10.202,00	LILA-Supermercado	Carrera 52 con Ave. Bolívar #65-98 Llano Largo	Barquisimeto	Lara	3508	Venezuela
10500	LAMAI	6	1997-04-09	1997-05-07	1997-04-17	1	$ 4.268,00	La maison d'Asie	1 rue Alsace-Lorraine	Toulouse	\N	31000	France
10501	BLAUS	9	1997-04-09	1997-05-07	1997-04-16	3	$ 885,00	Blauer See Delikatessen	Forsterstr. 57	Mannheim	\N	68306	Germany
10502	PERIC	2	1997-04-10	1997-05-08	1997-04-29	1	$ 6.932,00	Pericles Comidas clásicas	Calle Dr. Jorge Cash 321	México D.F.	\N	5033	Mexico
10503	HUNGO	6	1997-04-11	1997-05-09	1997-04-16	2	$ 1.674,00	Hungry Owl All-Night Grocers	8 Johnstown Road	Cork	Co. Cork	\N	Ireland
10504	WHITC	4	1997-04-11	1997-05-09	1997-04-18	3	$ 5.913,00	White Clover Markets	1029 - 12th Ave. S.	Seattle	WA	98124	USA
10505	MEREP	3	1997-04-14	1997-05-12	1997-04-21	3	$ 713,00	Mère Paillarde	43 rue St. Laurent	Montréal	Québec	H1J 1C3	Canada
10506	KOENE	9	1997-04-15	1997-05-13	1997-05-02	2	$ 2.119,00	Königlich Essen	Maubelstr. 90	Brandenburg	\N	14776	Germany
10507	ANTON	7	1997-04-15	1997-05-13	1997-04-22	1	$ 4.745,00	Antonio Moreno Taquería	Mataderos  2312	México D.F.	\N	5023	Mexico
10508	OTTIK	1	1997-04-16	1997-05-14	1997-05-13	2	$ 499,00	Ottilies Käseladen	Mehrheimerstr. 369	Köln	\N	50739	Germany
10509	BLAUS	4	1997-04-17	1997-05-15	1997-04-29	1	$ 15,00	Blauer See Delikatessen	Forsterstr. 57	Mannheim	\N	68306	Germany
10510	SAVEA	6	1997-04-18	1997-05-16	1997-04-28	3	$ 36.763,00	Save-a-lot Markets	187 Suffolk Ln.	Boise	ID	83720	USA
10511	BONAP	4	1997-04-18	1997-05-16	1997-04-21	3	$ 35.064,00	Bon app'	12, rue des Bouchers	Marseille	\N	13008	France
10512	FAMIA	7	1997-04-21	1997-05-19	1997-04-24	2	$ 353,00	Familia Arquibaldo	Rua Orós, 92	Sao Paulo	SP	05442-030	Brazil
10513	WANDK	7	1997-04-22	1997-06-03	1997-04-28	1	$ 10.565,00	Die Wandernde Kuh	Adenauerallee 900	Stuttgart	\N	70563	Germany
10514	ERNSH	3	1997-04-22	1997-05-20	1997-05-16	2	$ 78.995,00	Ernst Handel	Kirchgasse 6	Graz	\N	8010	Austria
10515	QUICK	2	1997-04-23	1997-05-07	1997-05-23	1	$ 20.447,00	QUICK-Stop	Taucherstraße 10	Cunewalde	\N	1307	Germany
10516	HUNGO	2	1997-04-24	1997-05-22	1997-05-01	3	$ 6.278,00	Hungry Owl All-Night Grocers	8 Johnstown Road	Cork	Co. Cork	\N	Ireland
10517	NORTS	3	1997-04-24	1997-05-22	1997-04-29	3	$ 3.207,00	North/South	South House 300 Queensbridge	London	\N	SW7 1RZ	UK
10518	TORTU	4	1997-04-25	1997-05-09	1997-05-05	2	$ 21.815,00	Tortuga Restaurante	Avda. Azteca 123	México D.F.	\N	5033	Mexico
10519	CHOPS	6	1997-04-28	1997-05-26	1997-05-01	3	$ 9.176,00	Chop-suey Chinese	Hauptstr. 31	Bern	\N	3012	Switzerland
10520	SANTG	7	1997-04-29	1997-05-27	1997-05-01	1	$ 1.337,00	Santé Gourmet	Erling Skakkes gate 78	Stavern	\N	4110	Norway
10521	CACTU	8	1997-04-29	1997-05-27	1997-05-02	2	$ 1.722,00	Cactus Comidas para llevar	Cerrito 333	Buenos Aires	\N	1010	Argentina
10522	LEHMS	4	1997-04-30	1997-05-28	1997-05-06	1	$ 4.533,00	Lehmanns Marktstand	Magazinweg 7	Frankfurt a.M.	\N	60528	Germany
10523	SEVES	7	1997-05-01	1997-05-29	1997-05-30	2	$ 7.763,00	Seven Seas Imports	90 Wadhurst Rd.	London	\N	OX15 4NB	UK
10524	BERGS	1	1997-05-01	1997-05-29	1997-05-07	2	$ 24.479,00	Berglunds snabbköp	Berguvsvägen  8	Luleå	\N	S-958 22	Sweden
10525	BONAP	1	1997-05-02	1997-05-30	1997-05-23	2	$ 1.106,00	Bon app'	12, rue des Bouchers	Marseille	\N	13008	France
10526	WARTH	4	1997-05-05	1997-06-02	1997-05-15	2	$ 5.859,00	Wartian Herkku	Torikatu 38	Oulu	\N	90110	Finland
10527	QUICK	7	1997-05-05	1997-06-02	1997-05-07	1	$ 419,00	QUICK-Stop	Taucherstraße 10	Cunewalde	\N	1307	Germany
10528	GREAL	6	1997-05-06	1997-05-20	1997-05-09	2	$ 335,00	Great Lakes Food Market	2732 Baker Blvd.	Eugene	OR	97403	USA
10529	MAISD	5	1997-05-07	1997-06-04	1997-05-09	2	$ 6.669,00	Maison Dewey	Rue Joseph-Bens 532	Bruxelles	\N	B-1180	Belgium
10530	PICCO	3	1997-05-08	1997-06-05	1997-05-12	2	$ 33.922,00	Piccolo und mehr	Geislweg 14	Salzburg	\N	5020	Austria
10531	OCEAN	7	1997-05-08	1997-06-05	1997-05-19	1	$ 812,00	Océano Atlántico Ltda.	Ing. Gustavo Moncada 8585 Piso 20-A	Buenos Aires	\N	1010	Argentina
10532	EASTC	7	1997-05-09	1997-06-06	1997-05-12	3	$ 7.446,00	Eastern Connection	35 King George	London	\N	WX3 6FW	UK
10533	FOLKO	8	1997-05-12	1997-06-09	1997-05-22	1	$ 18.804,00	Folk och fä HB	Åkergatan 24	Bräcke	\N	S-844 67	Sweden
10534	LEHMS	8	1997-05-12	1997-06-09	1997-05-14	2	$ 2.794,00	Lehmanns Marktstand	Magazinweg 7	Frankfurt a.M.	\N	60528	Germany
10535	ANTON	4	1997-05-13	1997-06-10	1997-05-21	1	$ 1.564,00	Antonio Moreno Taquería	Mataderos  2312	México D.F.	\N	5023	Mexico
10536	LEHMS	3	1997-05-14	1997-06-11	1997-06-06	2	$ 5.888,00	Lehmanns Marktstand	Magazinweg 7	Frankfurt a.M.	\N	60528	Germany
10537	RICSU	1	1997-05-14	1997-05-28	1997-05-19	1	$ 7.885,00	Richter Supermarkt	Starenweg 5	Genève	\N	1204	Switzerland
10538	BSBEV	9	1997-05-15	1997-06-12	1997-05-16	3	$ 487,00	B's Beverages	Fauntleroy Circus	London	\N	EC2 5NT	UK
10539	BSBEV	6	1997-05-16	1997-06-13	1997-05-23	3	$ 1.236,00	B's Beverages	Fauntleroy Circus	London	\N	EC2 5NT	UK
10540	QUICK	3	1997-05-19	1997-06-16	1997-06-13	3	$ 100.764,00	QUICK-Stop	Taucherstraße 10	Cunewalde	\N	1307	Germany
10541	HANAR	2	1997-05-19	1997-06-16	1997-05-29	1	$ 6.865,00	Hanari Carnes	Rua do Paço, 67	Rio de Janeiro	RJ	05454-876	Brazil
10542	KOENE	1	1997-05-20	1997-06-17	1997-05-26	3	$ 1.095,00	Königlich Essen	Maubelstr. 90	Brandenburg	\N	14776	Germany
10543	LILAS	8	1997-05-21	1997-06-18	1997-05-23	2	$ 4.817,00	LILA-Supermercado	Carrera 52 con Ave. Bolívar #65-98 Llano Largo	Barquisimeto	Lara	3508	Venezuela
10544	LONEP	4	1997-05-21	1997-06-18	1997-05-30	1	$ 2.491,00	Lonesome Pine Restaurant	89 Chiaroscuro Rd.	Portland	OR	97219	USA
10545	LAZYK	8	1997-05-22	1997-06-19	1997-06-26	2	$ 1.192,00	Lazy K Kountry Store	12 Orchestra Terrace	Walla Walla	WA	99362	USA
10546	VICTE	1	1997-05-23	1997-06-20	1997-05-27	3	$ 19.472,00	Victuailles en stock	2, rue du Commerce	Lyon	\N	69004	France
10547	SEVES	3	1997-05-23	1997-06-20	1997-06-02	2	$ 17.843,00	Seven Seas Imports	90 Wadhurst Rd.	London	\N	OX15 4NB	UK
10548	TOMSP	3	1997-05-26	1997-06-23	1997-06-02	2	$ 143,00	Toms Spezialitäten	Luisenstr. 48	Münster	\N	44087	Germany
10549	QUICK	5	1997-05-27	1997-06-10	1997-05-30	1	$ 17.124,00	QUICK-Stop	Taucherstraße 10	Cunewalde	\N	1307	Germany
10550	GODOS	7	1997-05-28	1997-06-25	1997-06-06	3	$ 432,00	Godos Cocina Típica	C/ Romero, 33	Sevilla	\N	41101	Spain
10551	FURIB	4	1997-05-28	1997-07-09	1997-06-06	3	$ 7.295,00	Furia Bacalhau e Frutos do Mar	Jardim das rosas n. 32	Lisboa	\N	1675	Portugal
10552	HILAA	2	1997-05-29	1997-06-26	1997-06-05	1	$ 8.322,00	HILARION-Abastos	Carrera 22 con Ave. Carlos Soublette #8-35	San Cristóbal	Táchira	5022	Venezuela
10553	WARTH	2	1997-05-30	1997-06-27	1997-06-03	2	$ 14.949,00	Wartian Herkku	Torikatu 38	Oulu	\N	90110	Finland
10554	OTTIK	4	1997-05-30	1997-06-27	1997-06-05	3	$ 12.097,00	Ottilies Käseladen	Mehrheimerstr. 369	Köln	\N	50739	Germany
10555	SAVEA	6	1997-06-02	1997-06-30	1997-06-04	3	$ 25.249,00	Save-a-lot Markets	187 Suffolk Ln.	Boise	ID	83720	USA
10556	SIMOB	2	1997-06-03	1997-07-15	1997-06-13	1	$ 98,00	Simons bistro	Vinbæltet 34	Kobenhavn	\N	1734	Denmark
10557	LEHMS	9	1997-06-03	1997-06-17	1997-06-06	2	$ 9.672,00	Lehmanns Marktstand	Magazinweg 7	Frankfurt a.M.	\N	60528	Germany
10558	AROUT	1	1997-06-04	1997-07-02	1997-06-10	2	$ 7.297,00	Around the Horn	Brook Farm Stratford St. Mary	Colchester	Essex	CO7 6JX	UK
10559	BLONP	6	1997-06-05	1997-07-03	1997-06-13	1	$ 805,00	Blondel père et fils	24, place Kléber	Strasbourg	\N	67000	France
10560	FRANK	8	1997-06-06	1997-07-04	1997-06-09	1	$ 3.665,00	Frankenversand	Berliner Platz 43	München	\N	80805	Germany
10561	FOLKO	2	1997-06-06	1997-07-04	1997-06-09	2	$ 24.221,00	Folk och fä HB	Åkergatan 24	Bräcke	\N	S-844 67	Sweden
10562	REGGC	1	1997-06-09	1997-07-07	1997-06-12	1	$ 2.295,00	Reggiani Caseifici	Strada Provinciale 124	Reggio Emilia	\N	42100	Italy
10563	RICAR	2	1997-06-10	1997-07-22	1997-06-24	2	$ 6.043,00	Ricardo Adocicados	Av. Copacabana, 267	Rio de Janeiro	RJ	02389-890	Brazil
10564	RATTC	4	1997-06-10	1997-07-08	1997-06-16	3	$ 1.375,00	Rattlesnake Canyon Grocery	2817 Milton Dr.	Albuquerque	NM	87110	USA
10565	MEREP	8	1997-06-11	1997-07-09	1997-06-18	2	$ 715,00	Mère Paillarde	43 rue St. Laurent	Montréal	Québec	H1J 1C3	Canada
10566	BLONP	9	1997-06-12	1997-07-10	1997-06-18	1	$ 884,00	Blondel père et fils	24, place Kléber	Strasbourg	\N	67000	France
10567	HUNGO	1	1997-06-12	1997-07-10	1997-06-17	1	$ 3.397,00	Hungry Owl All-Night Grocers	8 Johnstown Road	Cork	Co. Cork	\N	Ireland
10568	GALED	3	1997-06-13	1997-07-11	1997-07-09	3	$ 654,00	Galería del gastronómo	Rambla de Cataluña, 23	Barcelona	\N	8022	Spain
10569	RATTC	5	1997-06-16	1997-07-14	1997-07-11	1	$ 5.898,00	Rattlesnake Canyon Grocery	2817 Milton Dr.	Albuquerque	NM	87110	USA
10570	MEREP	3	1997-06-17	1997-07-15	1997-06-19	3	$ 18.899,00	Mère Paillarde	43 rue St. Laurent	Montréal	Québec	H1J 1C3	Canada
10571	ERNSH	8	1997-06-17	1997-07-29	1997-07-04	3	$ 2.606,00	Ernst Handel	Kirchgasse 6	Graz	\N	8010	Austria
10572	BERGS	3	1997-06-18	1997-07-16	1997-06-25	2	$ 11.643,00	Berglunds snabbköp	Berguvsvägen  8	Luleå	\N	S-958 22	Sweden
10573	ANTON	7	1997-06-19	1997-07-17	1997-06-20	3	$ 8.484,00	Antonio Moreno Taquería	Mataderos  2312	México D.F.	\N	5023	Mexico
10574	TRAIH	4	1997-06-19	1997-07-17	1997-06-30	2	$ 376,00	Trail's Head Gourmet Provisioners	722 DaVinci Blvd.	Kirkland	WA	98034	USA
10575	MORGK	5	1997-06-20	1997-07-04	1997-06-30	1	$ 12.734,00	Morgenstern Gesundkost	Heerstr. 22	Leipzig	\N	4179	Germany
10576	TORTU	3	1997-06-23	1997-07-07	1997-06-30	3	$ 1.856,00	Tortuga Restaurante	Avda. Azteca 123	México D.F.	\N	5033	Mexico
10577	TRAIH	9	1997-06-23	1997-08-04	1997-06-30	2	$ 2.541,00	Trail's Head Gourmet Provisioners	722 DaVinci Blvd.	Kirkland	WA	98034	USA
10578	BSBEV	4	1997-06-24	1997-07-22	1997-07-25	3	$ 296,00	B's Beverages	Fauntleroy Circus	London	\N	EC2 5NT	UK
10579	LETSS	1	1997-06-25	1997-07-23	1997-07-04	2	$ 1.373,00	Let's Stop N Shop	87 Polk St. Suite 5	San Francisco	CA	94117	USA
10580	OTTIK	4	1997-06-26	1997-07-24	1997-07-01	3	$ 7.589,00	Ottilies Käseladen	Mehrheimerstr. 369	Köln	\N	50739	Germany
10581	FAMIA	3	1997-06-26	1997-07-24	1997-07-02	1	$ 301,00	Familia Arquibaldo	Rua Orós, 92	Sao Paulo	SP	05442-030	Brazil
10582	BLAUS	3	1997-06-27	1997-07-25	1997-07-14	2	$ 2.771,00	Blauer See Delikatessen	Forsterstr. 57	Mannheim	\N	68306	Germany
10583	WARTH	2	1997-06-30	1997-07-28	1997-07-04	2	$ 728,00	Wartian Herkku	Torikatu 38	Oulu	\N	90110	Finland
10584	BLONP	4	1997-06-30	1997-07-28	1997-07-04	1	$ 5.914,00	Blondel père et fils	24, place Kléber	Strasbourg	\N	67000	France
10585	WELLI	7	1997-07-01	1997-07-29	1997-07-10	1	$ 1.341,00	Wellington Importadora	Rua do Mercado, 12	Resende	SP	08737-363	Brazil
10586	REGGC	9	1997-07-02	1997-07-30	1997-07-09	1	$ 48,00	Reggiani Caseifici	Strada Provinciale 124	Reggio Emilia	\N	42100	Italy
10587	QUEDE	1	1997-07-02	1997-07-30	1997-07-09	1	$ 6.252,00	Que Delícia	Rua da Panificadora, 12	Rio de Janeiro	RJ	02389-673	Brazil
10588	QUICK	2	1997-07-03	1997-07-31	1997-07-10	3	$ 19.467,00	QUICK-Stop	Taucherstraße 10	Cunewalde	\N	1307	Germany
10589	GREAL	8	1997-07-04	1997-08-01	1997-07-14	2	$ 442,00	Great Lakes Food Market	2732 Baker Blvd.	Eugene	OR	97403	USA
10590	MEREP	4	1997-07-07	1997-08-04	1997-07-14	3	$ 4.477,00	Mère Paillarde	43 rue St. Laurent	Montréal	Québec	H1J 1C3	Canada
10591	VAFFE	1	1997-07-07	1997-07-21	1997-07-16	1	$ 5.592,00	Vaffeljernet	Smagsloget 45	Århus	\N	8200	Denmark
10592	LEHMS	3	1997-07-08	1997-08-05	1997-07-16	1	$ 321,00	Lehmanns Marktstand	Magazinweg 7	Frankfurt a.M.	\N	60528	Germany
10593	LEHMS	7	1997-07-09	1997-08-06	1997-08-13	2	$ 1.742,00	Lehmanns Marktstand	Magazinweg 7	Frankfurt a.M.	\N	60528	Germany
10594	OLDWO	3	1997-07-09	1997-08-06	1997-07-16	2	$ 524,00	Old World Delicatessen	2743 Bering St.	Anchorage	AK	99508	USA
10595	ERNSH	2	1997-07-10	1997-08-07	1997-07-14	1	$ 9.678,00	Ernst Handel	Kirchgasse 6	Graz	\N	8010	Austria
10596	WHITC	8	1997-07-11	1997-08-08	1997-08-12	1	$ 1.634,00	White Clover Markets	1029 - 12th Ave. S.	Seattle	WA	98124	USA
10597	PICCO	7	1997-07-11	1997-08-08	1997-07-18	3	$ 3.512,00	Piccolo und mehr	Geislweg 14	Salzburg	\N	5020	Austria
10598	RATTC	1	1997-07-14	1997-08-11	1997-07-18	3	$ 4.442,00	Rattlesnake Canyon Grocery	2817 Milton Dr.	Albuquerque	NM	87110	USA
10599	BSBEV	6	1997-07-15	1997-08-26	1997-07-21	3	$ 2.998,00	B's Beverages	Fauntleroy Circus	London	\N	EC2 5NT	UK
10600	HUNGC	4	1997-07-16	1997-08-13	1997-07-21	1	$ 4.513,00	Hungry Coyote Import Store	City Center Plaza 516 Main St.	Elgin	OR	97827	USA
10601	HILAA	7	1997-07-16	1997-08-27	1997-07-22	1	$ 583,00	HILARION-Abastos	Carrera 22 con Ave. Carlos Soublette #8-35	San Cristóbal	Táchira	5022	Venezuela
10602	VAFFE	8	1997-07-17	1997-08-14	1997-07-22	2	$ 292,00	Vaffeljernet	Smagsloget 45	Århus	\N	8200	Denmark
10603	SAVEA	8	1997-07-18	1997-08-15	1997-08-08	2	$ 4.877,00	Save-a-lot Markets	187 Suffolk Ln.	Boise	ID	83720	USA
10604	FURIB	1	1997-07-18	1997-08-15	1997-07-29	1	$ 746,00	Furia Bacalhau e Frutos do Mar	Jardim das rosas n. 32	Lisboa	\N	1675	Portugal
10605	MEREP	1	1997-07-21	1997-08-18	1997-07-29	2	$ 37.913,00	Mère Paillarde	43 rue St. Laurent	Montréal	Québec	H1J 1C3	Canada
10606	TRADH	4	1997-07-22	1997-08-19	1997-07-31	3	$ 794,00	Tradiçao Hipermercados	Av. Inês de Castro, 414	Sao Paulo	SP	05634-030	Brazil
10607	SAVEA	5	1997-07-22	1997-08-19	1997-07-25	1	$ 20.024,00	Save-a-lot Markets	187 Suffolk Ln.	Boise	ID	83720	USA
10608	TOMSP	4	1997-07-23	1997-08-20	1997-08-01	2	$ 2.779,00	Toms Spezialitäten	Luisenstr. 48	Münster	\N	44087	Germany
10609	DUMON	7	1997-07-24	1997-08-21	1997-07-30	2	$ 185,00	Du monde entier	67, rue des Cinquante Otages	Nantes	\N	44000	France
10610	LAMAI	8	1997-07-25	1997-08-22	1997-08-06	1	$ 2.678,00	La maison d'Asie	1 rue Alsace-Lorraine	Toulouse	\N	31000	France
10611	WOLZA	6	1997-07-25	1997-08-22	1997-08-01	2	$ 8.065,00	Wolski Zajazd	ul. Filtrowa 68	Warszawa	\N	01-012	Poland
10612	SAVEA	1	1997-07-28	1997-08-25	1997-08-01	2	$ 54.408,00	Save-a-lot Markets	187 Suffolk Ln.	Boise	ID	83720	USA
10613	HILAA	4	1997-07-29	1997-08-26	1997-08-01	2	$ 811,00	HILARION-Abastos	Carrera 22 con Ave. Carlos Soublette #8-35	San Cristóbal	Táchira	5022	Venezuela
10614	BLAUS	8	1997-07-29	1997-08-26	1997-08-01	3	$ 193,00	Blauer See Delikatessen	Forsterstr. 57	Mannheim	\N	68306	Germany
10615	WILMK	2	1997-07-30	1997-08-27	1997-08-06	3	$ 75,00	Wilman Kala	Keskuskatu 45	Helsinki	\N	21240	Finland
10616	GREAL	1	1997-07-31	1997-08-28	1997-08-05	2	$ 11.653,00	Great Lakes Food Market	2732 Baker Blvd.	Eugene	OR	97403	USA
10617	GREAL	4	1997-07-31	1997-08-28	1997-08-04	2	$ 1.853,00	Great Lakes Food Market	2732 Baker Blvd.	Eugene	OR	97403	USA
10618	MEREP	1	1997-08-01	1997-09-12	1997-08-08	1	$ 15.468,00	Mère Paillarde	43 rue St. Laurent	Montréal	Québec	H1J 1C3	Canada
10619	MEREP	3	1997-08-04	1997-09-01	1997-08-07	3	$ 9.105,00	Mère Paillarde	43 rue St. Laurent	Montréal	Québec	H1J 1C3	Canada
10620	LAUGB	2	1997-08-05	1997-09-02	1997-08-14	3	$ 94,00	Laughing Bacchus Wine Cellars	2319 Elm St.	Vancouver	BC	V3F 2K1	Canada
10621	ISLAT	4	1997-08-05	1997-09-02	1997-08-11	2	$ 2.373,00	Island Trading	Garden House Crowther Way	Cowes	Isle of Wight	PO31 7PJ	UK
10622	RICAR	4	1997-08-06	1997-09-03	1997-08-11	3	$ 5.097,00	Ricardo Adocicados	Av. Copacabana, 267	Rio de Janeiro	RJ	02389-890	Brazil
10623	FRANK	8	1997-08-07	1997-09-04	1997-08-12	2	$ 9.718,00	Frankenversand	Berliner Platz 43	München	\N	80805	Germany
10624	THECR	4	1997-08-07	1997-09-04	1997-08-19	2	$ 948,00	The Cracker Box	55 Grizzly Peak Rd.	Butte	MT	59801	USA
10625	ANATR	3	1997-08-08	1997-09-05	1997-08-14	1	$ 439,00	Ana Trujillo Emparedados y helados	Avda. de la Constitución 2222	México D.F.	\N	5021	Mexico
10626	BERGS	1	1997-08-11	1997-09-08	1997-08-20	2	$ 13.869,00	Berglunds snabbköp	Berguvsvägen  8	Luleå	\N	S-958 22	Sweden
10627	SAVEA	8	1997-08-11	1997-09-22	1997-08-21	3	$ 10.746,00	Save-a-lot Markets	187 Suffolk Ln.	Boise	ID	83720	USA
10628	BLONP	4	1997-08-12	1997-09-09	1997-08-20	3	$ 3.036,00	Blondel père et fils	24, place Kléber	Strasbourg	\N	67000	France
10629	GODOS	4	1997-08-12	1997-09-09	1997-08-20	3	$ 8.546,00	Godos Cocina Típica	C/ Romero, 33	Sevilla	\N	41101	Spain
10630	KOENE	1	1997-08-13	1997-09-10	1997-08-19	2	$ 3.235,00	Königlich Essen	Maubelstr. 90	Brandenburg	\N	14776	Germany
10631	LAMAI	8	1997-08-14	1997-09-11	1997-08-15	1	$ 87,00	La maison d'Asie	1 rue Alsace-Lorraine	Toulouse	\N	31000	France
10632	WANDK	8	1997-08-14	1997-09-11	1997-08-19	1	$ 4.138,00	Die Wandernde Kuh	Adenauerallee 900	Stuttgart	\N	70563	Germany
10633	ERNSH	7	1997-08-15	1997-09-12	1997-08-18	3	$ 4.779,00	Ernst Handel	Kirchgasse 6	Graz	\N	8010	Austria
10634	FOLIG	4	1997-08-15	1997-09-12	1997-08-21	3	$ 48.738,00	Folies gourmandes	184, chaussée de Tournai	Lille	\N	59000	France
10635	MAGAA	8	1997-08-18	1997-09-15	1997-08-21	3	$ 4.746,00	Magazzini Alimentari Riuniti	Via Ludovico il Moro 22	Bergamo	\N	24100	Italy
10636	WARTH	4	1997-08-19	1997-09-16	1997-08-26	1	$ 115,00	Wartian Herkku	Torikatu 38	Oulu	\N	90110	Finland
10637	QUEEN	6	1997-08-19	1997-09-16	1997-08-26	1	$ 20.129,00	Queen Cozinha	Alameda dos Canàrios, 891	Sao Paulo	SP	05487-020	Brazil
10638	LINOD	3	1997-08-20	1997-09-17	1997-09-01	1	$ 15.844,00	LINO-Delicateses	Ave. 5 de Mayo Porlamar	I. de Margarita	Nueva Esparta	4980	Venezuela
10639	SANTG	7	1997-08-20	1997-09-17	1997-08-27	3	$ 3.864,00	Santé Gourmet	Erling Skakkes gate 78	Stavern	\N	4110	Norway
10640	WANDK	4	1997-08-21	1997-09-18	1997-08-28	1	$ 2.355,00	Die Wandernde Kuh	Adenauerallee 900	Stuttgart	\N	70563	Germany
10641	HILAA	4	1997-08-22	1997-09-19	1997-08-26	2	$ 17.961,00	HILARION-Abastos	Carrera 22 con Ave. Carlos Soublette #8-35	San Cristóbal	Táchira	5022	Venezuela
10642	SIMOB	7	1997-08-22	1997-09-19	1997-09-05	3	$ 4.189,00	Simons bistro	Vinbæltet 34	Kobenhavn	\N	1734	Denmark
10643	ALFKI	6	1997-08-25	1997-09-22	1997-09-02	1	$ 2.946,00	Alfreds Futterkiste	Obere Str. 57	Berlin	\N	12209	Germany
10644	WELLI	3	1997-08-25	1997-09-22	1997-09-01	2	$ 14,00	Wellington Importadora	Rua do Mercado, 12	Resende	SP	08737-363	Brazil
10645	HANAR	4	1997-08-26	1997-09-23	1997-09-02	1	$ 1.241,00	Hanari Carnes	Rua do Paço, 67	Rio de Janeiro	RJ	05454-876	Brazil
10646	HUNGO	9	1997-08-27	1997-10-08	1997-09-03	3	$ 14.233,00	Hungry Owl All-Night Grocers	8 Johnstown Road	Cork	Co. Cork	\N	Ireland
10647	QUEDE	4	1997-08-27	1997-09-10	1997-09-03	2	$ 4.554,00	Que Delícia	Rua da Panificadora, 12	Rio de Janeiro	RJ	02389-673	Brazil
10648	RICAR	5	1997-08-28	1997-10-09	1997-09-09	2	$ 1.425,00	Ricardo Adocicados	Av. Copacabana, 267	Rio de Janeiro	RJ	02389-890	Brazil
10649	MAISD	5	1997-08-28	1997-09-25	1997-08-29	3	$ 62,00	Maison Dewey	Rue Joseph-Bens 532	Bruxelles	\N	B-1180	Belgium
10650	FAMIA	5	1997-08-29	1997-09-26	1997-09-03	3	$ 17.681,00	Familia Arquibaldo	Rua Orós, 92	Sao Paulo	SP	05442-030	Brazil
10651	WANDK	8	1997-09-01	1997-09-29	1997-09-11	2	$ 206,00	Die Wandernde Kuh	Adenauerallee 900	Stuttgart	\N	70563	Germany
10652	GOURL	4	1997-09-01	1997-09-29	1997-09-08	2	$ 714,00	Gourmet Lanchonetes	Av. Brasil, 442	Campinas	SP	04876-786	Brazil
10653	FRANK	1	1997-09-02	1997-09-30	1997-09-19	1	$ 9.325,00	Frankenversand	Berliner Platz 43	München	\N	80805	Germany
10654	BERGS	5	1997-09-02	1997-09-30	1997-09-11	1	$ 5.526,00	Berglunds snabbköp	Berguvsvägen  8	Luleå	\N	S-958 22	Sweden
10655	REGGC	1	1997-09-03	1997-10-01	1997-09-11	2	$ 441,00	Reggiani Caseifici	Strada Provinciale 124	Reggio Emilia	\N	42100	Italy
10656	GREAL	6	1997-09-04	1997-10-02	1997-09-10	1	$ 5.715,00	Great Lakes Food Market	2732 Baker Blvd.	Eugene	OR	97403	USA
10657	SAVEA	2	1997-09-04	1997-10-02	1997-09-15	2	$ 35.269,00	Save-a-lot Markets	187 Suffolk Ln.	Boise	ID	83720	USA
10658	QUICK	4	1997-09-05	1997-10-03	1997-09-08	1	$ 36.415,00	QUICK-Stop	Taucherstraße 10	Cunewalde	\N	1307	Germany
10659	QUEEN	7	1997-09-05	1997-10-03	1997-09-10	2	$ 10.581,00	Queen Cozinha	Alameda dos Canàrios, 891	Sao Paulo	SP	05487-020	Brazil
10660	HUNGC	8	1997-09-08	1997-10-06	1997-10-15	1	$ 11.129,00	Hungry Coyote Import Store	City Center Plaza 516 Main St.	Elgin	OR	97827	USA
10661	HUNGO	7	1997-09-09	1997-10-07	1997-09-15	3	$ 1.755,00	Hungry Owl All-Night Grocers	8 Johnstown Road	Cork	Co. Cork	\N	Ireland
10662	LONEP	3	1997-09-09	1997-10-07	1997-09-18	2	$ 128,00	Lonesome Pine Restaurant	89 Chiaroscuro Rd.	Portland	OR	97219	USA
10663	BONAP	2	1997-09-10	1997-09-24	1997-10-03	2	$ 11.315,00	Bon app'	12, rue des Bouchers	Marseille	\N	13008	France
10664	FURIB	1	1997-09-10	1997-10-08	1997-09-19	3	$ 127,00	Furia Bacalhau e Frutos do Mar	Jardim das rosas n. 32	Lisboa	\N	1675	Portugal
10665	LONEP	1	1997-09-11	1997-10-09	1997-09-17	2	$ 2.631,00	Lonesome Pine Restaurant	89 Chiaroscuro Rd.	Portland	OR	97219	USA
10666	RICSU	7	1997-09-12	1997-10-10	1997-09-22	2	$ 23.242,00	Richter Supermarkt	Starenweg 5	Genève	\N	1204	Switzerland
10667	ERNSH	7	1997-09-12	1997-10-10	1997-09-19	1	$ 7.809,00	Ernst Handel	Kirchgasse 6	Graz	\N	8010	Austria
10668	WANDK	1	1997-09-15	1997-10-13	1997-09-23	2	$ 4.722,00	Die Wandernde Kuh	Adenauerallee 900	Stuttgart	\N	70563	Germany
10669	SIMOB	2	1997-09-15	1997-10-13	1997-09-22	1	$ 2.439,00	Simons bistro	Vinbæltet 34	Kobenhavn	\N	1734	Denmark
10670	FRANK	4	1997-09-16	1997-10-14	1997-09-18	1	$ 20.348,00	Frankenversand	Berliner Platz 43	München	\N	80805	Germany
10671	FRANR	1	1997-09-17	1997-10-15	1997-09-24	1	$ 3.034,00	France restauration	54, rue Royale	Nantes	\N	44000	France
10672	BERGS	9	1997-09-17	1997-10-01	1997-09-26	2	$ 9.575,00	Berglunds snabbköp	Berguvsvägen  8	Luleå	\N	S-958 22	Sweden
10673	WILMK	2	1997-09-18	1997-10-16	1997-09-19	1	$ 2.276,00	Wilman Kala	Keskuskatu 45	Helsinki	\N	21240	Finland
10674	ISLAT	4	1997-09-18	1997-10-16	1997-09-30	2	$ 9,00	Island Trading	Garden House Crowther Way	Cowes	Isle of Wight	PO31 7PJ	UK
10675	FRANK	5	1997-09-19	1997-10-17	1997-09-23	2	$ 3.185,00	Frankenversand	Berliner Platz 43	München	\N	80805	Germany
10676	TORTU	2	1997-09-22	1997-10-20	1997-09-29	2	$ 201,00	Tortuga Restaurante	Avda. Azteca 123	México D.F.	\N	5033	Mexico
10677	ANTON	1	1997-09-22	1997-10-20	1997-09-26	3	$ 403,00	Antonio Moreno Taquería	Mataderos  2312	México D.F.	\N	5023	Mexico
10678	SAVEA	7	1997-09-23	1997-10-21	1997-10-16	3	$ 38.898,00	Save-a-lot Markets	187 Suffolk Ln.	Boise	ID	83720	USA
10679	BLONP	8	1997-09-23	1997-10-21	1997-09-30	3	$ 2.794,00	Blondel père et fils	24, place Kléber	Strasbourg	\N	67000	France
10680	OLDWO	1	1997-09-24	1997-10-22	1997-09-26	1	$ 2.661,00	Old World Delicatessen	2743 Bering St.	Anchorage	AK	99508	USA
10681	GREAL	3	1997-09-25	1997-10-23	1997-09-30	3	$ 7.613,00	Great Lakes Food Market	2732 Baker Blvd.	Eugene	OR	97403	USA
10682	ANTON	3	1997-09-25	1997-10-23	1997-10-01	2	$ 3.613,00	Antonio Moreno Taquería	Mataderos  2312	México D.F.	\N	5023	Mexico
10683	DUMON	2	1997-09-26	1997-10-24	1997-10-01	1	$ 44,00	Du monde entier	67, rue des Cinquante Otages	Nantes	\N	44000	France
10684	OTTIK	3	1997-09-26	1997-10-24	1997-09-30	1	$ 14.563,00	Ottilies Käseladen	Mehrheimerstr. 369	Köln	\N	50739	Germany
10685	GOURL	4	1997-09-29	1997-10-13	1997-10-03	2	$ 3.375,00	Gourmet Lanchonetes	Av. Brasil, 442	Campinas	SP	04876-786	Brazil
10686	PICCO	2	1997-09-30	1997-10-28	1997-10-08	1	$ 965,00	Piccolo und mehr	Geislweg 14	Salzburg	\N	5020	Austria
10687	HUNGO	9	1997-09-30	1997-10-28	1997-10-30	2	$ 29.643,00	Hungry Owl All-Night Grocers	8 Johnstown Road	Cork	Co. Cork	\N	Ireland
10688	VAFFE	4	1997-10-01	1997-10-15	1997-10-07	2	$ 29.909,00	Vaffeljernet	Smagsloget 45	Århus	\N	8200	Denmark
10689	BERGS	1	1997-10-01	1997-10-29	1997-10-07	2	$ 1.342,00	Berglunds snabbköp	Berguvsvägen  8	Luleå	\N	S-958 22	Sweden
10690	HANAR	1	1997-10-02	1997-10-30	1997-10-03	1	$ 158,00	Hanari Carnes	Rua do Paço, 67	Rio de Janeiro	RJ	05454-876	Brazil
10691	QUICK	2	1997-10-03	1997-11-14	1997-10-22	2	$ 81.005,00	QUICK-Stop	Taucherstraße 10	Cunewalde	\N	1307	Germany
10692	ALFKI	4	1997-10-03	1997-10-31	1997-10-13	2	$ 6.102,00	Alfred's Futterkiste	Obere Str. 57	Berlin	\N	12209	Germany
10693	WHITC	3	1997-10-06	1997-10-20	1997-10-10	3	$ 13.934,00	White Clover Markets	1029 - 12th Ave. S.	Seattle	WA	98124	USA
10694	QUICK	8	1997-10-06	1997-11-03	1997-10-09	3	$ 39.836,00	QUICK-Stop	Taucherstraße 10	Cunewalde	\N	1307	Germany
10695	WILMK	7	1997-10-07	1997-11-18	1997-10-14	1	$ 1.672,00	Wilman Kala	Keskuskatu 45	Helsinki	\N	21240	Finland
10696	WHITC	8	1997-10-08	1997-11-19	1997-10-14	3	$ 10.255,00	White Clover Markets	1029 - 12th Ave. S.	Seattle	WA	98124	USA
10697	LINOD	3	1997-10-08	1997-11-05	1997-10-14	1	$ 4.552,00	LINO-Delicateses	Ave. 5 de Mayo Porlamar	I. de Margarita	Nueva Esparta	4980	Venezuela
10698	ERNSH	4	1997-10-09	1997-11-06	1997-10-17	1	$ 27.247,00	Ernst Handel	Kirchgasse 6	Graz	\N	8010	Austria
10699	MORGK	3	1997-10-09	1997-11-06	1997-10-13	3	$ 58,00	Morgenstern Gesundkost	Heerstr. 22	Leipzig	\N	4179	Germany
10700	SAVEA	3	1997-10-10	1997-11-07	1997-10-16	1	$ 651,00	Save-a-lot Markets	187 Suffolk Ln.	Boise	ID	83720	USA
10701	HUNGO	6	1997-10-13	1997-10-27	1997-10-15	3	$ 22.031,00	Hungry Owl All-Night Grocers	8 Johnstown Road	Cork	Co. Cork	\N	Ireland
10702	ALFKI	4	1997-10-13	1997-11-24	1997-10-21	1	$ 2.394,00	Alfred's Futterkiste	Obere Str. 57	Berlin	\N	12209	Germany
10703	FOLKO	6	1997-10-14	1997-11-11	1997-10-20	2	$ 1.523,00	Folk och fä HB	Åkergatan 24	Bräcke	\N	S-844 67	Sweden
10704	QUEEN	6	1997-10-14	1997-11-11	1997-11-07	1	$ 478,00	Queen Cozinha	Alameda dos Canàrios, 891	Sao Paulo	SP	05487-020	Brazil
10705	HILAA	9	1997-10-15	1997-11-12	1997-11-18	2	$ 352,00	HILARION-Abastos	Carrera 22 con Ave. Carlos Soublette #8-35	San Cristóbal	Táchira	5022	Venezuela
10706	OLDWO	8	1997-10-16	1997-11-13	1997-10-21	3	$ 13.563,00	Old World Delicatessen	2743 Bering St.	Anchorage	AK	99508	USA
10707	AROUT	4	1997-10-16	1997-10-30	1997-10-23	3	$ 2.174,00	Around the Horn	Brook Farm Stratford St. Mary	Colchester	Essex	CO7 6JX	UK
10708	THEBI	6	1997-10-17	1997-11-28	1997-11-05	2	$ 296,00	The Big Cheese	89 Jefferson Way Suite 2	Portland	OR	97201	USA
10709	GOURL	1	1997-10-17	1997-11-14	1997-11-20	3	$ 2.108,00	Gourmet Lanchonetes	Av. Brasil, 442	Campinas	SP	04876-786	Brazil
10710	FRANS	1	1997-10-20	1997-11-17	1997-10-23	1	$ 498,00	Franchi S.p.A.	Via Monte Bianco 34	Torino	\N	10100	Italy
10711	SAVEA	5	1997-10-21	1997-12-02	1997-10-29	2	$ 5.241,00	Save-a-lot Markets	187 Suffolk Ln.	Boise	ID	83720	USA
10712	HUNGO	3	1997-10-21	1997-11-18	1997-10-31	1	$ 8.993,00	Hungry Owl All-Night Grocers	8 Johnstown Road	Cork	Co. Cork	\N	Ireland
10713	SAVEA	1	1997-10-22	1997-11-19	1997-10-24	1	$ 16.705,00	Save-a-lot Markets	187 Suffolk Ln.	Boise	ID	83720	USA
10714	SAVEA	5	1997-10-22	1997-11-19	1997-10-27	3	$ 2.449,00	Save-a-lot Markets	187 Suffolk Ln.	Boise	ID	83720	USA
10715	BONAP	3	1997-10-23	1997-11-06	1997-10-29	1	$ 632,00	Bon app'	12, rue des Bouchers	Marseille	\N	13008	France
10716	RANCH	4	1997-10-24	1997-11-21	1997-10-27	2	$ 2.257,00	Rancho grande	Av. del Libertador 900	Buenos Aires	\N	1010	Argentina
10717	FRANK	1	1997-10-24	1997-11-21	1997-10-29	2	$ 5.925,00	Frankenversand	Berliner Platz 43	München	\N	80805	Germany
10718	KOENE	1	1997-10-27	1997-11-24	1997-10-29	3	$ 17.088,00	Königlich Essen	Maubelstr. 90	Brandenburg	\N	14776	Germany
10719	LETSS	8	1997-10-27	1997-11-24	1997-11-05	2	$ 5.144,00	Let's Stop N Shop	87 Polk St. Suite 5	San Francisco	CA	94117	USA
10720	QUEDE	8	1997-10-28	1997-11-11	1997-11-05	2	$ 953,00	Que Delícia	Rua da Panificadora, 12	Rio de Janeiro	RJ	02389-673	Brazil
10721	QUICK	5	1997-10-29	1997-11-26	1997-10-31	3	$ 4.892,00	QUICK-Stop	Taucherstraße 10	Cunewalde	\N	1307	Germany
10722	SAVEA	8	1997-10-29	1997-12-10	1997-11-04	1	$ 7.458,00	Save-a-lot Markets	187 Suffolk Ln.	Boise	ID	83720	USA
10723	WHITC	3	1997-10-30	1997-11-27	1997-11-25	1	$ 2.172,00	White Clover Markets	1029 - 12th Ave. S.	Seattle	WA	98124	USA
10724	MEREP	8	1997-10-30	1997-12-11	1997-11-05	2	$ 5.775,00	Mère Paillarde	43 rue St. Laurent	Montréal	Québec	H1J 1C3	Canada
10725	FAMIA	4	1997-10-31	1997-11-28	1997-11-05	3	$ 1.083,00	Familia Arquibaldo	Rua Orós, 92	Sao Paulo	SP	05442-030	Brazil
10726	EASTC	4	1997-11-03	1997-11-17	1997-12-05	1	$ 1.656,00	Eastern Connection	35 King George	London	\N	WX3 6FW	UK
10727	REGGC	2	1997-11-03	1997-12-01	1997-12-05	1	$ 899,00	Reggiani Caseifici	Strada Provinciale 124	Reggio Emilia	\N	42100	Italy
10728	QUEEN	4	1997-11-04	1997-12-02	1997-11-11	2	$ 5.833,00	Queen Cozinha	Alameda dos Canàrios, 891	Sao Paulo	SP	05487-020	Brazil
10729	LINOD	8	1997-11-04	1997-12-16	1997-11-14	3	$ 14.106,00	LINO-Delicateses	Ave. 5 de Mayo Porlamar	I. de Margarita	Nueva Esparta	4980	Venezuela
10730	BONAP	5	1997-11-05	1997-12-03	1997-11-14	1	$ 2.012,00	Bon app'	12, rue des Bouchers	Marseille	\N	13008	France
10731	CHOPS	7	1997-11-06	1997-12-04	1997-11-14	1	$ 9.665,00	Chop-suey Chinese	Hauptstr. 31	Bern	\N	3012	Switzerland
10732	BONAP	3	1997-11-06	1997-12-04	1997-11-07	1	$ 1.697,00	Bon app'	12, rue des Bouchers	Marseille	\N	13008	France
10733	BERGS	1	1997-11-07	1997-12-05	1997-11-10	3	$ 11.011,00	Berglunds snabbköp	Berguvsvägen  8	Luleå	\N	S-958 22	Sweden
10734	GOURL	2	1997-11-07	1997-12-05	1997-11-12	3	$ 163,00	Gourmet Lanchonetes	Av. Brasil, 442	Campinas	SP	04876-786	Brazil
10735	LETSS	6	1997-11-10	1997-12-08	1997-11-21	2	$ 4.597,00	Let's Stop N Shop	87 Polk St. Suite 5	San Francisco	CA	94117	USA
10736	HUNGO	9	1997-11-11	1997-12-09	1997-11-21	2	$ 441,00	Hungry Owl All-Night Grocers	8 Johnstown Road	Cork	Co. Cork	\N	Ireland
10737	VINET	2	1997-11-11	1997-12-09	1997-11-18	2	$ 779,00	Vins et alcools Chevalier	59 rue de l'Abbaye	Reims	\N	51100	France
10738	SPECD	2	1997-11-12	1997-12-10	1997-11-18	1	$ 291,00	Spécialités du monde	25, rue Lauriston	Paris	\N	75016	France
10739	VINET	3	1997-11-12	1997-12-10	1997-11-17	3	$ 1.108,00	Vins et alcools Chevalier	59 rue de l'Abbaye	Reims	\N	51100	France
10740	WHITC	4	1997-11-13	1997-12-11	1997-11-25	2	$ 8.188,00	White Clover Markets	1029 - 12th Ave. S.	Seattle	WA	98124	USA
10741	AROUT	4	1997-11-14	1997-11-28	1997-11-18	3	$ 1.096,00	Around the Horn	Brook Farm Stratford St. Mary	Colchester	Essex	CO7 6JX	UK
10742	BOTTM	3	1997-11-14	1997-12-12	1997-11-18	3	$ 24.373,00	Bottom-Dollar Markets	23 Tsawassen Blvd.	Tsawassen	BC	T2F 8M4	Canada
10743	AROUT	1	1997-11-17	1997-12-15	1997-11-21	2	$ 2.372,00	Around the Horn	Brook Farm Stratford St. Mary	Colchester	Essex	CO7 6JX	UK
10744	VAFFE	6	1997-11-17	1997-12-15	1997-11-24	1	$ 6.919,00	Vaffeljernet	Smagsloget 45	Århus	\N	8200	Denmark
10745	QUICK	9	1997-11-18	1997-12-16	1997-11-27	1	$ 352,00	QUICK-Stop	Taucherstraße 10	Cunewalde	\N	1307	Germany
10746	CHOPS	1	1997-11-19	1997-12-17	1997-11-21	3	$ 3.143,00	Chop-suey Chinese	Hauptstr. 31	Bern	\N	3012	Switzerland
10747	PICCO	6	1997-11-19	1997-12-17	1997-11-26	1	$ 11.733,00	Piccolo und mehr	Geislweg 14	Salzburg	\N	5020	Austria
10748	SAVEA	3	1997-11-20	1997-12-18	1997-11-28	1	$ 23.255,00	Save-a-lot Markets	187 Suffolk Ln.	Boise	ID	83720	USA
10749	ISLAT	4	1997-11-20	1997-12-18	1997-12-19	2	$ 6.153,00	Island Trading	Garden House Crowther Way	Cowes	Isle of Wight	PO31 7PJ	UK
10750	WARTH	9	1997-11-21	1997-12-19	1997-11-24	1	$ 793,00	Wartian Herkku	Torikatu 38	Oulu	\N	90110	Finland
10751	RICSU	3	1997-11-24	1997-12-22	1997-12-03	3	$ 13.079,00	Richter Supermarkt	Starenweg 5	Genève	\N	1204	Switzerland
10752	NORTS	2	1997-11-24	1997-12-22	1997-11-28	3	$ 139,00	North/South	South House 300 Queensbridge	London	\N	SW7 1RZ	UK
10753	FRANS	3	1997-11-25	1997-12-23	1997-11-27	1	$ 77,00	Franchi S.p.A.	Via Monte Bianco 34	Torino	\N	10100	Italy
10754	MAGAA	6	1997-11-25	1997-12-23	1997-11-27	3	$ 238,00	Magazzini Alimentari Riuniti	Via Ludovico il Moro 22	Bergamo	\N	24100	Italy
10755	BONAP	4	1997-11-26	1997-12-24	1997-11-28	2	$ 1.671,00	Bon app'	12, rue des Bouchers	Marseille	\N	13008	France
10756	SPLIR	8	1997-11-27	1997-12-25	1997-12-02	2	$ 7.321,00	Split Rail Beer & Ale	P.O. Box 555	Lander	WY	82520	USA
10757	SAVEA	6	1997-11-27	1997-12-25	1997-12-15	1	$ 819,00	Save-a-lot Markets	187 Suffolk Ln.	Boise	ID	83720	USA
10758	RICSU	3	1997-11-28	1997-12-26	1997-12-04	3	$ 13.817,00	Richter Supermarkt	Starenweg 5	Genève	\N	1204	Switzerland
10759	ANATR	3	1997-11-28	1997-12-26	1997-12-12	3	$ 1.199,00	Ana Trujillo Emparedados y helados	Avda. de la Constitución 2222	México D.F.	\N	5021	Mexico
10760	MAISD	4	1997-12-01	1997-12-29	1997-12-10	1	$ 15.564,00	Maison Dewey	Rue Joseph-Bens 532	Bruxelles	\N	B-1180	Belgium
10761	RATTC	5	1997-12-02	1997-12-30	1997-12-08	2	$ 1.866,00	Rattlesnake Canyon Grocery	2817 Milton Dr.	Albuquerque	NM	87110	USA
10762	FOLKO	3	1997-12-02	1997-12-30	1997-12-09	1	$ 32.874,00	Folk och fä HB	Åkergatan 24	Bräcke	\N	S-844 67	Sweden
10763	FOLIG	3	1997-12-03	1997-12-31	1997-12-08	3	$ 3.735,00	Folies gourmandes	184, chaussée de Tournai	Lille	\N	59000	France
10764	ERNSH	6	1997-12-03	1997-12-31	1997-12-08	3	$ 14.545,00	Ernst Handel	Kirchgasse 6	Graz	\N	8010	Austria
10765	QUICK	3	1997-12-04	1998-01-01	1997-12-09	3	$ 4.274,00	QUICK-Stop	Taucherstraße 10	Cunewalde	\N	1307	Germany
10766	OTTIK	4	1997-12-05	1998-01-02	1997-12-09	1	$ 15.755,00	Ottilies Käseladen	Mehrheimerstr. 369	Köln	\N	50739	Germany
10767	SUPRD	4	1997-12-05	1998-01-02	1997-12-15	3	$ 159,00	Suprêmes délices	Boulevard Tirou, 255	Charleroi	\N	B-6000	Belgium
10768	AROUT	3	1997-12-08	1998-01-05	1997-12-15	2	$ 14.632,00	Around the Horn	Brook Farm Stratford St. Mary	Colchester	Essex	CO7 6JX	UK
10769	VAFFE	3	1997-12-08	1998-01-05	1997-12-12	1	$ 6.506,00	Vaffeljernet	Smagsloget 45	Århus	\N	8200	Denmark
10770	HANAR	8	1997-12-09	1998-01-06	1997-12-17	3	$ 532,00	Hanari Carnes	Rua do Paço, 67	Rio de Janeiro	RJ	05454-876	Brazil
10771	ERNSH	9	1997-12-10	1998-01-07	1998-01-02	2	$ 1.119,00	Ernst Handel	Kirchgasse 6	Graz	\N	8010	Austria
10772	LEHMS	3	1997-12-10	1998-01-07	1997-12-19	2	$ 9.128,00	Lehmanns Marktstand	Magazinweg 7	Frankfurt a.M.	\N	60528	Germany
10773	ERNSH	1	1997-12-11	1998-01-08	1997-12-16	3	$ 9.643,00	Ernst Handel	Kirchgasse 6	Graz	\N	8010	Austria
10774	FOLKO	4	1997-12-11	1997-12-25	1997-12-12	1	$ 482,00	Folk och fä HB	Åkergatan 24	Bräcke	\N	S-844 67	Sweden
10775	THECR	7	1997-12-12	1998-01-09	1997-12-26	1	$ 2.025,00	The Cracker Box	55 Grizzly Peak Rd.	Butte	MT	59801	USA
10776	ERNSH	1	1997-12-15	1998-01-12	1997-12-18	3	$ 35.153,00	Ernst Handel	Kirchgasse 6	Graz	\N	8010	Austria
10777	GOURL	7	1997-12-15	1997-12-29	1998-01-21	2	$ 301,00	Gourmet Lanchonetes	Av. Brasil, 442	Campinas	SP	04876-786	Brazil
10778	BERGS	3	1997-12-16	1998-01-13	1997-12-24	1	$ 679,00	Berglunds snabbköp	Berguvsvägen  8	Luleå	\N	S-958 22	Sweden
10779	MORGK	3	1997-12-16	1998-01-13	1998-01-14	2	$ 5.813,00	Morgenstern Gesundkost	Heerstr. 22	Leipzig	\N	4179	Germany
10780	LILAS	2	1997-12-16	1997-12-30	1997-12-25	1	$ 4.213,00	LILA-Supermercado	Carrera 52 con Ave. Bolívar #65-98 Llano Largo	Barquisimeto	Lara	3508	Venezuela
10781	WARTH	2	1997-12-17	1998-01-14	1997-12-19	3	$ 7.316,00	Wartian Herkku	Torikatu 38	Oulu	\N	90110	Finland
10782	CACTU	9	1997-12-17	1998-01-14	1997-12-22	3	$ 11,00	Cactus Comidas para llevar	Cerrito 333	Buenos Aires	\N	1010	Argentina
10783	HANAR	4	1997-12-18	1998-01-15	1997-12-19	2	$ 12.498,00	Hanari Carnes	Rua do Paço, 67	Rio de Janeiro	RJ	05454-876	Brazil
10784	MAGAA	4	1997-12-18	1998-01-15	1997-12-22	3	$ 7.009,00	Magazzini Alimentari Riuniti	Via Ludovico il Moro 22	Bergamo	\N	24100	Italy
10785	GROSR	1	1997-12-18	1998-01-15	1997-12-24	3	$ 151,00	GROSELLA-Restaurante	5ª Ave. Los Palos Grandes	Caracas	DF	1081	Venezuela
10786	QUEEN	8	1997-12-19	1998-01-16	1997-12-23	1	$ 11.087,00	Queen Cozinha	Alameda dos Canàrios, 891	Sao Paulo	SP	05487-020	Brazil
10787	LAMAI	2	1997-12-19	1998-01-02	1997-12-26	1	$ 24.993,00	La maison d'Asie	1 rue Alsace-Lorraine	Toulouse	\N	31000	France
10788	QUICK	1	1997-12-22	1998-01-19	1998-01-19	2	$ 427,00	QUICK-Stop	Taucherstraße 10	Cunewalde	\N	1307	Germany
10789	FOLIG	1	1997-12-22	1998-01-19	1997-12-31	2	$ 1.006,00	Folies gourmandes	184, chaussée de Tournai	Lille	\N	59000	France
10790	GOURL	6	1997-12-22	1998-01-19	1997-12-26	1	$ 2.823,00	Gourmet Lanchonetes	Av. Brasil, 442	Campinas	SP	04876-786	Brazil
10791	FRANK	6	1997-12-23	1998-01-20	1998-01-01	2	$ 1.685,00	Frankenversand	Berliner Platz 43	München	\N	80805	Germany
10792	WOLZA	1	1997-12-23	1998-01-20	1997-12-31	3	$ 2.379,00	Wolski Zajazd	ul. Filtrowa 68	Warszawa	\N	01-012	Poland
10793	AROUT	3	1997-12-24	1998-01-21	1998-01-08	3	$ 452,00	Around the Horn	Brook Farm Stratford St. Mary	Colchester	Essex	CO7 6JX	UK
10794	QUEDE	6	1997-12-24	1998-01-21	1998-01-02	1	$ 2.149,00	Que Delícia	Rua da Panificadora, 12	Rio de Janeiro	RJ	02389-673	Brazil
10795	ERNSH	8	1997-12-24	1998-01-21	1998-01-20	2	$ 12.666,00	Ernst Handel	Kirchgasse 6	Graz	\N	8010	Austria
10796	HILAA	3	1997-12-25	1998-01-22	1998-01-14	1	$ 2.652,00	HILARION-Abastos	Carrera 22 con Ave. Carlos Soublette #8-35	San Cristóbal	Táchira	5022	Venezuela
10797	DRACD	7	1997-12-25	1998-01-22	1998-01-05	2	$ 3.335,00	Drachenblut Delikatessen	Walserweg 21	Aachen	\N	52066	Germany
10798	ISLAT	2	1997-12-26	1998-01-23	1998-01-05	1	$ 233,00	Island Trading	Garden House Crowther Way	Cowes	Isle of Wight	PO31 7PJ	UK
10799	KOENE	9	1997-12-26	1998-02-06	1998-01-05	3	$ 3.076,00	Königlich Essen	Maubelstr. 90	Brandenburg	\N	14776	Germany
10800	SEVES	1	1997-12-26	1998-01-23	1998-01-05	3	$ 13.744,00	Seven Seas Imports	90 Wadhurst Rd.	London	\N	OX15 4NB	UK
10801	BOLID	4	1997-12-29	1998-01-26	1997-12-31	2	$ 9.709,00	Bólido Comidas preparadas	C/ Araquil, 67	Madrid	\N	28023	Spain
10802	SIMOB	4	1997-12-29	1998-01-26	1998-01-02	2	$ 25.726,00	Simons bistro	Vinbæltet 34	Kobenhavn	\N	1734	Denmark
10803	WELLI	4	1997-12-30	1998-01-27	1998-01-06	1	$ 5.523,00	Wellington Importadora	Rua do Mercado, 12	Resende	SP	08737-363	Brazil
10804	SEVES	6	1997-12-30	1998-01-27	1998-01-07	2	$ 2.733,00	Seven Seas Imports	90 Wadhurst Rd.	London	\N	OX15 4NB	UK
10805	THEBI	2	1997-12-30	1998-01-27	1998-01-09	3	$ 23.734,00	The Big Cheese	89 Jefferson Way Suite 2	Portland	OR	97201	USA
10806	VICTE	3	1997-12-31	1998-01-28	1998-01-05	2	$ 2.211,00	Victuailles en stock	2, rue du Commerce	Lyon	\N	69004	France
10807	FRANS	4	1997-12-31	1998-01-28	1998-01-30	1	$ 136,00	Franchi S.p.A.	Via Monte Bianco 34	Torino	\N	10100	Italy
10808	OLDWO	2	1998-01-01	1998-01-29	1998-01-09	3	$ 4.553,00	Old World Delicatessen	2743 Bering St.	Anchorage	AK	99508	USA
10809	WELLI	7	1998-01-01	1998-01-29	1998-01-07	1	$ 487,00	Wellington Importadora	Rua do Mercado, 12	Resende	SP	08737-363	Brazil
10810	LAUGB	2	1998-01-01	1998-01-29	1998-01-07	3	$ 433,00	Laughing Bacchus Wine Cellars	2319 Elm St.	Vancouver	BC	V3F 2K1	Canada
10811	LINOD	8	1998-01-02	1998-01-30	1998-01-08	1	$ 3.122,00	LINO-Delicateses	Ave. 5 de Mayo Porlamar	I. de Margarita	Nueva Esparta	4980	Venezuela
10812	REGGC	5	1998-01-02	1998-01-30	1998-01-12	1	$ 5.978,00	Reggiani Caseifici	Strada Provinciale 124	Reggio Emilia	\N	42100	Italy
10813	RICAR	1	1998-01-05	1998-02-02	1998-01-09	1	$ 4.738,00	Ricardo Adocicados	Av. Copacabana, 267	Rio de Janeiro	RJ	02389-890	Brazil
10814	VICTE	3	1998-01-05	1998-02-02	1998-01-14	3	$ 13.094,00	Victuailles en stock	2, rue du Commerce	Lyon	\N	69004	France
10815	SAVEA	2	1998-01-05	1998-02-02	1998-01-14	3	$ 1.462,00	Save-a-lot Markets	187 Suffolk Ln.	Boise	ID	83720	USA
10816	GREAL	4	1998-01-06	1998-02-03	1998-02-04	2	$ 71.978,00	Great Lakes Food Market	2732 Baker Blvd.	Eugene	OR	97403	USA
10817	KOENE	3	1998-01-06	1998-01-20	1998-01-13	2	$ 30.607,00	Königlich Essen	Maubelstr. 90	Brandenburg	\N	14776	Germany
10818	MAGAA	7	1998-01-07	1998-02-04	1998-01-12	3	$ 6.548,00	Magazzini Alimentari Riuniti	Via Ludovico il Moro 22	Bergamo	\N	24100	Italy
10819	CACTU	2	1998-01-07	1998-02-04	1998-01-16	3	$ 1.976,00	Cactus Comidas para llevar	Cerrito 333	Buenos Aires	\N	1010	Argentina
10820	RATTC	3	1998-01-07	1998-02-04	1998-01-13	2	$ 3.752,00	Rattlesnake Canyon Grocery	2817 Milton Dr.	Albuquerque	NM	87110	USA
10821	SPLIR	1	1998-01-08	1998-02-05	1998-01-15	1	$ 3.668,00	Split Rail Beer & Ale	P.O. Box 555	Lander	WY	82520	USA
10822	TRAIH	6	1998-01-08	1998-02-05	1998-01-16	3	$ 70,00	Trail's Head Gourmet Provisioners	722 DaVinci Blvd.	Kirkland	WA	98034	USA
10823	LILAS	5	1998-01-09	1998-02-06	1998-01-13	2	$ 16.397,00	LILA-Supermercado	Carrera 52 con Ave. Bolívar #65-98 Llano Largo	Barquisimeto	Lara	3508	Venezuela
10824	FOLKO	8	1998-01-09	1998-02-06	1998-01-30	1	$ 123,00	Folk och fä HB	Åkergatan 24	Bräcke	\N	S-844 67	Sweden
10825	DRACD	1	1998-01-09	1998-02-06	1998-01-14	1	$ 7.925,00	Drachenblut Delikatessen	Walserweg 21	Aachen	\N	52066	Germany
10826	BLONP	6	1998-01-12	1998-02-09	1998-02-06	1	$ 709,00	Blondel père et fils	24, place Kléber	Strasbourg	\N	67000	France
10827	BONAP	1	1998-01-12	1998-01-26	1998-02-06	2	$ 6.354,00	Bon app'	12, rue des Bouchers	Marseille	\N	13008	France
10828	RANCH	9	1998-01-13	1998-01-27	1998-02-04	1	$ 9.085,00	Rancho grande	Av. del Libertador 900	Buenos Aires	\N	1010	Argentina
10829	ISLAT	9	1998-01-13	1998-02-10	1998-01-23	1	$ 15.472,00	Island Trading	Garden House Crowther Way	Cowes	Isle of Wight	PO31 7PJ	UK
10830	TRADH	4	1998-01-13	1998-02-24	1998-01-21	2	$ 8.183,00	Tradiçao Hipermercados	Av. Inês de Castro, 414	Sao Paulo	SP	05634-030	Brazil
10831	SANTG	3	1998-01-14	1998-02-11	1998-01-23	2	$ 7.219,00	Santé Gourmet	Erling Skakkes gate 78	Stavern	\N	4110	Norway
10832	LAMAI	2	1998-01-14	1998-02-11	1998-01-19	2	$ 4.326,00	La maison d'Asie	1 rue Alsace-Lorraine	Toulouse	\N	31000	France
10833	OTTIK	6	1998-01-15	1998-02-12	1998-01-23	2	$ 7.149,00	Ottilies Käseladen	Mehrheimerstr. 369	Köln	\N	50739	Germany
10834	TRADH	1	1998-01-15	1998-02-12	1998-01-19	3	$ 2.978,00	Tradiçao Hipermercados	Av. Inês de Castro, 414	Sao Paulo	SP	05634-030	Brazil
10835	ALFKI	1	1998-01-15	1998-02-12	1998-01-21	3	$ 6.953,00	Alfred's Futterkiste	Obere Str. 57	Berlin	\N	12209	Germany
10836	ERNSH	7	1998-01-16	1998-02-13	1998-01-21	1	$ 41.188,00	Ernst Handel	Kirchgasse 6	Graz	\N	8010	Austria
10837	BERGS	9	1998-01-16	1998-02-13	1998-01-23	3	$ 1.332,00	Berglunds snabbköp	Berguvsvägen  8	Luleå	\N	S-958 22	Sweden
10838	LINOD	3	1998-01-19	1998-02-16	1998-01-23	3	$ 5.928,00	LINO-Delicateses	Ave. 5 de Mayo Porlamar	I. de Margarita	Nueva Esparta	4980	Venezuela
10839	TRADH	3	1998-01-19	1998-02-16	1998-01-22	3	$ 3.543,00	Tradiçao Hipermercados	Av. Inês de Castro, 414	Sao Paulo	SP	05634-030	Brazil
10840	LINOD	4	1998-01-19	1998-03-02	1998-02-16	2	$ 271,00	LINO-Delicateses	Ave. 5 de Mayo Porlamar	I. de Margarita	Nueva Esparta	4980	Venezuela
10841	SUPRD	5	1998-01-20	1998-02-17	1998-01-29	2	$ 4.243,00	Suprêmes délices	Boulevard Tirou, 255	Charleroi	\N	B-6000	Belgium
10842	TORTU	1	1998-01-20	1998-02-17	1998-01-29	3	$ 5.442,00	Tortuga Restaurante	Avda. Azteca 123	México D.F.	\N	5033	Mexico
10843	VICTE	4	1998-01-21	1998-02-18	1998-01-26	2	$ 926,00	Victuailles en stock	2, rue du Commerce	Lyon	\N	69004	France
10844	PICCO	8	1998-01-21	1998-02-18	1998-01-26	2	$ 2.522,00	Piccolo und mehr	Geislweg 14	Salzburg	\N	5020	Austria
10845	QUICK	8	1998-01-21	1998-02-04	1998-01-30	1	$ 21.298,00	QUICK-Stop	Taucherstraße 10	Cunewalde	\N	1307	Germany
10846	SUPRD	2	1998-01-22	1998-03-05	1998-01-23	3	$ 5.646,00	Suprêmes délices	Boulevard Tirou, 255	Charleroi	\N	B-6000	Belgium
10847	SAVEA	4	1998-01-22	1998-02-05	1998-02-10	3	$ 48.757,00	Save-a-lot Markets	187 Suffolk Ln.	Boise	ID	83720	USA
10848	CONSH	7	1998-01-23	1998-02-20	1998-01-29	2	$ 3.824,00	Consolidated Holdings	Berkeley Gardens 12  Brewery	London	\N	WX1 6LT	UK
10849	KOENE	9	1998-01-23	1998-02-20	1998-01-30	2	$ 56,00	Königlich Essen	Maubelstr. 90	Brandenburg	\N	14776	Germany
10850	VICTE	1	1998-01-23	1998-03-06	1998-01-30	1	$ 4.919,00	Victuailles en stock	2, rue du Commerce	Lyon	\N	69004	France
10851	RICAR	5	1998-01-26	1998-02-23	1998-02-02	1	$ 16.055,00	Ricardo Adocicados	Av. Copacabana, 267	Rio de Janeiro	RJ	02389-890	Brazil
10852	RATTC	8	1998-01-26	1998-02-09	1998-01-30	1	$ 17.405,00	Rattlesnake Canyon Grocery	2817 Milton Dr.	Albuquerque	NM	87110	USA
10853	BLAUS	9	1998-01-27	1998-02-24	1998-02-03	2	$ 5.383,00	Blauer See Delikatessen	Forsterstr. 57	Mannheim	\N	68306	Germany
10854	ERNSH	3	1998-01-27	1998-02-24	1998-02-05	2	$ 10.022,00	Ernst Handel	Kirchgasse 6	Graz	\N	8010	Austria
10855	OLDWO	3	1998-01-27	1998-02-24	1998-02-04	1	$ 17.097,00	Old World Delicatessen	2743 Bering St.	Anchorage	AK	99508	USA
10856	ANTON	3	1998-01-28	1998-02-25	1998-02-10	2	$ 5.843,00	Antonio Moreno Taquería	Mataderos  2312	México D.F.	\N	5023	Mexico
10857	BERGS	8	1998-01-28	1998-02-25	1998-02-06	2	$ 18.885,00	Berglunds snabbköp	Berguvsvägen  8	Luleå	\N	S-958 22	Sweden
10858	LACOR	2	1998-01-29	1998-02-26	1998-02-03	1	$ 5.251,00	La corne d'abondance	67, avenue de l'Europe	Versailles	\N	78000	France
10859	FRANK	1	1998-01-29	1998-02-26	1998-02-02	2	$ 761,00	Frankenversand	Berliner Platz 43	München	\N	80805	Germany
10860	FRANR	3	1998-01-29	1998-02-26	1998-02-04	3	$ 1.926,00	France restauration	54, rue Royale	Nantes	\N	44000	France
10861	WHITC	4	1998-01-30	1998-02-27	1998-02-17	2	$ 1.493,00	White Clover Markets	1029 - 12th Ave. S.	Seattle	WA	98124	USA
10862	LEHMS	8	1998-01-30	1998-03-13	1998-02-02	2	$ 5.323,00	Lehmanns Marktstand	Magazinweg 7	Frankfurt a.M.	\N	60528	Germany
10863	HILAA	4	1998-02-02	1998-03-02	1998-02-17	2	$ 3.026,00	HILARION-Abastos	Carrera 22 con Ave. Carlos Soublette #8-35	San Cristóbal	Táchira	5022	Venezuela
10864	AROUT	4	1998-02-02	1998-03-02	1998-02-09	2	$ 304,00	Around the Horn	Brook Farm Stratford St. Mary	Colchester	Essex	CO7 6JX	UK
10865	QUICK	2	1998-02-02	1998-02-16	1998-02-12	1	$ 34.814,00	QUICK-Stop	Taucherstraße 10	Cunewalde	\N	1307	Germany
10866	BERGS	5	1998-02-03	1998-03-03	1998-02-12	1	$ 10.911,00	Berglunds snabbköp	Berguvsvägen  8	Luleå	\N	S-958 22	Sweden
10867	LONEP	6	1998-02-03	1998-03-17	1998-02-11	1	$ 193,00	Lonesome Pine Restaurant	89 Chiaroscuro Rd.	Portland	OR	97219	USA
10868	QUEEN	7	1998-02-04	1998-03-04	1998-02-23	2	$ 19.127,00	Queen Cozinha	Alameda dos Canàrios, 891	Sao Paulo	SP	05487-020	Brazil
10869	SEVES	5	1998-02-04	1998-03-04	1998-02-09	1	$ 14.328,00	Seven Seas Imports	90 Wadhurst Rd.	London	\N	OX15 4NB	UK
10870	WOLZA	5	1998-02-04	1998-03-04	1998-02-13	3	$ 1.204,00	Wolski Zajazd	ul. Filtrowa 68	Warszawa	\N	01-012	Poland
10871	BONAP	9	1998-02-05	1998-03-05	1998-02-10	2	$ 11.227,00	Bon app'	12, rue des Bouchers	Marseille	\N	13008	France
10872	GODOS	5	1998-02-05	1998-03-05	1998-02-09	2	$ 17.532,00	Godos Cocina Típica	C/ Romero, 33	Sevilla	\N	41101	Spain
10873	WILMK	4	1998-02-06	1998-03-06	1998-02-09	1	$ 82,00	Wilman Kala	Keskuskatu 45	Helsinki	\N	21240	Finland
10874	GODOS	5	1998-02-06	1998-03-06	1998-02-11	2	$ 1.958,00	Godos Cocina Típica	C/ Romero, 33	Sevilla	\N	41101	Spain
10875	BERGS	4	1998-02-06	1998-03-06	1998-03-03	2	$ 3.237,00	Berglunds snabbköp	Berguvsvägen  8	Luleå	\N	S-958 22	Sweden
10876	BONAP	7	1998-02-09	1998-03-09	1998-02-12	3	$ 6.042,00	Bon app'	12, rue des Bouchers	Marseille	\N	13008	France
10877	RICAR	1	1998-02-09	1998-03-09	1998-02-19	1	$ 3.806,00	Ricardo Adocicados	Av. Copacabana, 267	Rio de Janeiro	RJ	02389-890	Brazil
10878	QUICK	4	1998-02-10	1998-03-10	1998-02-12	1	$ 4.669,00	QUICK-Stop	Taucherstraße 10	Cunewalde	\N	1307	Germany
10879	WILMK	3	1998-02-10	1998-03-10	1998-02-12	3	$ 85,00	Wilman Kala	Keskuskatu 45	Helsinki	\N	21240	Finland
10880	FOLKO	7	1998-02-10	1998-03-24	1998-02-18	1	$ 8.801,00	Folk och fä HB	Åkergatan 24	Bräcke	\N	S-844 67	Sweden
10881	CACTU	4	1998-02-11	1998-03-11	1998-02-18	1	$ 284,00	Cactus Comidas para llevar	Cerrito 333	Buenos Aires	\N	1010	Argentina
10882	SAVEA	4	1998-02-11	1998-03-11	1998-02-20	3	$ 231,00	Save-a-lot Markets	187 Suffolk Ln.	Boise	ID	83720	USA
10883	LONEP	8	1998-02-12	1998-03-12	1998-02-20	3	$ 53,00	Lonesome Pine Restaurant	89 Chiaroscuro Rd.	Portland	OR	97219	USA
10884	LETSS	4	1998-02-12	1998-03-12	1998-02-13	2	$ 9.097,00	Let's Stop N Shop	87 Polk St. Suite 5	San Francisco	CA	94117	USA
10885	SUPRD	6	1998-02-12	1998-03-12	1998-02-18	3	$ 564,00	Suprêmes délices	Boulevard Tirou, 255	Charleroi	\N	B-6000	Belgium
10886	HANAR	1	1998-02-13	1998-03-13	1998-03-02	1	$ 499,00	Hanari Carnes	Rua do Paço, 67	Rio de Janeiro	RJ	05454-876	Brazil
10887	GALED	8	1998-02-13	1998-03-13	1998-02-16	3	$ 125,00	Galería del gastronómo	Rambla de Cataluña, 23	Barcelona	\N	8022	Spain
10888	GODOS	1	1998-02-16	1998-03-16	1998-02-23	2	$ 5.187,00	Godos Cocina Típica	C/ Romero, 33	Sevilla	\N	41101	Spain
10889	RATTC	9	1998-02-16	1998-03-16	1998-02-23	3	$ 28.061,00	Rattlesnake Canyon Grocery	2817 Milton Dr.	Albuquerque	NM	87110	USA
10890	DUMON	7	1998-02-16	1998-03-16	1998-02-18	1	$ 3.276,00	Du monde entier	67, rue des Cinquante Otages	Nantes	\N	44000	France
10891	LEHMS	7	1998-02-17	1998-03-17	1998-02-19	2	$ 2.037,00	Lehmanns Marktstand	Magazinweg 7	Frankfurt a.M.	\N	60528	Germany
10892	MAISD	4	1998-02-17	1998-03-17	1998-02-19	2	$ 12.027,00	Maison Dewey	Rue Joseph-Bens 532	Bruxelles	\N	B-1180	Belgium
10893	KOENE	9	1998-02-18	1998-03-18	1998-02-20	2	$ 7.778,00	Königlich Essen	Maubelstr. 90	Brandenburg	\N	14776	Germany
10894	SAVEA	1	1998-02-18	1998-03-18	1998-02-20	1	$ 11.613,00	Save-a-lot Markets	187 Suffolk Ln.	Boise	ID	83720	USA
10895	ERNSH	3	1998-02-18	1998-03-18	1998-02-23	1	$ 16.275,00	Ernst Handel	Kirchgasse 6	Graz	\N	8010	Austria
10896	MAISD	7	1998-02-19	1998-03-19	1998-02-27	3	$ 3.245,00	Maison Dewey	Rue Joseph-Bens 532	Bruxelles	\N	B-1180	Belgium
10897	HUNGO	3	1998-02-19	1998-03-19	1998-02-25	2	$ 60.354,00	Hungry Owl All-Night Grocers	8 Johnstown Road	Cork	Co. Cork	\N	Ireland
10898	OCEAN	4	1998-02-20	1998-03-20	1998-03-06	2	$ 127,00	Océano Atlántico Ltda.	Ing. Gustavo Moncada 8585 Piso 20-A	Buenos Aires	\N	1010	Argentina
10899	LILAS	5	1998-02-20	1998-03-20	1998-02-26	3	$ 121,00	LILA-Supermercado	Carrera 52 con Ave. Bolívar #65-98 Llano Largo	Barquisimeto	Lara	3508	Venezuela
10900	WELLI	1	1998-02-20	1998-03-20	1998-03-04	2	$ 166,00	Wellington Importadora	Rua do Mercado, 12	Resende	SP	08737-363	Brazil
10901	HILAA	4	1998-02-23	1998-03-23	1998-02-26	1	$ 6.209,00	HILARION-Abastos	Carrera 22 con Ave. Carlos Soublette #8-35	San Cristóbal	Táchira	5022	Venezuela
10902	FOLKO	1	1998-02-23	1998-03-23	1998-03-03	1	$ 4.415,00	Folk och fä HB	Åkergatan 24	Bräcke	\N	S-844 67	Sweden
10903	HANAR	3	1998-02-24	1998-03-24	1998-03-04	3	$ 3.671,00	Hanari Carnes	Rua do Paço, 67	Rio de Janeiro	RJ	05454-876	Brazil
10904	WHITC	3	1998-02-24	1998-03-24	1998-02-27	3	$ 16.295,00	White Clover Markets	1029 - 12th Ave. S.	Seattle	WA	98124	USA
10905	WELLI	9	1998-02-24	1998-03-24	1998-03-06	2	$ 1.372,00	Wellington Importadora	Rua do Mercado, 12	Resende	SP	08737-363	Brazil
10906	WOLZA	4	1998-02-25	1998-03-11	1998-03-03	3	$ 2.629,00	Wolski Zajazd	ul. Filtrowa 68	Warszawa	\N	01-012	Poland
10907	SPECD	6	1998-02-25	1998-03-25	1998-02-27	3	$ 919,00	Spécialités du monde	25, rue Lauriston	Paris	\N	75016	France
10908	REGGC	4	1998-02-26	1998-03-26	1998-03-06	2	$ 3.296,00	Reggiani Caseifici	Strada Provinciale 124	Reggio Emilia	\N	42100	Italy
10909	SANTG	1	1998-02-26	1998-03-26	1998-03-10	2	$ 5.305,00	Santé Gourmet	Erling Skakkes gate 78	Stavern	\N	4110	Norway
10910	WILMK	1	1998-02-26	1998-03-26	1998-03-04	3	$ 3.811,00	Wilman Kala	Keskuskatu 45	Helsinki	\N	21240	Finland
10911	GODOS	3	1998-02-26	1998-03-26	1998-03-05	1	$ 3.819,00	Godos Cocina Típica	C/ Romero, 33	Sevilla	\N	41101	Spain
10912	HUNGO	2	1998-02-26	1998-03-26	1998-03-18	2	$ 58.091,00	Hungry Owl All-Night Grocers	8 Johnstown Road	Cork	Co. Cork	\N	Ireland
10913	QUEEN	4	1998-02-26	1998-03-26	1998-03-04	1	$ 3.305,00	Queen Cozinha	Alameda dos Canàrios, 891	Sao Paulo	SP	05487-020	Brazil
10914	QUEEN	6	1998-02-27	1998-03-27	1998-03-02	1	$ 2.119,00	Queen Cozinha	Alameda dos Canàrios, 891	Sao Paulo	SP	05487-020	Brazil
10915	TORTU	2	1998-02-27	1998-03-27	1998-03-02	2	$ 351,00	Tortuga Restaurante	Avda. Azteca 123	México D.F.	\N	5033	Mexico
10916	RANCH	1	1998-02-27	1998-03-27	1998-03-09	2	$ 6.377,00	Rancho grande	Av. del Libertador 900	Buenos Aires	\N	1010	Argentina
10917	ROMEY	4	1998-03-02	1998-03-30	1998-03-11	2	$ 829,00	Romero y tomillo	Gran Vía, 1	Madrid	\N	28001	Spain
10918	BOTTM	3	1998-03-02	1998-03-30	1998-03-11	3	$ 4.883,00	Bottom-Dollar Markets	23 Tsawassen Blvd.	Tsawassen	BC	T2F 8M4	Canada
10919	LINOD	2	1998-03-02	1998-03-30	1998-03-04	2	$ 198,00	LINO-Delicateses	Ave. 5 de Mayo Porlamar	I. de Margarita	Nueva Esparta	4980	Venezuela
10920	AROUT	4	1998-03-03	1998-03-31	1998-03-09	2	$ 2.961,00	Around the Horn	Brook Farm Stratford St. Mary	Colchester	Essex	CO7 6JX	UK
10921	VAFFE	1	1998-03-03	1998-04-14	1998-03-09	1	$ 17.648,00	Vaffeljernet	Smagsloget 45	Århus	\N	8200	Denmark
10922	HANAR	5	1998-03-03	1998-03-31	1998-03-05	3	$ 6.274,00	Hanari Carnes	Rua do Paço, 67	Rio de Janeiro	RJ	05454-876	Brazil
10923	LAMAI	7	1998-03-03	1998-04-14	1998-03-13	3	$ 6.826,00	La maison d'Asie	1 rue Alsace-Lorraine	Toulouse	\N	31000	France
10924	BERGS	3	1998-03-04	1998-04-01	1998-04-08	2	$ 15.152,00	Berglunds snabbköp	Berguvsvägen  8	Luleå	\N	S-958 22	Sweden
10925	HANAR	3	1998-03-04	1998-04-01	1998-03-13	1	$ 227,00	Hanari Carnes	Rua do Paço, 67	Rio de Janeiro	RJ	05454-876	Brazil
10926	ANATR	4	1998-03-04	1998-04-01	1998-03-11	3	$ 3.992,00	Ana Trujillo Emparedados y helados	Avda. de la Constitución 2222	México D.F.	\N	5021	Mexico
10927	LACOR	4	1998-03-05	1998-04-02	1998-04-08	1	$ 1.979,00	La corne d'abondance	67, avenue de l'Europe	Versailles	\N	78000	France
10928	GALED	1	1998-03-05	1998-04-02	1998-03-18	1	$ 136,00	Galería del gastronómo	Rambla de Cataluña, 23	Barcelona	\N	8022	Spain
10929	FRANK	6	1998-03-05	1998-04-02	1998-03-12	1	$ 3.393,00	Frankenversand	Berliner Platz 43	München	\N	80805	Germany
10930	SUPRD	4	1998-03-06	1998-04-17	1998-03-18	3	$ 1.555,00	Suprêmes délices	Boulevard Tirou, 255	Charleroi	\N	B-6000	Belgium
10931	RICSU	4	1998-03-06	1998-03-20	1998-03-19	2	$ 136,00	Richter Supermarkt	Starenweg 5	Genève	\N	1204	Switzerland
10932	BONAP	8	1998-03-06	1998-04-03	1998-03-24	1	$ 13.464,00	Bon app'	12, rue des Bouchers	Marseille	\N	13008	France
10933	ISLAT	6	1998-03-06	1998-04-03	1998-03-16	3	$ 5.415,00	Island Trading	Garden House Crowther Way	Cowes	Isle of Wight	PO31 7PJ	UK
10934	LEHMS	3	1998-03-09	1998-04-06	1998-03-12	3	$ 3.201,00	Lehmanns Marktstand	Magazinweg 7	Frankfurt a.M.	\N	60528	Germany
10935	WELLI	4	1998-03-09	1998-04-06	1998-03-18	3	$ 4.759,00	Wellington Importadora	Rua do Mercado, 12	Resende	SP	08737-363	Brazil
10936	GREAL	3	1998-03-09	1998-04-06	1998-03-18	2	$ 3.368,00	Great Lakes Food Market	2732 Baker Blvd.	Eugene	OR	97403	USA
10937	CACTU	7	1998-03-10	1998-03-24	1998-03-13	3	$ 3.151,00	Cactus Comidas para llevar	Cerrito 333	Buenos Aires	\N	1010	Argentina
10938	QUICK	3	1998-03-10	1998-04-07	1998-03-16	2	$ 3.189,00	QUICK-Stop	Taucherstraße 10	Cunewalde	\N	1307	Germany
10939	MAGAA	2	1998-03-10	1998-04-07	1998-03-13	2	$ 7.633,00	Magazzini Alimentari Riuniti	Via Ludovico il Moro 22	Bergamo	\N	24100	Italy
10940	BONAP	8	1998-03-11	1998-04-08	1998-03-23	3	$ 1.977,00	Bon app'	12, rue des Bouchers	Marseille	\N	13008	France
10941	SAVEA	7	1998-03-11	1998-04-08	1998-03-20	2	$ 40.081,00	Save-a-lot Markets	187 Suffolk Ln.	Boise	ID	83720	USA
10942	REGGC	9	1998-03-11	1998-04-08	1998-03-18	3	$ 1.795,00	Reggiani Caseifici	Strada Provinciale 124	Reggio Emilia	\N	42100	Italy
10943	BSBEV	4	1998-03-11	1998-04-08	1998-03-19	2	$ 217,00	B's Beverages	Fauntleroy Circus	London	\N	EC2 5NT	UK
10944	BOTTM	6	1998-03-12	1998-03-26	1998-03-13	3	$ 5.292,00	Bottom-Dollar Markets	23 Tsawassen Blvd.	Tsawassen	BC	T2F 8M4	Canada
10945	MORGK	4	1998-03-12	1998-04-09	1998-03-18	1	$ 1.022,00	Morgenstern Gesundkost	Heerstr. 22	Leipzig	\N	4179	Germany
10946	VAFFE	1	1998-03-12	1998-04-09	1998-03-19	2	$ 272,00	Vaffeljernet	Smagsloget 45	Århus	\N	8200	Denmark
10947	BSBEV	3	1998-03-13	1998-04-10	1998-03-16	2	$ 326,00	B's Beverages	Fauntleroy Circus	London	\N	EC2 5NT	UK
10948	GODOS	3	1998-03-13	1998-04-10	1998-03-19	3	$ 2.339,00	Godos Cocina Típica	C/ Romero, 33	Sevilla	\N	41101	Spain
10949	BOTTM	2	1998-03-13	1998-04-10	1998-03-17	3	$ 7.444,00	Bottom-Dollar Markets	23 Tsawassen Blvd.	Tsawassen	BC	T2F 8M4	Canada
10950	MAGAA	1	1998-03-16	1998-04-13	1998-03-23	2	$ 25,00	Magazzini Alimentari Riuniti	Via Ludovico il Moro 22	Bergamo	\N	24100	Italy
10951	RICSU	9	1998-03-16	1998-04-27	1998-04-07	2	$ 3.085,00	Richter Supermarkt	Starenweg 5	Genève	\N	1204	Switzerland
10952	ALFKI	1	1998-03-16	1998-04-27	1998-03-24	1	$ 4.042,00	Alfred's Futterkiste	Obere Str. 57	Berlin	\N	12209	Germany
10953	AROUT	9	1998-03-16	1998-03-30	1998-03-25	2	$ 2.372,00	Around the Horn	Brook Farm Stratford St. Mary	Colchester	Essex	CO7 6JX	UK
10954	LINOD	5	1998-03-17	1998-04-28	1998-03-20	1	$ 2.791,00	LINO-Delicateses	Ave. 5 de Mayo Porlamar	I. de Margarita	Nueva Esparta	4980	Venezuela
10955	FOLKO	8	1998-03-17	1998-04-14	1998-03-20	2	$ 326,00	Folk och fä HB	Åkergatan 24	Bräcke	\N	S-844 67	Sweden
10956	BLAUS	6	1998-03-17	1998-04-28	1998-03-20	2	$ 4.465,00	Blauer See Delikatessen	Forsterstr. 57	Mannheim	\N	68306	Germany
10957	HILAA	8	1998-03-18	1998-04-15	1998-03-27	3	$ 10.536,00	HILARION-Abastos	Carrera 22 con Ave. Carlos Soublette #8-35	San Cristóbal	Táchira	5022	Venezuela
10958	OCEAN	7	1998-03-18	1998-04-15	1998-03-27	2	$ 4.956,00	Océano Atlántico Ltda.	Ing. Gustavo Moncada 8585 Piso 20-A	Buenos Aires	\N	1010	Argentina
10959	GOURL	6	1998-03-18	1998-04-29	1998-03-23	2	$ 498,00	Gourmet Lanchonetes	Av. Brasil, 442	Campinas	SP	04876-786	Brazil
10960	HILAA	3	1998-03-19	1998-04-02	1998-04-08	1	$ 208,00	HILARION-Abastos	Carrera 22 con Ave. Carlos Soublette #8-35	San Cristóbal	Táchira	5022	Venezuela
10961	QUEEN	8	1998-03-19	1998-04-16	1998-03-30	1	$ 10.447,00	Queen Cozinha	Alameda dos Canàrios, 891	Sao Paulo	SP	05487-020	Brazil
10962	QUICK	8	1998-03-19	1998-04-16	1998-03-23	2	$ 27.579,00	QUICK-Stop	Taucherstraße 10	Cunewalde	\N	1307	Germany
10963	FURIB	9	1998-03-19	1998-04-16	1998-03-26	3	$ 27,00	Furia Bacalhau e Frutos do Mar	Jardim das rosas n. 32	Lisboa	\N	1675	Portugal
10964	SPECD	3	1998-03-20	1998-04-17	1998-03-24	2	$ 8.738,00	Spécialités du monde	25, rue Lauriston	Paris	\N	75016	France
10965	OLDWO	6	1998-03-20	1998-04-17	1998-03-30	3	$ 14.438,00	Old World Delicatessen	2743 Bering St.	Anchorage	AK	99508	USA
10966	CHOPS	4	1998-03-20	1998-04-17	1998-04-08	1	$ 2.719,00	Chop-suey Chinese	Hauptstr. 31	Bern	\N	3012	Switzerland
10967	TOMSP	2	1998-03-23	1998-04-20	1998-04-02	2	$ 6.222,00	Toms Spezialitäten	Luisenstr. 48	Münster	\N	44087	Germany
10968	ERNSH	1	1998-03-23	1998-04-20	1998-04-01	3	$ 746,00	Ernst Handel	Kirchgasse 6	Graz	\N	8010	Austria
10969	COMMI	1	1998-03-23	1998-04-20	1998-03-30	2	$ 21,00	Comércio Mineiro	Av. dos Lusíadas, 23	Sao Paulo	SP	05432-043	Brazil
10970	BOLID	9	1998-03-24	1998-04-07	1998-04-24	1	$ 1.616,00	Bólido Comidas preparadas	C/ Araquil, 67	Madrid	\N	28023	Spain
10971	FRANR	2	1998-03-24	1998-04-21	1998-04-02	2	$ 12.182,00	France restauration	54, rue Royale	Nantes	\N	44000	France
10972	LACOR	4	1998-03-24	1998-04-21	1998-03-26	2	$ 2,00	La corne d'abondance	67, avenue de l'Europe	Versailles	\N	78000	France
10973	LACOR	6	1998-03-24	1998-04-21	1998-03-27	2	$ 1.517,00	La corne d'abondance	67, avenue de l'Europe	Versailles	\N	78000	France
10974	SPLIR	3	1998-03-25	1998-04-08	1998-04-03	3	$ 1.296,00	Split Rail Beer & Ale	P.O. Box 555	Lander	WY	82520	USA
10975	BOTTM	1	1998-03-25	1998-04-22	1998-03-27	3	$ 3.227,00	Bottom-Dollar Markets	23 Tsawassen Blvd.	Tsawassen	BC	T2F 8M4	Canada
10976	HILAA	1	1998-03-25	1998-05-06	1998-04-03	1	$ 3.797,00	HILARION-Abastos	Carrera 22 con Ave. Carlos Soublette #8-35	San Cristóbal	Táchira	5022	Venezuela
10977	FOLKO	8	1998-03-26	1998-04-23	1998-04-10	3	$ 2.085,00	Folk och fä HB	Åkergatan 24	Bräcke	\N	S-844 67	Sweden
10978	MAISD	9	1998-03-26	1998-04-23	1998-04-23	2	$ 3.282,00	Maison Dewey	Rue Joseph-Bens 532	Bruxelles	\N	B-1180	Belgium
10979	ERNSH	8	1998-03-26	1998-04-23	1998-03-31	2	$ 35.307,00	Ernst Handel	Kirchgasse 6	Graz	\N	8010	Austria
10980	FOLKO	4	1998-03-27	1998-05-08	1998-04-17	1	$ 126,00	Folk och fä HB	Åkergatan 24	Bräcke	\N	S-844 67	Sweden
10981	HANAR	1	1998-03-27	1998-04-24	1998-04-02	2	$ 19.337,00	Hanari Carnes	Rua do Paço, 67	Rio de Janeiro	RJ	05454-876	Brazil
10982	BOTTM	2	1998-03-27	1998-04-24	1998-04-08	1	$ 1.401,00	Bottom-Dollar Markets	23 Tsawassen Blvd.	Tsawassen	BC	T2F 8M4	Canada
10983	SAVEA	2	1998-03-27	1998-04-24	1998-04-06	2	$ 65.754,00	Save-a-lot Markets	187 Suffolk Ln.	Boise	ID	83720	USA
10984	SAVEA	1	1998-03-30	1998-04-27	1998-04-03	3	$ 21.122,00	Save-a-lot Markets	187 Suffolk Ln.	Boise	ID	83720	USA
10985	HUNGO	2	1998-03-30	1998-04-27	1998-04-02	1	$ 9.151,00	Hungry Owl All-Night Grocers	8 Johnstown Road	Cork	Co. Cork	\N	Ireland
10986	OCEAN	8	1998-03-30	1998-04-27	1998-04-21	2	$ 21.786,00	Océano Atlántico Ltda.	Ing. Gustavo Moncada 8585 Piso 20-A	Buenos Aires	\N	1010	Argentina
10987	EASTC	8	1998-03-31	1998-04-28	1998-04-06	1	$ 18.548,00	Eastern Connection	35 King George	London	\N	WX3 6FW	UK
10988	RATTC	3	1998-03-31	1998-04-28	1998-04-10	2	$ 6.114,00	Rattlesnake Canyon Grocery	2817 Milton Dr.	Albuquerque	NM	87110	USA
10989	QUEDE	2	1998-03-31	1998-04-28	1998-04-02	1	$ 3.476,00	Que Delícia	Rua da Panificadora, 12	Rio de Janeiro	RJ	02389-673	Brazil
10990	ERNSH	2	1998-04-01	1998-05-13	1998-04-07	3	$ 11.761,00	Ernst Handel	Kirchgasse 6	Graz	\N	8010	Austria
10991	QUICK	1	1998-04-01	1998-04-29	1998-04-07	1	$ 3.851,00	QUICK-Stop	Taucherstraße 10	Cunewalde	\N	1307	Germany
10992	THEBI	1	1998-04-01	1998-04-29	1998-04-03	3	$ 427,00	The Big Cheese	89 Jefferson Way Suite 2	Portland	OR	97201	USA
10993	FOLKO	7	1998-04-01	1998-04-29	1998-04-10	3	$ 881,00	Folk och fä HB	Åkergatan 24	Bräcke	\N	S-844 67	Sweden
10994	VAFFE	2	1998-04-02	1998-04-16	1998-04-09	3	$ 6.553,00	Vaffeljernet	Smagsloget 45	Århus	\N	8200	Denmark
10995	PERIC	1	1998-04-02	1998-04-30	1998-04-06	3	$ 460,00	Pericles Comidas clásicas	Calle Dr. Jorge Cash 321	México D.F.	\N	5033	Mexico
10996	QUICK	4	1998-04-02	1998-04-30	1998-04-10	2	$ 112,00	QUICK-Stop	Taucherstraße 10	Cunewalde	\N	1307	Germany
10997	LILAS	8	1998-04-03	1998-05-15	1998-04-13	2	$ 7.391,00	LILA-Supermercado	Carrera 52 con Ave. Bolívar #65-98 Llano Largo	Barquisimeto	Lara	3508	Venezuela
10998	WOLZA	8	1998-04-03	1998-04-17	1998-04-17	2	$ 2.031,00	Wolski Zajazd	ul. Filtrowa 68	Warszawa	\N	01-012	Poland
10999	OTTIK	6	1998-04-03	1998-05-01	1998-04-10	2	$ 9.635,00	Ottilies Käseladen	Mehrheimerstr. 369	Köln	\N	50739	Germany
11000	RATTC	2	1998-04-06	1998-05-04	1998-04-14	3	$ 5.512,00	Rattlesnake Canyon Grocery	2817 Milton Dr.	Albuquerque	NM	87110	USA
11001	FOLKO	2	1998-04-06	1998-05-04	1998-04-14	2	$ 1.973,00	Folk och fä HB	Åkergatan 24	Bräcke	\N	S-844 67	Sweden
11002	SAVEA	4	1998-04-06	1998-05-04	1998-04-16	1	$ 14.116,00	Save-a-lot Markets	187 Suffolk Ln.	Boise	ID	83720	USA
11003	THECR	3	1998-04-06	1998-05-04	1998-04-08	3	$ 1.491,00	The Cracker Box	55 Grizzly Peak Rd.	Butte	MT	59801	USA
11004	MAISD	3	1998-04-07	1998-05-05	1998-04-20	1	$ 4.484,00	Maison Dewey	Rue Joseph-Bens 532	Bruxelles	\N	B-1180	Belgium
11005	WILMK	2	1998-04-07	1998-05-05	1998-04-10	1	$ 75,00	Wilman Kala	Keskuskatu 45	Helsinki	\N	21240	Finland
11006	GREAL	3	1998-04-07	1998-05-05	1998-04-15	2	$ 2.519,00	Great Lakes Food Market	2732 Baker Blvd.	Eugene	OR	97403	USA
11007	PRINI	8	1998-04-08	1998-05-06	1998-04-13	2	$ 20.224,00	Princesa Isabel Vinhos	Estrada da saúde n. 58	Lisboa	\N	1756	Portugal
11008	ERNSH	7	1998-04-08	1998-05-06	\N	3	$ 7.946,00	Ernst Handel	Kirchgasse 6	Graz	\N	8010	Austria
11009	GODOS	2	1998-04-08	1998-05-06	1998-04-10	1	$ 5.911,00	Godos Cocina Típica	C/ Romero, 33	Sevilla	\N	41101	Spain
11010	REGGC	2	1998-04-09	1998-05-07	1998-04-21	2	$ 2.871,00	Reggiani Caseifici	Strada Provinciale 124	Reggio Emilia	\N	42100	Italy
11011	ALFKI	3	1998-04-09	1998-05-07	1998-04-13	1	$ 121,00	Alfred's Futterkiste	Obere Str. 57	Berlin	\N	12209	Germany
11012	FRANK	1	1998-04-09	1998-04-23	1998-04-17	3	$ 24.295,00	Frankenversand	Berliner Platz 43	München	\N	80805	Germany
11013	ROMEY	2	1998-04-09	1998-05-07	1998-04-10	1	$ 3.299,00	Romero y tomillo	Gran Vía, 1	Madrid	\N	28001	Spain
11014	LINOD	2	1998-04-10	1998-05-08	1998-04-15	3	$ 236,00	LINO-Delicateses	Ave. 5 de Mayo Porlamar	I. de Margarita	Nueva Esparta	4980	Venezuela
11015	SANTG	2	1998-04-10	1998-04-24	1998-04-20	2	$ 462,00	Santé Gourmet	Erling Skakkes gate 78	Stavern	\N	4110	Norway
11016	AROUT	9	1998-04-10	1998-05-08	1998-04-13	2	$ 338,00	Around the Horn	Brook Farm Stratford St. Mary	Colchester	Essex	CO7 6JX	UK
11017	ERNSH	9	1998-04-13	1998-05-11	1998-04-20	2	$ 75.426,00	Ernst Handel	Kirchgasse 6	Graz	\N	8010	Austria
11018	LONEP	4	1998-04-13	1998-05-11	1998-04-16	2	$ 1.165,00	Lonesome Pine Restaurant	89 Chiaroscuro Rd.	Portland	OR	97219	USA
11019	RANCH	6	1998-04-13	1998-05-11	\N	3	$ 317,00	Rancho grande	Av. del Libertador 900	Buenos Aires	\N	1010	Argentina
11020	OTTIK	2	1998-04-14	1998-05-12	1998-04-16	2	$ 433,00	Ottilies Käseladen	Mehrheimerstr. 369	Köln	\N	50739	Germany
11021	QUICK	3	1998-04-14	1998-05-12	1998-04-21	1	$ 29.718,00	QUICK-Stop	Taucherstraße 10	Cunewalde	\N	1307	Germany
11022	HANAR	9	1998-04-14	1998-05-12	1998-05-04	2	$ 627,00	Hanari Carnes	Rua do Paço, 67	Rio de Janeiro	RJ	05454-876	Brazil
11023	BSBEV	1	1998-04-14	1998-04-28	1998-04-24	2	$ 12.383,00	B's Beverages	Fauntleroy Circus	London	\N	EC2 5NT	UK
11024	EASTC	4	1998-04-15	1998-05-13	1998-04-20	1	$ 7.436,00	Eastern Connection	35 King George	London	\N	WX3 6FW	UK
11025	WARTH	6	1998-04-15	1998-05-13	1998-04-24	3	$ 2.917,00	Wartian Herkku	Torikatu 38	Oulu	\N	90110	Finland
11026	FRANS	4	1998-04-15	1998-05-13	1998-04-28	1	$ 4.709,00	Franchi S.p.A.	Via Monte Bianco 34	Torino	\N	10100	Italy
11027	BOTTM	1	1998-04-16	1998-05-14	1998-04-20	1	$ 5.252,00	Bottom-Dollar Markets	23 Tsawassen Blvd.	Tsawassen	BC	T2F 8M4	Canada
11028	KOENE	2	1998-04-16	1998-05-14	1998-04-22	1	$ 2.959,00	Königlich Essen	Maubelstr. 90	Brandenburg	\N	14776	Germany
11029	CHOPS	4	1998-04-16	1998-05-14	1998-04-27	1	$ 4.784,00	Chop-suey Chinese	Hauptstr. 31	Bern	\N	3012	Switzerland
11030	SAVEA	7	1998-04-17	1998-05-15	1998-04-27	2	$ 83.075,00	Save-a-lot Markets	187 Suffolk Ln.	Boise	ID	83720	USA
11031	SAVEA	6	1998-04-17	1998-05-15	1998-04-24	2	$ 22.722,00	Save-a-lot Markets	187 Suffolk Ln.	Boise	ID	83720	USA
11032	WHITC	2	1998-04-17	1998-05-15	1998-04-23	3	$ 60.619,00	White Clover Markets	1029 - 12th Ave. S.	Seattle	WA	98124	USA
11033	RICSU	7	1998-04-17	1998-05-15	1998-04-23	3	$ 8.474,00	Richter Supermarkt	Starenweg 5	Genève	\N	1204	Switzerland
11034	OLDWO	8	1998-04-20	1998-06-01	1998-04-27	1	$ 4.032,00	Old World Delicatessen	2743 Bering St.	Anchorage	AK	99508	USA
11035	SUPRD	2	1998-04-20	1998-05-18	1998-04-24	2	$ 17,00	Suprêmes délices	Boulevard Tirou, 255	Charleroi	\N	B-6000	Belgium
11036	DRACD	8	1998-04-20	1998-05-18	1998-04-22	3	$ 14.947,00	Drachenblut Delikatessen	Walserweg 21	Aachen	\N	52066	Germany
11037	GODOS	7	1998-04-21	1998-05-19	1998-04-27	1	$ 32,00	Godos Cocina Típica	C/ Romero, 33	Sevilla	\N	41101	Spain
11038	SUPRD	1	1998-04-21	1998-05-19	1998-04-30	2	$ 2.959,00	Suprêmes délices	Boulevard Tirou, 255	Charleroi	\N	B-6000	Belgium
11039	LINOD	1	1998-04-21	1998-05-19	\N	2	$ 650,00	LINO-Delicateses	Ave. 5 de Mayo Porlamar	I. de Margarita	Nueva Esparta	4980	Venezuela
11040	GREAL	4	1998-04-22	1998-05-20	\N	3	$ 1.884,00	Great Lakes Food Market	2732 Baker Blvd.	Eugene	OR	97403	USA
11041	CHOPS	3	1998-04-22	1998-05-20	1998-04-28	2	$ 4.822,00	Chop-suey Chinese	Hauptstr. 31	Bern	\N	3012	Switzerland
11042	COMMI	2	1998-04-22	1998-05-06	1998-05-01	1	$ 2.999,00	Comércio Mineiro	Av. dos Lusíadas, 23	Sao Paulo	SP	05432-043	Brazil
11043	SPECD	5	1998-04-22	1998-05-20	1998-04-29	2	$ 88,00	Spécialités du monde	25, rue Lauriston	Paris	\N	75016	France
11044	WOLZA	4	1998-04-23	1998-05-21	1998-05-01	1	$ 872,00	Wolski Zajazd	ul. Filtrowa 68	Warszawa	\N	01-012	Poland
11045	BOTTM	6	1998-04-23	1998-05-21	\N	2	$ 7.058,00	Bottom-Dollar Markets	23 Tsawassen Blvd.	Tsawassen	BC	T2F 8M4	Canada
11046	WANDK	8	1998-04-23	1998-05-21	1998-04-24	2	$ 7.164,00	Die Wandernde Kuh	Adenauerallee 900	Stuttgart	\N	70563	Germany
11047	EASTC	7	1998-04-24	1998-05-22	1998-05-01	3	$ 4.662,00	Eastern Connection	35 King George	London	\N	WX3 6FW	UK
11048	BOTTM	7	1998-04-24	1998-05-22	1998-04-30	3	$ 2.412,00	Bottom-Dollar Markets	23 Tsawassen Blvd.	Tsawassen	BC	T2F 8M4	Canada
11049	GOURL	3	1998-04-24	1998-05-22	1998-05-04	1	$ 834,00	Gourmet Lanchonetes	Av. Brasil, 442	Campinas	SP	04876-786	Brazil
11050	FOLKO	8	1998-04-27	1998-05-25	1998-05-05	2	$ 5.941,00	Folk och fä HB	Åkergatan 24	Bräcke	\N	S-844 67	Sweden
11051	LAMAI	7	1998-04-27	1998-05-25	\N	3	$ 279,00	La maison d'Asie	1 rue Alsace-Lorraine	Toulouse	\N	31000	France
11052	HANAR	3	1998-04-27	1998-05-25	1998-05-01	1	$ 6.726,00	Hanari Carnes	Rua do Paço, 67	Rio de Janeiro	RJ	05454-876	Brazil
11053	PICCO	2	1998-04-27	1998-05-25	1998-04-29	2	$ 5.305,00	Piccolo und mehr	Geislweg 14	Salzburg	\N	5020	Austria
11054	CACTU	8	1998-04-28	1998-05-26	\N	1	$ 33,00	Cactus Comidas para llevar	Cerrito 333	Buenos Aires	\N	1010	Argentina
11055	HILAA	7	1998-04-28	1998-05-26	1998-05-05	2	$ 12.092,00	HILARION-Abastos	Carrera 22 con Ave. Carlos Soublette #8-35	San Cristóbal	Táchira	5022	Venezuela
11056	EASTC	8	1998-04-28	1998-05-12	1998-05-01	2	$ 27.896,00	Eastern Connection	35 King George	London	\N	WX3 6FW	UK
11057	NORTS	3	1998-04-29	1998-05-27	1998-05-01	3	$ 413,00	North/South	South House 300 Queensbridge	London	\N	SW7 1RZ	UK
11058	BLAUS	9	1998-04-29	1998-05-27	\N	3	$ 3.114,00	Blauer See Delikatessen	Forsterstr. 57	Mannheim	\N	68306	Germany
11059	RICAR	2	1998-04-29	1998-06-10	\N	2	$ 858,00	Ricardo Adocicados	Av. Copacabana, 267	Rio de Janeiro	RJ	02389-890	Brazil
11060	FRANS	2	1998-04-30	1998-05-28	1998-05-04	2	$ 1.098,00	Franchi S.p.A.	Via Monte Bianco 34	Torino	\N	10100	Italy
11061	GREAL	4	1998-04-30	1998-06-11	\N	3	$ 1.401,00	Great Lakes Food Market	2732 Baker Blvd.	Eugene	OR	97403	USA
11062	REGGC	4	1998-04-30	1998-05-28	\N	2	$ 2.993,00	Reggiani Caseifici	Strada Provinciale 124	Reggio Emilia	\N	42100	Italy
11063	HUNGO	3	1998-04-30	1998-05-28	1998-05-06	2	$ 8.173,00	Hungry Owl All-Night Grocers	8 Johnstown Road	Cork	Co. Cork	\N	Ireland
11064	SAVEA	1	1998-05-01	1998-05-29	1998-05-04	1	$ 3.009,00	Save-a-lot Markets	187 Suffolk Ln.	Boise	ID	83720	USA
11065	LILAS	8	1998-05-01	1998-05-29	\N	1	$ 1.291,00	LILA-Supermercado	Carrera 52 con Ave. Bolívar #65-98 Llano Largo	Barquisimeto	Lara	3508	Venezuela
11066	WHITC	7	1998-05-01	1998-05-29	1998-05-04	2	$ 4.472,00	White Clover Markets	1029 - 12th Ave. S.	Seattle	WA	98124	USA
11067	DRACD	1	1998-05-04	1998-05-18	1998-05-06	2	$ 798,00	Drachenblut Delikatessen	Walserweg 21	Aachen	\N	52066	Germany
11068	QUEEN	8	1998-05-04	1998-06-01	\N	2	$ 8.175,00	Queen Cozinha	Alameda dos Canàrios, 891	Sao Paulo	SP	05487-020	Brazil
11069	TORTU	1	1998-05-04	1998-06-01	1998-05-06	2	$ 1.567,00	Tortuga Restaurante	Avda. Azteca 123	México D.F.	\N	5033	Mexico
11070	LEHMS	2	1998-05-05	1998-06-02	\N	1	$ 1.360,00	Lehmanns Marktstand	Magazinweg 7	Frankfurt a.M.	\N	60528	Germany
11071	LILAS	1	1998-05-05	1998-06-02	\N	1	$ 93,00	LILA-Supermercado	Carrera 52 con Ave. Bolívar #65-98 Llano Largo	Barquisimeto	Lara	3508	Venezuela
11072	ERNSH	4	1998-05-05	1998-06-02	\N	2	$ 25.864,00	Ernst Handel	Kirchgasse 6	Graz	\N	8010	Austria
11073	PERIC	2	1998-05-05	1998-06-02	\N	2	$ 2.495,00	Pericles Comidas clásicas	Calle Dr. Jorge Cash 321	México D.F.	\N	5033	Mexico
11074	SIMOB	7	1998-05-06	1998-06-03	\N	2	$ 1.844,00	Simons bistro	Vinbæltet 34	Kobenhavn	\N	1734	Denmark
11075	RICSU	8	1998-05-06	1998-06-03	\N	2	$ 619,00	Richter Supermarkt	Starenweg 5	Genève	\N	1204	Switzerland
11076	BONAP	4	1998-05-06	1998-06-03	\N	2	$ 3.828,00	Bon app'	12, rue des Bouchers	Marseille	\N	13008	France
11077	RATTC	1	1998-05-06	1998-06-03	\N	2	$ 853,00	Rattlesnake Canyon Grocery	2817 Milton Dr.	Albuquerque	NM	87110	USA
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (productid, productname, supplierid, categoryid, quantityperunit, unitprice, unitsinstock, unitsonorder, reorderlevel, discontinued) FROM stdin;
1	Chai	1	1	10 boxes x 20 bags	18.0	39	0	10	f
2	Chang	1	1	24 - 12 oz bottles	19.0	17	40	25	f
3	Aniseed Syrup	1	2	12 - 550 ml bottles	10.0	13	70	25	f
4	Chef Anton's Cajun Seasoning	2	2	48 - 6 oz jars	22.0	53	0	0	f
5	Chef Anton's Gumbo Mix	2	2	36 boxes	21.35	0	0	0	t
6	Grandma's Boysenberry Spread	3	2	12 - 8 oz jars	25.0	120	0	25	f
7	Uncle Bob's Organic Dried Pears	3	7	12 - 1 lb pkgs.	30.0	15	0	10	f
8	Northwoods Cranberry Sauce	3	2	12 - 12 oz jars	40.0	6	0	0	f
9	Mishi Kobe Niku	4	6	18 - 500 g pkgs.	97.0	29	0	0	t
10	Ikura	4	8	12 - 200 ml jars	31.0	31	0	0	f
11	Queso Cabrales	5	4	1 kg pkg.	21.0	22	30	30	f
12	Queso Manchego La Pastora	5	4	10 - 500 g pkgs.	38.0	86	0	0	f
13	Konbu	6	8	2 kg box	6.0	24	0	5	f
14	Tofu	6	7	40 - 100 g pkgs.	23.25	35	0	0	f
15	Genen Shouyu	6	2	24 - 250 ml bottles	15.5	39	0	5	f
16	Pavlova	7	3	32 - 500 g boxes	17.45	29	0	10	f
17	Alice Mutton	7	6	20 - 1 kg tins	39.0	0	0	0	t
18	Carnarvon Tigers	7	8	16 kg pkg.	62.5	42	0	0	f
19	Teatime Chocolate Biscuits	8	3	10 boxes x 12 pieces	9.2	25	0	5	f
20	Sir Rodney's Marmalade	8	3	30 gift boxes	81.0	40	0	0	f
21	Sir Rodney's Scones	8	3	24 pkgs. x 4 pieces	10.0	3	40	5	f
22	Gustaf's Knäckebröd	9	5	24 - 500 g pkgs.	21.0	104	0	25	f
23	Tunnbröd	9	5	12 - 250 g pkgs.	9.0	61	0	25	f
24	Guaraná Fantástica	10	1	12 - 355 ml cans	4.5	20	0	0	t
25	NuNuCa Nuß-Nougat-Creme	11	3	20 - 450 g glasses	14.0	76	0	30	f
26	Gumbär Gummibärchen	11	3	100 - 250 g bags	31.23	15	0	0	f
27	Schoggi Schokolade	11	3	100 - 100 g pieces	43.9	49	0	30	f
28	Rössle Sauerkraut	12	7	25 - 825 g cans	45.6	26	0	0	t
29	Thüringer Rostbratwurst	12	6	50 bags x 30 sausgs.	123.79	0	0	0	t
30	Nord-Ost Matjeshering	13	8	10 - 200 g glasses	25.89	10	0	15	f
31	Gorgonzola Telino	14	4	12 - 100 g pkgs	12.5	0	70	20	f
32	Mascarpone Fabioli	14	4	24 - 200 g pkgs.	32.0	9	40	25	f
33	Geitost	15	4	500 g	2.5	112	0	20	f
34	Sasquatch Ale	16	1	24 - 12 oz bottles	14.0	111	0	15	f
35	Steeleye Stout	16	1	24 - 12 oz bottles	18.0	20	0	15	f
36	Inlagd Sill	17	8	24 - 250 g  jars	19.0	112	0	20	f
37	Gravad lax	17	8	12 - 500 g pkgs.	26.0	11	50	25	f
38	Côte de Blaye	18	1	12 - 75 cl bottles	263.5	17	0	15	f
39	Chartreuse verte	18	1	750 cc per bottle	18.0	69	0	5	f
40	Boston Crab Meat	19	8	24 - 4 oz tins	18.4	123	0	30	f
41	Jack's New England Clam Chowder	19	8	12 - 12 oz cans	9.65	85	0	10	f
42	Singaporean Hokkien Fried Mee	20	5	32 - 1 kg pkgs.	14.0	26	0	0	t
43	Ipoh Coffee	20	1	16 - 500 g tins	46.0	17	10	25	f
44	Gula Malacca	20	2	20 - 2 kg bags	19.45	27	0	15	f
45	Rogede sild	21	8	1k pkg.	9.5	5	70	15	f
46	Spegesild	21	8	4 - 450 g glasses	12.0	95	0	0	f
47	Zaanse koeken	22	3	10 - 4 oz boxes	9.5	36	0	0	f
48	Chocolade	22	3	10 pkgs.	12.75	15	70	25	f
49	Maxilaku	23	3	24 - 50 g pkgs.	20.0	10	60	15	f
50	Valkoinen suklaa	23	3	12 - 100 g bars	16.25	65	0	30	f
51	Manjimup Dried Apples	24	7	50 - 300 g pkgs.	53.0	20	0	10	f
52	Filo Mix	24	5	16 - 2 kg boxes	7.0	38	0	25	f
53	Perth Pasties	24	6	48 pieces	32.8	0	0	0	t
54	Tourtière	25	6	16 pies	7.45	21	0	10	f
55	Pâté chinois	25	6	24 boxes x 2 pies	24.0	115	0	20	f
56	Gnocchi di nonna Alice	26	5	24 - 250 g pkgs.	38.0	21	10	30	f
57	Ravioli Angelo	26	5	24 - 250 g pkgs.	19.5	36	0	20	f
58	Escargots de Bourgogne	27	8	24 pieces	13.25	62	0	20	f
59	Raclette Courdavault	28	4	5 kg pkg.	55.0	79	0	0	f
60	Camembert Pierrot	28	4	15 - 300 g rounds	34.0	19	0	0	f
61	Sirop d'érable	29	2	24 - 500 ml bottles	28.5	113	0	25	f
62	Tarte au sucre	29	3	48 pies	49.3	17	0	0	f
63	Vegie-spread	7	2	15 - 625 g jars	43.9	24	0	5	f
64	Wimmers gute Semmelknödel	12	5	20 bags x 4 pieces	33.25	22	80	30	f
65	Louisiana Fiery Hot Pepper Sauce	2	2	32 - 8 oz bottles	21.05	76	0	0	f
66	Louisiana Hot Spiced Okra	2	2	24 - 8 oz jars	17.0	4	100	20	f
67	Laughing Lumberjack Lager	16	1	24 - 12 oz bottles	14.0	52	0	10	f
68	Scottish Longbreads	8	3	10 boxes x 8 pieces	12.5	6	10	15	f
69	Gudbrandsdalsost	15	4	10 kg pkg.	36.0	26	0	15	f
70	Outback Lager	7	1	24 - 355 ml bottles	15.0	15	10	30	f
71	Flotemysost	15	4	10 - 500 g pkgs.	21.5	26	0	0	f
72	Mozzarella di Giovanni	14	4	24 - 200 g pkgs.	34.8	14	0	0	f
73	Röd Kaviar	17	8	24 - 150 g jars	15.0	101	0	5	f
74	Longlife Tofu	4	7	5 kg pkg.	10.0	4	20	5	f
75	Rhönbräu Klosterbier	12	1	24 - 0.5 l bottles	7.75	125	0	25	f
76	Lakkalikööri	23	1	500 ml	18.0	57	0	20	f
77	Original Frankfurter grüne Soße	12	2	12 boxes	13.0	32	0	15	f
\.


--
-- Data for Name: shippers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shippers (shipperid, companyname, phone) FROM stdin;
1	Speedy Express	(503) 555-9831
2	United Package	(503) 555-3199
3	Federal Shipping	(503) 555-9931
\.


--
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.suppliers (supplierid, companyname, contactname, contacttitle, address, city, region, postalcode, country, phone, fax, homepage) FROM stdin;
1	Exotic Liquids	Charlotte Cooper	Purchasing Manager	49 Gilbert St.	London	NULL	EC1 4SD	UK	(171) 555-2222	NULL	NULL
2	New Orleans Cajun Delights	Shelley Burke	Order Administrator	P.O. Box 78934	New Orleans	LA	70117	USA	(100) 555-4822	NULL	#CAJUN.HTM#
3	Grandma Kelly's Homestead	Regina Murphy	Sales Representative	707 Oxford Rd.	Ann Arbor	MI	48104	USA	(313) 555-5735	(313) 555-3349	NULL
4	Tokyo Traders	Yoshi Nagase	Marketing Manager	9-8 Sekimai Musashino-shi	Tokyo	NULL	100	Japan	(03) 3555-5011	NULL	NULL
5	Cooperativa de Quesos 'Las Cabras'	Antonio del Valle Saavedra	Export Administrator	Calle del Rosal 4	Oviedo	Asturias	33007	Spain	(98) 598 76 54	NULL	NULL
6	Mayumi's	Mayumi Ohno	Marketing Representative	92 Setsuko Chuo-ku	Osaka	NULL	545	Japan	(06) 431-7877	NULL	Mayumi's (on the World Wide Web)#http://www.microsoft.com/accessdev/sampleapps/mayumi.htm#
7	Pavlova, Ltd.	Ian Devling	Marketing Manager	74 Rose St. Moonie Ponds	Melbourne	Victoria	3058	Australia	(03) 444-2343	(03) 444-6588	NULL
8	Specialty Biscuits, Ltd.	Peter Wilson	Sales Representative	29 King's Way	Manchester	NULL	M14 GSD	UK	(161) 555-4448	NULL	NULL
9	PB Knäckebröd AB	Lars Peterson	Sales Agent	Kaloadagatan 13	Göteborg	NULL	S-345 67	Sweden	031-987 65 43	031-987 65 91	NULL
10	Refrescos Americanas LTDA	Carlos Diaz	Marketing Manager	Av. das Americanas 12.890	Sao Paulo	NULL	5442	Brazil	(11) 555 4640	NULL	NULL
11	Heli Süßwaren GmbH & Co. KG	Petra Winkler	Sales Manager	Tiergartenstraße 5	Berlin	NULL	10785	Germany	(010) 9984510	NULL	NULL
12	Plutzer Lebensmittelgroßmärkte AG	Martin Bein	International Marketing Mgr.	Bogenallee 51	Frankfurt	NULL	60439	Germany	(069) 992755	NULL	Plutzer (on the World Wide Web)#http://www.microsoft.com/accessdev/sampleapps/plutzer.htm#
13	Nord-Ost-Fisch Handelsgesellschaft mbH	Sven Petersen	Coordinator Foreign Markets	Frahmredder 112a	Cuxhaven	NULL	27478	Germany	(04721) 8713	(04721) 8714	NULL
14	Formaggi Fortini s.r.l.	Elio Rossi	Sales Representative	Viale Dante, 75	Ravenna	NULL	48100	Italy	(0544) 60323	(0544) 60603	#FORMAGGI.HTM#
15	Norske Meierier	Beate Vileid	Marketing Manager	Hatlevegen 5	Sandvika	NULL	1320	Norway	(0)2-953010	NULL	NULL
16	Bigfoot Breweries	Cheryl Saylor	Regional Account Rep.	3400 - 8th Avenue Suite 210	Bend	OR	97101	USA	(503) 555-9931	NULL	NULL
17	Svensk Sjöföda AB	Michael Björn	Sales Representative	Brovallavägen 231	Stockholm	NULL	S-123 45	Sweden	08-123 45 67	NULL	NULL
18	Aux joyeux ecclésiastiques	Guylène Nodier	Sales Manager	203, Rue des Francs-Bourgeois	Paris	NULL	75004	France	(1) 03.83.00.68	(1) 03.83.00.62	NULL
19	New England Seafood Cannery	Robb Merchant	Wholesale Account Agent	Order Processing Dept. 2100 Paul Revere Blvd.	Boston	MA	02134	USA	(617) 555-3267	(617) 555-3389	NULL
20	Leka Trading	Chandra Leka	Owner	471 Serangoon Loop, Suite #402	Singapore	NULL	0512	Singapore	555-8787	NULL	NULL
21	Lyngbysild	Niels Petersen	Sales Manager	Lyngbysild Fiskebakken 10	Lyngby	NULL	2800	Denmark	43844108	43844115	NULL
22	Zaanse Snoepfabriek	Dirk Luchte	Accounting Manager	Verkoop Rijnweg 22	Zaandam	NULL	9999 ZZ	Netherlands	(12345) 1212	(12345) 1210	NULL
23	Karkki Oy	Anne Heikkonen	Product Manager	Valtakatu 12	Lappeenranta	NULL	53120	Finland	(953) 10956	NULL	NULL
24	G'day, Mate	Wendy Mackenzie	Sales Representative	170 Prince Edward Parade Hunter's Hill	Sydney	NSW	2042	Australia	(02) 555-5914	(02) 555-4873	G'day Mate (on the World Wide Web)#http://www.microsoft.com/accessdev/sampleapps/gdaymate.htm#
25	Ma Maison	Jean-Guy Lauzon	Marketing Manager	2960 Rue St. Laurent	Montréal	Québec	H1J 1C3	Canada	(514) 555-9022	NULL	NULL
26	Pasta Buttini s.r.l.	Giovanni Giudici	Order Administrator	Via dei Gelsomini, 153	Salerno	NULL	84100	Italy	(089) 6547665	(089) 6547667	NULL
27	Escargots Nouveaux	Marie Delamare	Sales Manager	22, rue H. Voiron	Montceau	NULL	71300	France	85.57.00.07	NULL	NULL
28	Gai pâturage	Eliane Noz	Sales Representative	Bat. B 3, rue des Alpes	Annecy	NULL	74000	France	38.76.98.06	38.76.98.58	NULL
29	Forêts d'érables	Chantal Goulet	Accounting Manager	148 rue Chasseur	Ste-Hyacinthe	Québec	J2S 7S8	Canada	(514) 555-2955	(514) 555-2921	NULL
\.


--
-- Name: categories_categoryid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categories_categoryid_seq', 1, false);


--
-- Name: employees_employeeid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employees_employeeid_seq', 1, false);


--
-- Name: orders_orderid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_orderid_seq', 1, false);


--
-- Name: products_productid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_productid_seq', 1, false);


--
-- Name: shippers_shipperid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.shippers_shipperid_seq', 1, false);


--
-- Name: suppliers_supplierid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.suppliers_supplierid_seq', 1, false);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (categoryid);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customerid);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (employeeid);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (orderid);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (productid);


--
-- Name: shippers shippers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shippers
    ADD CONSTRAINT shippers_pkey PRIMARY KEY (shipperid);


--
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (supplierid);


--
-- Name: categoriesproducts; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX categoriesproducts ON public.products USING btree (categoryid);


--
-- Name: categoryid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX categoryid ON public.products USING btree (categoryid);


--
-- Name: categoryname; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX categoryname ON public.categories USING btree (categoryname);


--
-- Name: city; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX city ON public.customers USING btree (city);


--
-- Name: companyname; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX companyname ON public.customers USING btree (companyname);


--
-- Name: companynamesupp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX companynamesupp ON public.suppliers USING btree (companyname);


--
-- Name: customerid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX customerid ON public.orders USING btree (customerid);


--
-- Name: customersorders; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX customersorders ON public.orders USING btree (customerid);


--
-- Name: employeeid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX employeeid ON public.orders USING btree (employeeid);


--
-- Name: employeesorders; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX employeesorders ON public.orders USING btree (employeeid);


--
-- Name: lastname; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX lastname ON public.employees USING btree (lastname);


--
-- Name: orderdate; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX orderdate ON public.orders USING btree (orderdate);


--
-- Name: orderid_details; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX orderid_details ON public.order_details USING btree (orderid);


--
-- Name: orders_order_details; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX orders_order_details ON public.order_details USING btree (orderid);


--
-- Name: postalcode; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX postalcode ON public.customers USING btree (postalcode);


--
-- Name: postalcode_employees; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX postalcode_employees ON public.employees USING btree (postalcode);


--
-- Name: postalcodesupp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX postalcodesupp ON public.suppliers USING btree (postalcode);


--
-- Name: productid_order_details; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX productid_order_details ON public.order_details USING btree (productid);


--
-- Name: productname; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX productname ON public.products USING btree (productname);


--
-- Name: products_order_details; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX products_order_details ON public.order_details USING btree (productid);


--
-- Name: region; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX region ON public.customers USING btree (region);


--
-- Name: shippeddate; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX shippeddate ON public.orders USING btree (shippeddate);


--
-- Name: shippersorders; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX shippersorders ON public.orders USING btree (shipvia);


--
-- Name: shippostalcode; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX shippostalcode ON public.orders USING btree (shippostalcode);


--
-- Name: supplierid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX supplierid ON public.products USING btree (supplierid);


--
-- Name: suppliersproducts; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX suppliersproducts ON public.products USING btree (supplierid);


--
-- PostgreSQL database dump complete
--

