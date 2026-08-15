FROM python:3.10-slim-bullseye

# 1. System dependencies ROOT user se install karo
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		build-essential \
		gcc \
		g++ \
		python3-dev \
	&& rm -rf /var/lib/apt/lists/*

# 2. Hugging Face ki requirement ke liye User ID 1000 banao
RUN useradd -m -u 1000 user
USER user

# 3. Naye user ke environment variables set karo
ENV HOME=/home/user \
    PATH=/home/user/.local/bin:$PATH

# 4. Working directory ab /app ki jagah naye user ke home mein hogi
WORKDIR $HOME/app

# 5. Apni files copy karo, aur permission 'user' ko de do (--chown=user)
COPY --chown=user . $HOME/app

# 6. Python packages install karo
RUN pip install --no-cache-dir --upgrade pip \
	&& pip install --no-cache-dir -r requirements.txt

# 7. Hugging Face ka required port expose karo
EXPOSE 7860

# 8. Apni application run karo
CMD ["python3", "app.py"]
