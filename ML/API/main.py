import io
import torch
import torch.nn.functional as F
import torch.nn as nn
from fastapi import FastAPI, UploadFile, File
from pydantic import BaseModel
from PIL import Image
import uvicorn

# =======================
# 1. 환경 설정
# =======================
app = FastAPI()

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

# 모델 정의 (학습에 사용했던 구조와 동일해야 함!)
class CNN(nn.Module):
    def __init__(self):
        super(CNN, self).__init__()
        # 컨볼루션 레이어
        self.conv1 = nn.Conv2d(in_channels=1, out_channels=16, kernel_size=3, stride=1, padding=1)
        self.conv2 = nn.Conv2d(in_channels=16, out_channels=32, kernel_size=3, stride=1, padding=1)
        
        # 완전 연결 레이어
        self.fc1 = nn.Linear(32 * 7 * 7, 128)
        self.fc2 = nn.Linear(128, 10)
        
        # 활성화 함수 및 풀링 레이어
        self.relu = nn.ReLU()
        self.maxpool = nn.MaxPool2d(kernel_size=2, stride=2)

    def forward(self, x):
        x = self.relu(self.conv1(x))
        x = self.maxpool(x)
        x = self.relu(self.conv2(x))
        x = self.maxpool(x)
        x = x.view(-1, 32 * 7 * 7) # 이미지를 1차원으로 평탄화
        x = self.relu(self.fc1(x))
        x = self.fc2(x)
        return x

# =======================
# 2. 모델 로드
# =======================
MODEL_PATH = "/Users/carki/Desktop/Dev/Vision/arithmetic/ML/best_cnn.pt"   # 학습된 모델 경로
model = CNN().to(device)
model.load_state_dict(torch.load(MODEL_PATH, map_location=device))
model.eval()

# =======================
# 3. API 정의
# =======================

@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    # 이미지 읽기
    contents = await file.read()
    image = Image.open(io.BytesIO(contents)).convert("L")  # MNIST는 흑백
    image = image.resize((28, 28))  # MNIST 크기 맞추기
    img_tensor = torch.tensor([[[list(image.getdata())[i:i+28] for i in range(0, 784, 28)]]], dtype=torch.float32)
    img_tensor = img_tensor / 255.0  # normalize (0~1)
    img_tensor = img_tensor.to(device)

    # 모델 예측
    with torch.no_grad():
        outputs = model(img_tensor)
        probs = F.softmax(outputs, dim=1)
        pred = torch.argmax(probs, dim=1).item()

    return {
        "prediction": pred,
        "probabilities": probs.cpu().numpy().tolist()
    }

# =======================
# 4. 서버 실행
# =======================
# uvicorn main:app --reload
