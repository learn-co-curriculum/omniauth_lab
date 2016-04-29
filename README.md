# Omniauth

## Objectives

1. Use Omniauth to provide OAuth authentication in a Rails server.

## Introduction

Let's implement all the knowledge we've just gained about oauth and omniauth.  In this lab we'll be allowing users to log in to facebook.  Because we have no control over facebook, the tests can't ensure that facebook responds correctly so you might have issues on the facebook side if you haven't set up everything exactly as explained in the README.  We'll be testing that everything on our servers side is configured correctly and assuming that facebook gives us the correct response that we can log the user in.

## Instructions

Our app will have one page, with a "Login with Facebook" link on it. When the user clicks the link, they'll be asked to authorize our app on Facebook. When they do, they'll be logged in by our app or created in our database if they've never logged in before.

There is already a view that outputs all the authenticaton data, as well as showing you the user's photo if one is provided.

## Resources
  * [Omniauth]

[Omniauth]: https://github.com/intridea/omniauth
[facebook_dev]: https://developers.facebook.com
[facebook_info_fields]: https://developers.facebook.com/docs/graph-api/reference/user/
<p class='util--hide'>View <a href='https://learn.co/lessons/omniauth_lab'>Omniauth Lab</a> on Learn.co and start learning to code for free.</p>
