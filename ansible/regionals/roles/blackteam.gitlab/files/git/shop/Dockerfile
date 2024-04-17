# Use an official Nginx runtime as a parent image
FROM --platform=linux/amd64 nginx:latest

# Set the working directory to the default Nginx public folder
WORKDIR /usr/share/nginx/html

# Copy the HTML, CSS, and JS files into the container at /usr/share/nginx/html
COPY src/* .

# Expose port 80 to allow external access
EXPOSE 80
