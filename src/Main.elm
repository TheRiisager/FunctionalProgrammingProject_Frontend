module Main exposing (..)

import Browser
import Html exposing (..)
import Http
import Employee exposing(Employee, employeeListDecoder)
import Debug exposing (toString)
import List exposing (length)



url : String
url = "localhost:8080/jpareststarter/api/employee/employees"

type Model
    = Failure
    | Loading
    | Success (List Employee)

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
                Ok value ->
                    (Success value , Cmd.none)
                
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
        
        Success value ->
            div[]
                [
                   table []
                    (List.concat [
                        [ thead []
                            [ th [][text "ID"]
                            , th [][text "Name"]
                            , th [][text "Surname"]
                            , th [][text "Email"]
                            , th [][text "Dept code"]
                            ]
                        ],
                        List.map employeeTable value
                    ])
                ]
        
headers : List Http.Header
headers = [Http.header "Content-Type" "application/json", Http.header "Accept" "application/json"]  
getEmployees : Cmd Msg
getEmployees =
     Http.request 
        { method = "GET"
        , headers = headers
        , url = "http://localhost:8080/jpareststarter/api/employee/employees"
        , body = Http.emptyBody
        , expect = Http.expectJson GotEmployees employeeListDecoder
        , timeout = Nothing
        , tracker = Nothing
        }  
   
main : Program () Model Msg
main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }

employeeTable : Employee -> Html Msg
employeeTable employee =
      tr []
            [ td [][text (toString employee.id)]
            , td [][text employee.firstName]
            , td [][text employee.lastName]
            , td [][text employee.email]
            , td [][text (toString employee.departmentcode)]
            ]