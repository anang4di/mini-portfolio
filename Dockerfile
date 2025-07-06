FROM nginx:alpine

RUN addgroup --system --gid 1001 webapp \
    && adduser --system --uid 1001 --ingroup webapp apprunner

RUN rm -rf /usr/share/nginx/html/*

COPY index.html /usr/share/nginx/html/
COPY assets/ /usr/share/nginx/html/assets/

RUN chown -R apprunner:webapp /usr/share/nginx/html \
    && chown -R apprunner:webapp /var/cache/nginx \
    && chown -R apprunner:webapp /var/run \
    && chown -R apprunner:webapp /etc/nginx

USER apprunner

EXPOSE 80
