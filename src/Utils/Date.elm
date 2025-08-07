module Utils.Date exposing (..)

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