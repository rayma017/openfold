import os
import torch
if torch.cuda.is_available():
    print("CUDA is available.")
    current_device = torch.cuda.current_device()
    print(f"Current GPU device index: {current_device}")
    print(f"GPU name: {torch.cuda.get_device_name(current_device)}")
    print(f"CUDA version: {torch.version.cuda}")
else:
    print("CUDA is not available.")
