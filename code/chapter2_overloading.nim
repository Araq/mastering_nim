
import std / [json]

proc toJ[T: enum](e: T): JsonNode {.inline.} = newJInt(ord(e))
proc toJ(s: string): JsonNode {.inline.} = newJString(s)
proc toJ(b: bool): JsonNode {.inline.} = newJBool(b)
proc toJ(f: float): JsonNode {.inline.} = newJFloat(f)
proc toJ(i: int): JsonNode {.inline.} = newJInt(i)

proc toJ[T: object](obj: T): JsonNode =
  result = newJObject()
  for f, v in fieldPairs(obj):
    result[f] = toJ(v)

proc toJ[T](s: seq[T]): JsonNode =
  result = newJArray()
  for x in s:
    result.add toJ(x)

proc fromJ[T: enum](t: typedesc[T]; j: JsonNode): T {.inline.} = T(j.getInt)
proc fromJ(t: typedesc[string]; j: JsonNode): string {.inline.} = j.getStr
proc fromJ(t: typedesc[bool]; j: JsonNode): bool {.inline.} = j.getBool
proc fromJ(t: typedesc[int]; j: JsonNode): int {.inline.} = int(j.getInt)
proc fromJ(t: typedesc[float]; j: JsonNode): float {.inline.} = j.getFloat

proc fromJ[T: seq](t: typedesc[T]; j: JsonNode): T =
  result = newSeq[typeof(result[0])]()
  assert j.kind == JArray
  for elem in items(j):
    result.add fromJ(typeof(result[0]), elem)

proc fromJ[T: object](t: typedesc[T]; j: JsonNode): T =
  result = T()
  assert j.kind == JObject
  for name, loc in fieldPairs(result):
    if j.hasKey(name):
      loc = fromJ(typeof(loc), j[name])
