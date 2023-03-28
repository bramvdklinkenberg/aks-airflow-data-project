##########################################################
# This DAG needs to be fixed first before it             #
# can be used and moved back to ../azure_data_dude/dags/ #
##########################################################

# import pendulum
# import os
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
# def weather_data_dag():
#     """
#     ### Weather API Data ETL DAG
#     This DAG Extracts Weather Data from a public API,
#     Transforms the data
#     and Loads it into a Azure Postgresql Database
#     """
#     @task()
#     def extract_weather_data():
#         from azure_data_dude.modules.weather_data import get_api_response

#         api_url = os.environ["WEATHER_API_BASE_URL"] + \
#             os.environ["WEATHER_API_PARAMETERS"] + \
#             '&key=' + \
#             os.environ["WEATHER_API_KEY"]

#         json_response = get_api_response(api_url)
#         return json_response

#     @task()
#     def transform_weather_data(json_response):
#         from azure_data_dude.modules.weather_data import transform_weather_data

#         df = transform_weather_data(json_response)
#         return df

#     @task(multiple_outputs=True, provide_context=True)
#     def connect_to_databases():
#         from azure_data_dude.modules.utils import get_postgres_connection

#         conn, cursor = get_postgres_connection()
#         return {"conn": conn, "cursor": cursor}

#     @task(provide_context=True)
#     def load_data(context, df):
#         from azure_data_dude.modules.weather_data import load_weather_data

#         table_name = os.environ["WEATHER_DATA_TABLE_NAME"]

#         conn = context["task_instance"].xcom_pull(task_ids="connect_to_databases", key="conn")
#         cursor = context["task_instance"].xcom_pull(task_ids="connect_to_databases", key="cursor")

#         load_weather_data(df, conn, cursor, table_name)
#         pass

#     @task(provide_context=True)
#     def view_data(context):
#         from azure_data_dude.modules.utils import view_table_name_data

#         table_name = os.environ["WEATHER_DATA_TABLE_NAME"]

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

#     weather_data = extract_weather_data()
#     df = transform_weather_data(weather_data)
#     connect_to_databases()
#     load_data(df)
#     view_data()
#     disconnect_from_database()


# weather_etl_dag = weather_data_dag()
