# Account Manager API
A simple Sinatra API to create accounts, deposit funds, get balances and perform withdrawals and transfers. It
uses Postgres in both local and staging environments

The API has no authentication thus far.
## How to run locally
```
docker-compose up
```
and wait for the server to be available. To get started, create your first account
## Check server functionality
The root addresses should return confirmation of functionality
```
curl --location --request GET 'localhost:9292'
curl --location --request GET 'https://ebanx-account-manager.herokuapp.com/'
```
It should return confirmation of the server working
## How to run the tests
At the project folder:
```
docker-compose exec api bash # for entering the container bash
rspec spec # to run all tests
rspec <relative_path_to_file> # to run a specific test
```
Should return confirmation of the server working

sequel -m db/migrations postgres://ebanx_user:ebanx_pw@db:5432/wallet_manager_db