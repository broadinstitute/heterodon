FROM openjdk:8
ENV PATH="/jython/bin:${PATH}"
WORKDIR /heterodon/
COPY . .
RUN ./build.sh
