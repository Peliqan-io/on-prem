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
  # Check if docker compose is installed
  echo "#### Checking docker compose installation"
  if command -v docker compose &> /dev/null; then
      echo "** Docker compose installation found"
  else
      echo "** Docker compose installation not found. Please install docker compose."
      exit 1
  fi
}

# Check if docker has access to Peliqan's private repository
check_private_repository_access() {
  echo "#### Checking access to Peliqan's private Docker Hub repo"
  # Try pulling a private image
  msg=$(docker pull peliqan/backend:latest 2>&1)
  case "$msg" in
  *"requested access to the resource is denied"*|*"pull access denied"*)
    echo "** Access denied. Please login to Docker Hub using the provided access keys!"
    exit 1
    ;;
  *"manifest unknown"*|*"not found"*)
    echo "** Access denied. Please login to Docker Hub using the provided access keys!"
    exit 1
    ;;
  *"Pulling from"*)
    echo "** Access to private repo is verified.";;
  *)
    echo "** Unknown message: $msg";;
  esac
}

entry_point() {
  # Check all the pre-requests are installed
  check_docker_installation
  print_new_line
  check_docker_compose_installation
  print_new_line

  # Handle user command input
  case $1 in
    "start")
      # Check directory access before starting
      print_new_line
      check_private_repository_access
      print_new_line

      # Start the services
      echo "#### Starting the services"
      print_new_line

      if [ ! -f .env ]
      then
        export $(cat .env | xargs)
      fi
      docker compose up -d
      print_new_line
    ;;
    "down")
      # Stop the services
      echo "#### Stopping the services"
      print_new_line

      docker compose down
      print_new_line
    ;;
    "update")

      # Update the services
      echo "#### Updating the services"
      print_new_line

      docker compose down
      docker compose pull
      docker compose up -d
      print_new_line
    ;;
    "destroy")
      # Destroy the services
      echo "#### Destroying the services"
      print_new_line

      docker compose down
      docker volume prune -f
      print_new_line
    ;;
    *)
      echo -n "Invalid"
    ;;
  esac
}

# Start up function
entry_point "$1"