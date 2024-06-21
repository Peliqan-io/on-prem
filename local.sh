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
  msg=$(docker pull peliqan/local-ingress:latest 2>&1)
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

# Check if the certificate and key files are present
check_certificate_files() {
  echo "#### Checking certificate files"
  if [ -f ./certificate.crt ] && [ -f ./certificate.key ]; then
    echo "** Certificate files found"
  else
    echo "** Certificate files not found. Please provide the certificate files."
    exit 1
  fi
}


entry_point() {
  # Handle user command input
  case $1 in
    "pre-requests-check")
      # Check all the pre-requests are installed
      check_docker_installation
      print_new_line
      check_docker_compose_installation
      print_new_line
      check_private_repository_access
      print_new_line
      check_certificate_files
      print_new_line
    ;;
    "start")
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
      # Ask for confirmation
      echo "#### WARNING: This will destroy the services and remove all the data."
      echo "#### WARNING: This action removes all the dangling docker volumes."
      echo "#### Are you sure you want to destroy the services? (y/n)"
      read -r response
      if [ "$response" != "y" ]
      then
        echo "#### Exiting"
        exit 1
      fi
      # Destroy the services
      echo "#### Destroying the services"
      print_new_line

      docker compose down
      docker volume rm $(docker volume ls -q --filter dangling=true)
      print_new_line
    ;;
    *)
      echo -n "Invalid"
    ;;
  esac
}

# Start up function
entry_point "$1"