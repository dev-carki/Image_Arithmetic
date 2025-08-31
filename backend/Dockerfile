# Step 1: Python 기반 이미지 선택 (alpine 버전 사용)
FROM python:3.10-slim

LABEL maintainer="Owen"

# Step 2: 환경 변수 설정
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# Step 3: 작업 디렉토리
WORKDIR /app

# Step 4: requirements 복사
COPY ./requirements.txt /tmp/requirements.txt

# Step 5: 의존성 설치
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apt-get update && apt-get install -y --no-install-recommends \
        gcc \
        g++ \
        libpq-dev \
        build-essential \
    && /py/bin/pip install -r /tmp/requirements.txt --extra-index-url https://download.pytorch.org/whl/cu128 \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp \
    && adduser --disabled-password --no-create-home fastapi-user

# Step 6: PATH 등록 (venv python 사용)
ENV PATH="/py/bin:$PATH"

# Step 7: 코드 복사
COPY ./api /app/api
COPY ./ml /app/ml


# Step 8: 포트 노출 (FastAPI 기본 uvicorn 포트 8000)
EXPOSE 8000

# Step 9: 권한 사용자 변경
USER fastapi-user

# Step 10: FastAPI 실행 (uvicorn)
CMD ["uvicorn", "api.main:app", "--host", "0.0.0.0", "--port", "8000"]
