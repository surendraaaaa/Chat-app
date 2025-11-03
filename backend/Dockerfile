########################
# Stage - 1 Build stage#
########################

# base image for building the application
FROM maven:3.9.6-eclipse-temurin-17 AS build

#create workdirectory in the container
WORKDIR /app

# copy package.json to install dependencies
COPY . .

# install dependencies
RUN mvn clean install -DskipTests

# package the application
RUN mvn package -DskipTests



########################################
# Stage 2 Execure the jar file         #
########################################

# use nginx-apline ( small image) as base image
FROM openjdk:17-alpine

# Nginx serves files in location /use/share/nginx/html 
WORKDIR /app

# copy from build stage
COPY --from=build /app/target/*.jar app.jar

#expose port 5000
EXPOSE 5000

# start nignx
CMD ["java", "-jar", "app.jar"]
