# Базовый слой
FROM golang:1.24-alpine AS base
WORKDIR /app
COPY . .
RUN go mod download

# Сборка server
FROM base AS build-server
RUN go build -o server ./cmd/server

# Сборка worker
FROM base AS build-worker
RUN go build -o worker ./cmd/worker

# Сборка тестов
FROM base AS build-test
RUN go test -c -o testbin ./server/messaging/tests

# Финальный образ server
FROM alpine:3.19 AS server
WORKDIR /app
COPY --from=build-server /app/server .
CMD ["./server"]

# Финальный образ worker
FROM alpine:3.19 AS worker
WORKDIR /app
COPY --from=build-worker /app/worker .
RUN chmod +x ./worker
CMD ["./worker"]

# Финальный образ юнит-теста
FROM alpine:3.19 AS test
WORKDIR /app
COPY --from=build-test /app/testbin .
CMD ["./testbin", "-test.v"]

# Финальный образ интеграционного теста
FROM golang:1.24-alpine AS integration-test
WORKDIR /app
COPY . .
RUN chmod +x ./scripts/integration_test.sh
CMD ["./scripts/integration_test.sh"]
