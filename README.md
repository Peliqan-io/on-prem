# Deploy Peliqan on-prem

Contact Peliqan to receive credentials, in order to deploy Peliqan in your private cloud or on-prem.

## Table of contents
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Post Installation](#post-installation)

# Prerequisites
- Clone the repo
    ```bash
    git clone https://github.com/Peliqan-io/on-prem.git peliqan-on-prem
    cd peliqan-on-prem
    ```
  

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
  # Generate certificate key
  openssl genrsa -out certificate.key 2048
  
  # Generate certificate signing request, fill the required fields.
  # NOTE : Common Name should be the Domain / IP / Hostname of the server.
  # NOTE : Leave the challenge password empty.
  openssl req -new -sha256 -key certificate.key -out csr.csr
  
  # Generate certificate using the certificate key and certificate signing request.
  openssl req -x509 -sha256 -days 365 -key certificate.key -in csr.csr -out certificate.crt
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
  
  # Example Output:
  # salt=A5F19EC95D22225E
  # key=33EDE25AD6F7FDF6B7CC80573E5BD173 ---> copy this and put in env file
  # iv =930BECC898006DD70E83B7995EE8F1A5
  ```
  - `PUBLIC_INGRESS_HOSTNAME` : Ingress hostname ( default : `localhost` ), replace `localhost` with your Domain / IP / Hostname.

# Installation
- Run the following command to check if all the pre-requests are installed
  ```bash
  ./local.sh check
  ```
- Run the following command to start the Peliqan server
  ```bash
  ./local.sh start
  ```

# Post Installation

- Login to the Peliqan server using the following URL
  ```bash
  # localhost should be replaced with your Domain / IP / Hostname
  https://localhost
  ```
  - Use the following credentials to login to the Peliqan server.
    - Email : `admin@peliqan.io` - ( as per the `.env` file )
    - Password : `Admin&!0` - ( as per the `.env` file )



- Install additional packages in data-app 
  ```bash
  # get name of data-app docker container
  docker ps | grep data-app 
  
  # Replace peliqan-on-prem-data-app-1 with the name of the data-app container
  docker exec peliqan-on-prem-data-app-1 pip install xxx
  
  # NOTE : Any additional packages installed using the above command will be lost when the container is restarted.
  ```

# Maintenance
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