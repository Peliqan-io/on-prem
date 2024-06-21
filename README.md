# Deploy Peliqan on-prem

Contact Peliqan to receive credentials, in order to deploy Peliqan in your private cloud or on-prem.

## Table of contents
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Post Installation](#post-installation)

# Prerequisites
- Docker
  - Installation docs : `https://docs.docker.com/engine/install/`
  

- Docker-compose
  - Installation docs : `https://docs.docker.com/compose/install/`
  

- Docker login
  - Run the following command to login to Docker to access the Peliqan images. Enter the passkey when prompted.
  ```bash
  docker login -u peliqan
  ```

- Certificate files
  - If you have a certificate file, you can use it to set up SSL.
  - If you don't have a certificate file, you can generate self-singed certificate using the following command.
  ```bash
  openssl req -x509 -newkey rsa:4096 -keyout certificate.key -out certificate.crt -days 365
  ```


- Configure Peliqan server environment variables.
  - Create `.env` by making a copy of `.env.example` file.
  ```bash
  cp .env.example .env
  ```
  

- Update the following important environment variables in the `.env` file.

  - `SECRET_KEY` : Secret key for the Peliqan server, it should be a random string ( 64 bytes - optimal ).
  - `DATABASE_USER` : Database user ( default : `peliqan` ).
  - `DATABASE_NAME` : Database name ( default : `peliqan` ).
  - `ADMIN_EMAIL` : Admin email ( default : `admin@peliqan.io` ), root superuser email.
  - `ADMIN_PASSWORD` : Admin password ( default : `admin` ), root superuser password.
  - `DATABASE_PASSWORD` : Database user password.
  - `REDIS_PASSWORD` : Redis server password.
  - `PUBLIC_BACKEND_URL` : Backend URL ( default : `https://localhost` ), replace `localhost` with your Domain / IP / Hostname.
  - `PUBLIC_WEB_FRONTEND_URL` : Web frontend URL ( default : `https://localhost` ), replace `localhost` with your Domain / IP / Hostname.
  - `PUBLIC_API_ENDPOINTS_BASE_URL` : API endpoints base URL ( default : `https://localhost` ), replace `localhost` with your Domain / IP / Hostname.
  - `EMAIL_VERIFY_SECRET_KEY` : Email verify secret key, it should be a random string ( 64 bytes - optimal ).
  - `PELIQAN_WAREHOUSE_HOST` : Warehouse host ( default : `localhost` ), replace `localhost` with your Domain / IP / Hostname.
  - `EXTRA_ALLOWED_HOSTS` : Extra allowed hosts. Add your Domain / IP / Hostname as comma seperated list ( for example : `"example.com,example.org"` ).
  - `SINGER_POSTGRES_TARGET_PASSWORD` : Set the password for the Singer pipelines Postgres target.
  - `OAUTH_SECRET_KEY` : OAuth secret key, it should be a random string ( 64 bytes - optimal ).
  - `PUBLIC_BACKOFFICE_URL` : Backoffice URL ( default : `https://localhost/backoffice` ), replace `localhost` with your Domain / IP / Hostname.
  - `AES_SECRET_KEY` : Expecting 128 bits key ( 16 bytes ) for AES encryption. Generate key using the following command.
  ```bash
  openssl enc -aes-128-cbc -k secret -P -md sha1
  ```
  - `PUBLIC_INGRESS_HOSTNAME` : Ingress hostname ( default : `localhost` ), replace `localhost` with your Domain / IP / Hostname.

# Installation
- Run the following command to check if all the pre-requests are installed
  ```bash
  ./local.sh pre-requests-check
  ```
- Run the following command to start the Peliqan server
  ```bash
  ./local.sh start
  ```
- Run the following command to stop the Peliqan server
  ```bash
  ./local.sh down
  ```
- Run the following command to update all images to the latest release
  ```bash
  ./local.sh update
  ```
- Run the following command to destroy the Peliqan server
  ```bash
  ./local.sh destroy
  ```

# Post Installation

## Adding Postgres connector
- Open the browser and navigate to the `PUBLIC_BACKOFFICE_URL` to access the Peliqan server backoffice.
- Login to the backoffice with the admin credentials.
- Go to `Connectors` -> `Create Connector` to create a new connector. And fill the following fields.
  - `Connector Name` : `Postgres`
  - `Connector Type` : `postgres`
- Click on the `Edit Json` button to edit the connector configuration.
- Copy and paste the contents of `postgres.json` to the editor and click on the `Update` button.
