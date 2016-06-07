module Main exposing (..)

import Color exposing (..)
import Collage exposing (..)
import Element exposing (..)
import Time exposing (..)
import Task exposing (perform)

import Platform.Cmd as Cmd
import Platform.Sub as Sub

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (style)

draggable = style [("-webkit-app-region","drag")]

main = App.program { init=(initModel,initCmd)
                   , update=update
                   , subscriptions=subscriptions
                   , view=view }

-- MODEL
type alias Model = { time:Time }

-- UPDATE
type Msg = NoOp
         | UpdateTime Time

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp -> (model, Cmd.none)
    UpdateTime t -> ({ model | time = t }, Cmd.none)

-- VIEW
view : Model -> Html Msg
view model = clock model.time

clock t =
  div [draggable]
    [ collage 225 225
      [ filled lightGrey (ngon 12 110)
      , outlined (solid grey) (ngon 12 110)
      , hand orange 100 (t)
      , hand charcoal 100 (t/60)
      , hand charcoal 60 (t/720)
      ] |> toHtml
    ]

hand clr len time =
  let
    angle = degrees (90 - 6 * inSeconds time)
  in
    segment (0,0) (fromPolar (len,angle))
      |> traced (solid clr)

-- SUBSCRIPTIONS
subscriptions model =
  every second UpdateTime

-- INIT
initModel = { time=0 }

initCmd = perform (always NoOp) UpdateTime now
