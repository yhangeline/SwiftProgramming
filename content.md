
# Swift基础语法

## 一.基础内容

#### 1.常量和变量

常量的值一旦设置好便不能再被更改，然而变量可以在将来被设置为不同的值。使用关键字 let 来声明常量，使用关键字 var 来声明变量

```
let a: Int = 123
var b: Float = 3.14
```

#### 2.类型推断

如果你没有为所需要的值进行类型声明，Swift 会使用类型推断的功能推断出合适的类型。通过检查你给变量赋的值，类型推断能够在编译阶段自动的推断出值的类型。

```
let meaningOfLife = 42 //Swift 会推断这个常量的类型是 Int
let pi = 3.14159  //Swift 在推断浮点值的时候始终会选择 Double （而不是 Float ）
let anotherPi = 3 + 0.14159 所以这个类型就被推断为 Double
```


#### 3.类型别名
类型别名可以为已经存在的类型定义了一个新的可选名字。用 `typealias` 关键字定义类型别名

```
typealias NewInt =  Int
```

#### 4.元组
元组把多个值合并成单一的复合型的值。元组内的值可以是任何类型，而且可以不必是同一类型

```
let http404Error = (404, "Not Found")
```
可以将一个元组的内容分解成单独的常量或变量，这样就可以正常的使用它们了:
```
let (statusCode, statusMessage) = http404Error
print("The status code is \(statusCode)")
// prints "The status code is 404"
print("The status message is \(statusMessage)")
// prints "The status message is Not Found"
```

如果只需要使用其中的一部分数据，不需要的数据可以用下滑线 ` _` 代替

```
let (statusCode, _) = http404Error
print("The status code is \(statusCode)")
// prints "The status code is 404"
```

另外一种方法就是利用从零开始的索引数字访问元组中的单独元素：

```
print("The status code is \(http404Error.0)")
// prints "The status code is 404"
print("The status message is \(http404Error.1)")
// prints "The status message is Not Found"
```

可以在定义元组的时候给其中的单个元素命名：

```
let http200Status = (statusCode: 200, description: "OK")
```

在命名之后，你就可以通过访问名字来获取元素的值了：

```
print("The status code is \(http200Status.statusCode)")
// prints "The status code is 200"
print("The status message is \(http200Status.description)")
// prints "The status message is OK"
```

#### 5.可选项
swift可以利用可选项来处理值可能缺失的情况。

```
var status: Int? = 1   // 申明可选Int类型,初始值为1
var defaultAddress: String? = "江苏南京"   // 申明可选String类型的变量,初始值为"江苏南京"
var student: Person? // 申明可选Person(自定义的类)的变量，初始值为nil

```

`Int?`与`Int`不相同，`Int?`表示可选的`Int`类型，可以赋值为nil，而`Int`不可以赋值为nil


在Objective-C 中，没有可选项的概念。在 Objective-C 中有一个近似的特性，一个方法可以返回一个对象或者返回 nil 。 nil 的意思是“缺少一个可用对象”。然而，他只能用在对象上，却不能作用在结构体，基础的 C 类型和枚举值上。对于这些类型，Objective-C 会返回一个特殊的值（例如 NSNotFound ）来表示值的缺失。

###### 强制展开
一旦你确定可选中包含值，你可以在可选的名字后面加一个感叹号 （ ! ） 来获取值，感叹号的意思就是说“我知道这个可选项里边有值，展开吧。”这就是所谓的可选值的**强制展开**。
```
if convertedNumber != nil {
    print("convertedNumber has an integer value of \(convertedNumber!).")
}
```

###### 可选项绑定

可以使用可选项绑定来判断可选项是否包含值，如果包含就把值赋给一个临时的常量或者变量

```
if let constantName = someOptional {
    statements
}
```

## 二.基本运算符

#### 1.合并空值运算符

合并空值运算符 （ a ?? b ）如果可选项 a  有值则展开，如果没有值，是 nil  ，则返回默认值 b 。表达式 a 必须是一个可选类型。表达式 b  必须与 a  的储存类型相同

合并空值运算符是下边代码的缩写：

```
a != nil ? a! : b

```

