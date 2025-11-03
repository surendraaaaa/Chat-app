########################
# Stage - 1 Build stage#
########################

# base image for building the application
FROM node:18 AS build

#create workdirectory in the container
WORKDIR /app

# copy package.json to install dependencies
COPY package*.json ./

# install dependencies
RUN npm install 

# copy source code
COPY . .

# build application
RUN npm run build

########################################
# Stage 2 Serve application with Nginx #
########################################

# use nginx-apline ( small image) as base image
FROM nginx:stable-alpine

# Nginx serves files in location /use/share/nginx/html 
WORKDIR /usr/share/nginx/html

# remove default configuration
RUN rm -rf ./*

# copy from build stage
COPY --from=build /app/build/ .

# serve with nginx
COPY ./nginx/nginx.conf /etc/nginx/conf.d/default.conf

#expose port 80
EXPOSE 80

# start nignx
CMD ["nginx", "-g", "daemon off;"]



 