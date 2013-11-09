hintr
find the best options among your friends

https://github.com/fijimunkii/hintr
http://hintr.co

facebook : long lived user_access token
https://developers.facebook.com/docs/roadmap/completed-changes/offline-access-removal/
→  https://developers.facebook.com/docs/facebook-login/manually-build-a-login-flow/


Routes
root to: ‘welcome#index’

//this will be from FB auth -- http://railscasts.com/episodes/360-facebook-authentication
post ‘/login’ => ‘session#create’
get ‘/logout’ => ‘session#destroy’

resources :users do
  resources :likes
  resources :hints do
    resources :likes
  end
end


User Stories
Unregistered Users

#1 1. As an unregistered user,
I want to see how the site works,
so that I will be interested in signing up.

#2 2. As an unregistered user,
I want to sign in to use the site,
so that I can start using the service.

Registered Users

#3 4. As a registered user, who has never visited the site before,
I want to confirm my interests,
so the site is relevant to me.

#4 1. As a registered user,
I want to log-in,
so that I can continue where I left off.

#5 2. As a registered user,
I want to see a list of recommended people,
so that I can see what we have in common.

#6 2. As a registered user,
I want to see pictures of all my recommended people,
so the site is pleasurable to look at.

#7 1. As a registered user,
I want to see an indication of others’ relationship status,
so that I know how to proceed.

#8 4. As a registered user,
I want to see match score with the person that I hovered over,
so that I know how compatible we are.

#9 2. As a registered user,
I want the option to send a message to a person,
so I can initiate contact.

#10 2. As a registered user,
I want to remove people from my feed,
so that I can ignore recommendations.

#11 4.  As a registered user,
I want to click on a person,
so that I can see more information.

#12 2-4. As a registered user,
I want to scroll through pictures of a person,
so that I can see if looks are consistent.




























Tagline
From Ana: Hintr takes all the people in your network and matches you based on your interests. It presents you with people you perhaps didn't know you had so much in common with and raises new possibilities for people to connect with. Then it gives you he option of messaging that person or of removing them from your feed if you don't agree that they'd be a good match. It refreshes every day, so you will always have new people to connect with from your own friends' list waiting for you. It is based on the premise that though we have so many facebook friends, we don't remember who all of them are. Sometimes people fixate on meeting new people and they don't think about reconnecting with someone they knew only vaguely in the past. It makes suggestions to connect with people based on information that's already there, waiting to be discovered.

The best part of facebook without the hard work.

The motion of the ocean.

Get some knowledge.


Waiting to be discovered.

What’s already there might be hard to find.

Using facebook is like finding a needle in a haystack.

Find the needle in your haystack.

hintr: filter your mates
hintr: sleek, unique, matches you up, perfection, beautiful,
hintr: clears out the clutter,
people are waiting to be discovered, connects you with the right people

WHY: because we care about straight to point, beautiful display of the right matches for each person
HOW:
WHAT:

hintr: find the best options among your friends


images: /user_stories_mockups