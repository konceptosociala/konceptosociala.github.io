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
import Utils.Utils exposing (pageLayout)

main : Program () (Model Event) Event
main =
   Browser.application
      { init = init
      , view = \m -> 
         { title = pageTitle m.route
         , body = [ toUnstyled
            (case m.route of
               Home ->
                  pageLayout 
                     "Koncepto Sociala"
                     Home.view

               Blog ->
                  pageLayout 
                     "Blog"
                     Blog.view

               About ->
                  pageLayout 
                     "About me"
                     About.view

               NotFound page ->
                  pageLayout
                     "404 | Page not found"
                     (NotFound.view page)

               Post id ->
                  let post = Dict.get id m.posts in
                  case post of
                     Just found ->
                        pageLayout
                           found.name
                           (Post.view found)

                     Nothing ->
                        pageLayout
                           "404 | Page not found"
                           (NotFound.view ("post/"++id))
            ) ]
         }
      , update = update
      , subscriptions = always Sub.none
      , onUrlChange = UrlChange
      , onUrlRequest = LinkClicked
      }
