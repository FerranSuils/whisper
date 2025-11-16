# Dockerfile para OpenAI Whisper
FROM python:3.10-slim

# Instalar ffmpeg y dependencias del sistema
RUN apt-get update && apt-get install -y \
    ffmpeg \
    git \
    && rm -rf /var/lib/apt/lists/*

# Establecer directorio de trabajo
WORKDIR /app

# Copiar archivos de requisitos
COPY requirements.txt pyproject.toml MANIFEST.in ./
COPY whisper ./whisper
COPY data ./data

# Instalar dependencias de Python
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Instalar el paquete whisper
RUN pip install --no-cache-dir -e .

# Crear directorio para modelos (se montará como volumen)
RUN mkdir -p /root/.cache/whisper

# Crear directorio para archivos de entrada/salida
RUN mkdir -p /data/input /data/output

# Exponer volúmenes
VOLUME ["/root/.cache/whisper", "/data"]

# Comando por defecto
CMD ["whisper", "--help"]
