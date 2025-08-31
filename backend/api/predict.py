import io
import torch
import torch.nn.functional as F
from fastapi import APIRouter, UploadFile, File
from PIL import Image
from api.model_loader import ModelLoader

router = APIRouter()

@router.post("/predict")
async def predict(file: UploadFile = File(...)):
    model, device = ModelLoader.get_model()

    # 이미지 로딩 및 전처리
    contents = await file.read()
    image = Image.open(io.BytesIO(contents)).convert("L")
    image = image.resize((28, 28))
    img_tensor = torch.tensor([[[list(image.getdata())[i:i+28] 
                                  for i in range(0, 784, 28)]]], dtype=torch.float32)
    img_tensor = img_tensor / 255.0
    img_tensor = img_tensor.to(device)

    # 모델 추론
    with torch.no_grad():
        outputs = model(img_tensor)
        probs = F.softmax(outputs, dim=1)
        pred = torch.argmax(probs, dim=1).item()

    return {
        "prediction": pred,
        "probabilities": probs.cpu().numpy().tolist()
    }
