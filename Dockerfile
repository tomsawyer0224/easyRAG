# base image
FROM python:3.12-slim
# set environment variables
ENV PYTHONUNBUFFERED=1
# install ollama and pull models
RUN apt update && apt install -y curl && rm -rf /var/lib/apt/lists/*
RUN curl -fsSL https://ollama.com/install.sh | sh
RUN ollama serve & sleep 10 && \
	ollama pull llama3.2 && \
	ollama pull llama3.2:1b 
# set the working directory
WORKDIR /app
# copy project to the image
COPY . .
# install dependencies
RUN pip install -U pip && pip install --no-cache-dir -r requirements.txt
# expose a port so that streamlit can listen on
EXPOSE 8501
# specify default commands
CMD ["/bin/bash", "-c", "ollama serve & sleep 10 && streamlit run app.py --server.port 8501 --server.headless true"]