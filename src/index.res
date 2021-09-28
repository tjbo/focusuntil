type timerId

type state = {
  now: float,
  prevNow: float,
  isRunning: bool,
  sessionLength: float,
  startTime: float,
  elaspedTime: float,
}

let initialState: state = {
  isRunning: false,
  now: Js.Date.now(),
  prevNow: Js.Date.now(),
  elaspedTime: 0.0,
  sessionLength: 45.0,
  startTime: 0.0,
}

type action =
  | TickTock
  | ToggleTimer
  | None

let reducer = (state: state, action: action) => {
  switch action {
  | TickTock => {
      let now = Js.Date.now()
      {
        ...state,
        prevNow: now,
        elaspedTime: state.isRunning
          ? now -. state.prevNow +. state.elaspedTime
          : state.elaspedTime,
      }
    }
  | ToggleTimer => {
      let now = Js.Date.now()
      {
        ...state,
        startTime: state.startTime === 0.0 ? now : state.startTime,
        isRunning: !state.isRunning,
      }
    }
  | None => initialState
  }
}

module App = {
  open Chakra
  open Clock
  open ClockSelect
  @react.component
  let make = () => {
    let (sessionLength, setSessionLength) = React.useState(_ => 45)
    let (endTime, setEndTime) = React.useState(_ => {"hour": 0, "minutes": 0})
    let (state, dispatch) = React.useReducer(reducer, initialState)

    let timeLeft = state.sessionLength *. 60.0 -. state.elaspedTime /. 1000.0

    React.useEffect(() => {
      let interval = ref(Js.Nullable.return(Js.Global.setInterval(() => dispatch(TickTock), 300)))
      let cleanup = () => {
        Js.Nullable.iter(interval.contents, (. intervalId) => Js.Global.clearInterval(intervalId))
      }
      Some(cleanup)
    })

    let setClock = session => {
      let now = Js.Date.make()
      let minutes = Belt.Float.toInt(Js.Date.getMinutes(now)) + session
      let hours = Belt.Float.toInt(Js.Date.getHours(now))

      let time = (hour, minutes) => {
        let newMinutes = ref(minutes)
        let newHours = ref(hour)

        while newMinutes.contents >= 60 {
          newMinutes := newMinutes.contents - 60
          newHours := newHours.contents + 1
        }

        (newHours.contents, newMinutes.contents)
      }
      let (hours, minutes) = time(hours, minutes)
      setEndTime(_ => {"hour": hours, "minutes": minutes})
    }

    let buttonText = switch state.isRunning {
    | false => "Start"
    | true => "Pause"
    }

    let secondsLeft = Js.Math.floor(Belt.Int.toFloat(mod(Belt.Float.toInt(timeLeft), 60)))
    let minutesLeft = Js.Math.floor(Belt.Int.toFloat(mod(Belt.Float.toInt(timeLeft) / 60, 60)))

    let onSessionChange = value => {
      setSessionLength(_ => value)
      setClock(value)
    }

    if endTime["hour"] === 0 {
      setClock(sessionLength)
    }

    Js.log(state)

    <Provider>
      <Flex border={#1} alignContent={#center} justifyContent={#center} height={#max}>
        <VStack>
          <Clock hour={endTime["hour"]} minutes={endTime["minutes"]} />
          <ClockSelect onChange={onSessionChange} value={sessionLength} />
          <Flex>
            {React.string("Time Remaining:")}
            {React.string(Belt.Int.toString(minutesLeft))}
            {React.string(":")}
            {React.string(Belt.Int.toString(secondsLeft))}
          </Flex>
          // TODO: <Box> <Link color={#blue800}> {React.string("Record Interuption")} </Link> </Box>
          <Button
            bg={#green500}
            onClick={_ => {
              dispatch(ToggleTimer)

              // let intervalId = callTimer(dispatch(Tick))
              // dispatch(SetIntervalId({intervalId: intervalId}))
            }}>
            {React.string(buttonText)}
          </Button>
        </VStack>
      </Flex>
    </Provider>
  }
}

switch ReactDOM.querySelector("#root") {
| Some(root) => ReactDOM.render(<div> <App /> </div>, root)
| None => ()
}
