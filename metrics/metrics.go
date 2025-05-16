package metrics

import (
	"github.com/gorilla/mux"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promauto"
	"github.com/prometheus/client_golang/prometheus/promhttp"
	"net/http"
)

// Define metrics
var (
	JobsSubmitted = promauto.NewCounter(prometheus.CounterOpts{
		Name: "job_submitted_total",
		Help: "The total number of submitted jobs",
	})

	JobsCompleted = promauto.NewCounter(prometheus.CounterOpts{
		Name: "job_completed_total",
		Help: "The total number of completed jobs",
	})

	WorkerHeartbeats = promauto.NewCounter(prometheus.CounterOpts{
		Name: "worker_heartbeats_total",
		Help: "Total heartbeats received from workers",
	})

	WorkerRegistered = promauto.NewCounter(prometheus.CounterOpts{
		Name: "worker_registered_total",
		Help: "Total registered available workers",
	})
)

// StartMetricsServer starts listening new endpoint for metrics
func StartMetricsServer() {
	router := mux.NewRouter()

	router.Handle("/metrics", promhttp.Handler())
	//http.Handle("/metrics", promhttp.Handler())
	go http.ListenAndServe(":2112", router)
}
