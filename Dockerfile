# Dockerfile

FROM golang:1.24 AS base
WORKDIR /app
COPY . .
RUN go mod download

# Билд сервера (если нужно)
FROM base AS server
RUN go build -o server ./cmd/server

# Билд воркера
FROM base AS worker
RUN go build -o worker ./cmd/worker
RUN chmod +x worker

# Билд для тестов
FROM base AS test
