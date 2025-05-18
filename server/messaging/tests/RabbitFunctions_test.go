package tests

import (
	"context"
	amqp "github.com/rabbitmq/amqp091-go"
	"gitlab.pg.innopolis.university/e.pustovoytenko/dnp25-project-19/server/messaging"
	"gitlab.pg.innopolis.university/e.pustovoytenko/dnp25-project-19/shared/models/Rabbit"
	"testing"
	"time"
)

func TestRabbit(t *testing.T) {
	conn, err := amqp.Dial("amqp://guest:guest@rabbitmq:5672/")
	if err != nil {
		t.Fatalf("Ошибка подключения к RabbitMQ: %v", err)
	}
	defer conn.Close()

	r, err := messaging.NewRabbit(conn)
	if err != nil {
		t.Fatalf("Ошибка инициализации Rabbit: %v", err)
	}

	ch1 := make(chan Rabbit.HealthReportWrapper, 20)
	ch2 := make(chan Rabbit.RegistrationWrapper, 20)
	ch3 := make(chan Rabbit.TaskReplyWrapper, 20)

	go r.ListenHeartBeat(ch1)
	go r.ListenRegister(ch2)
	go r.ListenTaskResults(ch3)

	t.Log("Ожидание регистрации воркера...")
	var workerId string
	select {
	case reg := <-ch2:
		workerId = reg.WorkerId
		t.Logf("Получен workerId: %s", workerId)
	case <-time.After(10 * time.Second):
		t.Fatal("Не удалось получить workerId от воркера")
	}

	luaScript := `local start = os.time(); while os.time() - start < 2 do end; local a, b = 10, 20; return a * b`
	err = r.SendTaskToWorker(context.Background(), luaScript, workerId, "task-123")
	if err != nil {
		t.Fatalf("Ошибка при отправке задачи: %v", err)
	}

	t.Log("Ожидание ответа от воркера...")
	select {
	case result := <-ch3:
		t.Logf("Получен результат: %s", result.TaskReply.Results)
		if result.TaskReply.Results != "200" {
			t.Errorf("Ожидали результат 200, получили %s", result.TaskReply.Results)
		}
	case <-time.After(20 * time.Second):
		t.Fatal("Не получили результат задачи от воркера")
	}
}
