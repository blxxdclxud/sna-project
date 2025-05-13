# Базовый образ
FROM golang:1.24 AS base
WORKDIR /app
COPY . .
RUN go mod download

# Для сервера
FROM base AS server
RUN go build -o /app/server ./cmd/server
CMD ["/app/server"]

# Для воркера
FROM base AS worker
RUN go build -o /app/worker ./cmd/worker
RUN chmod +x /app/worker  # Даем права на выполнение
CMD ["/app/worker"]

# Для тестов (тест-сервер)
FROM base AS test
CMD ["go", "test", "./server/messaging/tests"]
