module Session = {
  open Chakra
  open Clock
  open ClockCountDown
  open Types
  @react.component
  let make = (~endTime: endTime, ~elaspedTime: float, ~sessionLength: float) => {
    <Flex border={#1} alignContent={#center} justifyContent={#center} height={#max}>
      <VStack>
        <Clock endTime={endTime} />
        <ClockCountDown elaspedTime={elaspedTime} sessionLength={sessionLength} />
        // TODO: <Box> <Link color={#blue800}> {React.string("Record Interuption")} </Link> </Box>
      </VStack>
    </Flex>
  }
}
