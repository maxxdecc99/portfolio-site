FROM nginxinc/nginx-unprivileged:alpine

USER root
COPY index.html style.css /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/conf.d/default.conf
RUN chmod 644 /usr/share/nginx/html/index.html /usr/share/nginx/html/style.css /etc/nginx/conf.d/default.conf
USER 101

EXPOSE 8080
