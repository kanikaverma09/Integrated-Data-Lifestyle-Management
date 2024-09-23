CREATE MULTISET TABLE RK250076.SEM_AWS_ORDERS ,FALLBACK , 
   NO BEFORE JOURNAL, 
   NO AFTER JOURNAL, 
   CHECKSUM = DEFAULT, 
   DEFAULT MERGEBLOCKRATIO (
      Order_Id INTEGER, 
      Cust_Id INTEGER, 
      Order_Status VARCHAR(5), 
      Total_Price DECIMAL(10,2), 
      Order_Date DATE FORMAT 'YYYY-MM-DD',  
      Order_Priority INTEGER COMPRESS(10), 
      Clerk VARCHAR(50), 
      First_Name VARCHAR(50),
      Last_Name VARCHAR(50),
      Store_Id INTEGER, 
      Ship_Priority INTEGER COMPRESS(1,2,3,4,5), 
      Order_Comment VARCHAR(20) COMPRESS('In Stock'), 
      Order_Qty INTEGER, 
      Product_Id INTEGER, 
      Discount DECIMAL(10,2),
      Discount_Percent DECIMAL(10,2),
      SOURCE_SYSTEM VARCHAR(6),
      LOAD_DTTM TIMESTAMP(0) ) primary index (order_id)
      PARTITION BY (
      RANGE_N(STORE_ID BETWEEN 1 AND 100 EACH 1)
      ,RANGE_N(ORDER_DATE between '2015-01-01' and '2023-12-31' each interval '1' day))
      ;
      
	
GRANT SELECT ON RK250076.SEM_AWS_ORDERS TO MP255078 WITH GRANT OPTION;
GRANT SELECT ON RK250076.SEM_AWS_ORDERS TO AR186005 WITH GRANT OPTION;
GRANT SELECT ON RK250076.SEM_AWS_ORDERS TO SK186103 WITH GRANT OPTION;	

	
	