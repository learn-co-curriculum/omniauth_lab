# Omniauth Lab

## Objectives

1. Identify "Strategies" in Omniauth
2. Use the Developer Strategy with Omniauth
3. Use Omniauth to provide OAuth authentication in a Rails server through a
   third party API

## Introduction

In this lab we'll be allowing users to sign up for our application using
GitHub.

We'll not create a full user sign-up flow, but we'll demonstrate how to set up
the relationship between GitHub and our app and show how the authenticated
information comes back from GitHub. From there, you should have the raw
information you need (e.g. email addresses, usernames, avatar image URL) to
start to integrate what GitHub knows into your app.

To start we'll implement a simple authentication scheme, provided by Omniauth,
that helps us get the idea of how it will work. This scheme is called
"developer." We'll then swap out "developer" for "github" and use a GitHub API
key to get user credentials for our application.

## Identify "Strategies" in Omniauth

Omniauth is a flexible framework for third-party authentication. They support a
**ton** of authentication providers ([full-list][]). Each of these pluggable
providers are said to have a "strategy" that Omniauth can use. The word
strategy here might seem strange, but it means something like "plug-in." It
comes from the programming design pattern called "Strategy." As you grow in
object-oriented skill, you might find yourself learning and even using the
Strategy pattern. You can read more about the [Strategy pattern][strategy] with
sweet "Street Fighter" references.

## Use the Developer Strategy with Omniauth

While we're getting things going, Omniauth have provided a strategy called
"developer." It's helpful for getting our views setup without actually having
to log into a third-party API, get a two-factor authentication code etc. This
first section will be like a code-along.

We'll start by following along with the instructions provided by [Omniauth][].
Take a look at their "Getting Started" section and then come back.

They provide a file and a formula. In `config/initializers/omniauth.rb`, we'll
put these lines:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  # provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
end
```

We don't really have to know how Rails initializers work, we can just follow
the instructions. The name "initializer" suggests that they're used to set up
Rails when we start it. That's enough for now.

Inside the block, we see that we're telling the _Rails_ application to _use_ a
thing called `OmniAuth::Builder` which, inside of its block, adds _providers_.
Providers are our authenticating third-parties. Each provider has a _strategy_.
In the snippet above, we're saying "let's use the developer strategy."

We commented out the `twitter` configuration so that we can establish a decent
hypothesis about what other providers' configurations will look like. GitHub's
will probably be `provider :github, ENV['Something GitHub-related'],
ENV['Something else GitHub-related']`.

But for the moment, let's edit the file and define our active provider as being
`:developer`.

We need to add a route for Omniauth to use, per the documentation. So let's add
this line to `config/routes.rb`:

```ruby
match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
```

Once that's done, create a `WelcomeController` with an action called `home`.
Make this route accessible by editing `config/routes.rb` and also make
`welcome#home` be the `root` route for this Rails application. You can verify
that you've done it right when `rspec -t developer_strategy` works.

> _WOW!_ That last paragraph integrated a lot of Rails knowledge. This is the
> level at which professional Rails developers communicate with each other!

Start up your web server and visit the root route. Select `Signing in with the
developer strategy`.

You'll be redirected to the "dummy" or "temporary" signup form for the
`developer` strategy:

(image)

Fill in the name and the email address and submit the form....

Looks like we need to finish implementing our `SessionController`. We've
provided the logic inside of a method called `xcreate`. Rename this method to
`create` and make sure you can step through the logic from the root route, to
the _developer_ form, through `SessionsController#create`, then back to the
root route (but with data in the session that can be used to change the
application's appearance).

So we've proven we can log in via the _developer_ strategy. We'll now ensure we
can log in using GitHub's authentication.

## Log in via GitHub Oauth Authentication

Getting things to work with GitHub, now that we have _developer_ working, is
much easier. There are a number of steps to undertak that have _nothing_ to do
with code. We'll be following the documentation in [omniauth-github][oagh]

1. Update the `OmniAuth::Builder` to use a `:github` provider
2. Provide it ENV variables from the dotenv gem
3. That's it!

### Credentials and DotEnv

[Dotenv][dotenv] asks us to create a list of "Secure keys" that should be
accessible through a `Hash` called `ENV` inside of a file called `.env` in our
application's directory. We store these keys, which are like passwords, in a
file that we ***NEVER EVER EVER ADD OR COMMIT TO OUR GIT REPOSITORY***. If we
ever commit and push these keys to GitHub or anywhere on the internet, ***WE
MUST REVOKE THEM IMMEDIATELY***.

We get these secure keys by registering an application on GitHub.

...

With the GitHub provider added and our keys defined in `.env` we can now
authenticate through GitHub

* [Omniauth][]
* [List of Omniauth Authentication Strategies][full-list]


[Omniauth]: https://github.com/intridea/omniauth
[full-list]: https://github.com/omniauth/omniauth/wiki/List-of-Strategies
[strategy]: https://www.geeksforgeeks.org/strategy-pattern-set-1/
[oagh]: https://github.com/omniauth/omniauth-github
[dotenv]: https://github.com/bkeepers/dotenv

<p data-visibility='hidden'>View <a href='https://learn.co/lessons/omniauth_lab' title='Omniauth Lab'>Omniauth Lab</a> on Learn.co and start learning to code for free.</p>
