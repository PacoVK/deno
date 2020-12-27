FROM ubuntu as base

ARG FUNCTION_DIR="/app"

RUN apt update \
    && apt install -y curl unzip

RUN curl -fsSL https://deno.land/x/install/install.sh | sh

ENV DENO_INSTALL="/root/.deno"

ENV PATH="$DENO_INSTALL/bin:$PATH"

RUN mkdir -p ${FUNCTION_DIR}

WORKDIR ${FUNCTION_DIR}

FROM base as builder

COPY application .

RUN deno compile --unstable server.ts -o oakServer

FROM ubuntu

COPY --from=builder app/oakServer /bin/oakServer

ENTRYPOINT ["oakServer"]
