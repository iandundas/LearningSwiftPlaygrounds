//: Playground - noun: a place where people can play

import UIKit

// MARK global functions:
func findIndexOfString(string: String, array: [String]) -> Int? {
    for(index,value) in array.enumerate(){
        if (value == string){
            return index
        }
    }
    return nil;
}

// MARK creating a string and enumerating it

let array = ["Ian", "Ben", "Elisabeth"]
var newArray = [String]()

// MARK loop through an array:
for(index, value) in array.enumerate(){
    newArray.append(value)
}
newArray


// MARK optional binding example
let index: Int? = findIndexOfString("Ian", array: ["Ben", "Ian"])

// If we can unwrap index here:
if let indexValue = index{
    "yep, index is \(indexValue)"
}
else{
    "nope"
}




// MARK setup some classes
class Address {
    var buildingNumber: String?
    var streetName: String?
    var apartmentNumber: String?
}
class Residence {
    var address: Address?
}
class Person{
    // weak var home: Apartment? // e.g. weak reference. These must be optional and mutable because could be set to nil at any time
    // unowned let holder: Person // alternative to weak, ensures the object stays around without officially 'owning' it - for referencing a sibling object, i.e. they share an owning parent.
    var residence: Residence?
}

// MARK initialise a person:
let person = Person()
let residence = Residence()
let address = Address()
address.buildingNumber = "123"
address.streetName = "Main St."

residence.address = address
person.residence = residence

// MARK optional chaining
if let addressNumber = person.residence?.address?.buildingNumber {
    var addressNumberInt = Int(addressNumber)
}

//if let addressNumber = person.residence?.address?.buildingNumber?.toInt() {
//    addressNumber // we have address number now
//}



// MARK initialisation rules

// every value must be initialized before it is used.

var message: String // must be initialised *before it is used*, but doesn't necessarily need to be here.

// Struct initialisation experiments:
struct Color {
    let red, green, blue : Double // will inject an initialiser like Color(red: 1.3, green: 0.3, blue: 5.2)
    //  let red : Double = 0.5, green : Double = 0.0, blue : Double = 0.0 // default values, no default initialiser
    
    //    init (grayScale: Double){
    //        green = grayScale
    //        blue = grayScale
    //        red = grayScale
    //    }
}


let magenta = Color(red: 1.3, green: 0.3, blue: 5.2)
let redshade = magenta.red
"\(redshade)"

// or even like this:
let lightStruct = ("Ian", "Test")
lightStruct.0
lightStruct


// Class initialisation experiments:

class Car{
    var paintColor: Color
    init(color: Color) {
        paintColor = color
    }
    
    func fillGasTank(){}
}

class RaceCar: Car{
    var hasTurbo: Bool
    
    init(color: Color, turbo: Bool){
        hasTurbo = turbo
        super.init(color: color)
    }
    
    override func fillGasTank() {
        // overriding
    }
    
    // convenience initialisers can only call sideways
    // - either to another convenience initialiser,
    // - or to this class's designated initialiser
    
    override convenience init(color: Color){ // override convenience because is overriding Car's init
        self.init(color: color, turbo: true)
    }
    convenience init(){
        self.init(color: Color(red:1.5, green: 2.0, blue: 4.5))
    }
}

class FormulaOne: RaceCar{
    let minimumWeight = 642
    
    // we'd inherit the initialisers here from the superclass because we've given default values to all new variables (minimumWeight)
    
    // however we need to override convenience init(color: Color) from above, because no Turbo allowed for F1
    
    // providing this means the superclass's inits are now missing from this class
    init(color: Color){
        super.init(color: color, turbo: false)
    }
}



// MARK Lazy Properties
// e.g.

class Game {
    lazy var multiplayerManager = String() // only created when it's actually accessed
}

// MARK deinitialisers:
class FileHandle{
    let fileDescriptor: String
    init(path:String){
        fileDescriptor = path // i.e. openFile(path)
    }
    deinit{ // cool
        //        closeFile(fileDescriptor)
    }
}


// MARK Closures:

// sort in place:
var clients = ["Pestov", "Test", "ian"]
clients.sortInPlace { (a: String, b: String) -> Bool in
    return a > b
}
clients

// NOTE sort is now immutable - see sortInPlace instead.

var clients2 = clients.sort { (a: String, b: String) -> Bool in
    return a > b
}

// more concise:
clients.sort {
    return $0 < $1
}

// super concise:
var reversed = clients.sort {$0 > $1}

// can even just pass in an external function:
func backwards(s1: String, s2: String) -> Bool{
    return s1 > s2;
}
clients.sort(backwards)


// sort immutably (better)
let permanentClients = ["Apple", "Google"]

// Swift 1.2:
//let sortedPermanentClients = sorted(permanentClients, { (a: String, b: String) -> Bool in
//    return a < b
//})

let sortedPermanentClients = permanentClients.sort({ (a: String, b: String) -> Bool in
    return a < b
})


// more concise:
let sortedPermanentClientsB = permanentClients.sort({ a, b in
    a < b
})

// or even more consise:
let sortedPermanentClientsC = permanentClients.sort { a, b in a < b }

// or even more consise:
let sortedPermanentClientsD = permanentClients.sort { $0 < $1 }


let nums = [1,2,3,4,5,6]
var result = nums.reduce(0, combine: { (current, next) -> Int in
    current+next
})

// more concise:
result = nums.reduce(0, combine: {$0+$1})
result


// There's only one kind of method in Swift, so this is possible:
// so this:
//nums.map {println($0)}
// can even become this:
//nums.map(println)


// MARK weakself

// How to do weakSelf in a closure:
//    { [unowned self] temp in
//        self.currentTemp = temp
//    }




// MARK Enums:

enum TrainStatus {
    case OnTime
    case Delayed(Int)
}

let t = TrainStatus.Delayed(10)
// MARK Pattern Matching:

switch(t){
case .OnTime:
    "awesome"
case .Delayed(let minutes) where 0...5 ~= minutes:
    "just a little delay of \(minutes) minutes"
case .Delayed(let minutes):
    "damn, late by \(minutes)"
}


// Pattern Matching base on Type:

func tuneUp(car: Car){
    switch car {
    case let formulaOne as FormulaOne:
        formulaOne.fillGasTank()
        fallthrough // also do next block too.
    default:
        "Fill the gas tank"
    }
}



let color = (1.0, 1.0, 1.0, 1.0)
switch(color){
case (0.0, 0.5...1.0, let blue, _):
    "here with blue: \(blue)"
case let (r,g,b,1.0) where r==g && g==b:
    "monochrome"
default: ()
}



// MARK global functions

// They now have argument labels, which can be used in different ways:

//func saveStateA(_ name: String, encrypt encrypt:Bool){
//    name
//    encrypt
//}
//saveStateA("Ian", encrypt: true)

func saveStateB(name name: String, encrypt: Bool){
    name
    encrypt
}
saveStateB(name: "Ben", encrypt: true)

func saveStateC(name : String, _ encrypt : Bool){
    name
    encrypt
}
saveStateC("Ian", true)



// MARK String functions:
"Ian".characters.count // Counting size of string



// MARK other magic

func doStuff(){
    print("Checkpoint 2")
    defer { print("Do clean up here") } // Called at the end of the method, no matter what (including Exceptions)
    print("Checkpoint 3")
}
