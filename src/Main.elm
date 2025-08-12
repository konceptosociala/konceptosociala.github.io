module Main exposing (..)

import Browser
import Model exposing (Model, init)
import Event exposing (Event(..))
import Route exposing (Route(..))
import Html.Styled exposing (toUnstyled)
import Utils.Utils exposing (pageTitle)
import Html.Styled exposing (text)
import Update exposing (update)

main : Program () (Model Event) Event
main =
   Browser.application
      { init = init
      , view = \m -> 
         { title = pageTitle m.route
          , body = 
            case m.currentPage of
               Just pageView ->
                  [ toUnstyled pageView ]
               Nothing ->
                  [ toUnstyled (text "Loading...") ]
         }
      , update = update
      , subscriptions = always Sub.none
      , onUrlChange = UrlChange
      , onUrlRequest = LinkClicked
      }