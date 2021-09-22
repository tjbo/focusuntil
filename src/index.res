type intervalId
@val external setInterval: (unit => unit, int) => unit = "setInterval"
@val external clearInterval: (unit => unit, int) => unit = "clearInterval"

module Button = {
  open Chakra
  open Clock
  @react.component
  let make = () => {
    let (isStarted, setIsStarted) = React.useState(_ => false)
    let now = Belt.Float.toInt(Js.Date.now())

    let (startTime, setStartTime) = React.useState(_ => now)
    let (timeLeft, setTimeLeft) = React.useState(_ => 0)

    let onClick = _ =>
      if isStarted {
        setIsStarted(_ => false)
        // clearInterval(_ +tick.contents)
      } else {
        setIsStarted(_ => true)
        let count = ref(0)
        let now = Belt.Float.toInt(Js.Date.now())
        let tick = () => {
          count := count.contents + 1
          let now = Belt.Float.toInt(Js.Date.now())
          let elapsed = now - startTime
          let timeLeft = 45 * 60 - elapsed / 1000

          setTimeLeft(_ => timeLeft)
        }

        if startTime === 0 {
          setStartTime(_ => now)
        }

        setInterval(tick, 1000)
      }

    let buttonText = switch isStarted {
    | false => "Start"
    | true => "Pause"
    }

    let secondsLeft = Js.Math.floor(Belt.Int.toFloat(mod(timeLeft, 60)))
    let minutesLeft = Js.Math.floor(Belt.Int.toFloat(mod(timeLeft / 60, 60)))

    <Provider>
      <Heading> {React.string("Focus Until")} </Heading>
      <Box w={#fourteen} h={#fourteen}> <Clock /> </Box>
      <Flex>
        {React.string("Time Remaining:")}
        {React.string(Belt.Int.toString(minutesLeft))}
        {React.string(":")}
        {React.string(Belt.Int.toString(secondsLeft))}
      </Flex>
      <Box> <Link color={#blue800}> {React.string("Record Interuption")} </Link> </Box>
      <Button bg={#green500} onClick={onClick}> {React.string(buttonText)} </Button>
    </Provider>
  }
}

type color = [#red | #green | #blue]

let render = (myColor: color): string => {
  switch myColor {
  | #blue => "blue"
  | #green => "green"
  | #red => "red"
  }
}

switch ReactDOM.querySelector("#root") {
| Some(root) => ReactDOM.render(<div> <Button /> </div>, root)
| None => ()
}
