import torch
from ml.models import CNN

MODEL_PATH = "ml/best_cnn.pt"
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

# 싱글톤 형태로 모델 로드
class ModelLoader:
    _model = None

    @classmethod
    def get_model(cls):
        if cls._model is None:
            model = CNN().to(device)
            model.load_state_dict(torch.load(MODEL_PATH, map_location=device))
            model.eval()
            cls._model = model
        return cls._model, device
