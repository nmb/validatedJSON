# validatedJSON
Web app for structured JSON data.

## Features
* add JSON schemas via file upload
* create JSON objects from forms based on schemas
* edit, copy, share JSON objects
* API access using tokens

## Technical information
* Web app based on the [sinatra](http://sinatrarb.com/) framework.
* Data stored in [mongodb](https://www.mongodb.com/).
* HTML form generation using [json-editor](https://github.com/json-editor/json-editor).
* JSON display by [renderjson](http://caldwell.github.io/renderjson/).
* Authentication via OAuth (web) and JWT (api).
* Social media sharing using [web-share-shim](https://github.com/nimiq/web-share-shim).

## Local development

### Prerequisites
* ruby
* mongodb

### Start local instance

```bash
git clone https://github.com/nmb/validatedJSON
cd validatedJSON
bundle install
rackup
```

* For login to work, obtain OAuth credentials from google/github, and set environment variables
`GOOGLEOAUTH2ID`, `GOOGLEOAUTH2SECRET`, `GITHUB_KEY`, `GITHUB_SECRET`.
* Use rake tasks to list users, give admin rights to a user (see `rake --tasks`)

## API access

* Obtain token from user profile page (`/profile`).
* Example usage: 

```bash
curl -H "Authorization: Bearer $(cat token)" -F "title=My schema" -F "jsonstr=$(cat myschema.json)" http://localhost:9292/schemas
```

