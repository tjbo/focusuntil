module ClockSelect = {
  open Chakra
  @react.component
  let make = (~value: float, ~onChange: int => unit) => {
    let _onChange = e => {
      onChange(ReactEvent.Form.target(e)["value"] * 1)
    }

    <Flex m={#two}> <input value={Belt.Float.toString(value)} onChange={_onChange} /> </Flex>
  }
}