#### 2.区间运算符

###### 闭区间运算符

闭区间运算符（ a...b ）定义了从 a  到 b  的一组范围，并且包含 a  和 b  。 a  的值不能大于 b

```
for index in 1...5 {
    print("\(index) times 5 is \(index * 5)")
}
// 1 times 5 is 5
// 2 times 5 is 10
// 3 times 5 is 15
// 4 times 5 is 20
// 5 times 5 is 25
```

###### 半开区间运算符
半开区间运算符（ a..<b ）定义了从 a  到 b  但不包括 b  的区间，即 半开 ，因为它只包含起始值但并不包含结束值。（注：其实就是左闭右开区间。）如同闭区间运算符， a  的值也不能大于 b  ，如果 a  与 b  的值相等，那返回的区间将会是空的

###### 单侧区间

闭区间有另外一种形式来让区间朝一个方向尽可能的远——比如说，一个包含数组所有元素的区间，从索引 2 到数组的结束。在这种情况下，你可以省略区间运算符一侧的值。因为运算符只有一侧有值，所以这种区间叫做单侧区间

```
let names = ["Anna", "Alex", "Brian", "Jack"]
for name in names[2...] {
    print(name)
}
// Brian
// Jack

for name in names[...2] {
    print(name)
}
// Anna
// Alex
// Brian
```

## 三.字符串与字符

字符串是一系列的字符，比如说 "hello, world"或者 "albatross"。Swift 的字符串用 String类型来表示。 String的内容可以通过各种方法来访问到，包括作为 Character值的集合。

Swift 的 String类型桥接到了基础库中的 NSString类。Foundation 同时也扩展了所有 NSString 定义的方法给 String 。也就是说，如果你导入 Foundation ，就可以在 String 中访问所有的 NSString  方法，无需转换格式。

#### 字符串字面量

使用字符串字面量作为常量或者变量的初始值：
```
let someString = "Some string literal value"
```

如果你需要很多行的字符串，使用多行字符串字面量。多行字符串字面量是用三个双引号引起来的一系列字符：

```
let quotation = """
The White Rabbit put on his spectacles.  "Where shall I begin,
please your Majesty?" he asked.

"Begin at the beginning," the King said gravely, "and go on
till you come to the end; then stop."
"""
```

#### 字符串可变性

你可以通过把一个 String设置为变量（这里指可被修改），或者为常量（不能被修改）来指定它是否可以被修改（或者改变）：
```
var variableString = "Horse"
variableString += " and carriage"
// variableString is now "Horse and carriage"

let constantString = "Highlander"
constantString += " and another Highlander"
// this reports a compile-time error - a constant string cannot be modified
```
#### 字符串是值类型

Swift 的 String类型是一种值类型。如果你创建了一个新的 String值， String值在传递给方法或者函数的时候会被复制过去，还有赋值给常量或者变量的时候也是一样。每一次赋值和传递，现存的 String值都会被复制一次，传递走的是拷贝而不是原本

#### 字符串插值

字符串插值是一种从混合常量、变量、字面量和表达式的字符串字面量构造新 String值的方法。每一个你插入到字符串字面量的元素都要被一对圆括号包裹，然后使用反斜杠前缀：
```
let message = "\(multiplier) times 2.5 is \(Double(multiplier) * 2.5)"
// message is "3 times 2.5 is 7.5"
```

#### 访问和修改字符串

**字符串索引**：每一个 String值都有相关的索引类型， String.Index，它相当于每个 Character在字符串中的位置。

你可以使用下标脚本语法来访问 String索引中的特定 Character。
```
let greeting = "Guten Tag!"
greeting[greeting.startIndex]
// G
greeting[greeting.index(before: greeting.endIndex)]
// !
greeting[greeting.index(after: greeting.startIndex)]
// u
let index = greeting.index(greeting.startIndex, offsetBy: 7)
greeting[index]
// a
```

#### 子字符串

```
let greeting = "Hello, world!"
let index = greeting.index(of: ",") ?? greeting.endIndex
let beginning = greeting[..<index]
// beginning is "Hello"

// Convert the result to a String for long-term storage.
let newString = String(beginning)
```

