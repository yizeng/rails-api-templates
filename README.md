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
* Gems
  - [discard](https://github.com/jhawthorn/discard)
  - [dotenv-rails](https://github.com/bkeepers/dotenv)
  - [foreman](https://github.com/ddollar/foreman)
  - [Sidekiq](https://github.com/mperham/sidekiqs)
    - [sidekiq-failures](https://github.com/mhfs/sidekiq-failures)
    - [sidekiq-scheduler](https://github.com/moove-it/sidekiq-scheduler)
    - [sidekiq-unique-jobs](https://github.com/mhenrixon/sidekiq-unique-jobs)
  - Monitoring
    - [airbrake](https://github.com/airbrake/airbrake)
    - [logdna](https://github.com/logdna/ruby)
    - [newrelic_rpm](https://github.com/newrelic/newrelic-ruby-agent)
  - Development
    - [annotate](https://github.com/ctran/annotate_models)
    - [bullet](https://github.com/flyerhzm/bullet)
    - [letter_opener](https://github.com/ryanb/letter_opener)
    - [overcommit](https://github.com/sds/overcommit)
  - Testing
    - [factory_bot_rails](https://github.com/thoughtbot/factory_bot_rails)
    - [faker](https://github.com/faker-ruby/faker)
    - [fuubar](https://github.com/thekompanee/fuubar)
    - [rspec-rails](https://github.com/rspec/rspec-rails)
    - [rspec-sidekiq](https://github.com/rspec/rspec-rails)
    - [shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers)
    - [simplecov](https://github.com/simplecov-ruby/simplecov)
  - Production
    - [rack-timeout](https://github.com/sharpstone/rack-timeout)
