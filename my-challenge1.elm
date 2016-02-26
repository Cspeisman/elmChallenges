import Window
import Graphics.Element
import Mouse

view : (Int, Int) -> Int -> Graphics.Element.Element
view (w, h) x =
  let
    text = if   x > w //2
      then "right"
      else "left"
  in
    Graphics.Element.container w h Graphics.Element.middle (Graphics.Element.show text)

main : Signal Graphics.Element.Element
main =
  Signal.map2 view Window.dimensions Mouse.x
