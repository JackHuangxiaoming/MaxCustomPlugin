struct foo2
(
A = 1,
B = 3,
fn error = throw "ZZZ",
on create do format "Struct Created: %\n" this,
on clone do format "Struct Cloned: %\n" this
)

f = foo2 a:5
f2 =  copy f

box_prop = getPropNames Box
sort box_prop

mybox = select $Box001