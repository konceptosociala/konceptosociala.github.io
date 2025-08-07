module Main exposing (..)

import Browser.Navigation
import Browser
import Html exposing (text)
import Url
import Browser exposing (Document)
import Url.Parser as Parser exposing ((</>), s, string, top)

type alias Model = 
   { page : Page }

type Page 
   = Home
   | About
   | Blog
   | Post String
   | NotFound String

main : Program () Model ()
main =
   Browser.application
      { init = init
      , view = view
      , update = \_ m -> (m, Cmd.none)
      , subscriptions = always Sub.none
      , onUrlChange = \_ -> ()
      , onUrlRequest = \_ -> ()
      }

init : () -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd () )
init _ url _ = 
   ( { page = parseUrl url}, Cmd.none )

view : Model -> Document ()
view model =
   { title = pageTitle model.page
   , body = 
      [ text 
         (case model.page of  
            Home -> 
               "Homepage"

            About ->
               "About Us"

            Blog -> 
               "Blog Section"

            Post c -> 
               "Content" ++ c

            NotFound p -> 
               "Page not found: `"++p++"`"
         ) 
      ]
   }

pageTitle : Page -> String
pageTitle page =
   case page of
      Home -> "Home"
      About -> "About"
      Blog -> "Blog"
      Post _ -> "Post"
      NotFound _ -> "404 | Page Not Found"

parseUrl : Url.Url -> Page
parseUrl url =
   let
      parser : Parser.Parser (Page -> a) a
      parser =
         Parser.oneOf
            [ Parser.map Home top
            , Parser.map About (s "about")
            , Parser.map Blog (s "blog")
            , Parser.map Post (s "post" </> string)
            ]
   in
   case Parser.parse parser url of
      Just page ->
         page

      Nothing ->
         NotFound (String.dropLeft 1 url.path)
