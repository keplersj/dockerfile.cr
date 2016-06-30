FROM debian:jessie
MAINTAINER Nikolay Yurin <yurinnick@outlook.com>

RUN apt-get update && \
    apt-get install -y nginx

RUN rm -rf /var/lib/apt/lists/* && \
    chown -R www-data:www-data /var/lib/nginx

VOLUME /var/www/html
WORKDIR /etc/nginx
COPY site-example.conf /etc/nginx/sites-available/site-example.conf
COPY index.html.tmpl /var/www/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
