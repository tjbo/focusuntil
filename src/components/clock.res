open Types

module Clock = {
  open Chakra
  @react.component
  let make = (~endTime: endTime) => {
    let hour = endTime.hour
    let minutes = endTime.minutes
    <Flex width={#max} p={#six}>
      <Box fontSize={#xl4} mr={#six}> {React.string("Focus Until ")} </Box>
      <Box fontSize={#xl4}>
        {React.string(Belt.Float.toString(hour > 12.0 ? hour -. 12.0 : hour))}
      </Box>
      <Box fontSize={#xl4}> {React.string(":")} </Box>
      <Box fontSize={#xl4}> {minutes <= 9.0 ? React.string("0") : React.string("")} </Box>
      <Box fontSize={#xl4}> {React.string(Belt.Float.toString(minutes))} </Box>
    </Flex>
  }
}