与字符串类似，每一个子字符串都有一块内存区域用来保存组成子字符串的字符。字符串与子字符串的不同之处在于，作为性能上的优化，子字符串可以重用一部分用来保存原字符串的内存，或者是用来保存其他子字符串的内存。（字符串也拥有类似的优化，但是如果两个字符串使用相同的内存，他们就是等价的。）这个性能优化意味着在你修改字符串或者子字符串之前都不需要花费拷贝内存的代价。如同上面所说的，子字符串并不适合长期保存——因为它们重用了原字符串的内存，只要这个字符串有子字符串在使用中，那么这个字符串就必须一直保存在内存里。

在上面的例子中， greeting 是一个字符串，也就是说它拥有一块内存保存着组成这个字符串的字符。由于 beginning 是 greeting 的子字符串，它重用了 greeting 所用的内存。不同的是， newString 是字符串——当它从子字符串创建时，它就有了自己的内存。下面的图例显示了这些关系：

![1.png](1.png)

#### 字符串比较

```
let quotation = "We're a lot alike, you and I."
let sameQuotation = "We're a lot alike, you and I."
if quotation == sameQuotation {
    print("These two strings are considered equal")
}
```

## 四.集合类型

Swift 提供了三种主要的集合类型，所谓的Array、Set还有Dictionary，用来储存值的集合

```
创建一个空数组
var someInts = [Int]()

使用默认值创建数组
var threeDoubles = Array(repeating: 0.0, count: 3)
var anotherThreeDoubles = Array(repeating: 2.5, count: 3)

你可以通过把两个兼容类型的现存数组用加运算符（+）加在一起来创建一个新数组。新数组的类型将从你相加的数组里推断出来
var sixDoubles = threeDoubles + anotherThreeDoubles
// sixDoubles is inferred as [Double], and equals [0.0, 0.0, 0.0, 2.5, 2.5, 2.5]
```

使用数组字面量创建数组
```
var shoppingList: [String] = ["Eggs", "Milk"]
```

依托于Swift 的类型推断，如果你用包含相同类型值的数组字面量初始化数组，就不需要写明数组的类型。 shoppingList的初始化可以写得更短：

```
var shoppingList = ["Eggs", "Milk"]
```
因为数组字面量中的值都是相同的类型，Swift 就能够推断 [String]是 shoppingList变量最合适的类型。


#### 访问和修改数组


要得出数组中元素的数量，检查只读的 count属性：

```
print("The shopping list contains \(shoppingList.count) items.")
// prints "The shopping list contains 2 items."
```
使用布尔量 isEmpty属性来作为检查 count属性是否等于 0的快捷方式：

```
if shoppingList.isEmpty {
    print("The shopping list is empty.")
} else {
    print("The shopping list is not empty.")
}
// prints "The shopping list is not empty."

```
你可以通过 append方法给数组末尾添加新的元素：

```
shoppingList.append("Flour")
// shoppingList now contains 3 items, and someone is making pancakes

```

另外，可以使用加赋值运算符 ( +=)来在数组末尾添加一个或者多个同类型元素：

```
shoppingList += ["Baking Powder"]
// shoppingList now contains 4 items
shoppingList += ["Chocolate Spread", "Cheese", "Butter"]
// shoppingList now contains 7 items
```

通过下标脚本语法来从数组当中取回一个值，在紧跟数组名后的方括号内传入你想要取回的值的索引：

```
var firstItem = shoppingList[0]
// firstItem is equal to "Eggs"
```

同样可以使用下标脚本语法来一次改变一个范围的值，就算替换与范围长度不同的值的合集也行。下面的栗子替换用 "Bananas"和 "Apples"替换 "Chocolate Spread", "Cheese", and "Butter"：

```
shoppingList[4...6] = ["Bananas", "Apples"]
// shoppingList now contains 6 items
```

**注意:**
不能用下标脚本语法来追加一个新元素到数组的末尾


要把元素插入到特定的索引位置，调用数组的 insert(:at:)方法：

```
shoppingList.insert("Maple Syrup", at: 0)
// shoppingList now contains 7 items
// "Maple Syrup" is now the first item in the list
```

