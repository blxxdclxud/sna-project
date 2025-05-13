variable "worker_count" {
  description = "Number of workers"
  type        = number
  default     = 2
}

variable "scheduler_image_name" {
  description = "Name for Docker-image for scheduler"
  type        = string
  default     = "your-image/scheduler:latest"
}

variable "worker_image_name" {
  description = "Name for Docker-image for worker"
  type        = string
  default     = "your-image/worker:latest"
}
