# Use the official Node.js LTS image
FROM node:18

# Create app directory
WORKDIR /usr/src/app

# Copy source code
COPY server.js .

# Expose the required port
EXPOSE 8081

# Start the Node.js app
CMD [ "node", "server.js" ]
