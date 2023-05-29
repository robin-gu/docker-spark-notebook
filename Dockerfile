# Choose your desired base image
FROM jupyter/all-spark-notebook:python-3.10

RUN pip install --quiet --no-cache-dir backtrader akshare fastchat && \
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"