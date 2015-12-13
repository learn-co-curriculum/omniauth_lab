# Omniauth

## Objectives

We're going to use [Omniauth] and Rails to make an app that lets you login with Facebook, then shows you all the data that Facebook will provide about you.

## Introduction

Our app will have one page, with a "Login with Facebook" link on it. When the user clicks the link, they'll be asked to authorize our app on Facebook. When they do, they return to the homepage and see all the information about them we could glean from Facebook.

## Instructions

Add `omniauth` and `omniauth-facebook` to your Gemfile and `bundle`.

Create `config/initializers/omniauth.rb`. It will contain this:

    Rails.application.config.middleware.use OmniAuth::Builder do
      provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET']
    end

Log in to [the Facebook developer's panel][facebook_dev]. Create an app, copy the key (it's called "client ID" on Facebook's page) and the secret and set them as environment variables in the terminal:

    export FACEBOOK_KEY=<your_key>
    export FACEBOOK_SECRET=<your_key>

Then run `rails s` again.

Create a `SessionsController`. This will be simpler than ones we've made in the past. This time, we won't log you in at all, we'll just print all the information in the `request.env['omniauth.auth']` hash. The tests verify that the controller sets the appropriate variable for the views; ensure they pass.

There is already a view that outputs all the authenticaton data, as well as showing you the user's photo if one is provided.

We're not logging anyone in now. But if we were, it wouldn't be hard. You can trust the data coming in from `request.env['omniauth.auth']`, at least as far as you can trust the authentiation provider.

For extra fun, try editing your initializer to look like this:

    Rails.application.config.middleware.use OmniAuth::Builder do
      provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'],
               info_fields: ['name', 'email', 'age_range', 'context'].join(',')
    end

You can add more fields from the list [here][facebook_info_fields], and see what Facebook has to say about you.

## Resources
  * [Omniauth]

[Omniauth]: https://github.com/intridea/omniauth
[facebook_dev]: https://developers.facebook.com
[facebook_info_fields]: https://developers.facebook.com/docs/graph-api/reference/user/