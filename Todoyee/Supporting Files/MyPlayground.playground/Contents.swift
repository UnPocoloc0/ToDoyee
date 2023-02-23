import UIKit
// Defaults are a Singleton
let defaults = UserDefaults.standard

let dictionaryKey = "myDictionary"
defaults.set(0.24, forKey: "Volume")
defaults.set(true, forKey: "MusicOn")
defaults.set(Date(), forKey: "String")
defaults.set(Date(), forKey: "ApplastOpenedByUser")
let array = [1, 2, 3]
defaults.set(array, forKey: "myArray")
let dicitonary = ["name" : "Simeon"]
defaults.set(dicitonary, forKey: dictionaryKey)


let volume = defaults.float(forKey: "Volume")
let appLastOpen = defaults.object(forKey: "ApplastOpenedByUser")
let myArray = defaults.array(forKey: "myArray") as! [Int]
let myDictionary = defaults.dictionary(forKey: dictionaryKey)
