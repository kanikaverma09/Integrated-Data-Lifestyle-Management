CREATE MULTISET TABLE RK250076.STG_AWS_ORDERS ,FALLBACK ,
     NO BEFORE JOURNAL,
     NO AFTER JOURNAL,
     CHECKSUM = DEFAULT,
     DEFAULT MERGEBLOCKRATIO,
     MAP = TD_MAP1
     (
      Order_Id VARCHAR(255) CHARACTER SET LATIN NOT CASESPECIFIC,
      Cust_Id VARCHAR(255) CHARACTER SET LATIN NOT CASESPECIFIC,
      Order_Status VARCHAR(255) CHARACTER SET LATIN NOT CASESPECIFIC,
      Total_Price VARCHAR(255) CHARACTER SET LATIN NOT CASESPECIFIC,
      Order_Date VARCHAR(255) CHARACTER SET LATIN NOT CASESPECIFIC,
      Order_Priority VARCHAR(255) CHARACTER SET LATIN NOT CASESPECIFIC,
      Clerk VARCHAR(255) CHARACTER SET LATIN NOT CASESPECIFIC,
      Store_Id VARCHAR(255) CHARACTER SET LATIN NOT CASESPECIFIC,
      Ship_Priority VARCHAR(255) CHARACTER SET LATIN NOT CASESPECIFIC,
      Order_Comment VARCHAR(255) CHARACTER SET LATIN NOT CASESPECIFIC,
      Order_Qty VARCHAR(255) CHARACTER SET LATIN NOT CASESPECIFIC,
      Product_Id VARCHAR(255) CHARACTER SET LATIN NOT CASESPECIFIC,
      Discount VARCHAR(255) CHARACTER SET LATIN NOT CASESPECIFIC,
      Source_System VARCHAR(10) CHARACTER SET LATIN NOT CASESPECIFIC,
      LOAD_DTTM TIMESTAMP(6))
PRIMARY INDEX ( Order_Id );


replace view RK250076.STG_AWS_ORDERS_VW as sel * from RK250076.STG_AWS_ORDERS;

sel count(*) from RK250076.STG_AWS_ORDERS;
sel count(*) from RK250076.STG_AWS_ORDERS_VW;


GRANT SELECT ON RK250076.CORE_AWS_ORDERS TO MP255078 WITH GRANT OPTION;
GRANT SELECT ON RK250076.CORE_AWS_ORDERS TO AR186005 WITH GRANT OPTION;
GRANT SELECT ON RK250076.CORE_AWS_ORDERS TO SK186103 WITH GRANT OPTION;