module Main exposing (..)

import Browser
import Model exposing (Model, init)
import Event exposing (Event(..))
import Route exposing (Route(..))
import Html exposing (text)
import Update exposing (update)

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