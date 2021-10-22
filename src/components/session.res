module Session = {
  open Chakra
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

    <Flex alignContent={#center} justifyContent={#center} height={#max}>
      <VStack>
        <Clock endTime={endTime} />
        <ClockCountDown elaspedTime={elaspedTime} sessionLength={sessionLength} />
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
      </VStack>
      // <Box> {React.string("I can't focus ->")} </Box>
    </Flex>
  }
}
