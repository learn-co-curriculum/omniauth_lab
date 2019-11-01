# Omniauth Lab

## Objectives

1. Identify "Strategies" in Omniauth
2. Use the Developer Strategy with Omniauth
3. Use Omniauth to provide OAuth authentication in a Rails server through a
   third party API

## Introduction

In this lab, we'll be configuring our Rails application to request
authentication from a third party. Typical third-party authenticators are
Twitter, Facebook, and Google. We'll be configuring this application to use
GitHub.

We **won't** be creating a full user sign-up flow. Depending on which
third-party authenticator you use the data you receive will vary. As such,
we're going to provide the scaffolding to ensure you're talking to the
third-party authenticator and will set your expectations about what sort of
data you might have available. At the end of this lab, you will have the
ability to "extend" the application into creating user accounts (possibly
leveraging what you know about Devise or `has_secure_password`).

To start, we'll implement a simple authentication scheme, provided by Omniauth,
called "developer." The code in the "developer" authenticator is designed to
help you make sure you have your application set up. Once "developer" is
working as expected, we'll swap it for "github" and our app will look like
something that you might actually see in the wild.

## Identify "Strategies" in Omniauth

[Omniauth] is a flexible framework for third-party authentication. [Omniauth]
supports a **ton** of authentication providers ([full-list][]). Each of these
pluggable providers are said to have a "strategy" that [Omniauth] can use. The
word strategy here might seem strange, but it means something like "plug-in."
It comes from the programming design pattern called "Strategy." As you grow in
object-oriented skill, you might find yourself learning and even using the
Strategy pattern. You can read more about the [Strategy pattern][strategy]
(with sweet "Street Fighter" references). To get started, we need to include the
"omniauth" gem and gems for any "strategies" we want to include. We've already
provided them in the `Gemfile`.

## Use the Developer Strategy with Omniauth

We'll start by following along with the instructions provided by [Omniauth][].
Take a look at their ["Getting Started"][started] section and then come back.

These directions provide a file and a formula. In
`config/initializers/omniauth.rb`, we'll put these lines:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  # provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
end
```

We don't really have to know how Rails initializers work, we can just follow
the [Omniauth] instructions. The name "initializer" suggests that they're used
to set up Rails when we start it. We can learn more about initializers
[here][init].

Inside the block, we see that we're telling the _Rails_ application to _use_ a
thing called `OmniAuth::Builder` which, inside of its block, adds _providers_.
Providers are our authenticating third-parties. Each provider has a _strategy_.
In the snippet above, we're saying "let's use the developer strategy."

We commented out the `twitter` strategy because we won't use it in this lab.
Nevertheless, we're leaving it to show you that we can establish a decent
hypothesis about what other providers' configurations will look like. GitHub's
will probably be `provider :github, ENV['Something GitHub-related'],
ENV['Something else GitHub-related']`. This winds up being exactly true.

But for the moment, our code has the active provider as `:developer`.

The documentation then says that we need to provide a route for the providers'
strategies to "call back" to after the authenticating third-party decides
whether the user has passed or failed authentication.

So let's add the following line to `config/routes.rb`. This is a bit different
than what the documentation says, but it's a single line that's flexible enough
to work for both the _developer_ and _github_ strategies.

```ruby
match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
```

Once that's done, create a `WelcomeController` with an action called `home`.
Make this route accessible by editing `config/routes.rb` and also make
`welcome#home` be the `root` route for this Rails application.

> _WOW!_ That last paragraph integrated a lot of Rails knowledge. This is the
> level at which professional Rails developers communicate with each other!

Start up your web server and visit the root route. Select `Signing in with the
developer strategy`.

You'll be redirected to the "dummy" or "temporary" signup form for the
`developer` strategy:

(image)

Fill in the name and the email address and submit the form....

(image)

Whoops

(image)

Looks like we need to finish implementing our `SessionController`. We've
provided the logic for you inside of a method called `xcreate`. Rename this
method to `create` and try again.

You should be redirected back to your `Welcome#home` route and you will see
some diagnostic information on the screen.

