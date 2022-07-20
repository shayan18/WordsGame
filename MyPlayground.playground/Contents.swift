import UIKit

var test = 10
var closure = {
    test += 3
}
print(test) //
closure()
print(test) //

// Why the closure can capture the value type integer test?

var a = 0
var b = 0
let closure2 = { [a] in
    print(a, b) // ？
}

a = 10
b = 10
closure2()
