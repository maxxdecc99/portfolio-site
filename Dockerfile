FROM nginxinc/nginx-unprivileged:alpine

USER root
COPY index.html style.css /usr/share/nginx/html/
RUN chmod 644 /usr/share/nginx/html/index.html /usr/share/nginx/html/style.css
USER 101

EXPOSE 8080
