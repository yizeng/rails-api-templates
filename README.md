# Rails API Templates

## Description

This is based on a the fork of <https://github.com/mattbrictson/rails-template>,
but modified to be an API-only project (with Docker support but not required).

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
* Docker
  - .dockerignore
  - docker-composer.yml
  - Dockerfile
* Gems
  - [discard](https://github.com/jhawthorn/discard)
  - [redis](https://github.com/redis/redis-rb)
  - Sidekiq
    - [sidekiq-scheduler](https://github.com/moove-it/sidekiq-scheduler)
    - [sidekiq-unique-jobs](https://github.com/mhenrixon/sidekiq-unique-jobs)
  - Development
    - [annotate](https://github.com/ctran/annotate_models)
    - [bullet](https://github.com/flyerhzm/bullet)
    - [dotenv-rails](https://github.com/bkeepers/dotenv)
    - [letter_opener](https://github.com/ryanb/letter_opener)
  - Testing
    - [codecov](https://github.com/codecov/codecov-ruby)
    - [factory_bot_rails](https://github.com/thoughtbot/factory_bot_rails)
    - [faker](https://github.com/faker-ruby/faker)
    - [fuubar](https://github.com/thekompanee/fuubar)
    - [rspec-rails](https://github.com/rspec/rspec-rails)
    - [rspec-sidekiq](https://github.com/rspec/rspec-rails)
    - [shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers)
    - [simplecov](https://github.com/simplecov-ruby/simplecov)
    - [timecop](https://github.com/travisjeffery/timecop)
