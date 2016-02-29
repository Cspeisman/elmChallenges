import Time
import Graphics.Element exposing (show)
import Graphics.Collage
import Color
import Window
import StartApp
import Html
import Effects
import Random
import Keyboard

type alias Model = {
  circles : List Graphics.Collage.Form
  , seed : Random.Seed
  , coordinates : (Int, Int)
  , windowDim : (Int, Int)
  , isRunning : Bool
}


initalSeed : Random.Seed
initalSeed = Random.initialSeed 31415


randomPair model =
  let
    (w, h) = model.windowDim
    (x, y) = (toFloat w/2, toFloat h/2 )
  in
    Random.generate (Random.pair (Random.float -x x) (Random.float -y y)) model.seed


init : Model
init =
  { circles = []
  , seed = initalSeed
  , coordinates = (0,0)
  , windowDim = (0,0)
  , isRunning = True}


circle : (Float, Float) -> Graphics.Collage.Form
circle (x, y) =
    Graphics.Collage.move (x, y) (Graphics.Collage.filled Color.darkBlue (Graphics.Collage.circle 20.0))


type Action dimension key = NoOp
  | Draw dimension
  | Reset key


update action model =
  case action of
    Draw dimension ->
      let
        (newCoords, newSeed) = randomPair model
      in
        if model.isRunning then
          ({ model | circles = model.circles ++ [circle newCoords]
          , seed = newSeed
          , windowDim = dimension}
          , Effects.none)
        else
          (model, Effects.none)

    Reset key ->
      if key == 112 && model.isRunning then
        ({model | isRunning = False}, Effects.none)
      else if key == 112 && not model.isRunning then
        ({model | isRunning = True}, Effects.none)
      else if key == 114 then
        ({model | circles = []}, Effects.none)
      else
        (model, Effects.none)
    NoOp ->
      (model, Effects.none)



view address model =
  let
    (w,h) = model.windowDim
  in
    Html.fromElement (Graphics.Collage.collage w h model.circles)


timer : Signal Time.Time
timer =
  Time.every Time.second


app : StartApp.App Model
app =
  StartApp.start {
      init = (init, Effects.none)
    , view = view
    , update = update
    , inputs = [Signal.map2 (\_ d -> Draw d) timer Window.dimensions, Signal.map (\key -> Reset key) Keyboard.presses]
  }


main : Signal Html.Html
main =
  app.html
