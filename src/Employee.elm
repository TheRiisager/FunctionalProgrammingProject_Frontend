module Employee exposing (..)

import Json.Decode exposing (Decoder, field, string, int, list, map5)

type alias Employee =
    { id: Int
    , firstName: String
    , lastName: String
    , email: String
    , departmentcode: Int
    }

employeeListDecoder : Decoder (List Employee)
employeeListDecoder =
    list employeeDecoder

employeeDecoder : Decoder Employee
employeeDecoder =
    map5 Employee
        idDecoder
        firstNameDecoder
        lastNameDecoder
        emailDecoder
        departmentcodeDecoder

idDecoder : Decoder Int
idDecoder = 
    field "id" int

firstNameDecoder : Decoder String
firstNameDecoder = 
    field "firstName" string

lastNameDecoder : Decoder String
lastNameDecoder = 
    field "lastName" string

emailDecoder : Decoder String
emailDecoder = 
    field "email" string

departmentcodeDecoder : Decoder Int
departmentcodeDecoder = 
    field "departmentcode" int