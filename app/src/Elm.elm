port module Todo_app exposing (..)

import Html exposing (..)

import Update exposing (..)
import Model exposing (..)
import View exposing (..)

port setStorage : Model -> Cmd msg
updateWithStorage : Msg -> Model -> ( Model, Cmd Msg )
updateWithStorage msg model =
    let
        ( newModel, cmds ) =
            update msg model
    in
        ( newModel
        , Cmd.batch [ setStorage newModel, cmds ]
        )

main : Program (Maybe Model) Model Msg
main =
    Html.programWithFlags
        { init = init

        , view = view
        , update = updateWithStorage
        , subscriptions = \_ -> Sub.none
        }

init : Maybe Model -> ( Model, Cmd Msg )
init savedModel =
    Maybe.withDefault emptyModel savedModel ! []


