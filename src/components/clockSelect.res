module ClockSelect = {
  open Chakra
  @react.component
  let make = (~value: int, ~onChange: int => unit) => {
    let _onChange = e => {
      onChange(ReactEvent.Form.target(e)["value"] * 1)
    }

    <Flex m={#two}> <input value={Belt.Int.toString(value)} onChange={_onChange} /> </Flex>
  }
}
