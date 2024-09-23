

/*########################################################################
# Opening the BTEQ Script
##########################################################################*/



.set width 2555
.set pagelength 2555

.LOGMECH LDAP
.LOGON tdprd.td.teradata.com/MP255078,********;



UPDATE MP255078.CORE_AZURE_RETAIL_PRODUCT 
FROM
(
    SELECT  
    CAST(id AS INTEGER) as src_pid
    ,Product_Category as src_productcategory
    ,CAST(Product_Cost AS DECIMAL(6,2)) as src_productcost
    ,Product_Name as src_productname
    ,CAST(Recomsale_Price AS DECIMAL(6,2)) as src_recomsaleprice
    ,Serving_Size as src_servingsize
    FROM    SS255313.STG_AZURE_RETAIL_PRODUCT_VIEW 
	union 
	 SELECT  
    CAST(id AS INTEGER) as src_pid
    ,Product_Category as src_productcategory
    ,CAST(Product_Cost AS DECIMAL(6,2)) as src_productcost
    ,Product_Name as src_productname
    ,CAST(Recomsale_Price AS DECIMAL(6,2)) as src_recomsaleprice
    ,Serving_Size as src_servingsize
    FROM    SS255313.STG_AZURE_Online_PRODUCT_VIEW 
)
SRC
SET  EFF_END_DTTM =  CAST( DATE-1 AS timestamp(0)),CURR_IND = 'N'
WHERE  id = SRC.src_pid
AND EFF_END_DTTM = '9999-12-31 23:59:59' 
AND (
COALESCE(SRC.src_productcategory, 'zzz') <> COALESCE(product_category,'zzz') OR
COALESCE(SRC.src_productcost, 999) <> COALESCE(product_cost,999) OR
COALESCE(SRC.src_productname, 'zzz') <> COALESCE(product_name,'zzz') OR
COALESCE(SRC.src_recomsaleprice, 999) <> COALESCE(recomsale_price,999) OR
COALESCE(SRC.src_servingsize, 'zzz') <> COALESCE(serving_size,'zzz')
) ;

 
.IF ERRORCODE<>0 THEN .QUIT ERRORCODE; 

 INSERT INTO  MP255078.CORE_AZURE_RETAIL_PRODUCT  (
  id
,Product_Category
,Product_Cost
,Product_Name
,Recomsale_Price
,Serving_Size
,Source_System
,EFF_START_DTTM
,EFF_END_DTTM
,CURR_IND
,LOAD_DTTM
)
SELECT STG.* FROM
(
SELECT
CAST(SRC.id AS INTEGER) AS id
,SRC.Product_Category
,SRC.Product_Cost
,SRC.Product_Name
,CAST(SRC.Recomsale_Price AS DECIMAL(6,2)) AS Recomsale_Price
,SRC.Serving_Size
,'AZURE' AS Source_System
,CAST(DATE AS TIMESTAMP(0)) AS EFF_START_DTTM
,'9999-12-31 23:59:59' AS EFF_END_DTTM
,'Y' AS CURR_IND
,CURRENT_TIMESTAMP(0) AS LOAD_DTTM
FROM
SS255313.STG_AZURE_RETAIL_PRODUCT_VIEW SRC
UNION
SELECT
CAST(SRC.id AS INTEGER) AS id
,SRC.Product_Category
,SRC.Product_Cost
,SRC.Product_Name
,SRC.Recomsale_Price
,SRC.Serving_Size
,'AZURE' AS Source_System
,CAST(DATE AS TIMESTAMP(0)) AS EFF_START_DTTM
,'9999-12-31 23:59:59' AS EFF_END_DTTM
,'Y' AS CURR_IND
,CURRENT_TIMESTAMP(0) AS LOAD_DTTM
FROM
SS255313.STG_AZURE_Online_PRODUCT_VIEW SRC
)STG
LEFT JOIN MP255078.CORE_AZURE_RETAIL_PRODUCT TGT
ON STG.id = TGT.id
AND TGT.EFF_END_DTTM = '9999-12-31 23:59:59'
WHERE TGT.id IS NULL;


UPDATE  MP255078.CORE_AZURE_RETAIL_PRODUCT 
SET PRODUCT_NAME = 'TEST', PRODUCT_COST = 999
WHERE ID = 1


.IF ERRORCODE<>0 THEN .QUIT ERRORCODE; 


/*########################################################################################### 

#  Closing the BTEQ Script, Session Closed and Logging off 

###########################################################################################*/ 

.LOGOFF 

.QUIT 
