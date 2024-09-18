REPLACE  MACRO GetStoreData ( store_id INT )AS 
(
SELECT * FROM AR186005.SEM_AZURE_RETAIL_STORE_VW
WHERE Store_Id = :store_id;
);