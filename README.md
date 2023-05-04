# String of Fate App

Web application for String of Fate system that allows you to record your connections with other people.

Please also note the Web API that it uses: https://github.com/SteeringLife/StringofFate-api

## Install

Install this application by cloning the *relevant branch* and use bundler to install specified gems from `Gemfile.lock`:

```shell
bundle install
```

## Test

This web app does not contain any tests yet :(

## Execute

Launch the application using:

```shell
rake run:dev
```

The application expects the API application to also be running (see `config/app.yml` for specifying its URL)
