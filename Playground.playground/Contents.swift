//: Playground - noun: a place where people can play

import UIKit
import Interstellar

enum InterstellarError: ErrorType {
    case Error
}

enum Result<T> {
    case Success(T)
    case Error(InterstellarError)
    
    // Below we extend our Result<T> type to support a map function:
    //    func map<U>(f: T -> U) -> Result<U> {
    //        switch self {
    //        case let .Success(value):
    //            return .Success(f(value))
    //        case let .Error(error):
    //            return .Error(error)
    //        }
    //    }
    
    // this version of map takes an async non failing transform and returns a function that can be invoked with a completion block to get the result when it is completed (see example below)
    func map<U>(f:(T, (U -> Void)) -> Void) -> (Result<U> -> Void) -> Void { return { g in
            switch self {
            case let .Success(value): f(value){ transformed in
                g(.Success(transformed))
                }
            case let .Error(error): g(.Error(error))
            }
        }
    }
}

// The example:
func toHash(array: [String], completion: Int -> Void) {
    completion(array.count)
}

toHash(["Batman", "Superman", "Aquaman"]) { (number) -> Void in
    print(number) // 3
}

// result has the is now .Success of type Int with the value 3
Result.Success(["Batman", "Superman", "Aquaman"]).map(toHash)() { result in
    print(result) // Success(3)
}

// Simple example of using our Result<T> type:
func addOne(x: Int?) -> Result<Bool> {
    guard let x = x where x == 1 else {
        return .Error(InterstellarError.Error)
    }
    return .Success(true)
}

// We handle the the Result<T> type below:
switch addOne(12) {
case let .Success(value):
    print(value)
case let .Error(error):
    print(error)
}

