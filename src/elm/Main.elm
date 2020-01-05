port module Main exposing (main)

import Browser exposing (element)
import Html exposing (..)
import Json.Decode as JD
import Json.Encode as JE
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Task exposing (perform)
import Time


main : Program Int Model Msg
main =
    element
        { init = always ( initModel, initCmd )
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Model =
    { time : Maybe Time.Posix
    , zone : Time.Zone
    }



-- UPDATE


type Msg
    = NoOp
    | UpdateTime Time.Posix
    | UpdateZone Time.Zone


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        UpdateTime t ->
            ( { model | time = Just t }, Cmd.none )

        UpdateZone z ->
            ( { model | zone = z }, perform UpdateTime Time.now )



-- VIEW


view : Model -> Svg Msg
view model =
    case model.time of
        Just t ->
            clock t model.zone

        Nothing ->
            svg [] []


clock : Time.Posix -> Time.Zone -> Svg Msg
clock t z =
    let
        trans =
            "translate(110, 110)"

        sc =
            Time.toSecond z t

        mn =
            Time.toMinute z t

        hr =
            Time.toHour z t
    in
    svg [ width "230", height "230" ]
        [ circle [ fill "lightgrey", stroke "grey", cx "0", cy "0", r "100", transform trans ] []
        , hand "orange" 100 sc trans
        , hand "dimgrey" 100 mn trans
        , hand "dimgrey" 60 (hr * 5) trans
        ]


hand : String -> Float -> Int -> String -> Svg msg
hand clr len time trans =
    let
        angle =
            degrees (90 - 6 * toFloat time)

        ( x, y ) =
            fromPolar ( len, angle ) |> Tuple.mapSecond negate
    in
    line [ stroke clr, x1 "0", y1 "0", x2 (String.fromFloat x), y2 (String.fromFloat y), transform trans ] []



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Time.every 1000 UpdateTime



-- INIT


initModel : Model
initModel =
    { time = Nothing, zone = Time.utc }


initCmd : Cmd Msg
initCmd =
    perform UpdateZone Time.here



-- PORT


type alias Channel =
    String


port openIpc : Channel -> Cmd msg


port sendIpcMessage : ( Channel, JE.Value ) -> Cmd msg


port onIpcMessage : (( Channel, JD.Value ) -> msg) -> Sub msg
