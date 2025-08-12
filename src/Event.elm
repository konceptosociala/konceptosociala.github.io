module Event exposing (..)

import Url exposing (Url)
import Browser exposing (UrlRequest(..))
import Route exposing (Route(..))
import Http

type Event
   = UrlChange Url
   | LinkClicked UrlRequest
   | PostLoaded (Result Http.Error String)