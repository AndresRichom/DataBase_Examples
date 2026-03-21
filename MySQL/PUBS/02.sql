use pubs;

# Ejecucion de view:
select * from titleview;

/* Para tener estadisticas y del uso de la tabla 
EN SQL SERVER SE USA UPDATE STATISTICS publishers

EN MYSQL SE USA ANALYZE TABLE publishers;
Actualiza estadísticas de la tabla
Ayuda al optimizador de consultas (similar propósito)*/

analyze table publishers;
analyze table employee;
analyze table jobs;
analyze table pub_info;
analyze table titles;
analyze table authors;
analyze table titleauthor;
analyze table sales;
analyze table roysched;
analyze table stores;
analyze table discounts;

