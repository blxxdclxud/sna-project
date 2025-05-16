package main

import (
	"flag"
	"fmt"
	"gitlab.pg.innopolis.university/e.pustovoytenko/dnp25-project-19/metrics"
	"log"

	logger "gitlab.pg.innopolis.university/e.pustovoytenko/dnp25-project-19/pkg/logger"
	"gitlab.pg.innopolis.university/e.pustovoytenko/dnp25-project-19/server"
)

func main() {
	var rmqHost string

	flag.StringVar(&rmqHost, "rmq", "amqp://guest:guest@rabbitmq:5672/", "rabbitmq host address")
	flag.Parse()
	fmt.Println("rmq host:", rmqHost)

	err := logger.Init("development")
	if err != nil {
		log.Fatalf("failed to initialize logger: %v", err)
	}

	metrics.StartMetricsServer()

	// Pass the RabbitMQ host to RunServer
	server.RunServer(rmqHost)
}
