@val external setInterval: (unit => unit, int) => unit = "setInterval"
// @val external clearInterval: unit => unit) => unit = "clearInterval"

module App = {
  open Chakra
  open Clock
  @react.component
  let make = () => {
    let (isStarted, setIsStarted) = React.useState(_ => false)
    let (startTime, setStartTime) = React.useState(_ => Belt.Float.toInt(Js.Date.now()))
    let (timeLeft, setTimeLeft) = React.useState(_ => 0)

    let interval = ref(Js.Nullable.null)

    // let cancel = (): unit =>
    //   Js.Nullable.iter(interval.contents, (. id: int): unit => clearInterval(id))

    let tick = () => {
      let now = Belt.Float.toInt(Js.Date.now())
      let elapsedTime = now - startTime
      let timeLeft = 45 * 60 - elapsedTime / 1000
      setTimeLeft(_ => timeLeft)
    }

    let onClick = _ => {
      setIsStarted(_ => {
        if !isStarted {
          interval := Js.Nullable.return(setInterval(tick, 1000))

          if startTime === 0 {
            let now = Belt.Float.toInt(Js.Date.now())
            setStartTime(_ => now)
          }
        }
        !isStarted
      })
    }

    let buttonText = switch isStarted {
    | false => "Start"
    | true => "Pause"
    }

    let secondsLeft = Js.Math.floor(Belt.Int.toFloat(mod(timeLeft, 60)))
    let minutesLeft = Js.Math.floor(Belt.Int.toFloat(mod(timeLeft / 60, 60)))

    <Provider>
      <Flex border={#1} alignContent={#center} justifyContent={#center} height={#max}>
        <VStack>
          <Heading> {React.string("Focus Until")} </Heading>
          <Box w={#fourteen} h={#fourteen}> <Clock hour={#4} minute={#5} /> </Box>
          <Flex>
            {React.string("Time Remaining:")}
            {React.string(Belt.Int.toString(minutesLeft))}
            {React.string(":")}
            {React.string(Belt.Int.toString(secondsLeft))}
          </Flex>
          // TODO: <Box> <Link color={#blue800}> {React.string("Record Interuption")} </Link> </Box>
          <Button bg={#green500} onClick={onClick}> {React.string(buttonText)} </Button>
        </VStack>
      </Flex>
    </Provider>
  }
}

switch ReactDOM.querySelector("#root") {
| Some(root) => ReactDOM.render(<div> <App /> </div>, root)
| None => ()
}
