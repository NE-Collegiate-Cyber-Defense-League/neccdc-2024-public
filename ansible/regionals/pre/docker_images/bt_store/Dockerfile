FROM nginx:latest

WORKDIR /usr/share/nginx/html

COPY index.html .
COPY styles.css .

COPY favicon-16x16.png .
COPY favicon-32x32.png .

# ^ All the layers

EXPOSE 80
