FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*

COPY index.html /usr/share/nginx/html/
COPY assets/ /usr/share/nginx/html/assets/

RUN chown -R nginx:nginx /usr/share/nginx/html

USER nginx

EXPOSE 80
