FROM nginxinc/nginx-unprivileged:alpine
COPY --chmod=644 index.html style.css /usr/share/nginx/html/
EXPOSE 8080
