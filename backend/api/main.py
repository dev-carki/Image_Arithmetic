from fastapi import FastAPI
from api import predict

app = FastAPI(title="MNIST Digit Classifier API")

# 라우터 등록
app.include_router(predict.router)

# 실행
# uvicorn api.main:app --reload
