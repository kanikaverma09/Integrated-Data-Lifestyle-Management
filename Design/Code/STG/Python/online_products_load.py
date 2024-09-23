#####################################################################
"""
    This script is developed by Teradata Inc. 
    :All Copyright Reserved.
    :Developer: Teradata ITP Team-A :Saikrishna Kandimalla , Ashutosh Roy,Smita Sharma
    :Company:Teradata
    :python :Program to read data from JSON file and load into Teradata database
    :Install python install_all_packages.pyc 
    :Date:06-Apr-2024
"""
# Program to read data from JSON file and load into Teradata database 
#####################################################################
 
#pip show sqlalchemy
#pip install sqlalchemy==1.4.40
#pip install  pymysql==1.0.2
################################Important Note:#######################
# Prior to running the program below, please ensure that the correct versions of SQLAlchemy and PyMySQL are installed. 
#If the versions are higher than those specified, please downgrade to the versions mentioned above
#####################################################################
import getpass
from teradataml import *
#from sqlalchemy import create_engine
#from pyspark.sql.functions import col
 
 
#create_context(host = "tdprd.td.teradata.com", username = "sk186103", password='' ,logmech = "LDAP")
#print(get_context())
 
td_userID = getpass.getpass('Enter User id')
td_password = getpass.getpass('Enter pwd')
con = create_context(host = "tdprd.td.teradata.com", username = str(td_userID), password=str(td_password) ,logmech = "LDAP")
 
 
connection = con.raw_connection()
 
with connection.cursor() as cur:
 
    
   with open('C:\\Users\\sk186103\\OneDrive - Teradata\\Desktop\\ITP\\Dataset_v0.1\\Azure\\Day_0\\online_products.json','r') as json_file:
        data = json.load(json_file)
        #print(data)
 
result_cursor = execute_sql(statement="select * from  SS255313.STG_AZURE_RETAIL_ONLINE_PRODUCT where 1=? and 1=?;",
                                parameters=[(1,1)])
cnt=0
for row in result_cursor:
    cnt=cnt+1
table_name="SS255313.STG_AZURE_RETAIL_ONLINE_PRODUCT"
print('#####################################################################')
print(table_name,"table count before loading:",cnt)
 
#Iterate  through each item in the JSON data
for item in data['online_products']:
            id = item['id']
            product_category = item['productcategory']  
            product_cost = item['productcost']
            product_name = item['productname']
            recomsaleprice = item['recomsaleprice']
            servingsize = item['servingsize']    
            insert_qry = '''Insert into SS255313.STG_AZURE_RETAIL_ONLINE_PRODUCT(Product_Id,product_category,product_cost,product_name,Recom_Sale_Price,Serving_Size)
                               values (?,?,?,?,?,?)'''
            con.execute(insert_qry,(id,product_category,product_cost,product_name,recomsaleprice,servingsize))
 
 
result_cursor_fin = execute_sql(statement="select * from  SS255313.STG_AZURE_RETAIL_ONLINE_PRODUCT where 1=? and 1=?;",
                                parameters=[(1,1)])
cnt=0
for row in result_cursor_fin:
    cnt=cnt+1
print(table_name,"table count after loading: ",cnt)
print("Done:The data has been successfully inserted into the Teradata table. Please log in to the database to verify the accuracy of the data")
print('#####################################################################')