

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
	pid as src_pid
    ,productcategory as src_productcategory
	,productcost as src_productcost
	,productname as src_productname
	,recomsaleprice as src_recomsaleprice
	,servingsize as src_servingsize
	FROM	MP255078.STG_AZURE_RETAIL_PRODUCT
 )
SRC
SET  EFF_END_DTTM =  CAST( DATE-1 AS timestamp(0)),CURR_IND = 'N'
 WHERE	pid = SRC.src_pid
AND EFF_END_DTTM = '9999-12-31 23:59:59' 
AND (
COALESCE(SRC.src_productcategory, 'zzz') <> COALESCE(productcategory,'zzz') OR
COALESCE(SRC.src_productcost, 'zzz') <> COALESCE(productcost,'zzz') OR
COALESCE(SRC.src_productname, 'zzz') <> COALESCE(productname,'zzz') OR
COALESCE(SRC.src_recomsaleprice, 'zzz') <> COALESCE(recomsaleprice,'zzz') OR
COALESCE(SRC.src_servingsize, 'zzz') <> COALESCE(servingsize,'zzz')
) ;
 
.IF ERRORCODE<>0 THEN .QUIT ERRORCODE; 

 INSERT INTO  MP255078.CORE_AZURE_RETAIL_PRODUCT  (
 pid
,productcategory
,productcost
,productname
,recomsaleprice
,servingsize
,Source_System
,EFF_START_DTTM
,EFF_END_DTTM
,CURR_IND
,LOAD_DTTM
 )
SELECT
 SRC.pid
,SRC.productcategory
,SRC.productcost
,SRC.productname
,SRC.recomsaleprice
,SRC.servingsize
,'AZURE' AS Source_System
,CAST(DATE AS TIMESTAMP(0)) AS EFF_START_DTTM
,'9999-12-31 23:59:59' AS EFF_END_DTTM
,'Y'
,CURRENT_TIMESTAMP(0) AS LOAD_DTTM
FROM
MP255078.STG_AZURE_RETAIL_PRODUCT SRC
LEFT JOIN MP255078.CORE_AZURE_RETAIL_PRODUCT TGT
ON SRC.pid = TGT.pid
AND EFF_END_DTTM = '9999-12-31 23:59:59'
WHERE TGT.pid IS NULL;


.IF ERRORCODE<>0 THEN .QUIT ERRORCODE; 


/*########################################################################################### 

#  Closing the BTEQ Script, Session Closed and Logging off 

###########################################################################################*/ 

.LOGOFF 

.QUIT 
