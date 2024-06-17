#!/bin/bash

# Print new line
print_new_line() {
  echo ""
}

check_docker_installation() {
  # Check id docker is installed
  echo "#### Checking docker installation"
  if command -v docker &> /dev/null; then
      echo "** Docker installation found"
  else
      echo "** Docker installation not found. Please install docker."
      exit 1
  fi
}

check_docker_compose_installation() {
  # Check if docker-compose is installed
  echo "#### Checking docker-compose installation"
  if command -v docker-compose &> /dev/null; then
      echo "** Docker compose installation found"
  else
      echo "** Docker compose installation not found. Please install docker-compose."
      exit 1
  fi
}

# NOTE ( @akhil ) : nginx can be configured in docker-compose itself,
# So yea, local installation is not necessary
check_nginx_installation() {
  # Check if nginx is installed
  echo "#### Checking nginx installation"
  if command -v nginx &> /dev/null; then
    echo "** Nginx installation found"
  else
    echo "** Nginx installation not found. Please install nginx"
    exit 1
  fi
}

entry_point() {
  # Check all the pre-requests are installed
  check_docker_installation
  print_new_line
  check_docker_compose_installation
  print_new_line
  check_nginx_installation
}

# Start up function
entry_point