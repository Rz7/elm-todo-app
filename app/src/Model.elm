module Model exposing (..)

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