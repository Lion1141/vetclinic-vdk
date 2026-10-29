# VetApp Monorepo

Монорепозиторий микросервисов для системы ветеринарной клиники.

## Архитектура

```
Client ──► Gateway :8080
              │
              ├── /api/clinic/**    ──► clinic-svc    :8081 (PostgreSQL + RabbitMQ)
              ├── /api/medication/**─► medication-svc  :8082 (PostgreSQL + RabbitMQ)
              ├── /api/sync/**      ──► sync-svc      :8083 (PostgreSQL + Redis + RabbitMQ)
              └── /api/audit/**     ──► audit-svc     :8084 (PostgreSQL + RabbitMQ consumer)
```

## Структура проекта

```
demo/
├── apps/
│   ├── clinic-svc/        # Управление клиниками (REST + AMQP)
│   ├── medication-svc/    # Управление медикаментами (REST + AMQP publisher)
│   ├── sync-svc/          # Синхронизация данных (REST + Redis + AMQP)
│   ├── audit-svc/         # Аудит событий (AMQP consumer, без REST)
│   └── gateway/           # API Gateway (Spring Cloud Gateway)
├── packages/
│   └── contracts/         # Общие DTO и контракты (Jackson + Validation)
├── infra/
│   ├── compose/           # Docker Compose (базы данных)
│   ├── k8s/               # Kubernetes манифесты (в разработке)
│   └── scripts/           # Вспомогательные скрипты (в разработке)
└── pom.xml                # Корневой агрегатор (7 модулей)
```

## Технологии

- **Java 21**
- **Spring Boot 3.5.0**
- **Spring Cloud 2025.0.0** (Gateway)
- **Maven** (монорепозиторий с агрегатором)
- **PostgreSQL** — основная БД (HikariCP, pool: 10/5)
- **Flyway 11** — миграции БД (`baseline-on-migrate: true`)
- **RabbitMQ** — асинхронное взаимодействие (AMQP)
- **Redis** — кэширование и дедупликация (sync-svc)
- **Testcontainers 1.20** — интеграционные тесты
- **SpringDoc** — OpenAPI документация (clinic-svc, medication-svc)
- **Lombok** — уменьшение boilerplate

## Быстрый старт

### Сборка проекта

```bash
# Собрать все модули
./mvnw clean package -DskipTests

# Собрать конкретный сервис
./mvnw -pl apps/clinic-svc -am package

# Собрать и протестировать
./mvnw -pl apps/clinic-svc -am verify
```

### Запуск сервисов

Каждый сервис запускается отдельно:

```bash
# Clinic Service
./mvnw -pl apps/clinic-svc spring-boot:run

# Medication Service
./mvnw -pl apps/medication-svc spring-boot:run

# Sync Service
./mvnw -pl apps/sync-svc spring-boot:run

# Audit Service
./mvnw -pl apps/audit-svc spring-boot:run

# Gateway
./mvnw -pl apps/gateway spring-boot:run
```

### Запуск инфраструктуры

```bash
# PostgreSQL для clinic-svc
docker compose -f infra/compose/docker-compose.yml up -d
```

### Переменные окружения

| Переменная | Описание | По умолчанию |
|------------|----------|--------------|
| `DB_HOST` | Хост PostgreSQL | `localhost` |
| `DB_PORT` | Порт PostgreSQL | `5432` |
| `DB_NAME` | Имя БД | `{service}_db` |
| `DB_USER` | Пользователь БД | `postgres` |
| `DB_PASSWORD` | Пароль БД | `postgres` |
| `RABBITMQ_HOST` | Хост RabbitMQ | `localhost` |
| `RABBITMQ_PORT` | Порт RabbitMQ | `5672` |
| `REDIS_HOST` | Хост Redis (sync-svc) | `localhost` |
| `REDIS_PORT` | Порт Redis | `6379` |

## Порты сервисов

| Сервис | Порт | Описание |
|--------|------|----------|
| Gateway | 8080 | Spring Cloud Gateway |
| Clinic | 8081 | REST + AMQP |
| Medication | 8082 | REST + AMQP publisher |
| Sync | 8083 | REST + Redis + AMQP |
| Audit | 8084 | AMQP consumer (без REST) |

## Docker

### Сборка образа сервиса

```bash
docker build -t vetapp/clinic-svc -f apps/clinic-svc/Dockerfile .
docker build -t vetapp/medication-svc -f apps/medication-svc/Dockerfile .
docker build -t vetapp/sync-svc -f apps/sync-svc/Dockerfile .
docker build -t vetapp/audit-svc -f apps/audit-svc/Dockerfile .
docker build -t vetapp/gateway -f apps/gateway/Dockerfile .
```

Каждый Dockerfile использует multi-stage build:
- **Build stage:** `eclipse-temurin:21-jdk-alpine` → `./mvnw package -DskipTests`
- **Runtime stage:** `eclipse-temurin:21-jre-alpine` → `java -jar app.jar`

## CI/CD

GitHub Actions (`.github/workflows/ci-cd.yml`):

| Job | Триггер | Описание |
|-----|---------|----------|
| `build` | push/PR → main, develop | Компиляция, тесты для всех 6 модулей (matrix) |
| `docker` | push → main | Docker Buildx → Docker Hub (`vetapp/<service>:latest` + `:git-sha`) |

## Маршруты Gateway

| Route ID | Predicate | Target | StripPrefix |
|----------|-----------|--------|-------------|
| clinic-svc | `/api/clinic/**` | `localhost:8081` | 2 |
| medication-svc | `/api/medication/**` | `localhost:8082` | 2 |
| sync-svc | `/api/sync/**` | `localhost:8083` | 2 |
| audit-svc | `/api/audit/**` | `localhost:8084` | 2 |
