module DOM = Webapi.Dom
module Doc = Webapi.Dom.Document
module Canvas = Webapi.Canvas
module C2d = Webapi.Canvas.Canvas2d

module CircleTimer = {
  open Chakra
  @react.component
  let make = (~elaspedTime: float, ~sessionLength: float) => {
    React.useEffect(() => {
      switch Doc.getElementById("canvas", DOM.document) {
      | Some(element) => {
          let context = Canvas.CanvasElement.getContext2d(element)
          Canvas.CanvasElement.setWidth(element, 360)
          Canvas.CanvasElement.setHeight(element, 360)
          C2d.beginPath(context)
          C2d.arc(
            ~x=180.0,
            ~y=180.0,
            ~r=170.0,
            ~startAngle=0.0,
            ~endAngle=Js.Math._PI *. 2.0,
            ~anticw=false,
            context,
          )
          C2d.setStrokeStyle(context, String, "#9AE6B4")
          C2d.lineWidth(context, 20.0)
          C2d.stroke(context)
          C2d.closePath(context)

          let _sessionLength = sessionLength *. 60.0
          let _elaspedTime = elaspedTime /. 1000.0

          // end angle of circle should be between -0.5 and 1.5 * PI radians
          let val = (1.0 -. _elaspedTime /. _sessionLength) *. 2.0
          let normalizedValue = 1.5 -. val

          C2d.beginPath(context)
          C2d.arc(
            ~x=180.0,
            ~y=180.0,
            ~r=170.0,
            ~startAngle=Js.Math._PI *. 1.5,
            ~endAngle=Js.Math._PI *. normalizedValue,
            ~anticw=true,
            context,
          )
          C2d.setStrokeStyle(context, String, "#38A169")
          C2d.lineWidth(context, 20.0)
          C2d.stroke(context)
          C2d.closePath(context)
        }

      | None => ()
      }
      None
    })
    <Box> <canvas id="canvas" /> </Box>
  }
}
