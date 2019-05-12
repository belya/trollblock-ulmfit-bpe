from tqdm import tqdm_notebook
import torch
import fastai
from fastai.text import *
import numpy as np
import sentencepiece as spm
from ulmfit_bpe.model.config import *

sp = spm.SentencePieceProcessor()
sp.Load(VERSION_FOLDER + COMMENTS_BPE_PATH)

class BPETokenizer(BaseTokenizer):
    def tokenizer(self, text):
        return sp.EncodeAsPieces(text)

def return_tokenizer(*args, **kwargs):
    return BPETokenizer(*args, **kwargs)

class ULMFiTModel:
    def load(self):
        folder = VERSION_FOLDER
        path = DATA_PATH
        self.data = load_data(folder, path)
        self.classificator = text_classifier_learner(self.data, drop_mult=DROPOUT_COEFFICIENT, arch=AWD_LSTM)
        self.classificator = self.classificator.load(MODEL_PATH)

    def preprocess(self, messages):
        return [message.lower() for message in messages]

    def predict_probabilities(self, messages):
        probabilities = [self.classificator.predict(item=message) for message in tqdm_notebook(messages)]
        return np.array([float(p[2][-1]) for p in probabilities])
