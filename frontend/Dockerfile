# Stage 1: Build the React app
FROM node:21-alpine AS build

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the application for production
RUN npm run build

# Stage 2: Run the app
FROM node:21-alpine AS production

# Set the working directory
WORKDIR /app

# Copy the build files from the first stage
COPY --from=build /app/build ./build

# Install serve to serve the static files
RUN npm install -g serve

# Expose port 3000
EXPOSE 3000

# Start the application
CMD ["serve", "-s", "build", "-l", "3000"]