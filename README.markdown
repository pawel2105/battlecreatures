== Battle creatures

Rock, paper, scissors game for Mxit.

== Installation instructions

	bundle install
	bundle exec rake db:setup db:migrate

Add config/initializers/secret_token.rb and generate one for "BattleCreatures::Application.config.secret_token"

== Game objects

Battle creatures has a couple of models, namely the `user` and `battle` instances that belong to users. There is an `ability` class that is used for permissions and is used in conjunction with the CanCan gem.

Users also have a `mxit_location` and a `mxit_profile`. This is to track the user information you get from Mxit's headers, in case you need it.

== Game mechanics

Users play single player games where they choose one of 5 creatures and their opponents are always chosen at random. Every creature has a 1/5 chance of drawing and a 2/5 chance of either winning or losing. After every battle, any previous battles a user has that are older than about 24 hours are deleted.

== Notes

There is a helper method called `mxit_markup()` that is used to escape strange markup that users potentially use for their user names (which often include smileys).

There's also a helper method for Shinka advertising that you can insert into the game. You will need to sign up with Shinka and add your ID to the environment as `ENV['SHINKA_AUID']`

All clever things were done by www.github.com/grantspeelman and all the horrible things were done by me.