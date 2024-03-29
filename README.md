# Project X - A version of an Open Source project by OmbuLabs called Points

This project is used by the recruitment team for their Rails interview process.

## Getting started

To get started with the app, clone the repo and then install the needed gems running the setup script:

```bash
./bin/setup
```

## Starting the Server

```bash
rails s
```

Go to http://localhost:3000

## Login

Use the `Sign in` with the `Sign in with Developer` option. Use any name/email pair (it will create a user if it doesn't exists). Use `admin`/`admin@projectx.com` to log in as an admin user.

## Running Tests

```bash
rails spec
```

## Using Docker

> NOTE: You'll need to have docker and docker-compose installed

Build the ProjectX's docker image

```bash
./bin/setup_with_docker
```

Run the app

```bash
./bin/start_with_docker
```

### Change Capybara Driver

By default, we are using the Firefox driver to use Google Chrome driver
follow the instructions below.

Go to `spec/rails_helper.rb`,
uncomment `selenium_chrome` block and comment `headless_firefox` code block.

## Admin Users

Users are created without admin privileges by default, because admin users have access to a few more features related to reports and setting real score of stories.

Currently, the only way to flag a user as `admin` is a direct database update using either postgres cli or the rails console.

If you want to set the flag for a user, you can follow these steps:

```bash
rails console
```

or

```bash
docker-compose run --rm web rails console
```

and then:

```ruby
User.find_by(email: "user@example.com").update_attribute(:admin, true)
```
