# validatedJSON
Web app for structured JSON data.

## Features
* add JSON schemas via file upload
* create JSON objects from forms based on schemas
* edit, copy, share JSON objects
* API access using tokens

## Technical information
* Web app based on the [sinatra](http://sinatrarb.com/) framework.
* html form generation using [json-editor](https://github.com/json-editor/json-editor).
* Authentication via OAuth (web) and JWT (api).

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

