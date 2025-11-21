module Main exposing (..)

import Browser
import Model exposing (Model, init)
import Event exposing (Event(..))
import Route exposing (Route(..))
import Html exposing (..)
import Html.Attributes exposing (..)
import Update exposing (update)
import Model exposing (Flags)

main : Program Flags (Model Event) Event
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
                  [ p [ class "service-text" ] [ text "Loading..." ] ]
         }
      , update = update
      , subscriptions = always Sub.none
      , onUrlChange = UrlChange
      , onUrlRequest = LinkClicked
      }