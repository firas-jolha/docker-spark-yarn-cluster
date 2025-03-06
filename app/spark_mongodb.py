import pymongo

from pyspark.sql import SparkSession
import pandas as pd


spark = SparkSession\
    .builder\
    .appName("MySparkApp")\
    .getOrCreate()    

sc = spark.sparkContext
sc.setLogLevel("OFF") # WARN, FATAL, INFO

# The default configuration
# localhost:27017
client = pymongo.MongoClient()

db = client['moviesdb'] # client['<db_name>']

# A pymongo Cursor 
# db.<collection_name>
movies_cur = db.movies.find() # Get all documents

# print(movies_cur)


# Convert to Pandas DataFrame
df1 = pd.DataFrame(movies_cur)

from pyspark.sql.types import *

schema = StructType([
    # StructField(<fieldname>, <fieldtype>, <nullability>)
    StructField("_id", StringType(), True), # Special field for the documents in Mongodb

    StructField("Film", StringType(), True),
    StructField("Genre", StringType(), True),
    StructField("Lead Studio", StringType(), True),
    StructField("Audience score %", IntegerType(), True),
    StructField("Profitability", StringType(), True),
    StructField("Rotten Tomatoes %", IntegerType(), True),
    StructField("Worldwide Gross", StringType(), True),
    StructField("Year", IntegerType(), True),

    ])

# Try to run spark.createDataFrame(movies_cur) 

movies_cur = db.movies.find() # Get all documents

# Convert immediately to Spark DataFrame
df3 = spark.createDataFrame(movies_cur, schema)

movies_cur = db.movies.find() # Get all documents

    
# Convert to RDD then to Spark DataFrame
df4 = spark.createDataFrame(sc.parallelize(movies_cur), schema) # Convert to Spark DataFrame

print(df1)
print(df1.columns)

df3.show()
df4.show()