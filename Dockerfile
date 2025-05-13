# Базовый образ
FROM golang:1.24 AS base
WORKDIR /app
COPY . .
RUN go mod download

# Для сервера
FROM base AS server
RUN go build -o server ./cmd/server
CMD ["./server"]

# Для воркера
FROM base AS worker
RUN go build -o worker ./cmd/worker
RUN chmod +x ./worker  # Даем права на выполнение
CMD ["./worker"]

# Для тестов (тест-сервер)
FROM base AS test
CMD ["go", "test", "./server/messaging/tests"]
