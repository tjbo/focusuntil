module Session = {
  open Chakra
  open Clock
  open ClockCountDown
  open Types
  @react.component
  let make = (
    ~endTime: endTime,
    ~elaspedTime: float,
    ~interruptions: int,
    ~sessionLength: float,
    ~onRecordInterruption: unit => unit,
  ) => {
    <Flex alignContent={#center} justifyContent={#center} height={#max}>
      <VStack>
        <Clock endTime={endTime} />
        <ClockCountDown elaspedTime={elaspedTime} sessionLength={sessionLength} />
        <Box> {React.string(Belt.Int.toString(interruptions))} </Box>
        <Box>
          <Link color={#blue800} onClick={_ => onRecordInterruption()}>
            <Button> {React.string("Record Distraction")} </Button>
          </Link>
        </Box>
      </VStack>
    </Flex>
  }
}
