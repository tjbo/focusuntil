type intervalId
@val external setInterval: (unit => unit, int) => unit = "setInterval"

module Button = {
  open Chakra
  open Clock
  @react.component
  let make = () => {
    let (isStarted, setIsStarted) = React.useState(_ => false)
    let (currentTime, setCurrentTime) = React.useState(_ => Js.Date.now())

    let onClick = _ =>
      if isStarted {
        setIsStarted(_ => false)
      } else {
        setIsStarted(_ => true)

        let count = ref(0)
        let tick = () => {
          count := count.contents + 1
          Js.log(Belt.Int.toString(count.contents))
        }

        setInterval(tick, 1000)
      }

    Js.log(isStarted)

    let buttonText = switch isStarted {
    | false => "Start"
    | true => "Stop"
    }

    <Provider>
      <Heading> {React.string("Focus Until")} </Heading>
      <Box bg={#red500} w={#fourteen} h={#fourteen}> <Clock /> </Box>
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
| None => () // do nothing
}
