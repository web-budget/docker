ARG JAVA_VERSION

FROM gradle:7-alpine AS gradle-build

RUN apk update && apk --no-cache add git

WORKDIR /
RUN git clone https://github.com/web-budget/back-end.git app
WORKDIR /app

RUN gradle --no-daemon clean bootjar -x test -x detekt

FROM eclipse-temurin:${JAVA_VERSION}-jdk AS jdk

RUN mkdir -p /build
WORKDIR /build

FROM jdk AS jar-extractor

ARG JAVA_VERSION

COPY entrypoint.sh entrypoint.sh
COPY --from=gradle-build /app/build/libs/back-end.jar app.jar

RUN java -Djarmode=layertools -jar app.jar extract

RUN jdeps \
    --multi-release ${JAVA_VERSION} \
    --class-path 'spring-boot-loader/org/*:snapshot-dependencies/BOOT-INF/lib/*:dependencies/BOOT-INF/lib/*' \
    --recursive \
    --ignore-missing-deps \
    --print-module-deps \
    app.jar \
    > java-modules.txt

RUN sed -i ' 1 s/.*/&,jdk.crypto.ec,jdk.management/' java-modules.txt

FROM jdk AS jre-builder

COPY --from=jar-extractor /build/java-modules.txt .

RUN jlink \
    --verbose \
    --add-modules $(cat java-modules.txt) \
    --compress 2 \
    --strip-java-debug-attributes \
    --no-header-files \
    --no-man-pages \
    --output "/build/opt/java-minimal"

FROM debian:stable-slim AS package

LABEL maintainer="Arthur Gregorio"
LABEL contact="contato@consusoft.com.br"

ENV JAVA_HOME="/opt/java-minimal"
ENV PATH="$PATH:$JAVA_HOME/bin"

RUN mkdir -p /workspace/lib
RUN mkdir -p /workspace/log

VOLUME ["/workspace/log"]

WORKDIR /workspace/lib

RUN apt -y update && \
    apt -y install curl && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=jar-extractor /build/entrypoint.sh /workspace
COPY --from=jre-builder /build/opt/java-minimal $JAVA_HOME

COPY --from=jar-extractor /build/dependencies/ /workspace/lib
COPY --from=jar-extractor /build/spring-boot-loader/ /workspace/lib
COPY --from=jar-extractor /build/snapshot-dependencies/ /workspace/lib
COPY --from=jar-extractor /build/application/ /workspace/lib

ENTRYPOINT ["sh", "/workspace/entrypoint.sh"]
