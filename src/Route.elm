module Route exposing (..)

import Url.Parser exposing (oneOf, map, top, s, string, parse, Parser, (</>))
import Url

type Route
   = Home
   | About
   | Blog
   | Post String
   | NotFound String

routeParser : Parser (Route -> a) a
routeParser = oneOf
   [ map Home top
   , map About (s "about")
   , map Blog (s "blog")
   , map Post (s "post" </> string)
   ]

parseUrl : Url.Url -> Route
parseUrl url =
   parse routeParser url
      |> Maybe.withDefault (NotFound (String.dropLeft 1 url.path))