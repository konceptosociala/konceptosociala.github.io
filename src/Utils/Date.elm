module Utils.Date exposing (..)
import Parser exposing (..)

type alias Date =
   { year : Int
   , month : Int
   , day : Int
   }

compare : Date -> Date -> Order
compare d1 d2 = 
   case Basics.compare d1.year d2.year of
      EQ -> 
         case Basics.compare d1.month d2.month of
            EQ -> 
               Basics.compare d1.day d2.day
            other -> other
      other -> other

intWithLeadingZero : Parser Int
intWithLeadingZero =
   Parser.map String.toInt (Parser.getChompedString (Parser.chompWhile Char.isDigit))
      |> Parser.andThen (\maybeInt ->
            case maybeInt of
               Just n ->
                  Parser.succeed n

               Nothing ->
                  Parser.problem "Expected a number"
         )

year : Parser Int
year =
   Parser.andThen 
      (\i -> 
         if i < 0 || i > 3000 then 
            Parser.problem ("Year must be between 0 and 3000; found " ++ String.fromInt i)
         else 
            Parser.succeed i
      ) 
      intWithLeadingZero

month : Parser Int
month =
   Parser.andThen
      (\i ->
         if i < 1 || i > 12 then
            Parser.problem ("Month must be between 1 and 12; found " ++ String.fromInt i)
         else
            Parser.succeed i
      )
      intWithLeadingZero

day : Parser Int
day =
   Parser.andThen
      (\i ->
         if i < 1 || i > 31 then
            Parser.problem ("Day must be between 1 and 31; found " ++ String.fromInt i)
         else
            Parser.succeed i
      )
      intWithLeadingZero

parse : Parser Date
parse =
   succeed Date
      |= year
      |. symbol "-"
      |= month
      |. symbol "-"
      |= day