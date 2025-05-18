#!/bin/sh

set -e  # Выход при первой ошибке

# Запускаем сервер в фоне
echo "Starting server..."
go run cmd/server/main.go &
SERVER_PID=$!
sleep 2  # Даем серверу время на запуск

# Запускаем воркер в фоне
echo "Starting worker..."
go run cmd/worker/main.go &
WORKER_PID=$!
sleep 1  # Даем воркеру время на запуск

# Запускаем клиент и проверяем вывод
echo "Running client test..."
EXPECTED_OUTPUT="Submitting job to server at http://server:8080...
Job submitted successfully! Job ID: 1, Initial status: PENDING
Polling for job result...
Current status: COMPLETED
Job completed! Result: 4"

CLIENT_OUTPUT=$(go run cmd/client/main.go -file lua-examples/simpleTest.lua -host server:8080)

echo "Client output:"
echo "$CLIENT_OUTPUT"

# Сравниваем вывод с ожидаемым (игнорируем пробелы и пустые строки)
if [ "$(echo "$CLIENT_OUTPUT" | tr -d '[:space:]')" = "$(echo "$EXPECTED_OUTPUT" | tr -d '[:space:]')" ]; then
    echo "✅ Test passed: Output matches expected result."
    EXIT_CODE=0
else
    echo "❌ Test failed: Output does not match expected result."
    EXIT_CODE=1
fi

# Останавливаем сервер и воркер
echo "Stopping server and worker..."
kill $SERVER_PID
kill $WORKER_PID
wait $SERVER_PID $WORKER_PID 2>/dev/null  # Игнорируем ошибки, если процессы уже завершились

exit $EXIT_CODE