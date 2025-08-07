module Event exposing (..)

import Url exposing (Url)
import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Route exposing (parseUrl)
import Model exposing (Model)

type Event
   = UrlChange Url
   | LinkClicked UrlRequest

update : Event -> Model Event -> ( Model Event, Cmd Event )
update msg model = 
   case msg of
      UrlChange url ->
         ( { model | route = parseUrl url }
         , Cmd.none
         )

      LinkClicked req ->
         case req of 
            External href ->
               ( model, Nav.load href )

            Internal url ->
               ( model, Nav.pushUrl model.key (Url.toString url) )