可以用 for-in循环来遍历整个数组中值的合集：
```
for item in shoppingList {
    print(item)
}
```

创建并初始化一个空合集

```
使用初始化器语法来创建一个确定类型的空合集：
var letters = Set<Character>()

使用数组字面量创建合集
var favoriteGenres: Set<String> = ["Rock", "Classical", "Hip hop"]
```

**合集类型不能从数组字面量推断出来，所以 Set类型必须被显式地声明**


#### 字典

字典初始化：

```
var namesOfIntegers = [Int: String]()
// namesOfIntegers is an empty [Int: String] dictionary

同样可以使用字典字面量来初始化一个字典
var airports: [String: String] = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]

与数组一样，如果你用一致类型的字典字面量初始化字典，就不需要写出字典的类型了。 airports的初始化就能写的更短：

var airports = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]

```

遍历字典

```
for (airportCode, airportName) in airports {
    print("\(airportCode): \(airportName)")
}
```

可以通过访问字典的 keys和 values属性来取回可遍历的字典的键或值的集合
```
for airportCode in airports.keys {
    print("Airport code: \(airportCode)")
}
// Airport code: YYZ
// Airport code: LHR

for airportName in airports.values {
    print("Airport name: \(airportName)")
}
// Airport name: Toronto Pearson
// Airport name: London Heathrow
```
## 五.控制流

1.For-in   

2.if

3.while

4.repeat-while
```
repeat {
    statements
} while condition
```

5.switch

Swift 里的 switch 语句不会默认从每个情况的末尾贯穿到下一个情况里。相反，整个 switch 语句会在匹配到第一个 switch 情况执行完毕之后退出，不再需要显式的 break 语句。这使得 switch 语句比 C 的更安全和易用，并且避免了意外地执行多个 switch 情况。

```
let someCharacter: Character = "z"
switch someCharacter {
case "a":
    print("The first letter of the alphabet")
case "z":
    print("The last letter of the alphabet")
default:
    print("Some other character")
}
```

每一个情况的函数体必须包含至少一个可执行的语句。下面的代码就是不正确的，因为第一个情况是空的：

```
let anotherCharacter: Character = "a"
switch anotherCharacter {
case "a":
case "A":
    print("The letter A")
default:
    print("Not the letter A")
}
// this will report a compile-time error
```



在一个 switch 情况中匹配多个值可以用逗号分隔，并且可以写成多行

```
let anotherCharacter: Character = "a"
switch anotherCharacter {
case "a", "A":
    print("The letter A")
default:
    print("Not the letter A")
}
// Prints "The letter A"
```

**区间匹配**

switch情况的值可以在一个区间中匹配

```
let approximateCount = 62
let countedThings = "moons orbiting Saturn"
var naturalCount: String
switch approximateCount {
case 0:
    naturalCount = "no"
case 1..<5:
    naturalCount = "a few"
case 5..<12:
    naturalCount = "several"
case 12..<100:
    naturalCount = "dozens of"
case 100..<1000:
    naturalCount = "hundreds of"
default:
    naturalCount = "many"
}
print("There are \(naturalCount) \(countedThings).")
// prints "There are dozens of moons orbiting Saturn."
```

**元组**

可以使用元组来在一个 switch 语句中测试多个值。每个元组中的元素都可以与不同的值或者区间进行匹配。另外，使用下划线 `_` 来表明匹配所有可能的值

```
let somePoint = (1, 1)
switch somePoint {
case (0, 0):
    print("(0, 0) is at the origin")
case (_, 0):
    print("(\(somePoint.0), 0) is on the x-axis")
case (0, _):
    print("(0, \(somePoint.1)) is on the y-axis")
case (-2...2, -2...2):
    print("(\(somePoint.0), \(somePoint.1)) is inside the box")
default:
    print("(\(somePoint.0), \(somePoint.1)) is outside of the box")
}
// prints "(1, 1) is inside the box"
```

**值绑定**

switch 情况可以将匹配到的值临时绑定为一个常量或者变量，来给情况的函数体使用。

