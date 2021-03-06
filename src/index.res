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
  interruptions: array<string>,
  isFinished: bool,
  isSessionInit: bool,
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
  interruptions: [],
  isSessionInit: false,
  isFinished: false,
  isRunning: false,
  now: Js.Date.now(),
  prevNow: Js.Date.now(),
  elaspedTime: 0.0,
  sessionLength: 0.5,
  startTime: 0.0,
}

type action =
  | RecordInterruption
  | SetSessionLength({minutes: float})
  | Tick
  | ToggleTimer
  | None

let reducer = (state: state, action: action) => {
  switch action {
  | RecordInterruption => {
      ...state,
      interruptions: Js.Array2.concat(["x"], state.interruptions),
    }
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

      let isFinished = state.elaspedTime /. 1000.0 >= state.sessionLength *. 60.0
      let isRunning = !isFinished ? state.isRunning : false
      {
        ...state,
        isRunning: isRunning,
        isFinished: isFinished,
        prevNow: now,
        elaspedTime: isRunning ? now -. state.prevNow +. state.elaspedTime : state.elaspedTime,
      }
    }
  | ToggleTimer => {
      let now = Js.Date.make()
      let endTime = calculateEndTime(now, state.sessionLength)

      {
        ...state,
        endTime: endTime,
        isSessionInit: true,
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
      let interval = ref(Js.Nullable.return(Js.Global.setInterval(() => dispatch(Tick), 26)))
      let cleanup = () => {
        Js.Nullable.iter(interval.contents, (. intervalId) => Js.Global.clearInterval(intervalId))
      }
      Some(cleanup)
    })

    React.useEffect1(() => {
      if state.isFinished {
        Js.log("is finsihed")
      }
      None
    }, [state.isFinished])

    let onSessionChange = value => {
      dispatch(SetSessionLength({minutes: Belt.Int.toFloat(value)}))
    }

    <Provider>
      <Box bgColor={#blue600} paddingTop={#40} border={#1} height={#pc(100.00)}>
        <VStack justify={#center}>
          <Box>
            {state.isSessionInit === true
              ? <Session
                  elaspedTime=state.elaspedTime
                  endTime=state.endTime
                  interruptions={state.interruptions}
                  isRunning={state.isRunning}
                  onRecordInterruption={_ => dispatch(RecordInterruption)}
                  sessionLength={state.sessionLength}
                  toggleTimer={() => dispatch(ToggleTimer)}
                />
              : <ClockSelect
                  onChange={onSessionChange}
                  value={state.sessionLength}
                  toggleTimer={() => dispatch(ToggleTimer)}
                />}
          </Box>
        </VStack>
      </Box>
    </Provider>
  }
}

switch ReactDOM.querySelector("#root") {
| Some(root) => ReactDOM.render(<div> <App /> </div>, root)
| None => ()
}
