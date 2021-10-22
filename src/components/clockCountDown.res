module ClockCountDown = {
  open Chakra
  @react.component
  let make = (~elaspedTime: float, ~sessionLength: float) => {
    let timeLeft = sessionLength *. 60.0 -. elaspedTime /. 1000.0
    let secondsLeft = Js.Math.floor(Belt.Int.toFloat(mod(Belt.Float.toInt(timeLeft), 60)))
    let minutesLeft = Js.Math.floor(Belt.Int.toFloat(mod(Belt.Float.toInt(timeLeft) / 60, 60)))
    let hoursLeft = Js.Math.floor(Belt.Int.toFloat(mod(Belt.Float.toInt(timeLeft) / 60 / 60, 60)))
    <VStack justify={#center} width={#max} minHeight={#20} minWidth={#full}>
      <Box fontSize={#xl4}>
        {hoursLeft > 0
          ? <Box _as="span"> {React.string(Belt.Int.toString(hoursLeft))} {React.string(":")} </Box>
          : React.null}
        {React.string(Belt.Int.toString(minutesLeft))}
        {React.string(":")}
        {secondsLeft < 10 ? React.string("0") : React.string("")}
        {React.string(Belt.Int.toString(secondsLeft))}
      </Box>
    </VStack>
  }
}
