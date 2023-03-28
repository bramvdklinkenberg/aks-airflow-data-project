from airflow import DAG
from datetime import datetime, timedelta
from airflow.operators.python import PythonOperator
import os


def print_env_vars():
    env_vars = os.environ
    for var in env_vars:
        print(var + "=" + env_vars[var])


with DAG(
    "test_dag",
    default_args={
        "depends_on_past": False,
        "email_on_failure": False,
        "email_on_retry": False,
        "retries": 1,
        "retry_delay": timedelta(minutes=5),
    },
    description="A test dag",
    schedule=timedelta(hours=1),
    start_date=datetime(2023, 3, 16),
    catchup=False,
    tags=["test"],
) as dag:

    print_env = PythonOperator(
        task_id="print_env",
        python_callable=print_env_vars
    )

    print_env
