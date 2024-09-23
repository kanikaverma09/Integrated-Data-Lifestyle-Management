CREATE MULTISET TABLE AR186005.SEM_AZURE_ONLINE_PRODUCT ,
FALLBACK ,
	NO BEFORE JOURNAL, 
    NO AFTER JOURNAL, 
    CHECKSUM = DEFAULT,
    DEFAULT MERGEBLOCKRATIO (
     Order_Id INTEGER, 
     Order_Date DATE FORMAT 'YYYY-MM-DD',
     Cust_Id INTEGER,
     First_Name VARCHAR(50) CHARACTER SET LATIN CASESPECIFIC,
     Last_Name VARCHAR(50) CHARACTER SET LATIN CASESPECIFIC,
     id INTEGER NOT NULL,
     Product_Name VARCHAR(255) CHARACTER SET LATIN NOT CASESPECIFIC,
	 Order_Status VARCHAR(5) CHARACTER SET LATIN CASESPECIFIC,
	 Total_Price DECIMAL(10,2) ,
	 Order_Priority INTEGER COMPRESS 10 ,
     Store_Id INTEGER,
	 Ship_Priority INTEGER COMPRESS (1 ,2 ,3 ,4 ,5 ),
	 Order_Qty INTEGER,
	 Discount DECIMAL(10,2),
	 Discount_Percent DECIMAL(10,2),
	 Recomsale_Price DECIMAL(6,2)
     ) 
PRIMARY INDEX (Order_Date );


