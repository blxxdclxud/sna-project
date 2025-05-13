# Этап 1 — загрузка зависимостей
FROM golang:1.24-alpine AS deps
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download

# Этап 2 — сборка
FROM golang:1.24-alpine AS builder
WORKDIR /app
COPY --from=deps /go/pkg /go/pkg
COPY --from=deps /app/go.mod /app/go.sum ./
COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o /bin/server ./cmd/server/main.go
RUN CGO_ENABLED=0 GOOS=linux go build -o /bin/worker ./cmd/worker/main.go

# Этап 3 — server
FROM alpine:latest AS server
RUN apk --no-cache add ca-certificates
WORKDIR /app
COPY --from=builder /bin/server .
ENTRYPOINT ["/app/server"]

# Этап 4 — worker
FROM alpine:latest AS worker
RUN apk --no-cache add ca-certificates
WORKDIR /app
COPY --from=builder /bin/worker .
ENTRYPOINT ["/app/worker"]
