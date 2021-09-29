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
  isSessionStarted: bool,
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
  isSessionStarted: false,
  isRunning: false,
  now: Js.Date.now(),
  prevNow: Js.Date.now(),
  elaspedTime: 0.0,
  sessionLength: 45.0,
  startTime: 0.0,
}

type action =
  | SetSessionLength({minutes: float})
  | Tick
  | ToggleTimer
  | None

let reducer = (state: state, action: action) => {
  switch action {
  | SetSessionLength({minutes}) => {
      let now = Js.Date.make()
      let endTime = calculateEndTime(now, state.sessionLength)
      {
        ...state,
        endTime: endTime,
        sessionLength: minutes,
      }
    }
  | Tick => {
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
  open ClockSelect
  open Session
  @react.component
  let make = () => {
    let (state, dispatch) = React.useReducer(reducer, initialState)

    React.useEffect(() => {
      let interval = ref(Js.Nullable.return(Js.Global.setInterval(() => dispatch(Tick), 300)))
      let cleanup = () => {
        Js.Nullable.iter(interval.contents, (. intervalId) => Js.Global.clearInterval(intervalId))
      }
      Some(cleanup)
    })

    let onSessionChange = value => {
      dispatch(SetSessionLength({minutes: Belt.Int.toFloat(value)}))
    }

    Js.log(state)

    let buttonText = switch state.isRunning {
    | false => "Start"
    | true => "Pause"
    }

    <Provider>
      <VStack>
        <Box minHeight=#px(200)>
          {state.isSessionStarted
            ? <Session
                elaspedTime=state.elaspedTime
                endTime=state.endTime
                sessionLength={state.sessionLength}
              />
            : <ClockSelect onChange={onSessionChange} value={state.sessionLength} />}
        </Box>
        <Button
          bg={#green500}
          onClick={_ => {
            dispatch(ToggleTimer)
          }}>
          {React.string(buttonText)}
        </Button>
      </VStack>
    </Provider>
  }
}

switch ReactDOM.querySelector("#root") {
| Some(root) => ReactDOM.render(<div> <App /> </div>, root)
| None => ()
}
