import teradatasql
from datetime import datetime
import json
import os
import json
import teradatasql
import pandas as pd
from teradataml import execute_sql


class DatetimeEncoder(json.JSONEncoder):
    def default(self, obj):
        try:
            return super().default(obj)
        except TypeError:
            return str(obj)

Export_Sql="CURRENT VALIDTIME SELECT Cust_id, Age, Gender,Cust_name,LOAD_DTTM FROM MP255078.CORE_AZURE_RETAIL_CUSTOMER WHERE CAST(LOAD_DTTM AS DATE)  = CURRENT_DATE"
with teradatasql.connect(host="tdprd.td.teradata.com", user="MP255078",password="********" ,logmech = "LDAP") as connect:
    with connect.cursor() as cur:
        cur.execute(Export_Sql)
        rows = cur.fetchall()
        columns = [desc[0] for desc in cur.description]

data_dicts = [dict(zip(columns, row)) for row in rows]
with open('Export_Customer.json','w') as json_file:
    json.dump(data_dicts, json_file, indent=4,cls=DatetimeEncoder)
    
    
    