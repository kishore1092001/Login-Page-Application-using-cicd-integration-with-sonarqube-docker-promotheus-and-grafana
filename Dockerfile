# Use the official Nginx image as the base
FROM nginx:latest

# Remove the default Nginx page
RUN rm /usr/share/nginx/html/*

# Copy the login page HTML file into the Nginx web directory
COPY index.html /usr/share/nginx/html/

# Expose port 80 for web traffic
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]

