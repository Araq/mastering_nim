
{.emit: """

#include <stdlib.h>
typedef struct {
  double x;
  char* s;
} Obj;

Obj* createObj(const char* s) {
  Obj* result = (Obj*) malloc(sizeof(Obj));
  result->x = 40.0;
  result->s = malloc(100);
  strcpy(result->s, s);
  return result;
}

void destroyObj(Obj* obj) {
  free(obj->s);
  free(obj);
}

void useObj(Obj* obj) {}

double getX(Obj* obj) { return obj->x; }

""".}

type
  Obj = object

proc createObj(s: cstring): ptr Obj {.importc, nodecl.}
proc destroyObj(obj: ptr Obj) {.importc, nodecl.}
proc useObj(obj: ptr Obj) {.importc, nodecl.}
proc getX(obj: ptr Obj): float {.importc, nodecl.}

type
  Wrapper = object
    obj: ptr Obj
    rc: ptr int

proc `=destroy`(dest: var Wrapper) =
  if dest.obj != nil:
    if dest.rc[] == 0:
      dealloc(dest.rc)
      destroyObj(dest.obj)
    else:
      dec dest.rc[]

proc `=copy`(dest: var Wrapper; source: Wrapper) =
  inc source.rc[]
  `=destroy`(dest)
  dest.obj = source.obj
  dest.rc = source.rc

proc create(s: string): Wrapper =
  Wrapper(obj: createObj(cstring(s)), rc: cast[ptr int](alloc0(sizeof(int))))

proc use(w: Wrapper) = useObj(w.obj)
proc getX(w: Wrapper): float = getX(w.obj)


proc useWrapper =
  let w = @[create("abc"), create("def")]
  use w[0]
  echo w[1].getX

useWrapper()
