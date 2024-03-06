FROM alpine:latest AS prep
RUN wget https://github.com/pocketbase/pocketbase/releases/download/v0.22.3/pocketbase_0.22.3_linux_amd64.zip
RUN apk update && apk add unzip
RUN unzip /pocketbase_0.22.3_linux_amd64.zip

FROM alpine:latest as run
LABEL org.opencontainers.image.source https://github.com/eulentier161/dockerbase
RUN addgroup --system --gid 1001 pocketbase
RUN adduser --system --uid 1001 pocketbase
WORKDIR /pocketbase
RUN chown pocketbase:pocketbase /pocketbase
COPY --from=prep --chown=pocketbase:pocketbase /pocketbase pocketbase
USER pocketbase:pocketbase
RUN mkdir pb_data
EXPOSE 8090
CMD [ "./pocketbase", "serve", "--http", "0.0.0.0:8090" ]
