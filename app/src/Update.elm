module Update exposing (..)

import Model exposing (..)

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

