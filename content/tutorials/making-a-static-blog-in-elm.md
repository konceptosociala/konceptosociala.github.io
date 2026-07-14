+++
title = "Making a Static Blog in Elm: Why and How?"
date = 2025-08-21
description = "I've been remaking my tech blog on GitHub Pages several times: I switched themes for Jekyll static website generator, then moved from Jekyll to Zola..."

[taxonomies]
language = ["elm"]

[extra]
read_time = 12
+++

**Warning:** this post is more like a cheat sheet than a full tutorial, so you should get acquainted with some basics
of functional programming, or at least read [the official Elm guide](https://guide.elm-lang.org/) first.

I've been remaking my tech blog on GitHub Pages several times: I switched themes for Jekyll
static website generator, then moved from Jekyll to Zola, [wrote my own Zola theme](https://github.com/konceptosociala/socio/), returned to Jekyll back with a simple no-style design, but it was really **boring**.
I still write my blog posts in plain old Markdown, as I did before, but I wanted to try something new and
quite captivating; however, writing my own Jekyll/Zola theme from scratch seemed unsound, because it's still the same HTML/CSS/JS, which we all "love" so much.

About a year ago I got acquainted with Elm. Then it seemed to me like another one "compile-to-JS" stuff, with a
weird syntax, but still well-known and cool MVP paradigm, like in Flutter, Relm and other declarative UI frameworks.
And now in 2025, when I got used to Haskell syntax as well as a functional programming paradigm, I clearly see 
Elm as a simplified version of Haskell (what it really is), developed for web frontend. And now this website, at least as of the 21st of August, 2025, is completely written in Elm, and I'll show you how exactly.

## Why?

You should use Elm for building a website for several reasons:

1. Strict static typing: no `null`, `undefined`, `[] + {} - " "` expressions and other undebuggable stuff — only     
   strong and concrete data types;
2. Cool functional features, like immutability, pattern matching, 
   [ADTs](https://en.wikipedia.org/wiki/Algebraic_data_type) etc;
3. Reactive and modern Model-View-Update architecture, which is fast and pretty easy to use for creating
   responsive applications (even a blog);
4. No JavaScript! You may use it only if you need some specific stuff, written in JS, which is not present in
   Elm infrastructure (like highlight.js; you can read about it below).

## How?

First of all, install Elm and make a basic web app setup, following [this guide](https://guide.elm-lang.org/install/elm.html).

Now create base `index.html` file with the following contents:

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="/absolute/path/to/css">
  <title></title>
</head>
<body>
  <script src="/elm.js"></script>
  <script>
    var app = Elm.Main.init();
  </script>
</body>
</html>
```

**Note**: you should also copy your `index.html` contents to `404.html` file as your server will redirect every page to a 404 default page, which would be useful to turn out to be a copy of the app's main page :)

In this tutorial we won't use `elm reactor`, because it can't work with html files and it will be hard to debug, imo.
Instead, I'd recommend to install [Run on Save VS Code extension](https://marketplace.visualstudio.com/items?itemName=emeraldwalk.RunOnSave) and write the following lines to your `.vscode/settings.json`:

```json
{
    "emeraldwalk.runonsave": {
    "commands": [
      {
        "match": "\\.(elm)$",
        "cmd": "elm make src/Main.elm --optimize --output=elm.js"
      }
    ]
  }
}
```

Now every time you save any of your Elm files, the project will be compiled to an `elm.js` file
and you will be able to test your app in your browser using some kind of HTTP server. I haven't come up 
with anything better than using a custom Python HTTP server, run with a simple script, which you can find
on [this pastebin link](https://pastebin.com/eGXvBERW), as I don't want to write the full code here.

Now let's start coding in Elm! Start with `Model` and `Event` types, which are crucial in every Elm application:

```elm
type alias Model msg =
   -- Navigation key used in URL change
   { key : Browser.Navigation.Key
   -- Route to navigate through our pages
   , route : Route
   -- Current page content to be loaded
   , currentPage : Maybe (Html msg)
   -- Current title to be loaded
   , currentTitle : Maybe (String)
   -- Loaded blog post previews (like date + title + link)
   , blogPosts : Maybe (List PostData)
   }

-- Different events (predominantly for data loading)
type Event
   = UrlChange Url
   | LinkClicked UrlRequest
   | PostLoaded (Result Http.Error String)
   | PostsIndexLoaded (Result Http.Error (List PostData))
   -- Will be used for Highlight.js example
   | DomReady
```

And let's write some simple routes parsing:

```elm
type Route
   = Home
   | About
   | Blog
   | Post String
   | NotFound String

routeParser : Parser (Route -> a) a
routeParser = oneOf
   [ map Home top                   -- /
   , map About (s "about")          -- /about
   , map Blog (s "blog")            -- /blog
   , map Post (s "post" </> string) -- /post/my-super-post
   ]

parseUrl : Url.Url -> Route
parseUrl url =
   parse routeParser url
      |> Maybe.withDefault (NotFound (String.dropLeft 1 url.path))
```

Now let's take a look at our `main` function in `Main.elm`:

```elm
main : Program () (Model Event) Event
main =
   Browser.application
      { init = init
      , view = \m -> 
         { title = 
            case m.currentTitle of
               Just title 
                  -> title

               Nothing 
                  -> "Loading..."
         , body = 
            case m.currentPage of
               Just pageView ->
                  [ pageView ]
                  
               Nothing ->
                  [ text "Loading..." ]
         }
      , update = update
      , subscriptions = always Sub.none
      , onUrlChange = UrlChange
      , onUrlRequest = LinkClicked
      }
```

Let's highlight the most important moments:

1. `view` function: as we get a part of our views from HTTP requests, we can't just rely on static
   view for each route like "if home then view home", "if post then view post" etc. We will just try to
   show some results, stored in the Model, which will be computed in `init` and `update` functions;
2. `init` function: there we will parse our passed URL, construct our initial Model with the data given
   and check the route to perform further actions: load view directly (Home, About) or send an HTTP request
   (Blog, Post). Here it is:
   ```elm
   init : () -> Url -> Nav.Key -> ( Model Event, Cmd Event )
   init _ url key = 
      -- Parse our url and generate initial model
      let
         route = parseUrl url
         model =
            { key = key
            , route = route
            , currentPage = Nothing
            , currentTitle = Nothing
            , blogPosts = Nothing
            }
      in
      case model.route of
         -- Load view directly
         Home ->
            (  { model 
                  | currentPage = Just (pageLayout model.route "Koncepto Sociala" Home.view) 
                  , currentTitle = Just "Koncepto Sociala"
               }
            , Cmd.none
            )
         -- Send some HTTP request with a result returned as our Event
         Blog ->
            ( model
            , Http.get
               { url = "../posts/index.json"
               -- result will be parsed from JSON to our `List PostData` type
               , expect = Http.expectJson PostsIndexLoaded postListDecoder
               }
            )

         -- Other routes
   ```
3. `update` function: here we will process all the events emitted: 
   ```elm
   update : Event -> Model Event -> ( Model Event, Cmd Event )
   update msg model = 
      case msg of
         -- event matching
   ```
   `UrlChange` and `LinkClicked` are
   usual for most of Elm apps where manipulation with links happens:
   ```elm
   UrlChange url ->
      -- We call init for every URL change, as we need to parse it
      -- for every route and remove unnecessary data
      init () url model.key

   LinkClicked req ->
      case req of 
         External href ->
            ( model, Nav.load href )
         Internal url ->
            ( model, Nav.pushUrl model.key (Url.toString url) ) 
   ```
   But let's also look at a more interesting event:
   ```elm
   -- Emitted, when a post loaded from HTTP request
   PostLoaded result ->
      case result of
         -- If it is actually loaded — we parse its content
         -- to our Post model using custom parser;
         -- for more info, look at a repo of this website (links are at the post footer)
         Ok content ->
            let post = Parser.run PostModel.parse content in
            case post of
               Ok p ->
                  (  { model 
                        | currentPage = Just (pageLayout model.route p.name (Post.view p)) 
                        , currentTitle = Just p.name
                     }
                  -- What is this? We'll find out soon
                  , nextTick DomReady
                  )
               -- Print errors, if parsing failed, for debug purposes
               Err errors ->
                  (  { model 
                        | currentPage = Just (text ("Post parsing error:\n" ++ parsingErrors errors))
                        , currentTitle = Just "Post parsing error"
                     }
                  , Cmd.none
                  )
         -- Loading failed ;(
         Err _ ->
            ( { model 
                  | currentPage = Just (text "Post not found") 
                  , currentTitle = Just "Post not found"
               }
            , Cmd.none
            )
   ```

## Highlight.js or sync pitfalls

What if we want to use some external JS library, which will process/change our DOM like Highlight.js?
How shall we synchronize Elm, finishing generating our DOM, and our library, which must
process it afterwards? Official documentation suggests, that we need **ports** — tool for
interracting with some JavaScript code in Elm.

Include needed libraries and change Elm initialization like this (don't forget to sync 404.html
and index.html):

```js
// Init Elm app
var app = Elm.Main.init();

// We will call hljs.highlightAll(); only when the message is sent
app.ports.sendMessage.subscribe(function (message) {
   hljs.highlightAll();
});
```

Then we rename our `module` to `port module` and add `port sendMessage : () -> Cmd msg` to the top of
our module, where events are processed. However, if you try to use `sendMessage` directly, as suggested
in official tutorials, you may find out, that Highlight.js works... but every other time. It happens because
Highlight.js is still not really synchronized well and may be called before the DOM is completely generated.

To avoid this behaviour, we will use our custom `DomReady` event, which we prepared before, along with our custom `nextTick` function to make a small delay before calling JavaScript (20 ms should be sufficient):

```elm
nextTick : msg -> Cmd msg
nextTick msg =
   Task.perform (\_ -> msg) (Process.sleep 20)
```

Now, when we send `nextTick DomReady` command every time, where our JS library should be called, we will wait for
20 ms and then push `DomReady` event to the application, which will be processed in a following straightforward way:

```elm
DomReady ->
   -- means: send request event for JavaScript call
   ( model, sendMessage () )
```

## What's next?

In this post I've not covered all the topics, that would be useful for making your Elm blog or
another application using Elm, so here is some utile resources and libraries to learn:

1. [This website full code](https://github.com/konceptosociala/konceptosociala.github.io/) — nothing to say
   more: useful utilities for parsing, data types and functions to work with them;
2. [elm-css](https://package.elm-lang.org/packages/rtfeldman/elm-css/latest/) — using CSS styling
   directly in Elm code;
3. [elm-parser](https://package.elm-lang.org/packages/elm/parser/latest/) — writing parsers easily;
4. [elm-ui](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/) — UI design toolkit as
   alternative for HTML/CSS. Looks promising, but I don't quite understand it yet;
5. [json](https://package.elm-lang.org/packages/elm/json/latest/) and 
   [http](https://package.elm-lang.org/packages/elm/http/latest/) libraries — mandatory for any web app.

If I missed something or made a mistake — don't hesitate and [file an issue](https://github.com/konceptosociala/konceptosociala.github.io/issues) :3