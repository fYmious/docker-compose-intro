#show link: underline

#set document(
  title: [ЛР4],
)

#let img(imagePath, caption, supplement: [Рисунок]) = {
  align(center)[
    #figure(image(imagePath), caption: caption, supplement: supplement)
  ]
}


#set page(
  paper: "a4",
  numbering: "1",
)

#set par(
  justify: true,
  first-line-indent: (
    amount: 1.25cm,
    all: true,
  ),
  spacing: 0.65em,
)

#set text(
  lang: "ru",
  font: "Times New Roman",
  size: 14pt,
)

#set page(footer: context {
  if counter(page).get().first() > 1 [
    #align(center)[
      #counter(page).display("1")
    ]
  ]
  if counter(page).get().first() == 1 [
    #align(center)[
      Санкт-Петербург \ 2026
    ]
  ]
})

#set page(header: context {
  if counter(page).get().first() == 1 [
    #align(center)[
      *Министерство науки и высшего образования Российской Федерации* \
    ]
  ]
})

#show raw: set text(font: "Consolas")
#show raw.where(block: false): box.with(
  fill: luma(240),
  inset: (x: 3pt, y: 0pt),
  outset: (y: 3pt),
  radius: 2pt,
)

#show raw.where(block: true): block.with(
  fill: luma(240),
  inset: 10pt,
  radius: 4pt,
)

// title

#align(center)[
  ФЕДЕРАЛЬНОЕ ГОСУДАРСТВЕННОЕ АВТОНОМНОЕ ОБРАЗОВАТЕЛЬНОЕ УЧРЕЖДЕНИЕ ВЫСШЕГО ОБРАЗОВАНИЯ
]

#align(center)[
  #text(size: 12pt)[
    \ *НАЦИОНАЛЬНЫЙ ИССЛЕДОВАТЕЛЬСКИЙ УНИВЕРСИТЕТ ИТМО*
  ]
]

#align(center)[
  \ *ITMO University*
]


#for _ in range(5) { linebreak() }

#align(center)[*ЛАБОРАТОРНАЯ 4*]

#table(
  stroke: white,
  columns: 1,
  inset: 10pt,

  [*По дисциплине* Контейнеризация и оркестрация приложений],
  [*Тема работы* Docker Compose: оркестрация сервисов с Redis-кэшированием],
  [*Обучающийся* Дощенников Никита Андреевич],
  [*Факультет* Прикладной информатики],
  [*Группа* К3321],
  [*Направление подготовки* 11.03.02 Инфокоммуникационные технологии и системы связи],
  [*Образовательная программа* Программирование в инфокоммуникационных системах],
  [],
)

