FROM ubuntu AS BUILD_STEP

RUN apt-get update
RUN apt-get --force-yes --assume-yes install git maven

RUN mkdir /app
WORKDIR /app

RUN git clone https://github.com/openshift/test-maven-app.git

RUN cd test-maven-app && mvn install


FROM openjdk:8-jdk-alpine

ENV APP_DIR=/tmp
RUN mkdir -p $APP_DIR
WORKDIR $APP_DIR

COPY --from=BUILD_STEP /app/test-maven-app/target/hello.jar $APP_DIR/

EXPOSE 8080

CMD ["java", "-jar", "hello.jar"]
