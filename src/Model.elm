module Model exposing (..)

import Url exposing (Url)
import Browser.Navigation as Nav
import Route exposing (parseUrl, Route(..))
import Dict exposing (Dict)
import Utils.Post as Post
import Utils.Post exposing (Post)
import Posts.LiniaAlgebroPorDespero1

type alias Model msg =
   { key : Nav.Key
   , route : Route
   , posts : Dict String (Post msg)
   }

init : () -> Url -> Nav.Key -> ( Model msg, Cmd msg )
init _ url key = 
   ( { key = key
     , route = parseUrl url 
     , posts = allPosts
     }
   , Cmd.none 
   )

allPosts : Dict String (Post msg)
allPosts = Dict.fromList <| List.sortWith Post.compare 
   [ Posts.LiniaAlgebroPorDespero1.post
   ]