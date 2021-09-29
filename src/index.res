type timerId
open Types

let calculateEndTime = (date, sessionLength): endTime => {
  let newMinutes = ref(Js.Date.getMinutes(date) +. sessionLength)
  let newHour = ref(Js.Date.getHours(date))

  while newMinutes.contents >= 60.0 {
    newMinutes := newMinutes.contents -. 60.0
    newHour := newHour.contents +. 1.0
  }
  {hour: newHour.contents, minutes: newMinutes.contents}
}

type state = {
  endTime: endTime,
  now: float,
  prevNow: float,
  isRunning: bool,
  sessionLength: float,
  startTime: float,
  elaspedTime: float,
}

let initialState: state = {
  endTime: {
    hour: 0.0,
    minutes: 0.0,
  },
  isRunning: false,
  now: Js.Date.now(),
  prevNow: Js.Date.now(),
  elaspedTime: 0.0,
  sessionLength: 45.0,
  startTime: 0.0,
}

type action =
  | SetSessionLength({minutes: float})
  | TickTock
  | ToggleTimer
  | None

let reducer = (state: state, action: action) => {
  switch action {
  | SetSessionLength({minutes}) => {
      ...state,
      sessionLength: minutes,
    }
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
      let now = Js.Date.make()

      let endTime = calculateEndTime(now, state.sessionLength)

      {
        ...state,
        endTime: endTime,
        startTime: state.startTime === 0.0 ? Js.Date.getMilliseconds(now) : state.startTime,
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
    let (state, dispatch) = React.useReducer(reducer, initialState)

    React.useEffect(() => {
      let interval = ref(Js.Nullable.return(Js.Global.setInterval(() => dispatch(TickTock), 300)))
      let cleanup = () => {
        Js.Nullable.iter(interval.contents, (. intervalId) => Js.Global.clearInterval(intervalId))
      }
      Some(cleanup)
    })

    let buttonText = switch state.isRunning {
    | false => "Start"
    | true => "Pause"
    }

    let timeLeft = state.sessionLength *. 60.0 -. state.elaspedTime /. 1000.0
    let secondsLeft = Js.Math.floor(Belt.Int.toFloat(mod(Belt.Float.toInt(timeLeft), 60)))
    let minutesLeft = Js.Math.floor(Belt.Int.toFloat(mod(Belt.Float.toInt(timeLeft) / 60, 60)))
    let hoursLeft = Js.Math.floor(Belt.Int.toFloat(mod(Belt.Float.toInt(timeLeft) / 60 / 60, 60)))

    let onSessionChange = value => {
      dispatch(SetSessionLength({minutes: Belt.Int.toFloat(value)}))
    }

    <Provider>
      <Flex border={#1} alignContent={#center} justifyContent={#center} height={#max}>
        <VStack>
          <Clock endTime={state.endTime} />
          <ClockSelect onChange={onSessionChange} value={state.sessionLength} />
          <Flex>
            {React.string("Time Remaining:")}
            {React.string(Belt.Int.toString(hoursLeft))}
            {React.string(":")}
            {React.string(Belt.Int.toString(minutesLeft))}
            {React.string(":")}
            {React.string(Belt.Int.toString(secondsLeft))}
          </Flex>
          // TODO: <Box> <Link color={#blue800}> {React.string("Record Interuption")} </Link> </Box>
          <Button
            bg={#green500}
            onClick={_ => {
              dispatch(ToggleTimer)
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