Make sure you can step through the logic that you just worked through:

1. From the root route
2. To the _developer_ strategy's form which used the `/auth/:provider/callback`
   route to travel to...
3. `SessionsController#create` which logged some diagnostic data and stored
   some authentication information in the `session` and then went _back_ to the root
   route
4. Which rendered an ERB file whose content changed because of what was in the
   `session`

We've proven we can log in via the _developer_ strategy. We'll now ensure we
can log in using _GitHub's_ authentication.

## Log in via GitHub OAuth Authentication

Getting things to work with GitHub, now that we have _developer_ working, is
much easier. There are a number of steps to undertake that have _nothing_ to do
with code. We'll be following the documentation in [omniauth-github][oagh]

1. Update the `OmniAuth::Builder` to use a `:github` provider
2. Provide it ENV variables from the dotenv gem
3. That's it!

### Credentials and DotEnv

[Dotenv][dotenv] lets us store a list of "Secure keys" in a file called `.env`.
The contents of this file are available as a `Hash` called `ENV` inside of our
Rails application.

(image)

Here, because we defined `GITHUB_KEY` in `.env`, we'll have its value available
through `ENV['GITHUB_KEY']`

Because the `.env` file is full of secure keys, which are like passwords, we
should ***NEVER EVER EVER ADD OR COMMIT TO OUR GIT REPOSITORY***. In this
repository we've added `.env` go the `.gitignore` file so that `git` never sees
the `.env` file.

If we ever commit and push these keys to GitHub or anywhere on the internet,
***WE MUST REVOKE THEM IMMEDIATELY***. Because of the way Git is build,
enterprising bad people can find commits with passwords _easily_.

So, we know we need to guard our keys and store them in `.env`...but how do we
get them? For this we need to work with GitHub bureaucracy.

### Getting our Keys

First, visit GitHub: https://github.com/settings/developers. When you're logged
in, this site will let you click a button to create a "New OAuth App."

(image)

When we click it we'll be asked to fill in a form:

(image)

The important part is to provide the callback path that you defined at the very
beginning. Your app will hand off to GitHub, GitHub needs to know how to hand
off _back_ to your application (to, as it were, "call it back").

The form looks like this when filled in:

(image)

Super! Let's update our initializer (`config/initializers/omniauth.rb`) to look
like:

```ruby
provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
```

You'll see that the `ENV` `Hash`'s keys correspond to the contents of `.env`:

```text
GITHUB_KEY=33...
GITHUB_SECRET=519...
```

With this in place, visit the root route and click the link that uses GitHub
for authentication. You'll know you're on the right track when you see
something like:

(image)

If you provide your GitHub credentials (including two-factor, if it's
enabled!), you'll be redirected back to our `Session#create` and then
redirected, from there, back to the root route with GitHub information in the
`session`.

(image)

Congratulations! You just had GitHub handle user authentication for you!

## Next Steps

Using third-party authentication is commonly used to help users create new
accounts in applications. For examples of how this can work visit the [Omniauth
"Integration" document][integration] or consult their [wiki][].


* [Omniauth][]
* [List of Omniauth Authentication Strategies][full-list]

[Omniauth]: https://github.com/intridea/omniauth
[full-list]: https://github.com/omniauth/omniauth/wiki/List-of-Strategies
[strategy]: https://www.geeksforgeeks.org/strategy-pattern-set-1/
[oagh]: https://github.com/omniauth/omniauth-github
[dotenv]: https://github.com/bkeepers/dotenv
[started]: https://github.com/omniauth/omniauth#getting-started
[init]: https://guides.rubyonrails.org/v2.3/configuring.html#using-initializers
[integration]: https://github.com/omniauth/omniauth#integrating-omniauth-into-your-application
[wiki]: https://github.com/omniauth/omniauth/wiki

<p data-visibility='hidden'>View <a href='https://learn.co/lessons/omniauth_lab' title='Omniauth Lab'>Omniauth Lab</a> on Learn.co and start learning to code for free.</p>
