

/*########################################################################
# Opening the BTEQ Script
##########################################################################*/



.set width 2555
.set pagelength 2555

.LOGMECH LDAP
.LOGON tdprd.td.teradata.com/<USERID>,<PASSWORD>;



.IF ERRORCODE<>0 THEN .QUIT ERRORCODE; 

INSERT INTO RK250076.SEM_NOS_AWS_ORDERS  (
LOCATION
,THEYEAR
,THEMONTH
,SALES_DATE
,CUSTOMER_ID
,STORE_ID
,BASKET_ID
,PRODUCT_ID
,SALES_QUANTITY
,DISCOUNT_AMOUNT
,Source_System
,LOAD_DTTM
 )
SELECT
LOCATION
,THEYEAR
,THEMONTH
,SALES_DATE
,CUSTOMER_ID
,STORE_ID
,BASKET_ID
,PRODUCT_ID
,SALES_QUANTITY
,DISCOUNT_AMOUNT
,Source_System
,LOAD_DTTM
FROM RK250076.CORE_NOS_AWS_ORDERS;


.IF ERRORCODE<>0 THEN .QUIT ERRORCODE; 


/*########################################################################################### 

#  Closing the BTEQ Script, Session Closed and Logging off 

###########################################################################################*/ 

.LOGOFF 

.QUIT 
