port module Update exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Route exposing (Route(..))
import Model exposing (Model)
import Html exposing (text)
import Event exposing (Event(..))
import Url
import Utils.Utils exposing (pageLayout)
import Utils.Post as PostModel
import Parser
import Page.Post as Post
import Utils.Utils exposing (parsingErrors)
import Page.Blog as Blog
import Model exposing (init)
import Task
import Process

port sendMessage : () -> Cmd msg

update : Event -> Model Event -> ( Model Event, Cmd Event )
update msg model = 
   case msg of
      UrlChange url ->
         init ()
            url
            model.key

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
                           | currentPage = Just (pageLayout model.route p.name (Post.view p)) 
                           , currentTitle = Just p.name
                        }
                     , nextTick DomReady
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

      PostsIndexLoaded result ->
         case result of
            Ok posts ->
               ( { model
                   | currentPage = Just (pageLayout model.route "Blog" (Blog.view posts))
                   , currentTitle = Just "Blog"
                }
               , Cmd.none
               )

            Err _ ->
               ( { model
                   | currentPage = Just (text ("Posts index not found or is invalid"))
                   , currentTitle = Just "Posts index not found or is invalid"
                }
               , Cmd.none
               )

      DomReady ->
         ( model, sendMessage () )

nextTick : msg -> Cmd msg
nextTick msg =
   Task.perform (\_ -> msg) (Process.sleep 20)