
/*########################################################################
# Opening the BTEQ Script
##########################################################################*/



.set width 2555
.set pagelength 2555

.LOGMECH LDAP
.LOGON tdprd.td.teradata.com/KV255007,*********;


UPDATE KV255007.STG_AZURE_RETAIL_STORE_VIEW
SET Phone_Number = REGEXP_REPLACE(Phone_Number, '[[:space:]()-.]', '');


INSERT INTO KV255007.CORE_AZURE_RETAIL_STORE 
(
   Store_Id,
    Brand ,
    CapaCity ,
    City  ,
    Country  ,
    District ,
    Latitude,
    Longitude,
    Outlet_Design ,
    Outlet_Type ,
    Ownership_Type ,
    Phone_Number ,
    State ,
    Store_Name ,
    Store_Number ,
    Steet_Address ,
    Territory ,
    Time_Zone ,
    Zip_Code ,
    State_Name ,
    County ,
    Extract_Dttm ,
    Source_System
   ,EFF_START_DTTM
   ,EFF_END_DTTM
   ,CURR_IND
   ,LOAD_DTTM
 
	)
SELECT 
cast (Store_Id as Integer),
Brand ,
CAST ( CapaCity  AS INTEGER) ,
City ,
Country ,
District   ,
CAST (Latitude AS DECIMAL(6,2)) AS  Latitude,
CAST (Longitude AS DECIMAL(6,2)) AS  Longitude ,
Outlet_Design  ,
Outlet_Type   ,
Ownership_Type  ,
CAST ( Phone_Number AS VARCHAR(12)) ,
State  ,
Store_Name  ,
Store_Number  ,
Steet_Address  ,
Territory  ,
Time_Zone  ,
Zip_Code  ,
State_Name  ,
County  ,
CAST ( Extract_Dttm  AS TIMESTAMP(6)),
'AZURE' AS Source_System
,CAST(DATE AS TIMESTAMP(0)) AS EFF_START_DTTM
,'9999-12-31 23:59:59' AS EFF_END_DTTM
,'Y'
,CURRENT_TIMESTAMP(0) AS LOAD_DTTM
 FROM
KV255007.STG_AZURE_RETAIL_STORE_VIEW
QUALIFY ROW_NUMBER() OVER (PARTITION BY Store_Id ORDER BY Extract_Dttm DESC) = 1;


.IF ERRORCODE<>0 THEN .QUIT ERRORCODE; 


UPDATE KV255007.CORE_AZURE_RETAIL_STORE
SET Geospatial_point = 'POINT(' || CAST(Longitude AS VARCHAR(20)) || ' ' || CAST(Latitude AS VARCHAR(20)) || ')';

UPDATE KV255007.CORE_AZURE_RETAIL_STORE
SET Phone_Number = SUBSTRING(Phone_Number, 1, 3) || '-' || SUBSTRING(Phone_Number, 4, 3) || '-' || SUBSTRING(Phone_Number, 7, 4);

 
/*########################################################################################### 

#  Closing the BTEQ Script, Session Closed and Logging off 

###########################################################################################*/ 

.LOGOFF 

.QUIT 
