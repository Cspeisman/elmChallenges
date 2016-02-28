import Time
import Graphics.Element exposing (show)
import Graphics.Collage
import Color
import Window
import StartApp
import Html
import Effects
import Random


initalSeed = Random.initialSeed 31415


randomPair model =
  let
    (w, h) = model.windowDim
    (x, y) = (toFloat w/2, toFloat h/2 )
  in
    Random.generate (Random.pair (Random.float -x x) (Random.float -y y)) model.seed


init =
  {circles = [], seed = initalSeed, coordinates = (0,0), windowDim = (0,0)}


circle (x, y) =
    Graphics.Collage.move (x, y) (Graphics.Collage.filled Color.darkBlue (Graphics.Collage.circle 20.0))


type Action dimension = NoOp | Draw dimension


update action model =
  case action of
    Draw dimension ->
      let
        (newCoords, newSeed) = randomPair model
      in
        ({ model | circles = model.circles ++ [circle newCoords]
        , seed = newSeed
        , windowDim = dimension}
        , Effects.none)

    NoOp ->
      (model, Effects.none)


view address model =
  let
    (w,h) = model.windowDim
  in
    Html.fromElement (Graphics.Collage.collage w h model.circles)


timer =
  Time.every Time.second


app =
  StartApp.start {
      init = (init, Effects.none)
    , view = view
    , update = update
    , inputs = [Signal.map2 (\_ d -> Draw d) timer Window.dimensions]
  }


main =
  app.html
