[![Build Status](https://circleci.com/gh/thingssimple/burnbox.svg?style=svg)](https://circleci.com/gh/thingssimple/burnbox) [![Code Climate](http://img.shields.io/codeclimate/github/thingssimple/burnbox.svg)](https://codeclimate.com/github/thingssimple/burnbox)

# BurnBox

Anonymous, self-destructing message and file sharing.

## API

If you would like to create messages programmatically, you can do that:

    $ curl --header "Accept: application/json" -F 'message[text]=check this out&message[file]=@/path/to/test.txt' https://burnboxapp.com/messages
