# Билдер
FROM golang:1.24 AS builder-worker
WORKDIR /app
COPY . .
RUN go mod download
RUN go build -o worker ./cmd/worker

# Финальный образ
FROM alpine:3.19 AS worker
WORKDIR /app
COPY --from=builder-worker /app/worker ./worker
RUN chmod +x ./worker
CMD ["./worker"]
