

/*########################################################################
# Opening the BTEQ Script
##########################################################################*/



.set width 2555
.set pagelength 2555

.LOGMECH LDAP
.LOGON tdprd.td.teradata.com/<USERNAME>,<PASSWORD>;


CREATE VOLATILE TABLE VOL_DISCOUNT_PERCENT AS
(SELECT ORDER_ID, CAST((SAO.DISCOUNT/SAO.TOTAL_PRICE) * 100 AS DECIMAL(10,2)) AS DISCOUNT_PERCENT FROM RK250076.STG_AWS_ORDERS SAO)
WITH DATA AND STATISTICS
ON COMMIT PRESERVE ROWS;

DELETE FROM VOL_DISCOUNT_PERCENT WHERE DISCOUNT_PERCENT > 90.0; 

CREATE VOLATILE TABLE VOL_AVG_DISCOUNT AS
(SELECT SAO.PRODUCT_ID, X.AVERAGE_DISCOUNT AS AVERAGE_DISCOUNT_NULL FROM RK250076.STG_AWS_ORDERS SAO
LEFT OUTER JOIN (SELECT PRODUCT_ID, AVG(SAO.DISCOUNT) AS AVERAGE_DISCOUNT FROM RK250076.STG_AWS_ORDERS SAO GROUP BY PRODUCT_ID) X
ON SAO.PRODUCT_ID = X.PRODUCT_ID
WHERE SAO.DISCOUNT IS NULL)
WITH DATA AND STATISTICS
ON COMMIT PRESERVE ROWS;

--DROP TABLE VOL_DISCOUNT_PERCENT;
--DROP TABLE VOL_AVG_DISCOUNT;


INSERT INTO  RK250076.CORE_AWS_ORDERS  (
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
 )
SELECT
 SRC.Order_Id
,SRC.Cust_Id
,SRC.Order_Status
,SRC.Total_Price
--,TO_DATE(TO_CHAR(TO_DATE(SRC.Order_Date, 'MM/DD/YYYY'), 'YYYY-MM-DD'), 'YYYY-MM-DD') (VARCHAR(10)) AS Order_Date
,CAST(TO_DATE(order_date,'MM/DD/YYYY') AS DATE FORMAT 'YYYY-MM-DD')
,SRC.Order_Priority
,REGEXP_REPLACE(SRC.Clerk, '[0-9]', '') AS Clerk
,STRTOK(SRC.CLERK, ' ', 1) AS First_Name
,STRTOK(SRC.CLERK, ' ', 2) AS Last_Name
,SRC.Store_Id
,SRC.Ship_Priority
,SRC.Order_Comment
,SRC.Order_Qty
,SRC.Product_Id
,SRC.Discount
,CASE WHEN VDP.DISCOUNT_PERCENT IS NOT NULL THEN VDP.DISCOUNT_PERCENT
	  WHEN VDP.DISCOUNT_PERCENT IS NULL THEN VAD.AVERAGE_DISCOUNT_NULL	
END AS DISCOUNT_PERCENT
,'AWS' AS Source_System
,CURRENT_TIMESTAMP(0) AS LOAD_DTTM
FROM
RK250076.STG_AWS_ORDERS SRC
LEFT JOIN VOL_DISCOUNT_PERCENT VDP
ON SRC.ORDER_ID = VDP.ORDER_ID
LEFT JOIN VOL_AVG_DISCOUNT VAD
ON SRC.PRODUCT_ID = VAD.PRODUCT_ID
;


.IF ERRORCODE <> 0 THEN .EXIT ERRORCODE; 


/*########################################################################################### 

#  Closing the BTEQ Script, Session Closed and Logging off 

###########################################################################################*/ 

.LOGOFF 

.QUIT 
