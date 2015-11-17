//: Playground - noun: a place where people can play

import Cocoa


/*
-------------------------------------------------
1.1) Pure Functions
-------------------------------------------------
*/

// Functional Approach:
func incrementFunctional(number: Int) -> Int {
    return number + 1
}

// Advantages: Easy to reason about; very limited
// amount of input and output; easy to test; easy to reuse

let a = incrementFunctional(4)

var b = 4

// Non-Functional Approach:

func incrementNonFunctional() -> () {
    b = b + 1
}

incrementNonFunctional()

a
b

/*
-------------------------------------------------
2.1) Declarative vs. Imperative
-------------------------------------------------
*/

enum BankAccountTransaction {
    case Deposit(Double)
    case Withdrawal(Double)
}

struct BankAccount {
    var transactions: [BankAccountTransaction] = []
    
    var balance: Double {
        get {
            return transactions.reduce(0.0) { balance, transaction in
                switch transaction {
                case .Deposit(let amount):
                    return balance + amount
                case .Withdrawal(let amount):
                    return balance - amount
                }
            }
        }
    }
}

var bankAccount = BankAccount()
var transactions: [BankAccountTransaction] = [.Deposit(100.00), .Withdrawal(32.00), .Deposit(42.00)]
bankAccount.transactions = transactions

print(bankAccount.balance)


/*
-------------------------------------------------
2.2) Declarative vs. Imperative
-------------------------------------------------
*/

var array1 = [1, 2, 3, 4, 5]
var sum = 0
// Imperative code
for (var i = 0; i < array1.count; i++) {
    array1[i] = array1[i] * 2
    sum += array1[i]
}
array1
sum


var array2 = [1, 2, 3, 4, 5]
// Describes Relationship
let result2 = array2.map { $0 * 2 }
let sum2 = result2.reduce(0) { $0 + $1 }
// Equivalent, more concise:
//let sum2 = result2.reduce(0, combine: +)
result2
sum2


/*
-------------------------------------------------
3.) Function Pipelining
-------------------------------------------------
*/

// Dummy implementation of real functions:

class User {}
class Trip {}

func login(username: String, password: String) -> User? {
    return User()
}

func fetchData(user: User) -> [String: AnyObject]? {
    return [:]
}

func parse(json: [String: AnyObject]) -> [Trip]? {
    return [Trip(), Trip(), Trip()]
}

// Simple and dangerous way to compose these functions would be:
//parse(fetchData(login("test", password:  "test")!)!)


// Thanks to: http://gilesvangruisen.com/writing-a-pipeline-operator-in-swift/

infix operator --> { associativity left }

func --><In, Out>(left: In?, fn: (In) -> (Out?)) -> Out? {
    
    if let arg = left {
        return fn(arg)
    } else {
        return nil
    }
    
}

// This is another example for declarative code:

let data = login("test", password: "test")
                --> fetchData
                --> parse

data

/*
-------------------------------------------------
4.) Currying
-------------------------------------------------
*/

func generateURL (logFile: String)(urlString: String) -> NSURL {
    logFile
    return NSURL(string: urlString)!
}

func downloadData(logFile: String)(url: NSURL) -> NSData {
    logFile
    return NSData()
}

let logfile = "log.txt"
let fGenerateURL = generateURL(logfile)
let fDownloadData = downloadData(logfile)

let downloadedFile = fGenerateURL(urlString: "www.amazon.com")
                        --> fDownloadData

downloadedFile


// Here's how you would implement currying yourself:
//func customCurriedFunction (logFile:String) -> (urlString: String) -> NSURL {
//    return { (urlString: String) -> NSURL in
//        print(logFile)
//        return NSURL(string: urlString)!
//    }
//}
//
//let curriedFunction = customCurriedFunction("log.txt")
//let url = curriedFunction(urlString: "amazon.com")
//url

