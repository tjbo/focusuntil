type hour = [#1 | #2 | #3 | #4 | #5 | #6 | #7 | #8 | #9 | #10 | #11 | #12]
type minute = [#0 | #5 | #10 | #15 | #20 | #25 | #30 | #35 | #40 | #45 | #50 | #55]

let renderHour = hour => {
  switch hour {
  | #1 => React.string("1")
  | #2 => React.string("2")
  | #3 => React.string("3")
  | #4 => React.string("4")
  | #5 => React.string("5")
  | #6 => React.string("6")
  | #7 => React.string("7")
  | #8 => React.string("8")
  | #9 => React.string("9")
  | #10 => React.string("10")
  | #11 => React.string("11")
  | #12 => React.string("12")
  }
}

let renderMinute = minute => {
  switch minute {
  | #0 => React.string(":00")
  | #5 => React.string(":05")
  | #10 => React.string(":10")
  | #15 => React.string(":15")
  | #20 => React.string(":20")
  | #25 => React.string(":25")
  | #30 => React.string(":30")
  | #35 => React.string(":35")
  | #40 => React.string(":40")
  | #45 => React.string(":45")
  | #50 => React.string(":50")
  | #55 => React.string(":55")
  }
}

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
  let make = (~hour: hour, ~minute: minute) => {
    <Flex m={#two}>
      <Box fontSize={#xl6}> {renderHour(hour)} </Box>
      <Box fontSize={#xl6}> {renderMinute(minute)} </Box>
    </Flex>
  }
}