```
let anotherPoint = (2, 0)
switch anotherPoint {
case (let x, 0):
    print("on the x-axis with an x value of \(x)")
case (0, let y):
    print("on the y-axis with a y value of \(y)")
case let (x, y):
    print("somewhere else at (\(x), \(y))")
}
// prints "on the x-axis with an x value of 2"
```

**Where**

```
let yetAnotherPoint = (1, -1)
switch yetAnotherPoint {
case let (x, y) where x == y:
    print("(\(x), \(y)) is on the line x == y")
case let (x, y) where x == -y:
    print("(\(x), \(y)) is on the line x == -y")
case let (x, y):
    print("(\(x), \(y)) is just some arbitrary point")
}
```

#### 控制转移语句

- continue

- break

- fallthrough

Swift 中的 Switch 语句不会从每个情况的末尾贯穿到下一个情况中。相反，整个 switch 语句会在第一个匹配到的情况执行完毕之后就直接结束执行。比较而言，C 你在每一个 switch 情况末尾插入显式的 break 语句来阻止贯穿。避免默认贯穿意味着 Swift 的 switch 语句比 C 更加清晰和可预料，并且因此它们避免了意外执行多个 switch 情况。

```
let integerToDescribe = 5
var description = "The number \(integerToDescribe) is"
switch integerToDescribe {
case 2, 3, 5, 7, 11, 13, 17, 19:
    description += " a prime number, and also"
    fallthrough
default:
    description += " an integer."
}
print(description)
```

#### 给语句打标签

循环和条件语句都可以使用 break 语句来提前结束它们的执行。因此，显式地标记那个循环或者条件语句是你想用 break 语句结束的就很有必要。同样的，如果你有多个内嵌循环，显式地标记你想让 continue 语句生效的是哪个循环就很有必要了

要达到这些目的，你可以用语句标签来给循环语句或者条件语句做标记。在一个条件语句中，你可以使用一个语句标签配合 break 语句来结束被标记的语句。在循环语句中，你可以使用语句标签来配合 break 或者 continue 语句来结束或者继续执行被标记的语句

```
gameLoop: while square != finalSquare {
    diceRoll += 1
    if diceRoll == 7 { diceRoll = 1 }
    switch square + diceRoll {
    case finalSquare:
        // diceRoll will move us to the final square, so the game is over
        break gameLoop
    case let newSquare where newSquare > finalSquare:
        // diceRoll will move us beyond the final square, so roll again
        continue
    default:
        // this is a valid move, so find out its effect
        square += diceRoll
        square += board[square]
    }
}
print("Game over!")
```

如果上边的 break 语句不使用 gameLoop 标签，它就会中断 switch 语句而不是 while 语句。使用 gameLoop 标签使得要结束那个控制语句变得清晰明了

#### guard 语句

与if语句相同的是，guard也是基于一个表达式的布尔值去判断一段代码是否该被执行。与if语句不同的是，guard只有在条件不满足的时候才会执行这段代码

```
let result = true

if result {
    //doSomeThing
}

guard result else {
    //doSomeThing
}
```

## 六.函数

定义函数:
```
func greet(person: String) -> String {
    let greeting = "Hello, " + person + "!"
    return greeting
}
```

调用函数：
```
greet(person: "Anna")
```

上面调用没有用到返回值 所以会报`Result of call to 'greet(person:)' is unused`的警告

```
@discardableResult
func greet(person: String) -> String {
    let greeting = "Hello, " + person + "!"
    return greeting
}
```
在函数定义前加`discardableResult` 可以忽略这个警告

**可选返回类型**

如果函数返回值可能为nil

```
func greet(person: String) -> String? {

    return nil
}
```

#### 函数实际参数标签和形式参数名

每一个函数的形式参数都包含实际参数标签和形式参数名。实际参数标签用在调用函数的时候；在调用函数的时候每一个实际参数前边都要写实际参数标签。形式参数名用在函数的实现当中。默认情况下，形式参数使用它们的形式参数名作为实际参数标签。

```
func someFunction(firstParameterName: Int, secondParameterName: Int) {
    // In the function body, firstParameterName and secondParameterName
    // refer to the argument values for the first and second parameters.
}
someFunction(firstParameterName: 1, secondParameterName: 2)

```

