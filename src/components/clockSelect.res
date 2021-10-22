module ClockSelect = {
  open Chakra
  @react.component
  let make = (~value: float, ~onChange: int => unit, ~toggleTimer: unit => unit) => {
    let _onChange = e => {
      // for some reason this turns to a string, maybe React.Reason doesn't cast it directly?
      onChange(ReactEvent.Form.target(e)["value"] * 1)
    }

    <VStack justify={#spaceEvenly} minHeight={#px(200)} spacing={#6}>
      <Box maxWidth={#px(400)} textAlign={#center}>
        <Text fontSize={#xl4} color={#white}>
          {React.string("How many minutes will you focus for?")}
        </Text>
      </Box>
      <Box>
        <Input
          bgColor={#white}
          onChange={_onChange}
          textAlign={#center}
          size={#lg}
          value={Belt.Float.toString(value)}
        />
      </Box>
      <Box>
        <Button bg={#green500} onClick={_ => toggleTimer()}> {React.string("Start")} </Button>
      </Box>
    </VStack>
  }
}
