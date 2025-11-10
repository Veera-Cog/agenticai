FROM python:3.10-slim

# Set working directory
WORKDIR /code

# Install required packages
RUN pip install -U gunicorn autogenstudio

# Create a non-root user
RUN useradd -m -u 1000 user
USER user

# Proper environment variable declarations
ENV HOME=/home/user
ENV PATH=/home/user/.local/bin:$PATH
ENV AUTOGENSTUDIO_APPDIR=/home/user/app

# Set working directory to app dir
WORKDIR $HOME/app

# Copy project files with correct ownership
COPY --chown=user . $HOME/app

# Start AutoGen Studio with Gunicorn
# Note: avoid shell arithmetic in CMD, keep it simple
CMD ["gunicorn", "-w", "3", "--timeout", "12600", "-k", "uvicorn.workers.UvicornWorker", "autogenstudio.web.app:app", "--bind", "0.0.0.0:8081"]
