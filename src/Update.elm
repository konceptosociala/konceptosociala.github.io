module Update exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Route exposing (parseUrl, Route(..))
import Model exposing (Model)
import Html.Styled exposing (text)
import Event exposing (Event(..))
import Url
import Utils.Utils exposing (pageLayout)
import Utils.Post as PostModel
import Parser
import Page.Post as Post
import Utils.Utils exposing (parsingErrors)

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

      PostLoaded result ->
         case result of
            Ok content ->
               let post = Parser.run PostModel.parse content in

               case post of
                  Ok p ->
                     (  { model 
                           | currentPage = Just (pageLayout p.name (Post.view p)) 
                           , currentTitle = Just p.name
                        }
                     , Cmd.none
                     )

                  Err errors ->
                     (  { model 
                           | currentPage = Just (text ("Post parsing error:\n" ++ parsingErrors errors))
                           , currentTitle = Just "Post parsing error"
                        }
                     , Cmd.none
                     )

            Err _ ->
               ( { model 
                     | currentPage = Just (text "Post not found") 
                     , currentTitle = Just "Post not found"
                  }
               , Cmd.none
               )