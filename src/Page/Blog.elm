module Page.Blog exposing (..)

import Html exposing (..)
import Utils.Post exposing (PostData, comparePostDataDesc)
import Utils.Date as Date
import Html.Attributes exposing (..)

view : List PostData -> Html msg
view posts =
   div []
      [ ul []
         (List.sortWith comparePostDataDesc posts
            |> List.map viewPost
         )
      ]

viewPost : PostData -> Html msg
viewPost post =
   li [ class "text-light", class "blog-post-link" ] 
      [ text (Date.toString post.date)
      , text " - "
      , a [ href ("/post/" ++ post.link), class "blog-post-link" ] [ text post.title ]
      ]