CREATE MULTISET TABLE AR186005.STG_AZURE_RETAIL_PRODUCT ,FALLBACK , 
     NO BEFORE JOURNAL,
     NO AFTER JOURNAL,
     CHECKSUM = DEFAULT,
     DEFAULT MERGEBLOCKRATIO,
     MAP = TD_MAP1
	 (
      Product_Id VARCHAR(255) CHARACTER SET LATIN NOT CASESPECIFIC, 
      Product_Category VARCHAR(255) CHARACTER SET LATIN NOT CASESPECIFIC, 
      Product_Cost VARCHAR(255) CHARACTER SET LATIN NOT CASESPECIFIC, 
      Product_Name VARCHAR(255) CHARACTER SET LATIN NOT CASESPECIFIC, 
      Recom_Sale_Price VARCHAR(255) CHARACTER SET LATIN NOT CASESPECIFIC,  
      Serving_Size VARCHAR(255) CHARACTER SET LATIN NOT CASESPECIFIC,
      Source_System VARCHAR(10)CHARACTER SET LATIN NOT CASESPECIFIC, 
      LOAD_DTTM TIMESTAMP(6)
     ) PRIMARY INDEX (Product_Id );


replace view AR186005.STG_AZURE_RETAIL_PRODUCT_VW AS SEL * FROM AR186005.STG_AZURE_RETAIL_PRODUCT;


GRANT SELECT ON AR186005.STG_AZURE_RETAIL_PRODUCT_VW TO MP255078 WITH GRANT OPTION;
GRANT SELECT ON AR186005.STG_AZURE_RETAIL_PRODUCT_VW TO SS255313 WITH GRANT OPTION;
GRANT SELECT ON AR186005.STG_AZURE_RETAIL_PRODUCT_VW TO SK186103 WITH GRANT OPTION;