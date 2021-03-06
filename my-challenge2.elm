import Time
import Graphics.Element exposing (show)
import Graphics.Collage
import Color
import Window
import StartApp
import Html
import Effects
import Random


type alias Model = {circles : List Graphics.Collage.Form, seed : Random.Seed, coordinates : (Int, Int), windowDim : (Int, Int)}


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
  {circles = [], seed = initalSeed, coordinates = (0,0), windowDim = (0,0)}


circle : (Float, Float) -> Graphics.Collage.Form
circle (x, y) =
    Graphics.Collage.move (x, y) (Graphics.Collage.filled Color.darkBlue (Graphics.Collage.circle 20.0))


type Action dimension = NoOp | Draw dimension


update : Action ( Int, Int ) -> Model -> (Model, Effects.Effects (Action ( Int, Int )))
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


view : Signal.Address (Action ( Int, Int )) -> Model -> Html.Html
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
    , inputs = [Signal.map2 (\_ d -> Draw d) timer Window.dimensions]
  }


main : Signal Html.Html
main =
  app.html
