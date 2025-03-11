import pandas


def some_f(session):
    print("hello from backend")
    df = pandas.DataFrame(range(10))
    print(f"hello from backend where df.shape is {df.shape}")
    print(pandas.__version__)
    session.createDataFrame(df).show()