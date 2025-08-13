module Event exposing (..)

import Url exposing (Url)
import Browser exposing (UrlRequest(..))
import Route exposing (Route(..))
import Http
import Utils.Post exposing (PostData)

type Event
   = UrlChange Url
   | LinkClicked UrlRequest
   | PostLoaded (Result Http.Error String)
   | PostsIndexLoaded (Result Http.Error (List PostData))
   | DomReady