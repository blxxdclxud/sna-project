# Создаем сети
resource "docker_network" "internal" {
  name     = "internal"
  internal = true
}

resource "docker_network" "external" {
  name = "external"
}

# Images
resource "docker_image" "scheduler" {
  name = var.scheduler_image_name
  build {
    context    = "../"
    dockerfile = "Dockerfile"
    target     = "server"
  }
}

resource "docker_image" "worker" {
  name = var.worker_image_name
  build {
    context    = "../"
    dockerfile = "Dockerfile"
    target     = "worker"
  }
}

# RabbitMQ
resource "docker_container" "rabbitmq" {
  name  = "rabbitmq"
  image = "rabbitmq:3-management"
  networks_advanced {
    name = docker_network.internal.name
  }
  ports {
    internal = 5672
    external = 5672
  }
  healthcheck {
    test     = ["CMD", "rabbitmq-diagnostics", "check_port_connectivity"]
    interval = "10s"
    timeout  = "5s"
    retries  = 5
  }
}

# Scheduler
resource "docker_container" "scheduler" {
  name  = "scheduler"
  image = docker_image.scheduler.image_id
  networks_advanced {
    name = docker_network.internal.name
  }
  networks_advanced {
    name = docker_network.external.name
  }
  ports {
    internal = 8080
    external = 8080
  }
  env = [
    "RABBITMQ_URL=amqp://guest:guest@rabbitmq:5672/"
  ]
  depends_on = [
    docker_container.rabbitmq
  ]
  restart = "unless-stopped"
}

# Workers
resource "docker_container" "worker" {
  count = var.worker_count
  name  = "worker-${count.index}"
  image = docker_image.worker.image_id
  networks_advanced {
    name = docker_network.internal.name
  }
  env = [
    "RABBITMQ_URL=amqp://guest:guest@rabbitmq:5672/"
  ]
  depends_on = [
    docker_container.rabbitmq
  ]
  restart = "unless-stopped"
}