指定实际参数标签

```
func greet(person: String, from hometown: String) -> String {
    return "Hello \(person)!  Glad you could visit from \(hometown)."
}
greet(person: "Bill", from: "Cupertino")

```

省略实际参数标签

```
func someFunction(_ firstParameterName: Int, secondParameterName: Int) {
    // In the function body, firstParameterName and secondParameterName
    // refer to the argument values for the first and second parameters.
}
someFunction(1, secondParameterName: 2)
```

默认形式参数值

```
func someFunction(parameterWithDefault: Int = 12) {
    // In the function body, if no arguments are passed to the function
    // call, the value of parameterWithDefault is 12.
}
someFunction(parameterWithDefault: 6) // parameterWithDefault is 6
someFunction() // parameterWithDefault is 12
```

可变形式参数

```
func arithmeticMean(_ numbers: Double...) -> Double {
    var total: Double = 0
    for number in numbers {
        total += number
    }
    return total / Double(numbers.count)
}
arithmeticMean(1, 2, 3, 4, 5)
// returns 3.0, which is the arithmetic mean of these five numbers
arithmeticMean(3, 8.25, 18.75)
// returns 10.0, which is the arithmetic mean of these three numbers
```


**输入输出形式参数**

如果你想函数能够修改一个形式参数的值，而且你想这些改变在函数结束之后依然生效，那么就需要将形式参数定义为输入输出形式参数。

在形式参数定义开始的时候在前边添加一个 `inout` 关键字可以定义一个输入输出形式参数。输入输出形式参数有一个能输入给函数的值，函数能对其进行修改，还能输出到函数外边替换原来的值。

你只能把变量作为输入输出形式参数的实际参数。你不能用常量或者字面量作为实际参数，因为常量和字面量不能修改。在将变量作为实际参数传递给输入输出形式参数的时候，直接在它前边添加一个和符合 `&` 来明确可以被函数修改

```
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}

var someInt = 3
var anotherInt = 107
swapTwoInts(&someInt, &anotherInt)
print("someInt is now \(someInt), and anotherInt is now \(anotherInt)")
// prints "someInt is now 107, and anotherInt is now 3"
```

**函数类型**

每一个函数都有一个特定的函数类型，它由形式参数类型，返回类型组成

```
func addTwoInts(_ a: Int, _ b: Int) -> Int {
    return a + b
}
```

函数的类型都是 (Int, Int) -> Int 。也读作：
“有两个形式参数的函数类型，它们都是 Int类型，并且返回一个 Int类型的值。”

```
func printHelloWorld() {
    print("hello, world")
}
```
这个函数的类型是 () -> Void，或者 “一个没有形式参数的函数，返回 Void。”

**使用函数类型**

可以给一个常量或变量定义一个函数类型，并且为变量指定一个相应的函数

`var mathFunction: (Int, Int) -> Int = addTwoInts`

可以利用名字 mathFunction来调用指定的函数。

```
print("Result: \(mathFunction(2, 3))")
// prints "Result: 5"
```


**函数类型作为返回类型**

```
func stepForward(_ input: Int) -> Int {
    return input + 1
}
func stepBackward(_ input: Int) -> Int {
    return input - 1
}

func chooseStepFunction(backwards: Bool) -> (Int) -> Int {
    return backwards ? stepBackward : stepForward
}

```

**内嵌函数**

可以在函数的内部定义另外一个函数。这就是内嵌函数。

重写上边的栗子 chooseStepFunction(backward:)来使用和返回内嵌函数：

```
func chooseStepFunction(backward: Bool) -> (Int) -> Int {
    func stepForward(input: Int) -> Int { return input + 1 }
    func stepBackward(input: Int) -> Int { return input - 1 }
    return backward ? stepBackward : stepForward
}
```

## 七.闭包

闭包是可以在你的代码中被传递和引用的功能性独立模块。Swift 中的闭包和 Objective-C 中的 blocks 很像,闭包能够捕获和存储定义在其上下文中的任何常量和变量的引用


