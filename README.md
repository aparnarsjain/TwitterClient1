TwitterClient1
==============

Twitter client homework

==============

###Mock Twitter app
This is a mock app that uses Twitter APIs and looks and behaves similarly. Authentication is done with OAuth.

Time spent: 25 hours spent in total

Completed user stories:

####Required-
- [x] User can sign in using OAuth login flow
- [x] User can view last 20 tweets from their home timeline
- [x] The current signed in user will be persisted across restarts
- [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.  In other words, design the custom cell with the proper Auto Layout settings.  You will also need to augment the model classes.
- [x] User can pull to refresh
- [x] User can compose a new tweet by tapping on a compose button.
- [x] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.

####Optionals
- [x] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [x] When composing, you should have a countdown in the upper right for the tweet limit.

####Pods used-

- AFNetworking
- Mantle
- BDBOAuth1Manager
- MHPrettyDate

####Preview-
![alt tag](https://raw.githubusercontent.com/aparnarsjain/TwitterClient1/master/twitter.gif)


Twitter Redux
==============



####Hamburger menu

- [x] Dragging anywhere in the view should reveal the menu.
- [x] The menu should include links to your profile, the home timeline, and the mentions view.
- [x] The menu can look similar to the LinkedIn menu below or feel free to take liberty with the UI.

####Profile page
- [x] Contains the user header view
- [] Optional: Implement the paging view for the user description.
- [] Optional: As the paging view moves, increase the opacity of the background screen. See the actual Twitter app for this effect
- [x] Optional: Pulling down the profile page should blur and resize the header image.
- [x] Contains a section with the users basic stats: # tweets, # following, # followers

####Home Timeline
- [x] Tapping on a user image should bring up that user's profile page

####Account switching (optional)
- [x] Long press on tab bar to bring up Account view with animation (done as a separate project)
- [] Tap account to switch to
- [] Include a plus button to Add an Account
- [] Swipe to delete an account
 
![alt tag](https://raw.githubusercontent.com/aparnarsjain/TwitterClient1/master/twitter_redux.gif)

####Account switching animation gif

![alt tag](https://raw.githubusercontent.com/aparnarsjain/TwitterClient1/master/twitter_redux_accounts.gif)


