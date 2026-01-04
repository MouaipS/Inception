*This project has been created as part of the 42 curriculum by adrouin*

# Inception

## Description

This project aims to build ourselves a docker infrastructure with different services under specific rules. 

It is based on a Dockerized infrastructure that includes:
- Nginx with TLS (a safety transport protocol)
- MariaDB 
- WordPress

The project demonstrates the use of Docker to deploy, isolate, and manage multiple services in a reproducible way.

---

## Project Architecture & Design Choices

### Use of Docker

Docker is used to containerize each service of the project in order to:
- Ensure environment consistency
- Simplify deployment and reproducibility
- Isolate services

All services are orchestrated using **Docker Compose**.

### Included Sources

The project includes:
- Dockerfiles for each service
- A `docker-compose.yml` file
- Configuration files
- Volumes for persistent data
- A Makefile to simplify commands

---

## Technical Comparisons

### Virtual Machines vs Docker

| Virtual Machines | Docker |
|------------------|--------|
| Heavy, full OS   | Lightweight containers |
| Slower startup  | Fast startup |
| Higher resource usage | Efficient resource usage |

A project which runs on a specific environment may not work on another. Docker is here to solve this problem. 

### Secrets vs Environment Variables

| Secrets | Environment Variables |
|--------|-----------------------|
| Stored securely | Easier to expose |
| Recommended for sensitive data | Suitable for non-sensitive config |

### Docker Network vs Host Network

| Docker Network | Host Network |
|---------------|-------------|
| Isolated, secure | Direct access to host |
| Recommended | Less secure |

### Docker Volumes vs Bind Mounts

| Docker Volumes | Bind Mounts |
|---------------|-------------|
| Managed by Docker | Linked to host filesystem |
| Safer and portable | Useful for development |

---

## Instructions

### Prerequisites

- Docker
- Docker Compose
- Make

### Installation

```bash
git clone <repository_url>
cd <repository_name>