全局和内嵌函数，实际上是特殊的闭包。闭包符合如下三种形式中的一种：

- 全局函数是一个有名字但不会捕获任何值的闭包；
- 内嵌函数是一个有名字且能从其上层函数捕获值的闭包；
- 闭包表达式是一个轻量级语法所写的可以捕获其上下文中常量或变量值的没有名字的闭包。

**闭包表达式语法**

闭包表达式语法有如下的一般形式
```
{
  (parameters) -> (return type) in
    statements
}
  ```

  ```
  let names = ["Chris","Alex","Ewa","Barry","Daniella"]
  var reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in
    return s1 > s2
})
  ```
  
 **从语境中推断类型**
 
 因排序闭包为实际参数来传递给函数，故 Swift 能推断它的形式参数类型和返回类型。 sorted(by:) 方法期望它的第二个形式参数是一个 (String, String) -> Bool 类型的函数。这意味着 (String, String)和 Bool 类型不需要被写成闭包表达式定义中的一部分，因为所有的类型都能被推断，返回箭头 ( ->) 和围绕在形式参数名周围的括号也能被省略：

```
reversedNames = names.sorted(by: { s1, s2 in return s1 > s2 } )
```

当把闭包作为行内闭包表达式传递给函数，形式参数类型和返回类型都可以被推断出来。所以说，当闭包被用作函数的实际参数时你都不需要用完整格式来书写行内闭

**单表达式闭包隐式返回**

单表达式闭包能够通过从它们的声明中删掉 return 关键字来隐式返回它们单个表达式的结果
```
reversedNames = names.sorted(by: { s1, s2 in s1 > s2 } )
```

**简写的实际参数名**

Swift 自动对行内闭包提供简写实际参数名，你也可以通过 $0 , $1 , $2 等名字来引用闭包的实际参数值

如果你在闭包表达式中使用这些简写实际参数名，那么你可以在闭包的实际参数列表中忽略对其的定义，并且简写实际参数名的数字和类型将会从期望的函数类型中推断出来。 in  关键字也能被省略

```
reversedNames = names.sorted(by: { $0 > $1 } )
```

#### 尾随闭包

如果你需要将一个很长的闭包表达式作为函数最后一个实际参数传递给函数，使用尾随闭包将增强函数的可读性。尾随闭包是一个被书写在函数形式参数的括号外面（后面）的闭包表达式：

```
reversedNames = names.sorted() { $0 > $1 }
  
```

**如果闭包表达式被用作函数唯一的实际参数并且你把闭包表达式用作尾随闭包，那么调用这个函数的时候你就不需要在函数的名字后面写一对圆括号 ( )。**

```
reversedNames = names.sorted { $0 > $1 }
```

### 捕获值 

一个闭包能够从上下文捕获已被定义的常量和变量。即使定义这些常量和变量的原作用域已经不存在，闭包仍能够在其函数体内引用和修改这些值。

在 Swift 中，一个能够捕获值的闭包最简单的模型是内嵌函数，即被书写在另一个函数的内部。一个内嵌函数能够捕获外部函数的实际参数并且能够捕获任何在外部函数的内部定义了的常量与变量

```
func makeIncrementer(forIncrement amount: Int) -> () -> Int {
    var runningTotal = 0
    func incrementer() -> Int {
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}

let incrementByTen = makeIncrementer(forIncrement: 10)
incrementByTen()
//return a value of 10
incrementByTen()
//return a value of 20
incrementByTen()
//return a value of 30

```

### 逃逸闭包

当闭包作为一个实际参数传递给一个函数的时候，我们就说这个闭包逃逸了，因为它可以在函数返回之后被调用。当你声明一个接受闭包作为形式参数的函数时，你可以在形式参数前写 `@escaping `来明确闭包是允许逃逸的。

闭包可以逃逸的一种方法是被储存在定义于函数外的变量里。比如说，很多函数接收闭包实际参数来作为启动异步任务的回调。函数在启动任务后返回，但是闭包要直到任务完成——闭包需要逃逸

```
var completionHandlers: [() -> Void] = []
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    completionHandlers.append(completionHandler)
}
```