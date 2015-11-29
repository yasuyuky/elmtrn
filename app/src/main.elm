module Main where

import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import Time exposing (..)
import Signal exposing (Signal, Address)

import Native.Log
import Native.Unsafe

import Html exposing (..)
import Html.Attributes exposing (style)

draggable = style [("-webkit-app-region","drag")]

main = Signal.map (view actions.address) model

-- signal handler

model : Signal Model
model = Signal.foldp update initialModel signals

signals = Signal.mergeMany [ actions.signal
                           , Signal.map UpdateTime (Native.Log.log (every second))
                           ]

actions : Signal.Mailbox Action
actions = Signal.mailbox NoOp

-- model
type alias Model = { time:Time }

initialModel = { time=Native.Unsafe.unsignal(every second) }

-- actions
type Action = NoOp
            | UpdateTime Time

update : Action -> Model -> Model
update action model =
  case action of
    NoOp -> model
    UpdateTime t -> { model | time = t }

-- view
view : Address Action -> Model -> Html
view address model = clock model.time

clock t =
  div [draggable]
    [ collage 225 225
      [ filled lightGrey (ngon 12 110)
      , outlined (solid grey) (ngon 12 110)
      , hand orange 100 (t)
      , hand charcoal 100 (t/60)
      , hand charcoal 60 (t/720)
      ] |> fromElement
    ]


hand clr len time =
  let
    angle = degrees (90 - 6 * inSeconds time)
  in
    segment (0,0) (fromPolar (len,angle))
      |> traced (solid clr)
