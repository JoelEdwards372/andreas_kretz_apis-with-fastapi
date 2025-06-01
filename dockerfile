FROM tiangolo/uvicorn-gunicorn-fastapi:python3.7

COPY ./app /app

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]