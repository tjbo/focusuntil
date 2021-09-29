module ClockSelect = {
  open Chakra
  @react.component
  let make = (~value: float, ~onChange: int => unit) => {
    let _onChange = e => {
      // for some reason this turns to a string, maybe React.Reason doesn't cast it directly?
      onChange(ReactEvent.Form.target(e)["value"] * 1)
    }

    <Flex m={#two}> <input value={Belt.Float.toString(value)} onChange={_onChange} /> </Flex>
  }
}
