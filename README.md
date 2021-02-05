# Rails API Templates

## Description

This is based on a the fork of <https://github.com/mattbrictson/rails-template>,
but modified to be an API-only project.

Branches:
- `main`: plain Rails API only project
- `restful`: Rails RESTful API
- `graphql`: Rails GraphQL API

## Usage

`main`

```
rails new -d postgresql --api -T -m https://gitlab.com/yi.zeng/rails-api-templates/-/raw/main/template.rb rails-api
```

`restful`

```
rails new -d postgresql --api -T -m https://gitlab.com/yi.zeng/rails-api-templates/-/raw/restful/template.rb rails-restful-api
```

`graphql`

```
rails new -d postgresql --api -T -m https://gitlab.com/yi.zeng/rails-api-templates/-/raw/graphql/template.rb rails-graphql-api
```

## What's in additional to mattbrictson/rails-template?

* Rails API Only + Many other changes
  - [dotenv-rails](https://github.com/bkeepers/dotenv)
  - [foreman](https://github.com/ddollar/foreman)
  - Monitoring
    - [airbrake](https://github.com/airbrake/airbrake)
    - [logdna](https://github.com/logdna/ruby)
    - [newrelic_rpm](https://github.com/newrelic/newrelic-ruby-agent)
  - Testing
    - [factory_bot_rails](https://github.com/thoughtbot/factory_bot_rails)
    - [faker](https://github.com/faker-ruby/faker)
    - [fuubar](https://github.com/thekompanee/fuubar)
    - [rspec-rails](https://github.com/rspec/rspec-rails)
    - [shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers)
    - [simplecov](https://github.com/simplecov-ruby/simplecov)
