-- MySQL dump 10.13  Distrib 8.0.36, for Linux (x86_64)
--
-- Host: localhost    Database: northwnd
-- ------------------------------------------------------
-- Server version	8.0.42-0ubuntu0.20.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Temporary view structure for view `Orders Qry`
--

DROP TABLE IF EXISTS `Orders Qry`;
/*!50001 DROP VIEW IF EXISTS `Orders Qry`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `Orders Qry` AS SELECT 
 1 AS `OrderID`,
 1 AS `CustomerID`,
 1 AS `EmployeeID`,
 1 AS `OrderDate`,
 1 AS `RequiredDate`,
 1 AS `ShippedDate`,
 1 AS `ShipVia`,
 1 AS `Freight`,
 1 AS `ShipName`,
 1 AS `ShipAddress`,
 1 AS `ShipCity`,
 1 AS `ShipRegion`,
 1 AS `ShipPostalCode`,
 1 AS `ShipCountry`,
 1 AS `CompanyName`,
 1 AS `Address`,
 1 AS `City`,
 1 AS `Region`,
 1 AS `PostalCode`,
 1 AS `Country`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `Products_Above_Average_Price`
--

DROP TABLE IF EXISTS `Products_Above_Average_Price`;
/*!50001 DROP VIEW IF EXISTS `Products_Above_Average_Price`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `Products_Above_Average_Price` AS SELECT 
 1 AS `ProductName`,
 1 AS `UnitPrice`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `Quarterly_Orders`
--

DROP TABLE IF EXISTS `Quarterly_Orders`;
/*!50001 DROP VIEW IF EXISTS `Quarterly_Orders`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `Quarterly_Orders` AS SELECT 
 1 AS `CustomerID`,
 1 AS `CompanyName`,
 1 AS `City`,
 1 AS `Country`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `Summary_of_Sales_by_Quarter`
--

DROP TABLE IF EXISTS `Summary_of_Sales_by_Quarter`;
/*!50001 DROP VIEW IF EXISTS `Summary_of_Sales_by_Quarter`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `Summary_of_Sales_by_Quarter` AS SELECT 
 1 AS `ShippedDate`,
 1 AS `OrderID`,
 1 AS `Subtotal`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `Products_by_Category`
--

DROP TABLE IF EXISTS `Products_by_Category`;
/*!50001 DROP VIEW IF EXISTS `Products_by_Category`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `Products_by_Category` AS SELECT 
 1 AS `CategoryName`,
 1 AS `ProductName`,
 1 AS `QuantityPerUnit`,
 1 AS `UnitsInStock`,
 1 AS `Discontinued`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `Invoices`
--

DROP TABLE IF EXISTS `Invoices`;
/*!50001 DROP VIEW IF EXISTS `Invoices`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `Invoices` AS SELECT 
 1 AS `CustomerID`,
 1 AS `CompanyName`,
 1 AS `ContactName`,
 1 AS `ContactTitle`,
 1 AS `Address`,
 1 AS `City`,
 1 AS `Region`,
 1 AS `PostalCode`,
 1 AS `Country`,
 1 AS `Phone`,
 1 AS `Fax`,
 1 AS `ShipName`,
 1 AS `ShipAddress`,
 1 AS `ShipCity`,
 1 AS `ShipRegion`,
 1 AS `ShipPostalCode`,
 1 AS `ShipCountry`,
 1 AS `Salesperson`,
 1 AS `ShipperName`,
 1 AS `ProductID`,
 1 AS `ProductName`,
 1 AS `UnitPrice`,
 1 AS `Quantity`,
 1 AS `Discount`,
 1 AS `ExtendedPrice`,
 1 AS `Freight`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `Current_Product_List`
--

DROP TABLE IF EXISTS `Current_Product_List`;
/*!50001 DROP VIEW IF EXISTS `Current_Product_List`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `Current_Product_List` AS SELECT 
 1 AS `ProductID`,
 1 AS `ProductName`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `Order_Details_Extended`
--

DROP TABLE IF EXISTS `Order_Details_Extended`;
/*!50001 DROP VIEW IF EXISTS `Order_Details_Extended`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `Order_Details_Extended` AS SELECT 
 1 AS `OrderID`,
 1 AS `ProductID`,
 1 AS `ProductName`,
 1 AS `UnitPrice`,
 1 AS `Quantity`,
 1 AS `Discount`,
 1 AS `ExtendePrice`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `Sales_Totals_by_Amount`
--

DROP TABLE IF EXISTS `Sales_Totals_by_Amount`;
/*!50001 DROP VIEW IF EXISTS `Sales_Totals_by_Amount`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `Sales_Totals_by_Amount` AS SELECT 
 1 AS `SaleAmount`,
 1 AS `OrderID`,
 1 AS `CompanyName`,
 1 AS `ShippedDate`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `Summary_of_Sales_by_Year`
--

DROP TABLE IF EXISTS `Summary_of_Sales_by_Year`;
/*!50001 DROP VIEW IF EXISTS `Summary_of_Sales_by_Year`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `Summary_of_Sales_by_Year` AS SELECT 
 1 AS `ShippedDate`,
 1 AS `OrderID`,
 1 AS `Subtotal`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `Product_Sales_for_1997`
--

DROP TABLE IF EXISTS `Product_Sales_for_1997`;
/*!50001 DROP VIEW IF EXISTS `Product_Sales_for_1997`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `Product_Sales_for_1997` AS SELECT 
 1 AS `CategoryName`,
 1 AS `ProductName`,
 1 AS `ProductSales`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `Order_Subtotals`
--

DROP TABLE IF EXISTS `Order_Subtotals`;
/*!50001 DROP VIEW IF EXISTS `Order_Subtotals`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `Order_Subtotals` AS SELECT 
 1 AS `OrderID`,
 1 AS `SubTotal`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `Customer_and_Suppliers_by_City`
--

DROP TABLE IF EXISTS `Customer_and_Suppliers_by_City`;
/*!50001 DROP VIEW IF EXISTS `Customer_and_Suppliers_by_City`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `Customer_and_Suppliers_by_City` AS SELECT 
 1 AS `City`,
 1 AS `CompanyName`,
 1 AS `ContactName`,
 1 AS `Relationship`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `Sales_by_Category`
--

DROP TABLE IF EXISTS `Sales_by_Category`;
/*!50001 DROP VIEW IF EXISTS `Sales_by_Category`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `Sales_by_Category` AS SELECT 
 1 AS `CategoryID`,
 1 AS `CategoryName`,
 1 AS `ProductName`,
 1 AS `ProductSales`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `Alphabetical_list_of_products`
--

DROP TABLE IF EXISTS `Alphabetical_list_of_products`;
/*!50001 DROP VIEW IF EXISTS `Alphabetical_list_of_products`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `Alphabetical_list_of_products` AS SELECT 
 1 AS `ProductID`,
 1 AS `ProductName`,
 1 AS `SupplierID`,
 1 AS `CategoryID`,
 1 AS `QuantityPerUnit`,
 1 AS `UnitPrice`,
 1 AS `UnitsInStock`,
 1 AS `UnitsOnOrder`,
 1 AS `ReorderLevel`,
 1 AS `Discontinued`,
 1 AS `CategoryName`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `Orders Qry`
--

/*!50001 DROP VIEW IF EXISTS `Orders Qry`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `Orders Qry` AS select `orders`.`OrderID` AS `OrderID`,`orders`.`CustomerID` AS `CustomerID`,`orders`.`EmployeeID` AS `EmployeeID`,`orders`.`OrderDate` AS `OrderDate`,`orders`.`RequiredDate` AS `RequiredDate`,`orders`.`ShippedDate` AS `ShippedDate`,`orders`.`ShipVia` AS `ShipVia`,`orders`.`Freight` AS `Freight`,`orders`.`ShipName` AS `ShipName`,`orders`.`ShipAddress` AS `ShipAddress`,`orders`.`ShipCity` AS `ShipCity`,`orders`.`ShipRegion` AS `ShipRegion`,`orders`.`ShipPostalCode` AS `ShipPostalCode`,`orders`.`ShipCountry` AS `ShipCountry`,`customers`.`CompanyName` AS `CompanyName`,`customers`.`Address` AS `Address`,`customers`.`City` AS `City`,`customers`.`Region` AS `Region`,`customers`.`PostalCode` AS `PostalCode`,`customers`.`Country` AS `Country` from (`customers` join `orders` on((`customers`.`CustomerID` = `orders`.`CustomerID`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `Products_Above_Average_Price`
--

/*!50001 DROP VIEW IF EXISTS `Products_Above_Average_Price`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `Products_Above_Average_Price` AS select `products`.`ProductName` AS `ProductName`,`products`.`UnitPrice` AS `UnitPrice` from `products` where (`products`.`UnitPrice` > (select avg(`products`.`UnitPrice`) from `products`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `Quarterly_Orders`
--

/*!50001 DROP VIEW IF EXISTS `Quarterly_Orders`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `Quarterly_Orders` AS select distinct `customers`.`CustomerID` AS `CustomerID`,`customers`.`CompanyName` AS `CompanyName`,`customers`.`City` AS `City`,`customers`.`Country` AS `Country` from (`orders` left join `customers` on((`customers`.`CustomerID` = `orders`.`CustomerID`))) where (`orders`.`OrderDate` between '19970101' and '19971231') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `Summary_of_Sales_by_Quarter`
--

/*!50001 DROP VIEW IF EXISTS `Summary_of_Sales_by_Quarter`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `Summary_of_Sales_by_Quarter` AS select `orders`.`ShippedDate` AS `ShippedDate`,`orders`.`OrderID` AS `OrderID`,`Order_Subtotals`.`SubTotal` AS `Subtotal` from (`orders` join `Order_Subtotals` on((`orders`.`OrderID` = `Order_Subtotals`.`OrderID`))) where (`orders`.`ShippedDate` is not null) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `Products_by_Category`
--

/*!50001 DROP VIEW IF EXISTS `Products_by_Category`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `Products_by_Category` AS select `categories`.`CategoryName` AS `CategoryName`,`products`.`ProductName` AS `ProductName`,`products`.`QuantityPerUnit` AS `QuantityPerUnit`,`products`.`UnitsInStock` AS `UnitsInStock`,`products`.`Discontinued` AS `Discontinued` from (`categories` join `products` on((`categories`.`CategoryID` = `products`.`CategoryID`))) where (`products`.`Discontinued` <> 1) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `Invoices`
--

/*!50001 DROP VIEW IF EXISTS `Invoices`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `Invoices` AS select `a`.`CustomerID` AS `CustomerID`,`a`.`CompanyName` AS `CompanyName`,`a`.`ContactName` AS `ContactName`,`a`.`ContactTitle` AS `ContactTitle`,`a`.`Address` AS `Address`,`a`.`City` AS `City`,`a`.`Region` AS `Region`,`a`.`PostalCode` AS `PostalCode`,`a`.`Country` AS `Country`,`a`.`Phone` AS `Phone`,`a`.`Fax` AS `Fax`,`b`.`ShipName` AS `ShipName`,`b`.`ShipAddress` AS `ShipAddress`,`b`.`ShipCity` AS `ShipCity`,`b`.`ShipRegion` AS `ShipRegion`,`b`.`ShipPostalCode` AS `ShipPostalCode`,`b`.`ShipCountry` AS `ShipCountry`,((`d`.`FirstName` + '') + `d`.`LastName`) AS `Salesperson`,`e`.`CompanyName` AS `ShipperName`,`c`.`ProductID` AS `ProductID`,`f`.`ProductName` AS `ProductName`,`c`.`UnitPrice` AS `UnitPrice`,`c`.`Quantity` AS `Quantity`,`c`.`Discount` AS `Discount`,round(((`c`.`UnitPrice` * `c`.`Quantity`) * (1 - `c`.`Discount`)),2) AS `ExtendedPrice`,`b`.`Freight` AS `Freight` from (((((`customers` `a` join `orders` `b` on((`a`.`CustomerID` = `b`.`CustomerID`))) join `order_details` `c` on((`b`.`OrderID` = `c`.`OrderID`))) join `employees` `d` on((`d`.`EmployeeID` = `b`.`EmployeeID`))) join `shippers` `e` on((`e`.`ShipperID` = `b`.`ShipVia`))) join `products` `f` on((`f`.`ProductID` = `c`.`ProductID`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `Current_Product_List`
--

/*!50001 DROP VIEW IF EXISTS `Current_Product_List`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `Current_Product_List` AS select `Product_List`.`ProductID` AS `ProductID`,`Product_List`.`ProductName` AS `ProductName` from `products` `Product_List` where (`Product_List`.`Discontinued` = 0) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `Order_Details_Extended`
--

/*!50001 DROP VIEW IF EXISTS `Order_Details_Extended`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `Order_Details_Extended` AS select `b`.`OrderID` AS `OrderID`,`b`.`ProductID` AS `ProductID`,`a`.`ProductName` AS `ProductName`,`b`.`UnitPrice` AS `UnitPrice`,`b`.`Quantity` AS `Quantity`,`b`.`Discount` AS `Discount`,(round((`b`.`UnitPrice` * `b`.`Quantity`),((1 - `b`.`Discount`) / 100)) * 100) AS `ExtendePrice` from (`products` `a` join `order_details` `b` on((`a`.`ProductID` = `b`.`ProductID`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `Sales_Totals_by_Amount`
--

/*!50001 DROP VIEW IF EXISTS `Sales_Totals_by_Amount`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `Sales_Totals_by_Amount` AS select `Order_Subtotals`.`SubTotal` AS `SaleAmount`,`orders`.`OrderID` AS `OrderID`,`customers`.`CompanyName` AS `CompanyName`,`orders`.`ShippedDate` AS `ShippedDate` from (`customers` join (`orders` join `Order_Subtotals` on((`orders`.`OrderID` = `Order_Subtotals`.`OrderID`))) on((`customers`.`CustomerID` = `orders`.`CustomerID`))) where ((`Order_Subtotals`.`SubTotal` > 2.500) and (`orders`.`ShippedDate` between '19970101' and '19971231')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `Summary_of_Sales_by_Year`
--

/*!50001 DROP VIEW IF EXISTS `Summary_of_Sales_by_Year`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `Summary_of_Sales_by_Year` AS select `orders`.`ShippedDate` AS `ShippedDate`,`orders`.`OrderID` AS `OrderID`,`Order_Subtotals`.`SubTotal` AS `Subtotal` from (`orders` join `Order_Subtotals` on((`orders`.`OrderID` = `Order_Subtotals`.`OrderID`))) where (`orders`.`ShippedDate` is not null) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `Product_Sales_for_1997`
--

/*!50001 DROP VIEW IF EXISTS `Product_Sales_for_1997`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `Product_Sales_for_1997` AS select `a`.`CategoryName` AS `CategoryName`,`b`.`ProductName` AS `ProductName`,sum((round((((`c`.`UnitPrice` * `c`.`Quantity`) * (1 - `c`.`Discount`)) / 100),0) * 100)) AS `ProductSales` from (((`categories` `a` join `products` `b` on((`a`.`CategoryID` = `b`.`CategoryID`))) join `order_details` `c` on((`c`.`ProductID` = `b`.`UnitPrice`))) join `orders` `d` on((`c`.`OrderID` = `d`.`OrderID`))) where (`d`.`ShippedDate` between '19970101' and '19971231') group by `a`.`CategoryName`,`b`.`ProductName` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `Order_Subtotals`
--

/*!50001 DROP VIEW IF EXISTS `Order_Subtotals`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `Order_Subtotals` AS select `order_details`.`OrderID` AS `OrderID`,sum(((round((`order_details`.`UnitPrice` * `order_details`.`Quantity`),0) * (1 - `order_details`.`Discount`)) / 100)) AS `SubTotal` from `order_details` group by `order_details`.`OrderID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `Customer_and_Suppliers_by_City`
--

/*!50001 DROP VIEW IF EXISTS `Customer_and_Suppliers_by_City`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `Customer_and_Suppliers_by_City` AS select `customers`.`City` AS `City`,`customers`.`CompanyName` AS `CompanyName`,`customers`.`ContactName` AS `ContactName`,'Customers' AS `Relationship` from `customers` union select `suppliers`.`City` AS `City`,`suppliers`.`CompanyName` AS `CompanyName`,`suppliers`.`ContactName` AS `ContactName`,'Suppliers' AS `Suppliers` from `suppliers` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `Sales_by_Category`
--

/*!50001 DROP VIEW IF EXISTS `Sales_by_Category`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `Sales_by_Category` AS select `categories`.`CategoryID` AS `CategoryID`,`categories`.`CategoryName` AS `CategoryName`,`products`.`ProductName` AS `ProductName`,sum(`Order_Details_Extended`.`ExtendePrice`) AS `ProductSales` from (`categories` join (`products` join (`orders` join `Order_Details_Extended` on((`orders`.`OrderID` = `Order_Details_Extended`.`OrderID`))) on((`products`.`ProductID` = `Order_Details_Extended`.`ProductID`))) on((`categories`.`CategoryID` = `products`.`CategoryID`))) where (`orders`.`OrderDate` between '19970101' and '19971231') group by `categories`.`CategoryID`,`categories`.`CategoryName`,`products`.`ProductName` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `Alphabetical_list_of_products`
--

/*!50001 DROP VIEW IF EXISTS `Alphabetical_list_of_products`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `Alphabetical_list_of_products` AS select `products`.`ProductID` AS `ProductID`,`products`.`ProductName` AS `ProductName`,`products`.`SupplierID` AS `SupplierID`,`products`.`CategoryID` AS `CategoryID`,`products`.`QuantityPerUnit` AS `QuantityPerUnit`,`products`.`UnitPrice` AS `UnitPrice`,`products`.`UnitsInStock` AS `UnitsInStock`,`products`.`UnitsOnOrder` AS `UnitsOnOrder`,`products`.`ReorderLevel` AS `ReorderLevel`,`products`.`Discontinued` AS `Discontinued`,`categories`.`CategoryName` AS `CategoryName` from (`categories` join `products` on((`categories`.`CategoryID` = `products`.`CategoryID`))) where (`products`.`Discontinued` = 0) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-28 13:26:18
