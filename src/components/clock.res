open Types

module Clock = {
  open Chakra
  @react.component
  let make = (~hour: hour, ~minutes: minutes) => {
    <Flex width={#max} p={#six}>
      <Box fontSize={#xl4} mr={#six}> {React.string("Focus Until ")} </Box>
      <Box fontSize={#xl4}> {React.string(Belt.Int.toString(hour > 12 ? hour - 12 : hour))} </Box>
      <Box fontSize={#xl4}> {React.string(":")} </Box>
      <Box fontSize={#xl4}> {minutes <= 9 ? React.string("0") : React.string("")} </Box>
      <Box fontSize={#xl4}> {React.string(Belt.Int.toString(minutes))} </Box>
    </Flex>
  }
}
