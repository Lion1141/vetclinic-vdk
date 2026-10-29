# VetApp Monorepo

Монорепозиторий микросервисов для системы ветеринарной клиники.

## Структура проекта

```
vet-app/
├── apps/
│   ├── clinic-svc/        # Сервис управления клиниками
│   ├── medication-svc/    # Сервис управления медикаментами
│   ├── sync-svc/          # Сервис синхронизации данных
│   ├── audit-svc/         # Сервис аудита событий
│   └── gateway/           # API Gateway (Spring Cloud Gateway)
├── packages/
│   └── contracts/         # Общие контракты и DTO
└── pom.xml                # Корневой агрегатор
```

## Технологии

- **Java 21**
- **Spring Boot 3.5.x**
- **Maven** (монорепозиторий с агрегатором)
- **PostgreSQL** — основная БД
- **Flyway** — миграции БД
- **RabbitMQ** — асинхронное взаимодействие
- **Redis** — кэширование и дедупликация (sync-svc)
- **Spring Cloud Gateway** — API Gateway
- **Testcontainers** — интеграционные тесты

## Быстрый старт

### Сборка проекта

```bash
# Собрать все модули
mvn -q compile

# Собрать конкретный сервис
mvn -pl apps/clinic-svc -am package

# Собрать и протестировать
mvn -pl apps/clinic-svc -am verify
```

### Запуск сервисов

Каждый сервис запускается отдельно:

```bash
# Clinic Service
mvn -pl apps/clinic-svc spring-boot:run

# Medication Service
mvn -pl apps/medication-svc spring-boot:run

# Sync Service
mvn -pl apps/sync-svc spring-boot:run

# Audit Service
mvn -pl apps/audit-svc spring-boot:run

# Gateway
mvn -pl apps/gateway spring-boot:run
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

| Сервис | Порт |
|--------|------|
| Gateway | 8080 |
| Clinic | 8081 |
| Medication | 8082 |
| Sync | 8083 |
| Audit | 8084 |

## Docker

### Сборка образа сервиса

```bash
docker build -t vetapp/clinic-svc -f apps/clinic-svc/Dockerfile .
docker build -t vetapp/medication-svc -f apps/medication-svc/Dockerfile .
docker build -t vetapp/sync-svc -f apps/sync-svc/Dockerfile .
docker build -t vetapp/audit-svc -f apps/audit-svc/Dockerfile .
docker build -t vetapp/gateway -f apps/gateway/Dockerfile .
```

## CI/CD

Конвейер GitHub Actions автоматически:
- Собирает проект при push в main/develop
- Запускает тесты для изменённых модулей
- Создает Docker-образы при релизах

## Разработка

### Добавление нового сервиса

1. Скопируйте структуру одного из существующих сервисов в `apps/`
2. Добавьте модуль в корневой `pom.xml`
3. Настройте маршрут в `gateway/src/main/resources/application.yml`

### Генерация DTO из OpenAPI

```bash
# В пакете contracts
openapi-generator-cli generate \
  -i src/main/resources/openapi/clinic-api.yaml \
  -g java \
  -o src/main/java \
  --additional-properties=library=jakarta-ee
```
