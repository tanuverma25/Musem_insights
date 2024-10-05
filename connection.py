
import pandas as pd 
from sqlalchemy import create_engine

conn_string = 'mysql+pymysql://root:your_password@localhost/painting'
db = create_engine(conn_string)
conn = db.connect()

files = ['artist','canvas_size','museum','museum_hours','product_size','subject','work']

for file in files:
    df = pd.read_csv(rf'\\PC-PC\Users\PC\paintings_data\Datasets\{file}.csv')
    df.to_sql(file, con=conn, if_exists='replace', index=False)
