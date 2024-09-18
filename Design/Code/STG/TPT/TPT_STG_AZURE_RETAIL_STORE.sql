	DEFINE JOB Retail_store
	DESCRIPTION 'loading data into table from file'
	(
	   DEFINE SCHEMA OPERATOR_SOURCE_SCHEMA
	   DESCRIPTION 'OPERATORS INFORMATION'
	   (Store_Id VARCHAR(255),
    Brand VARCHAR(255) ,
    Capacity VARCHAR(255) ,
    City VARCHAR(255) ,
    Country VARCHAR(255) ,
    District VARCHAR(255) ,
    Latitude VARCHAR(255),
    Longitude VARCHAR(255),
    Outlet_Design VARCHAR(255) ,
    Outlet_Type VARCHAR(255),
    Ownership_Type VARCHAR(255),
    Phone_Number VARCHAR(255) ,
    State VARCHAR(255),
    Store_Name VARCHAR(255),
    Store_Number VARCHAR(255) ,
    Steet_Address VARCHAR(255),
    Territory VARCHAR(255),
    Time_Zone VARCHAR(255),
    Zip_Code VARCHAR(255),
    State_Name VARCHAR(255),
    County VARCHAR(255) ,
    Extract_Dttm VARCHAR(255) 
	   );


	   DEFINE OPERATOR LOAD_OPERATOR
	   DESCRIPTION 'TERADATA PARALLEL TRANSPORTER LOAD OPERATOR'
	   TYPE LOAD
	   SCHEMA *
	   ATTRIBUTES
	   (      INTEGER TenacityHours   = 1,
		  INTEGER TenacitySleep   = 1,
		  INTEGER BufferSize      = 16,
		  INTEGER MaxSessions     = 1,
		  INTEGER MinSessions     = 1,
		  INTEGER ErrorLimit      = 1,
		  VARCHAR TdpId	      = 	'tdprd.td.teradata.com',
		  VARCHAR LogonMech       = 'LDAP',
		  VARCHAR UserName        = 'KV255007',
		  VARCHAR UserPassword    = '*********',
		  VARCHAR TargetTable     = 'KV255007.STG_AZURE_RETAIL_STORE_STG',
		  VARCHAR LogTable        = 'KV255007.STG_AZURE_RETAIL_STORE_STG_LOG',
		  VARCHAR ErrorTable1     = 'KV255007.STG_AZURE_RETAIL_STORE_STG_ERROR1',
		  VARCHAR ErrorTable2     = 'KV255007.STG_AZURE_RETAIL_STORE_STG_ERROR2'
	   );

	   DEFINE OPERATOR Operator_data_loading
	   DESCRIPTION 'TERADATA PARALLEL TRANSPORTER DATACONNECTOR OPERATOR'
	   TYPE DATACONNECTOR PRODUCER
	   SCHEMA OPERATOR_SOURCE_SCHEMA
	   ATTRIBUTES
	   (
		  VARCHAR FileName      = 'itp_retail_store.csv',
		  VARCHAR OpenMode      = 'Read',
		  VARCHAR Format        = 'DELIMITED',
		  INTEGER SKIPROWS      = 1, 
		  VARCHAR TextDelimiter = '|',
		  VARCHAR DirectoryPath = 'C:\Users\kv255007\OneDrive - Teradata\DESKTOP\Dataset_v0.1\Azure\Day_0'
	   );
			 Step Load_Table
	   (
		  APPLY 
		(
		'INSERT INTO KV255007.STG_AZURE_RETAIL_STORE_STG
		(    Store_Id,
                     Brand ,
                     Capacity ,
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
                      ,LOAD_DTTM
                      )
                      VALUES(:Store_Id,
                         :Brand ,
                         :Capacity ,
                         :City  ,
                         :Country  ,
                         :District ,
                         :Latitude,
                         :Longitude,
                         :Outlet_Design ,
                         :Outlet_Type ,
                         :Ownership_Type ,
                         :Phone_Number ,
                         :State ,
                         :Store_Name ,
                         :Store_Number ,
                         :Steet_Address ,
                         :Territory ,
                         :Time_Zone ,
                         :Zip_Code ,
                         :State_Name ,
                         :County ,
                         :Extract_Dttm ,
	                 ''Azure''
                        , Current_Timestamp(6));')

		  TO OPERATOR 
		(
		LOAD_OPERATOR
		)
		  SELECT * FROM OPERATOR (Operator_data_loading);
	   );
	   
	);
