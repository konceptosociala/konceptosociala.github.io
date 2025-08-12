module Model exposing (..)

import Url exposing (Url)
import Browser.Navigation as Nav
import Route exposing (parseUrl, Route(..))
import Html.Styled exposing (Html)
import Page.Home as Home
import Page.Blog as Blog
import Page.About as About
import Page.NotFound as NotFound
import Http
import Event exposing (Event(..))
import Utils.Utils exposing (pageLayout)

type alias Model msg =
   { key : Nav.Key
   , route : Route
   , currentPage : Maybe (Html msg)
   , currentTitle : Maybe (String)
   }

init : () -> Url -> Nav.Key -> ( Model Event, Cmd Event )
init _ url key = 
   let
      route = parseUrl url
      model =
         { key = key
         , route = route
         , currentPage = Nothing
         , currentTitle = Nothing
         }
   in
   
   case model.route of
      Home ->
         (  { model 
               | currentPage = Just (pageLayout "Koncepto Sociala" Home.view) 
               , currentTitle = Just "Koncepto Sociala"
            }
         , Cmd.none
         )

      Blog ->
         (  { model 
               | currentPage = Just (pageLayout "Blog" Blog.view) 
               , currentTitle = Just "Blog"
            }
         , Cmd.none
         )

      About ->
         (  { model 
               | currentPage = Just (pageLayout "About" About.view) 
               , currentTitle = Just "About"
            }
         , Cmd.none
         )

      NotFound page ->
         (  { model 
               | currentPage = Just (pageLayout "404 | Not Found" (NotFound.view page)) 
               , currentTitle = Just "404 | Not Found"
            }
         , Cmd.none
         )

      Post id ->
         ( model
         , Http.get
            { url = "../posts/" ++ id ++ ".md"
            , expect = Http.expectString PostLoaded
            }
         )