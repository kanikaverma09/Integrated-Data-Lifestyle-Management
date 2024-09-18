

/*########################################################################
# Opening the BTEQ Script
##########################################################################*/



.set width 2555
.set pagelength 2555

.LOGMECH LDAP
.LOGON tdprd.td.teradata.com/MP255078,********;



UPDATE MP255078.CORE_AZURE_RETAIL_CUSTOMER
FROM
(
	SELECT	
	CAST(Cust_id AS INTEGER) as src_Cust_id
    ,Age as src_Age
	,CASE WHEN TRIM(UPPER(Gender))='MALE' THEN 'M' WHEN TRIM(UPPER(Gender))='FEMALE' THEN 'F' ELSE NULL END  as src_Gender
	,REGEXP_REPLACE(TRIM(cust_name),'[^a-zA-Z ]','') as src_Cust_name
	FROM	MP255078.STG_AZURE_RETAIL_CUSTOMER_VIEW
	QUALIFY ROW_NUMBER() OVER (PARTITION BY CUST_ID ORDER BY LOAD_DTTM DESC) = 1
 )
SRC
SET  EFF_END_DTTM =  CAST( TEMPORAL_DATE-1 AS timestamp(0)),CURR_IND = 'N'
 WHERE	Cust_id = SRC.src_Cust_id
AND EFF_END_DTTM = '9999-12-31 23:59:59' 
AND (
COALESCE(SRC.src_Age,999) <> COALESCE(Age,999) OR
COALESCE(SRC.src_Gender, 'z') <> COALESCE(Gender,'z') OR
COALESCE(SRC.src_Cust_name, 'zzz') <> COALESCE(Cust_name,'zzz') 
) ;



 INSERT INTO  MP255078.CORE_AZURE_RETAIL_CUSTOMER  (
 Cust_id
,Age
,Gender
,Cust_name
,Source_System
,EFF_START_DTTM
,EFF_END_DTTM
,CURR_IND
,LOAD_DTTM
 )
 SELECT SRC.* FROM
 (
SELECT
 CAST(Cust_id AS INTEGER) AS Cust_id
,CAST(Age AS INTEGER) AS AGE
,CASE WHEN TRIM(UPPER(Gender))='MALE' THEN 'M' WHEN TRIM(UPPER(Gender))='FEMALE' THEN 'F' ELSE NULL END AS GENDER
,REGEXP_REPLACE(TRIM(cust_name),'[^a-zA-Z ]','') AS Cust_name
,'AZURE' AS Source_System
,CAST(TEMPORAL_DATE AS TIMESTAMP(0)) AS EFF_START_DTTM
,'9999-12-31 23:59:59' AS EFF_END_DTTM
,'Y' AS CURR_IND
,CURRENT_TIMESTAMP(0) AS LOAD_DTTM
FROM
MP255078.STG_AZURE_RETAIL_CUSTOMER_VIEW 
QUALIFY ROW_NUMBER() OVER (PARTITION BY CUST_ID ORDER BY LOAD_DTTM DESC) = 1
)SRC
LEFT JOIN MP255078.CORE_AZURE_RETAIL_CUSTOMER_VIEW TGT
ON SRC.Cust_id = TGT.Cust_id
--AND TGT.EFF_END_DTTM = '9999-12-31 23:59:59'
AND TGT.CURR_IND = 'Y'
WHERE TGT.Cust_id IS NULL;



.IF ERRORCODE<>0 THEN .QUIT ERRORCODE; 


/*########################################################################################### 

#  Closing the BTEQ Script, Session Closed and Logging off 

###########################################################################################*/ 

.LOGOFF 

.QUIT 
