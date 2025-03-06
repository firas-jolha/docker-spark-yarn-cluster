from pyspark.sql import SparkSession
# import pandas as pd


spark = SparkSession\
    .builder\
    .appName("PythonSparkApp")\
    .getOrCreate()    

sc = spark.sparkContext
sc.setLogLevel("OFF") # WARN, FATAL, INFO

data = [('hello', 1), ('world', 2)]
# print(pd.DataFrame(data))


spark.createDataFrame(data).show()


rdd = sc.parallelize(data)
print(rdd.collect())

print("hello")

from backend import some_f
some_f(spark)