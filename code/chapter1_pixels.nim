import pixels

type
  Point = object
    x: int
    y: int

proc drawHorizontalLine(start: Point; length: Positive) = # <1>
  for delta in 0 .. length:  # <2>
    putPixel(start.x + delta, start.y) # <3>

proc drawVerticalLine(start: Point; length: Positive) =
  for delta in 0 .. length:
    putPixel(start.x, start.y + delta) # <4>

let a = Point(x: 60, y: 40)

drawHorizontalLine(a, 50) # <5>
drawVerticalLine(a, 30)   # <6>





# this must be line 25
type
  Direction = enum  # <1>
    Horizontal      # <2>
    Vertical

proc drawLine(start: Point; length: Positive; direction: Direction) = # <3>
  case direction  # <4>
  of Horizontal:
    drawHorizontalLine(start, length) # <5>
  of Vertical:
    drawVerticalLine(start, length)

drawLine(a, 50, Horizontal) # <6>
drawLine(a, 30, Vertical)





# this must be line 45
proc drawHorizontalLine(a, b: Point) = # <1>
  if b.x < a.x:
    drawHorizontalLine(b, a) # <2>
  else:
    for x in a.x .. b.x:
      putPixel(x, a.y) # <3>

proc drawVerticalLine(a, b: Point) =
  if b.y < a.y:
    drawVerticalLine(b, a)
  else:
    for y in a.y .. b.y:
      putPixel(a.x, y)

let
  p = Point(x: 20, y: 20)
  q = Point(x: 50, y: 20)
  r = Point(x: 20, y: -10)

drawHorizontalLine(p, q) # <4>
drawVerticalLine(p, r)   # <5>



# this must be line 70
drawText 30, 40, "Welcome to Nim!", 10, Yellow



# this must be line 75
for i in 1..3:
  let texttodraw = "welcome to nim for the " & $i & "th time!"  # <1>
  drawtext 10, i*10, texttodraw, 8, Yellow   # <2>






# this must be line 85
proc putPixels(points: seq[Point]; col: Color) =  # <1>
  for p in items(points):  # <2>
    pixels.putPixel p.x, p.y, col # <3>

putPixels(@[Point(x: 2, y: 3), Point(x: 5, y: 10)], Gold) # <4>




# this must be line 95
const
  ScreenWidth = 1024 # <1>
  ScreenHeight = 768

proc safePutPixel(x, y: int; col: Color) =
  if x < 0 or x >= ScreenWidth or
     y < 0 or y >= ScreenHeight:
    return # <2>
  putPixel(x, y, col) # <3>





# this must be line 110
template wrap(body: untyped) = # <1>
  drawText 0, 10, "Before Body", 8, Yellow # <2>
  body # <3>

wrap: # <4>
  for i in 1..3:
    let textToDraw = "Welcome to Nim for the " & $i & "th time!"
    drawText 10, i*10, textToDraw, 8, Yellow






# this must be line 125
template withColor(col: Color; body: untyped) = # <1>
  let colorContext {.inject.} = col # <2>
  body

withColor Blue: # <3>
  putPixel 3, 4 # <4>
  drawText 10, 10, "abc", 12