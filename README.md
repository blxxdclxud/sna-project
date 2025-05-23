# 🌐 Distributed Job Scheduling 

A distributed task scheduling system designed for efficient management and distribution of computational load in a multi-node environment. The project uses Docker to containerize services, Terraform for more flexible system management, Prometheus and Grafana for system state tracking and CI for automated testing.
## 🔍 Description
- [📄 About the project](#-about-the-project): in this section you will find a brief description of the project.
- [🚀 Project features](#-project-features): in this section you will find the specifics of the project implementation.
- [⚙️ Requirements](#-requirements): in this section you will find the necessary resources that must be installed in order for the program to work.
- [💿 How to use the program](#-how-to-use-the-program): in this section you will find a description of how to start the server and how to start a client, as well as how to use additional features.
    - [🐋 Launching the project via Docker Compose](#launching-the-project-via-docker-compose)
    - [🪐 Launching the project via Terraform](#launching-the-project-via-terraform)
- [📊 How to monitor the system status](#-how-to-monitor-the-system-status)
- [👨🏻‍💻 Authors](#-authors): in this section you will find information about the students of this project 

## 📄 About the project
The project was created as part of an academic project activity in which students demonstrate their skills with terraform, docker, CI/CD, Grafana, and Prometheus.

## 🔖 Project features
- Possibility to start the project both via docker compose and terraform.
- The project is written in Go.
- The project works locally.
- The project solves lua code tasks.

## ⚙️ Requirements
- Go
- Terraform
- Docker 

## 💿 How to use the program
There are two ways to run the program: 

**(1)** Launching the project via Docker Compose

**(2)** Launching the project via Terraform

### Launching the project via Docker Compose:
Getting the project up using docker compose
#### Host and Workers side:
- Download the project from github
```bash
git clone https://github.com/blxxdclxud/sna-project.git
cd sna-project
```
- Start a docker and run the project
```bash
cd .\deployments\
docker compose -f docker-compose.yml up --build
```
#### Client side:
- Build a file for the client and send the task through it
```bash
go build cmd/client/main.go
./main -file lua-examples/factorial.lua
```

### Launching the project via Terraform:
*This way works only on Linux.*

Getting the project up using Terraform
#### Host and Workers side:
- Download the project from github
```bash
git clone https://github.com/blxxdclxud/sna-project.git
```
- Start a docker and run a terraform
```bash
cd .\terraform-local\
terraform build
```
To confirm the creation, you must enter "yes"

- To finish working with the system
```bash
terraform destroy
```
To confirm, you must enter "yes"

---
- To change the number of workers, do the following steps:
```bash
cd .\terraform-local\
nano terraform.tfvars
```
Change the value of the workers_count variable and save changes:
```
worker_count = 5
```
---
This part must be done if the “terraform build” command does not work.

**Attention!** VPN is required for this part since terraform doesn't work in Russia.
``` bash
cd .\terraform-local\
terraform init
```

#### Client side:
- Build a file for the client and send the task through it
```bash
go build cmd/client/main.go
./main -file lua-examples/factorial.lua
```
## 📊 How to monitor the system status
#### 🧭 1. Access Grafana UI

After starting the system with Docker Compose, open Grafana in your browser:
```
http://localhost:3000
```


#### 2. Log in

- **Username**: `admin`
- **Password**: `admin` (or set on first login)
    

> You may be prompted to change the password on first login.

#### 📂 3. View Dashboards

- Navigate to **"Dashboards"** and open the one named **"DJS"**


#### 🔄 4. Refresh & Time Range

- Use the time picker in the top-right to adjust the time range (e.g., _Last 15 minutes_)
- Set a **refresh interval** (e.g., _every 10s_) for live updates

## 👨🏻‍💻 Authors
- **Daniil Mayorov** d.mayorov@innopolis.university 
- **Niyaz Gubaidullin** n.gubaidullin@innopolis.university
- **Ramazan Nazmiev** r.nazmiev@innopolis.university
