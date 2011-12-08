# Pollex

Pollex generates thumbnails for items stored on CloudApp. It's a thin client 
that at its heart is a simple [Sinatra] app which pings 
the [CloudApp API] for its details, and renders a thumbnail or icon according 
to the type of drop.

[sinatra]:      https://github.com/sinatra/sinatra
[cloudapp api]: http://developer.getcloudapp.com/view-item

## Prerequisites

Pollex's needs are basic:

* Ruby 1.9.3 - If using RVM, then... <code>rvm install 1.9.3</code>
* [Bundler]
* An Event Machine based web server such as [Thin]
* [ImageMagick] - If using Homebrew... <code>brew install imagemagick</code>


[thin]:         http://code.macournoyer.com/thin/
[bundler]:      https://github.com/carlhuda/bundler
[imagemagick]:  http://www.imagemagick.org/

## Parting Words

We'd love to see what you're doing with Pollex. [Get a hold of us][twitter] and
show it off! Did you find something broken? Have questions getting things
running? [Open an issue][issue] or send over a pull request.


[twitter]: http://twitter.com/cloudapp
[issue]:   https://github.com/cloudapp/pollex/issues


## License

Pollex is released under the MIT license.
