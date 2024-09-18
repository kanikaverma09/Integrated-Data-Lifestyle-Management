
-----------Alter command to add the temporal column-----------
ALTER TABLE MP255078.CORE_AZURE_RETAIL_CUSTOMER
   ADD PERIOD FOR Customer_Validity(EFF_START_DTTM,EFF_END_DTTM) AS VALIDTIME;
   
-----------select command to check the data----------- 
SELECT * FROM MP255078.CORE_AZURE_RETAIL_CUSTOMER;
   
-----------sSample queries to use the period column added-----------    
   select * from MP255078.CORE_AZURE_RETAIL_CUSTOMER
   where BEGIN(Customer_Validity) >= DATE '2024-04-15';
   
   
   select * from MP255078.CORE_AZURE_RETAIL_CUSTOMER
   where BEGIN(Customer_Validity) >= DATE '2024-04-10'
   AND END(CUSTOMER_VALIDITY) < DATE '2024-04-20';
   