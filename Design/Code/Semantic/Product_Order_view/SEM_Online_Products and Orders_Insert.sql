

/*########################################################################
# Opening the BTEQ Script
##########################################################################*/



.set width 2555
.set pagelength 2555

.LOGMECH LDAP
.LOGON tdprd.td.teradata.com/SS255313,******;



DELETE SS255313.SEM_AZURE_ONLINE_PRODUCT_VW
 ;

 
.IF ERRORCODE<>0 THEN .QUIT ERRORCODE; 

 INSERT INTO SS255313.SEM_AZURE_ONLINE_PRODUCT_VW
   (Order_Id, Order_Date,
	Cust_Id, First_Name, Last_Name, id, Product_Name, Order_Status,
	Total_Price, Order_Priority, Store_Id, Ship_Priority, Order_Qty,
	Discount, Discount_Percent, Recomsale_Price)

sel	ORD.Order_Id,
	Ord.Order_Date,ORD.Cust_Id,ORD.First_Name,ORD.Last_Name,
	pro.id,
	pro.Product_Name,ORD.Order_Status,ORD.Total_Price,ORD.Order_Priority,
	ORD.Store_Id,ORD.Ship_Priority,
	ORD.Order_Qty,ORD.Discount,
	ORD.Discount_Percent,
	PRO.Recomsale_Price
from	
RK250076.CORE_AWS_ORDERS_VW ORD
Inner join 
MP255078.CORE_AZURE_RETAIL_PRODUCT_VW PRO
	on ORD.Product_Id=pro.id
	where  PRO.product_name like 'Online:%'  
	and pro.CURR_IND='Y'  
	and ord.CURR_IND='Y' ; 


.IF ERRORCODE<>0 THEN .QUIT ERRORCODE; 


/*########################################################################################### 

#  Closing the BTEQ Script, Session Closed and Logging off 

###########################################################################################*/ 

.LOGOFF 

.QUIT 
