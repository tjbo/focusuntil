let hours = React.array([React.string("1"), React.string("2"), React.string("3")])

let minutes = React.array([
  React.string(":00"),
  React.string(":05"),
  React.string(":10"),
  React.string(":15"),
  React.string(":20"),
  React.string(":25"),
  React.string(":30"),
  React.string(":35"),
  React.string(":40"),
  React.string(":45"),
  React.string(":50"),
  React.string(":55"),
])

module Clock = {
  open Chakra
  @react.component
  let make = () => {
    let age = 10
    let message = j`Today I am $age years old.`

    let print = (x: React.element): React.element => <option> {x} </option>

    <Flex m={#two}>
      <select> {React.Children.map(hours, print)} </select>
      <select> {React.Children.map(minutes, print)} </select>
    </Flex>
  }
}
