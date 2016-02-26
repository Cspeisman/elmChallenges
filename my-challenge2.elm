import Time
import Graphics.Element exposing (show)
import Graphics.Collage
import Color
import Window
import StartApp
import Html
import Effects
import Random

init =
  {circles = []}

circle =
  Graphics.Collage.filled Color.darkBlue (Graphics.Collage.circle 20.0)


type Action = NoOp | Draw


update action model =
  case action of
    Draw ->
      ({model | circles = model.circles ++ [circle]}, Effects.none)

    NoOp ->
      (model, Effects.none)


view address model =
  Html.fromElement (Graphics.Collage.collage 500 500 model.circles)


timer =
  Time.every Time.second


app =
  StartApp.start {
      init = (init, Effects.none)
    , view = view
    , update = update
    , inputs = [Signal.map (\_ -> Draw) timer]
  }


main =
  app.html
