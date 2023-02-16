# README
![Mighty MarketPlace Logo](https://raw.github.com/mkamien1993/mighty/main/mighty.jpeg)

**Mighty** is a backend API for a single-page application like "Opensea" (NFT Marketplace). The API has 3 endpoints:
- **Mint (create) an NFT**
- **Buy NFT**
- **List all minted NFTs**

## Table of Contents

- [Usage](#usage)
  - [How to execute the app](#how-to-execute-the-app)
  - [How to run the tests](#how-to-run-the-tests)
- [Data models](#data-models)  
- [Endpoints](#endpoints)
- [Postman](#postman)
- [Used Gems](#used-gems)
- [Database](#database)

## Usage

## How to execute the app

1) First of all, you need to have Docker installed.
2) You need to decompress the `web_backend_test_exercise.zip` file.
3) You need to enter to /mighty directory and run the following command inside:
```ruby
docker-compose up
```
This will run the full application locally. The server should be listening on:
```ruby
http://0.0.0.0:3000
```

## How to run the tests

Once you have the app running, you should run two commands:
1) From the root of the project (/mighty):
```
docker exec -it mighty_web_1 bash
```
2) Once inside the container:
```
bundle exec rspec
```

If everything goes well, you should see someling like this:
```
..................................

Finished in 1.47 seconds (files took 3.13 seconds to load)
34 examples, 0 failures
```

## Data Models
There are only two models in the application:
1) User (all users are created with balance = 100)
```
User
- id: integer
- balance: float
- created_at: datetime
- updated_at: datetime
```
When you run the app ten users are created. If you want to create a new one just go to the rails console `bundle exec rails c` (inside the container) and run `User.create!`


2) NFT
```
NFT
- id: integer
- description: string
- owner_id: integer
- creators_ids: []integer
- created_at: datetime
- updated_at: datetime
- image: ActiveStorage::Attached::One
```
- Description, owner_id and image are mandatory attributes.
- When an NFT is created, the owner_id is automatically added to the creators_ids array (also called `co_creators`).


## Endpoints

To see the Swagger documentation, once you have the app running, you should run two commands:
1) From the root of the project (/mighty):
```
docker exec -it mighty_web_1 bash
```
2) Once inside the container:
```
bundle exec rake rswag:specs:swaggerize
```
This will generate the `/mighty/swagger/v1/swagger.yaml` file. 

Once this file is generated you can go to `http://localhost:3000/api-docs/index.html` and you will see the endpoints documentation. 

## Postman

There is a file in the root of the directory call `mighty_postman_collection.json`. You can import that collection into Postman and you will have the three endpoints there to try them.

## Used Gems
- [`Pagy`](https://github.com/ddnexus/pagy): Used for pagination. 
- [`Rswag`](https://github.com/rswag/rswag): Used to generate Swagger documentation.
- [`Shoulda-Matchers`](https://github.com/thoughtbot/shoulda-matchers): Used to test.

## Database
The database selected is Postgres and the version is `15.2`

