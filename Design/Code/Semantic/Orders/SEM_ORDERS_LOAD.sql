

/*########################################################################
# Opening the BTEQ Script
##########################################################################*/



.set width 2555
.set pagelength 2555

.LOGMECH LDAP
.LOGON tdprd.td.teradata.com/<USERID>,<PASSWORD>;



.IF ERRORCODE<>0 THEN .QUIT ERRORCODE; 

INSERT INTO RK250076.SEM_AWS_ORDERS (
 Order_Id
,Cust_Id
,Order_Status
,Total_Price
,ORDER_DATE
,Order_Priority
,Clerk
,First_Name
,Last_Name
,Store_Id
,Ship_Priority
,Order_Comment
,Order_Qty
,Product_Id
,Discount
,Discount_Percent
,Source_System
,LOAD_DTTM)
SELECT
 Order_Id
,Cust_Id
,Order_Status
,Total_Price
,ORDER_DATE
,Order_Priority
,Clerk
,First_Name
,Last_Name
,Store_Id
,Ship_Priority
,Order_Comment
,Order_Qty
,Product_Id
,Discount
,Discount_Percent
,Source_System
,LOAD_DTTM
FROM RK250076.CORE_AWS_ORDERS  ; 


.IF ERRORCODE<>0 THEN .QUIT ERRORCODE; 


/*########################################################################################### 

#  Closing the BTEQ Script, Session Closed and Logging off 

###########################################################################################*/ 

.LOGOFF 

.QUIT 
