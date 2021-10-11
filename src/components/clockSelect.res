module ClockSelect = {
  open Chakra
  @react.component
  let make = (~value: float, ~onChange: int => unit) => {
    let _onChange = e => {
      // for some reason this turns to a string, maybe React.Reason doesn't cast it directly?
      onChange(ReactEvent.Form.target(e)["value"] * 1)
    }

    <VStack>
      <Text fontSize={#xl3}> {React.string("How many minutes will you focus for?")} </Text>
      <Box> <Input onChange={_onChange} value={Belt.Float.toString(value)} /> </Box>
    </VStack>
  }
}