#table(
  stroke: white,
  columns: 4,
  inset: 10pt,

  table.cell(align: top)[*Обучающийся*],

  table(
    columns: 1,
    inset: 2pt,
    stroke: white,
    table.cell(
      align: top + center,
    )[#text(size: 10pt, fill: white)[.]],
    [#line(length: 100pt)],
  ),

  table(
    columns: 1,
    inset: 2pt,
    stroke: white,
    table.cell(
      align: top + center,
    )[#text(size: 11pt, fill: white)[.]],
    [#line(length: 100pt)],
  ),

  table(
    columns: 1,
    inset: 2pt,
    stroke: white,
    table.cell(
      align: top + center,
    )[#text(size: 10pt)[Дощенников Н.А.]],
    [#line(length: 100pt)],
  ),

  [],
  table.cell(align: center)[#text(size: 10pt)[(дата)]],
  table.cell(align: center)[#text(size: 10pt)[(подпись)]],
  table.cell(align: center)[#text(size: 10pt)[(Ф.И.О.)]],

  table.cell(align: top)[*Руководитель*],

  table(
    columns: 1,
    inset: 2pt,
    stroke: white,
    table.cell(
      align: top + center,
    )[#text(size: 10pt, fill: white)[.]],
    [#line(length: 100pt)],
  ),

  table(
    columns: 1,
    inset: 2pt,
    stroke: white,
    table.cell(
      align: top + center,
    )[#text(size: 11pt, fill: white)[.]],
    [#line(length: 100pt)],
  ),

  table(
    columns: 1,
    inset: 2pt,
    stroke: white,
    table.cell(
      align: top + center,
    )[#text(size: 10pt)[Аминов Н.С.]],
    [#line(length: 100pt)],
  ),

  [],
  table.cell(align: center)[#text(size: 10pt)[(дата)]],
  table.cell(align: center)[#text(size: 10pt)[(подпись)]],
  table.cell(align: center)[#text(size: 10pt)[(Ф.И.О.)]],
)


#pagebreak()

#outline(title: [Содержание])

#pagebreak()
= Персональные параметры

#align(center)[
  #figure(
    table(
      columns: 2,
      inset: 10pt,
      align: horizon + center,
      fill: (x, y) => if (y == 0) { gray },
      table.header([*Параметр*], [*Значение*]),
      [Номер ИСУ], [_465797_],
      [Персональный порт (app)], [_#(5430 + 97)_],
      [Персональный порт (Redis)], [_#(6370 + 97)_],
      [Персональный префикс], [_doschennikov_],
      [Секретный ключ], [_secret97doschennikov_],
      [Имя базы данных], [_doschennikov97_],
    ),
    caption: [Персональные параметры],
  )
]

#pagebreak()
= Этап 1. Подготовка проекта для Docker Compose

== Задание 1.1

Я создал файл `.env` с персональными переменными:

```sh
APP_OWNER=doschennikov
APP_SECRET=secret97doschennikov
APP_PORT=5527
POSTGRES_HOST=db
POSTGRES_PORT=5432
POSTGRES_USER=user_465797
POSTGRES_PASSWORD=pgpass_465797
POSTGRES_DB=assistant_465797
PG_PORT=5527
REDIS_PORT=6467
CACHE_TTL=120
```

== Задание 1.2

Я создал `docker-compose.yml` с сервисами app и db:

```yaml
# version: '3.8'
services:
  db:
    container_name: doschennikov-postgres
    image: postgres:15
    networks:
      - doschennikov-backend
    env_file:
      - .env
  app:
    build: .
    container_name: doschennikov-assistant
    networks:
      - doschennikov-backend
    depends_on:
      db:
        condition: service_healthy
    env_file:
      - .env
    ports:
      - "5527:5527"

volumes:
  doschennikov-pgdata:

networks: doschennikov-backend:
    driver: bridge
    name: doschennikov-backend
```

== Задание 1.3

Затем проверил базовый запуск:

```sh
docker-compose up -d --build
```
#img("assets/1.png", [Проверка базового запуска: сборка])

```
docker-compose ps
```
#img("assets/2.png", [Проверка базового запуска: контейнеры])

```sh
docker-compose logs app
```
#img("assets/3.png", [Проверка базового запуска: логи `app`])

```sh
docker-compose logs db
```
#img("assets/4.png", [Проверка базового запуска: логи `db`])

Затем я убедился, что оба контейнера запущены и приложение отвечает:

```sh
curl http://localhost:5527/
curl http://localhost:5527/health
```

#img("assets/5.png", [Проверка работоспособности контейнеров])

#pagebreak()
= Этап 2. Добавление Redis для кеширования погоды

== Задание 2.1

Я добавил новый сервис `redis` в `docker-compose.yml`, при этом приложение (`app`) зависит от Redis.

```sh
redis:
  image: redis:7-alpine
  container_name: doschennikov-redis
  ports:
    - "${REDIS_PORT}:6379"
  networks:
    - doschennikov-backend
  healthcheck:
    test: ["CMD", "redis-cli", "ping"]
    interval: 5s
    timeout: 3s
    retries: 5
```

Также я обновил секцию `depends_on` у сервиса `app`, добавив зависимость от `redis`:

```sh
services:
  app:
    build: .
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_healthy
```

== Задание 2.2 ???

== Задание 2.3

Я убедился, что в `main.py` интегрирован Redis. // Верьте мне!

#pagebreak()
= Этап 3. Запуск и проверка полного стека

== Задание 3.1

Я пересобрал и запустил все сервисы:

```sh
docker-compose down -v
docker-compose up -d --build
```

#img("assets/6.png", [Сборка сервисов])

== Задание 3.2

Я проверил порядок запуска:

```sh
docker-compose logs --tail=30
docker-compose logs app | head -5
```

#img("assets/7.png", [Порядок запуска (1)])
#img("assets/8.png", [Порядок запуска (2)])

== Задание 3.3

Затем я проверил работу кеширования:

```sh
curl http://localhost:5527/weather/Moscow
curl http://localhost:5527/weather/Moscow
```

#img("assets/9.png", [Данные из API и кэша])

Затем я проверил статистику кэша:

```sh
curl http://localhost:5527/cache/stats
```

#img("assets/10.png", [Статистика кэша])

Я проверил данные напрямую в Redis:

```sh
docker exec doschennikov-redis redis-cli KEYS "weather:*"
docker exec doschennikov-redis redis-cli TTL weather:doschennikov:moscow
```

#img("assets/11.png", [Данные в Redis])

== Задание 3.4

Я посмотрел список сетей:

```sh
docker network ls --filter "name=doschennikov"
```

#img("assets/12.png", [Список сетей])

```sh
docker network inspect doschennikov-backend
```

#img("assets/13.png", [Детали сети])

Я посмотрел список томов:

```sh
docker volume ls --filter "name=doschennikov"
```

#img("assets/14.png", [Список томов])

#pagebreak()
= Этап 4. Масштабирование сервиса

== Задание 4.1

Я создал отдельный `docker-compose.scale.yml`. Для масштабирования я убрал `container_name` у `app` и изменил порт на диапазон:

```yml
# docker-compose.scale.yml
# version: '3.8'

services:
  db:
    image: postgres:15
    container_name: doschennikov-postgres
    environment:
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      POSTGRES_DB: ${POSTGRES_DB}
    volumes:
      - doschennikov-pgdata:/var/lib/postgresql/data
    networks:
      - doschennikov-backend
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER}"]
      interval: 5s
      timeout: 3s
      retries: 5

  redis:
    image: redis:7-alpine
    container_name: doschennikov-redis
    networks:
      - doschennikov-backend
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 5s
      timeout: 3s
      retries: 5

  app:
    build: .
    ports:
      - "5527"
    environment:
      APP_OWNER: ${APP_OWNER}
      APP_SECRET: ${APP_SECRET}
      DATABASE_URL:
        postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@db:5432/${POSTGRES_DB}
      REDIS_URL: redis://redis:6379/0
      CACHE_TTL: ${CACHE_TTL}
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_healthy
    networks:
      - doschennikov-backend

volumes:
  doschennikov-pgdata:

networks:
  doschennikov-backend:
  driver: bridge
```

== Задание 4.2

Я запустил масштабирование. Для этого я остановил текущие контейнеры:

```sh
docker-compose down
```

#img("assets/15.png", [Остановка контейнеров])

Затем запустил с 3 экземпляра `app`:

```sh
docker-compose -f docker-compose.scale.yml up -d --build --scale app=3
```

#img("assets/16.png", [Запуск с масштабированием])

Я также проверил, что запустилось 3 экземпляра:

```sh
docker-compose -f docker-compose.scale.yml ps
```

#img("assets/17.png", [Проверка запуска])

== Задание 4.3

Я проверил работу масштабированных экземпляров. Для этого я узнал назначенные порты:

```sh
docker-compose -f docker-compose.scale.yml ps app
```

#img("assets/18.png", [Назначенные порты])

Затем я обратился к каждому экземпляру:

```sh
curl http://localhost:32771/health
curl http://localhost:32772/health
curl http://localhost:32773/health
```

#img("assets/19.png", [Healthcheck])

Затем я проверил, что кэш Redis общий для всех экземпляров:

```sh
curl http://localhost:32771/weather/London
curl http://localhost:32772/weather/London
curl http://localhost:32773/cache/stats
```

#img("assets/20.png", [Общий кэш для нескольких экземпляров])

== Задание 4.4

Я вернулся к основной конфигурации. Для этого я остановил масштабированные контейнеры:

```sh
docker-compose -f docker-compose.scale.yml down
```

#img("assets/21.png", [Остановка контейнеров])

А затем запустил основную конфигурацию:

```sh
docker-compose up -d
```

#img("assets/22.png", [Запуск основной конфигурации])

#pagebreak()
= Этап 5. Финальный артефакт

== Задание 5.1

Я сформировал финальный артефакт:

```sh
echo "========================================" && \
echo "ЛР4 завершена: $(date '+%d.%m.%Y %H:%M:%S')" && \
echo "Студент: $(whoami)@$(hostname)" && \
echo "========================================" && \
echo "" && \
echo "Docker Compose сервисы:" && \
docker-compose ps && \
echo "" && \
echo "Сети:" && \
docker network ls --filter "name=doschennikov" && \
echo "" && \
echo "Volumes:" && \
docker volume ls --filter "name=doschennikov" && \
echo "" && \
echo "Кэш Redis:" && \
docker exec doschennikov-redis redis-cli KEYS "weather:*" && \
echo "" && \
echo "Погода (из кэша):" && \
curl -s http://localhost:5527/cache/stats | python3 -m json.tool
```

#img("assets/23.png", [Финальный артефакт])

#pagebreak()
= Приложение

`.dockerignore`:

```exclude
__pycache__/
*.pyc
*.pyo
.git
.gitignore
.venv/
venv/
.env
*.log
Dockerfile*
README.md
```

#pagebreak()
`.env`:

```env
APP_OWNER=doschennikov
APP_SECRET=secret97doschennikov
APP_PORT=5527
POSTGRES_HOST=db
POSTGRES_PORT=5432
POSTGRES_USER=user_465797
POSTGRES_PASSWORD=pgpass_465797
POSTGRES_DB=assistant_465797
PG_PORT=5527
REDIS_PORT=6467
CACHE_TTL=120
```

#pagebreak()
`docker-compose.scale.yml`:

```yml
services:
  db:
    image: postgres:15
    container_name: doschennikov-postgres
    environment:
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      POSTGRES_DB: ${POSTGRES_DB}
    volumes:
      - doschennikov-pgdata:/var/lib/postgresql/data
    networks:
        - doschennikov-backend
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER}"]
      interval: 5s
      timeout: 3s
      retries: 5

  redis:
    image: redis:7-alpine
    container_name: doschennikov-redis
    networks:
        - doschennikov-backend
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 5s
      timeout: 3s
      retries: 5

  app:
    build: .
    ports:
      - "5527"
    environment:
      APP_OWNER: ${APP_OWNER}
      APP_SECRET: ${APP_SECRET}
      DATABASE_URL:
        postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@db:5432/${POSTGRES_DB}
      REDIS_URL: redis://redis:6379/0
      CACHE_TTL: ${CACHE_TTL}
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_healthy
    networks:
      - doschennikov-backend

volumes:
  doschennikov-pgdata:

networks:
  doschennikov-backend:
    driver: bridge
```

#pagebreak()
`docker-compose.yml`:

```yml
services:
  db:
    container_name: doschennikov-postgres
    image: postgres:15
    networks:
      - doschennikov-backend
    env_file:
      - .env
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U $${POSTGRES_USER} -d $${POSTGRES_DB}"]
      interval: 5s
      timeout: 5s
      retries: 10
      start_period: 10s
    volumes:
      - doschennikov-pgdata:/var/lib/postgresql/data

  app:
    build: .
    container_name: doschennikov-assist
    networks:
      - doschennikov-backend
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_healthy
    env_file:
      - .env
    environment:
      REDIS_URL: redis://redis:6379/0
    ports:
      - "5527:5527"

  redis:
    image: redis:7-alpine
    container_name: doschennikov-redis
    ports:
      - "${REDIS_PORT}:6379"
    networks:
      - doschennikov-backend
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 5s
      timeout: 3s
      retries: 5

volumes:
  doschennikov-pgdata:

networks:
  doschennikov-backend:
    driver: bridge
    name: doschennikov-backend
```

#pagebreak()
`Dockerfile`:

```Dockerfile
FROM python:3.11 AS builder

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

FROM python:3.11-slim

LABEL maintainer="doschennikov@lab.local"
LABEL version="1.0"

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends curl \
  && rm -rf /var/lib/apt/lists/*

COPY --from=builder /install /usr/local

COPY app/ ./app/

EXPOSE 5527

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "5527"]

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:5527/health || exit 1
```
