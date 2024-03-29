module One exposing (..)

import Data exposing (day1LinesIn)
import Dict
import Html exposing (text)


main : Html.Html msg
main =
    day1LinesIn
        |> calibrate
        |> String.fromInt
        |> text


calibrate : String -> Int
calibrate =
    -- `lines` here is more semantic, but results in extra whitespace to clean up
    String.words
        >> List.map evaluateLine
        >> List.sum


numDict : Dict.Dict String String
numDict =
    Dict.fromList
        [ ( "nine", "9" )
        , ( "eight", "8" )
        , ( "seven", "7" )
        , ( "six", "6" )
        , ( "five", "5" )
        , ( "four", "4" )
        , ( "three", "3" )
        , ( "two", "2" )
        , ( "one", "1" )
        ]



{- Take a line of characters and return the double digit value of this line (left and right digits). -}


evaluateLine : String -> Int
evaluateLine line =
    let
        -- convert to list of chars
        lineAsList : List Char
        lineAsList =
            String.toList line

        {- Takes a direction to associate with fold direction, and returns a reducer/step which finds the first digit -
           actual, or a word representing one.
        -}
        toOuterNumber : Direction -> Char -> String -> String
        toOuterNumber direction nextChar acc =
            case String.toInt (String.left 1 acc) of
                -- if first char of acc can be converted to Int, we've found digit so loop out
                Just _ ->
                    acc

                -- otherwise take next char and proceed
                Nothing ->
                    if Char.isDigit nextChar then
                        String.fromChar nextChar

                    else
                        -- otherwise, see if new char creates a number word when added to accumulator string
                        let
                            newAcc =
                                case direction of
                                    Left ->
                                        acc ++ String.fromChar nextChar

                                    Right ->
                                        String.fromChar nextChar ++ acc

                            containsNumberWord =
                                Dict.keys numDict |> List.filter (\s -> String.contains s newAcc)
                        in
                        case containsNumberWord of
                            -- no word found, keep iterating
                            [] ->
                                newAcc

                            -- word found, lookup digit value and return as accumulator
                            x :: _ ->
                                Dict.get x numDict |> Maybe.withDefault newAcc

        l =
            lineAsList
                |> List.foldl (toOuterNumber Left) ""

        r =
            lineAsList
                |> List.foldr (toOuterNumber Right) ""
    in
    -- combine leftmost and rightmost numbers, convert string to Int
    l
        ++ r
        |> String.toInt
        |> Maybe.withDefault 0


type Direction
    = Left
    | Right
