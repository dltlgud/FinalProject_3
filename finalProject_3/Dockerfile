FROM eclipse-temurin:17-jdk
WORKDIR /app
COPY build/libs/finalProject_3-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 9080
ENV JAVA_OPTS="-Xmx512m -Xms256m"
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
