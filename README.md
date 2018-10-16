# Installation

* Ruby version must be >= 2.3.0

Run
```
$ git clone git@github.com:chiaraani/remember-lang.git
$ cd remember-lang
$ bundle
$ rails db:migrate
```
Ready to use!

# Start Application
```
$ rails s
```
Then you can browse throughout Remember Lang at http://localhost:3000/

Ctrl+C to stop the application.

# Usage
* Create a new word.
* Add a new review scheduled for tomorrow.
* Then wait until tomorrow.
* Do the word's review as you like
* Check passed whether you remember the word
* Update the Review.

If you passed the review, a new review will be created which will be ready to perform in 2 days.
Otherwise, a new review will be created for tomorrow.
