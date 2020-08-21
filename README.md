# EMPW Backend API

This is the backend part of EMPW.

## What is EMPW?

Find out at [EMPW's website](https://empw.netlify.app/).

## Run locally

You can install each piece of the required software independently. Or simply have Docker do it for you. You need to have [Docker](https://docs.docker.com/get-docker/) and [docker compose](https://docs.docker.com/compose/install/) installed.

Clone the repo

```shell
git clone https://github.com/empw-org/api.git empw-api
cd empw-api
```

make a copy of `example.env` to `.env` and set the required environment variables

```shell
cp example.env .env
```

Get everything up and running

```shell
docker-compose up
```

## Architecture

<div align='center'>

  ![backend architecture](./images/backend.svg)

</div>

## 3rd parties

EMPW wouldn't be possible without:

<div align='center'>
  <img src="./images/twilio.svg" width='200px'/>  
  <img src="./images/sendgrid.svg" width='200px'/>  
  <img src="./images/cloudinary.svg" width='200px'/>  
</div>
