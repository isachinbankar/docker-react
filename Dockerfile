# node:alpine named as "builder" so we can have reference
FROM node:alpine as builder 
# selected work directory
WORKDIR "/app"
# copy only package.json, because we need only package.json
# for npm install
COPY package*.json ./
# installing dependencies
RUN npm install
# copy remaining files. Source Code files.
# we copied source code files after installing depedecies
# because, if we make any changes in source code
# build will not need to start again from second step
# rebuild will start from below steps
COPY . .
# build production image
RUN npm build

# nginx is used for production server
FROM nginx
#Map port 80 to 80
EXPOSE 80
# copy only build folder which we required to nginx.
# To run production application we dont need other folders
COPY --from=builder /app/build /usr/share/nginx/html 
