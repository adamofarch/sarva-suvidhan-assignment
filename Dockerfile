FROM python:3.12-slim

ARG BUILDKIT_INLINE_CACHE=1

ENV PYTHONUNBUFFERED=1

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  apt-get update && apt-get install -y \
  build-essential \
  gir1.2-gdkpixbuf-2.0 \
  gir1.2-pango-1.0 \
  libgirepository-1.0-1 \
  python3-gi \
  libcairo2 \
  libffi-dev \
  libgdk-pixbuf2.0-0 \
  libpango-1.0-0 \
  libpq-dev \
  wget \
  curl \
  git

WORKDIR /app

COPY requirements.txt .

RUN --mount=type=cache,target=/root/.cache/pip,sharing=locked \
  pip install --no-cache-dir -r requirements.txt

COPY . .

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 5002
ENTRYPOINT ["/entrypoint.sh"]


