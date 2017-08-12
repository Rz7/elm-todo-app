module View exposing (..)

import Dom
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Keyed as Keyed
import Task

import Model exposing (..)
import Update exposing (..)

-- VIEW

view : Model -> Html Msg
view model =
    div [ classList [ ("all", True) ] ] [
        header []
        [
            h1 [] [ text "Simple todo application" ]
        ],
        div [ classList [ ("content", True) ] ]
        [
            section [] [
               div [ classList [ ("primary", True) ] ]
               [
                    div [ classList [ ("row", True) ] ]
                    [
                        formTodo model
                    ],
                    fixedButton
               ]
            ],
            section [] [
               div [ classList [ ("collection", True), ("no-margin", True) ] ] <|
               List.map viewKeyedTask (model.todoList)
            ]
        ],
        footer []
        [
            h3 [] [ text "Simple todo application" ]
        ]
    ]

viewKeyedTask : Task -> ( Html Msg )
viewKeyedTask todo =
    ( viewTask todo )

viewTask : Task -> Html Msg
viewTask task =
    a [
        classList [
            ("collection-item", True),
            ("checked", task.completed)
        ],

        onClick (Check (task.id))
    ]
    [
        span [ classList [ ("new", task.completed == False), ("badge", True) ] ] [],
        text (task.name ++ ": " ++ task.description)
    ]


formTodo : Model -> Html Msg
formTodo model =
    Html.form [
        classList [
            ("col", True),
            ("s12", True),
            ("form-margin", True)
        ]
    ]
    [
        div [ classList [ ("row", True) ] ]
        [
            div [ classList [
                    ("input-field", True),
                    ("col", True),
                    ("s6", True)
                ]
            ]
            [
                input ([ id "todoname"
                    , type_ "text"
                    , onInput EditNewTodoName
                    , onFocus FocusNewTodo
                    , classList [ ("validate", True) ] ] ++ if model.added then [value ""] else [])
                [],
                label [ for "todoname" ] [ text "Todo name" ]
            ]
        ],
        div [ classList [ ("row", True) ] ]
        [
            div [ classList [
                    ("input-field", True),
                    ("col", True),
                    ("s6", True)
                ]
            ]
            [
                input ([ id "tododescription"
                    , type_ "text"
                    , onInput EditNewTodoDescription
                    , onFocus FocusNewTodo
                    , classList [ ("validate", True) ] ] ++ if model.added then [value ""] else [])
                [],
                label [ for "tododescription" ] [ text "Todo description" ]
            ]
        ]
    ]


fixedButton: Html Msg
fixedButton =
    div [ classList [ ("primary__fixed_button", True) ] ]
    [
        a [ classList [
                ("btn-floating", True),
                ("btn-large", True),
                ("waves-effect", True),
                ("waves-light", True),
                ("pink", True)
            ],
            onClick Add
        ]
        [
            i [ classList [ ("material-icons", True) ] ] [ text "add" ]
        ]
    ]