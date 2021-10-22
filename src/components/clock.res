open Types

module Clock = {
  open Chakra
  @react.component
  let make = (~endTime: endTime) => {
    let hour = endTime.hour
    let minutes = endTime.minutes
    <Flex color={#white} width={#max} p={#6} bg={#green600}>
      <Box fontSize={#xl3} mr={#3}> {React.string("Focus Until")} </Box>
      <Box fontSize={#xl3}>
        {React.string(Belt.Float.toString(hour > 12.0 ? hour -. 12.0 : hour))}
      </Box>
      <Box fontSize={#xl3}> {React.string(":")} </Box>
      <Box fontSize={#xl3}> {minutes <= 9.0 ? React.string("0") : React.string("")} </Box>
      <Box fontSize={#xl3}> {React.string(Belt.Float.toString(minutes))} </Box>
    </Flex>
  }
}
