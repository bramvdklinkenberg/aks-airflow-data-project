##########################################################
# This DAG needs to be fixed first before it             #
# can be used and moved back to ../azure_data_dude/dags/ #
##########################################################


# import os
# import pendulum
# from airflow.decorators import (
#     dag,
#     task
# )


# @dag(
#     schedule_interval=None,
#     start_date=pendulum.datetime(2021, 1, 1),
#     catchup=False,
#     tags=["etl", "humidity", "taskflow"]
# )
# def humidity_data_dag():
#     """
#     ### Humidity Data ETL DAG
#     This DAG Extracts, Transforms and Loads Humidity Data from an Azure Blob Storage to Azure Postgresql Database
#     """
#     @task()
#     def connect_to_storage():
#         from azure_data_dude.modules.utils import get_blob_client

#         storage_client = get_blob_client()
#         return storage_client

#     @task()
#     def extract_storage_data(storage_client):
#         from azure_data_dude.modules.csv_humidity_data import extract_csv_data

#         csv_content = extract_csv_data(storage_client)
#         return csv_content

#     @task()
#     def transform_storage_data(csv_content):
#         from azure_data_dude.modules.csv_humidity_data import (
#             convert_csv_to_dataframe,
#             transform_humidity_data
#         )

#         df = convert_csv_to_dataframe(csv_content)
#         df = transform_humidity_data(df)
#         return df

#     @task(multiple_outputs=True, provide_context=True)
#     def connect_to_databases():
#         from azure_data_dude.modules.utils import get_postgres_connection

#         conn, cursor = get_postgres_connection()
#         return {"conn": conn, "cursor": cursor}

#     @task(provide_context=True)
#     def load_data(context, df):
#         from azure_data_dude.modules.csv_humidity_data import load_humidity_data

#         table_name = os.environ["HUMIDITY_DATA_TABLE_NAME"]

#         conn = context["task_instance"].xcom_pull(task_ids="connect_to_databases", key="conn")
#         cursor = context["task_instance"].xcom_pull(task_ids="connect_to_databases", key="cursor")

#         load_humidity_data(df, conn, cursor, table_name)
#         pass

#     @task(provide_context=True)
#     def view_data(context):
#         from azure_data_dude.modules.utils import view_table_name_data

#         table_name = os.environ["HUMIDITY_DATA_TABLE_NAME"]

#         cursor = context["task_instance"].xcom_pull(task_ids="connect_to_databases", key="cursor")

#         view_table_name_data(cursor, table_name)
#         pass

#     @task(provide_context=True)
#     def disconnect_from_database(context):
#         from azure_data_dude.modules.utils import close_postgres_connection

#         conn = context["task_instance"].xcom_pull(task_ids="connect_to_databases", key="conn")
#         cursor = context["task_instance"].xcom_pull(task_ids="connect_to_databases", key="cursor")

#         close_postgres_connection(conn, cursor)
#         pass

#     storage_client = connect_to_storage()
#     csv_content = extract_storage_data(storage_client)
#     df = transform_storage_data(csv_content)
#     connect_to_databases()
#     load_data(df)
#     view_data()
#     disconnect_from_database()


# humidity_etl_dag = humidity_data_dag()
