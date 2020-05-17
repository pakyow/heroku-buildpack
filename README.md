# Heroku Buildpack for Pakyow

This is a [Heroku Buildpack](https://devcenter.heroku.com/articles/buildpacks) for [Pakyow](https://pakyow.com) projects.

* Installs the Ruby version required by your project.
* Compiles your project's dependencies using [Bundler](https://bundler.io).
* Runs the prelaunch steps necessary for building and releasing your project.

## Usage

If you haven't already, [install Pakyow](https://pakyow.com/docs/hello/installing) and the [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli) in your local development environment.

Next, generate a brand new project:

```
pakyow create my-project
cd my-project
```

Initialize a Git repository from the directory of your new project:

```
git init
git add .
git commit -m "Initial commit"
```

Create a Heroku application for your new project:

```
heroku create --buildpack https://github.com/pakyow/heroku-buildpack.git
```

Most Pakyow projects require Postgres and Redis, so create those add-ons next:

```
heroku addons:create heroku-postgresql:hobby-dev --wait
heroku addons:create heroku-redis:hobby-dev --wait
```

Now push your project to Heroku:

```
git push heroku master
```

Open your new application in a web browser:

```
heroku open
```
