use northwnd;

# Ejecutar procedimiento almacenado Employee Sales by Country:
CALL Employee_Sales_by_Country ("1996-07-04 ", "1996-08-04 ");

# Ejecutar el procedimiento Sales_by_Year
CALL Sales_by_Year ("1996-07-04 ", "1996-08-04 ");

# Procedimiento alamacenado CustOrdersDetail en el cual debes usar el OrderID del producto
call CustOrdersDetail(10248);

# Procedimiento Busqueda de Ordenes de Cliente:
call CustOrdersOrders ("RICSU");

# Procedimiento en el cual suma la compra total del cliente
call CustOrderHist("RICSU");

# Procedimiento en el cual podras observar venta por categoria por año
CALL SalesByCategory("Beverages", "1998");

