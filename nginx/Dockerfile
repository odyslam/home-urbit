FROM arm64v8/nginx
RUN apt-get update && apt-get install nano
COPY ./nginx.conf /etc/nginx/nginx.conf
RUN mkdir /logs
