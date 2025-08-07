module Main exposing (..)

import Browser
import Model exposing (Model, init)
import Event exposing (Event(..), update)
import Route exposing (Route(..))
import Html.Styled exposing (toUnstyled)
import Page.Home as Home
import Page.About as About
import Page.NotFound as NotFound
import Page.Blog as Blog
import Utils.Utils exposing (pageTitle)
import Page.Post as Post
import Dict

main : Program () (Model Event) Event
main =
   Browser.application
      { init = init
      , view = \m -> 
         { title = pageTitle m.route
         , body = [ toUnstyled 
            (case m.route of
               Home ->
                  Home.view

               Blog ->
                  Blog.view

               About ->
                  About.view

               NotFound page ->
                  NotFound.view page

               Post id ->
                  Post.view (Dict.get id m.posts)
            ) ]
         }
      , update = update
      , subscriptions = always Sub.none
      , onUrlChange = UrlChange
      , onUrlRequest = LinkClicked
      }
