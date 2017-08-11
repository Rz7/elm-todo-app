port module Todo_app exposing (..)

import Dom
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Keyed as Keyed
import Html.Lazy exposing (lazy, lazy2)
import Json.Decode as Json
import String
import Task

main : Program (Maybe Model) Model Msg
main =
    Html.programWithFlags
        { init = init

        , view = view
        , update = updateWithStorage
        , subscriptions = \_ -> Sub.none
        }


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

-- MODEL
type alias Model =
    {
        added: Bool,
        newtodoname : String,
        newtododescription : String,
        todoList: List Task,
        todoCounter: Int
    }

emptyModel : Model
emptyModel =
    {
        added = False,
        newtodoname = "",
        newtododescription = "",
        todoCounter = 0,
        todoList = []
    }

type alias Task =
    {
        id : Int,
        name: String,
        description : String,
        completed : Bool
    }

newTask : Int -> String -> String -> Task
newTask id name description =
    {
        id = id,
        name = name,
        description = description,
        completed = False
    }

init : Maybe Model -> ( Model, Cmd Msg )
init savedModel =
    Maybe.withDefault emptyModel savedModel ! []

-- UPDATE
type Msg
    = Add
    | Check Int
    | EditNewTodoName String
    | FocusNewTodo
    | EditNewTodoDescription String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of

    EditNewTodoName str ->
        { model |
            newtodoname = str
        }
        ! []

    FocusNewTodo ->
        { model |
            added = False
        }
        ! []

    EditNewTodoDescription str ->
        { model |
            newtododescription = str
        }
        ! []

    Add ->
        { model |
            added = True,
            newtodoname = "",
            newtododescription = "",
            todoCounter = model.todoCounter + 1,
            todoList =
                if String.isEmpty model.newtodoname then
                    model.todoList
                else
                    model.todoList ++ [ newTask model.todoCounter model.newtodoname model.newtododescription  ]
        }
        ! []

    Check id ->
        let
            updateTask t =
                if t.id == id then
                    { t | completed = True }
                else
                    t
        in
            { model | todoList = List.map updateTask model.todoList }
            ! []

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


