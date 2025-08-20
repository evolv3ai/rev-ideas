# Base image from OpenAI Codex Universal
FROM openai/codex-universal:latest

# Set working directory
WORKDIR /workspace

# Install Python 3.11 and Node.js 18 if not already in base
RUN apt-get update && apt-get install -y \
    python3.11 \
    python3.11-venv \
    python3-pip \
    nodejs \
    npm \
    postgresql-client \
    redis-tools \
    curl \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install global development tools
RUN npm install -g pnpm typescript @types/node

# Copy project files
COPY . /workspace/

# Install Python dependencies if requirements.txt exists
RUN if [ -f "backend/requirements.txt" ]; then \
    cd backend && \
    python3.11 -m venv venv && \
    . venv/bin/activate && \
    pip install --upgrade pip && \
    pip install -r requirements.txt; \
    fi

# Install Node dependencies if package.json exists
RUN if [ -f "frontend/package.json" ]; then \
    cd frontend && \
    npm install; \
    fi

# Expose ports
EXPOSE 3000 8000 5432 6379

# Set up development environment variables
ENV PYTHONUNBUFFERED=1
ENV NODE_ENV=development
ENV PATH="/workspace/backend/venv/bin:$PATH"

# Default command
CMD ["bash"]
