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

Export_Sql="SEL * FROM AR186005.CORE_AZURE_RETAIL_CUSTOMER WHERE CURR_IND = 'Y'"
with teradatasql.connect(host="tdprd.td.teradata.com", user="AR186005",password="Vishal@55121978" ,logmech = "LDAP") as connect:
    with connect.cursor() as cur:
        cur.execute(Export_Sql)
        rows = cur.fetchall()
        columns = [desc[0] for desc in cur.description]

data_dicts = [dict(zip(columns, row)) for row in rows]
with open('Export_Customer.json','w') as json_file:
    json.dump(data_dicts, json_file, indent=4,cls=DatetimeEncoder)