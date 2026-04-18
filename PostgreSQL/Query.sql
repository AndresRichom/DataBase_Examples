/*Probar View:*/
select * from titleview;

/*Probar los procedimientos almacenados que se pasaron a funciones*/
SELECT public.byroyalty(30);

SELECT public.reptq1();

SELECT *
FROM reptq2()
WHERE pub_id <> 'ALL';

SELECT * FROM reptq3(10, 50, 'business');
