//
//  AIBrain.swift
//  Hangman
//
//  Created by Andrey Isachenko on 05/03/2017.
//  Copyright © 2017 University of Groningen. All rights reserved.
//

import Foundation

class AIBrain {
    
    var usedLetters = ""
    var goodLetters = ""
    var wordRepresentation = ""
    var possibleLetters = "qwertyuiopasdfghjklzxcvbnm"
    
    func getLetter() -> Character {        
        while true {
            let index:Int = Int(arc4random_uniform(UInt32(possibleLetters.characters.count)))
            let letter = possibleLetters.characters[possibleLetters.index(possibleLetters.startIndex, offsetBy: index)]
            if !usedLetters.contains(String(letter)) {
                usedLetters.append(letter)
                return letter
            }
        }
        
    }
}
