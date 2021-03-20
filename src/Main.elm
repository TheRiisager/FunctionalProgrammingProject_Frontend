module Main exposing (..)

import Browser
import Html exposing (..)
import Http
import Employee exposing(Employee, employeeListDecoder)

url = "localhost:8080/jpareststarter/api/"

type Model
    = Failure
    | Loading
    | Success

type Msg
    = GotEmployees (Result Http.Error (List Employee))

init : () -> (Model, Cmd Msg)
init _ = (
          Loading
        , getEmployees
        )
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        GotEmployees result ->
            case result of
                Ok _ ->
                    (Success, Cmd.none)
                
                Err _ ->
                    (Failure, Cmd.none)

view : Model -> Html Msg
view model =
    div[]
        [
            viewEmployees model
        ]

viewEmployees : Model -> Html Msg
viewEmployees model =
    case model of
        Failure ->
            div[]
                [
                    p[][text "Something went wrong, don't ask... We don't know"]
                ]
        Loading ->
            text "Loading..."
        
        Success ->
            div[]
                [
                    p[][text "We'll figure this out later..."]
                ]
        

    
getEmployees : Cmd Msg
getEmployees =
    Http.get
            { url = url++"employee/employees"
            , expect = Http.expectJson GotEmployees employeeListDecoder
            }

main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }

