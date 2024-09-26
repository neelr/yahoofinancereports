# Use an official OpenJDK runtime as a parent image
FROM openjdk:11-jre-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the current directory contents into the container at /usr/src/app
COPY . .

# Compile the Java files
RUN javac *.java

# Install cron
RUN apt-get update && apt-get install -y cron

# Add crontab file in the cron directory
ADD crontab /etc/cron.d/yahoo-finance-cron

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/yahoo-finance-cron

# Apply cron job
RUN crontab /etc/cron.d/yahoo-finance-cron

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Run the command on container startup
CMD cron && tail -f /var/log/cron.log
