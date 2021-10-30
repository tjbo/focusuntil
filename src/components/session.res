module Session = {
  open Chakra
  open CircleTimer
  open Clock
  open ClockCountDown
  open Types
  @react.component
  let make = (
    ~endTime: endTime,
    ~elaspedTime: float,
    ~interruptions: array<string>,
    ~isRunning: bool,
    ~sessionLength: float,
    ~onRecordInterruption: unit => unit,
    ~toggleTimer: unit => unit,
  ) => {
    let buttonText = switch isRunning {
    | false => "Resume"
    | true => "Pause"
    }
    <Flex height={#max} direction={#column} alignItems={#center}>
      <Box> <Clock endTime={endTime} /> </Box>
      <Flex position={#relative} alignItems={#center} justifyContent={#center}>
        <Box> <CircleTimer sessionLength={sessionLength} elaspedTime={elaspedTime} /> </Box>
        <Box position={#absolute}>
          <ClockCountDown elaspedTime={elaspedTime} sessionLength={sessionLength} />
        </Box>
      </Flex>
      <Box mt={#6}>
        <HStack>
          {interruptions
          ->Belt.Array.map(check =>
            <Box
              bg={#red500}
              color={#white}
              fontSize={#xl2}
              lineHeight={#6}
              h={#6}
              w={#6}
              textAlign={#center}>
              {React.string(check)}
            </Box>
          )
          ->React.array}
        </HStack>
        <HStack>
          <Box>
            <Link color={#blue800} onClick={_ => onRecordInterruption()}>
              <Button> {React.string("Record Distraction")} </Button>
            </Link>
          </Box>
          <Box> <Button onClick={_ => toggleTimer()}> {React.string(buttonText)} </Button> </Box>
        </HStack>
      </Box>
    </Flex>
  }
}
