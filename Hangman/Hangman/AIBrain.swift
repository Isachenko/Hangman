//
//  AIBrain.swift
//  Hangman
//
//  Created by Andrey Isachenko on 05/03/2017.
//  Copyright © 2017 University of Groningen. All rights reserved.
//

import Foundation

class AIBrain {
    var historyChunks: [String:Int] = [ "LA" : 10,
                                        "LB" : 0,
                                        "LC" : 0,
                                        "LD" : 0,
                                        "LE" : 0,
                                        "LF" : 0,
                                        "LG" : 0,
                                        "LH" : 0,
                                        "LI" : 0,
                                        "LJ" : 0,
                                        "LK" : 0,
                                        "LL" : 0,
                                        "LM" : 0,
                                        "LN" : 10,
                                        "LO" : 0,
                                        "LP" : 0,
                                        "LQ" : 0,
                                        "LR" : 10,
                                        "LS" : 10,
                                        "LT" : 0,
                                        "LU" : 0,
                                        "LV" : 0,
                                        "LW" : 0,
                                        "LX" : 0,
                                        "LY" : 0,
                                        "LZ" : 0]

    var usedLetters = ""
    var goodLetters = ""
    var wordRepresentation = ""
    var possibleLetters = "qwertyuiopasdfghjklzxcvbnm"
    var possibleWordBool = false
    var possibleWordString = ""
    var sizeOfHiddenWord = Int()
    var wrongLettersDict = [Character]()
    var rightLettersDict = [Character]()
    var flag = true
    
    var actrAI : Model
    
    init() {
        actrAI = Model()
        actrAI.loadModel(fileName: "hangman")
        chargeMemoryPreviousGamesInActr()
    }
    
    func getRandomLetter() -> Character {
        while true {
            let index:Int = Int(arc4random_uniform(UInt32(possibleLetters.characters.count)))
            let letter = possibleLetters.characters[possibleLetters.index(possibleLetters.startIndex, offsetBy: index)]
            if !usedLetters.contains(String(letter)) {
                usedLetters.append(letter)
                return letter
            }
        }
    }

    
    func getLetter() -> Character {
        //return getRandomLetter()
//        flag = true
        actrAI.run()
        return actrAI.lastAction("choice")!.characters.first!
    }
    
    func getLetterFromWord() -> Character {
        print("getLetterFromWord")
        //        for character in possibleWordString.characters {
        //            if( (possibleWordString.characters.count == sizeOfHiddenWord) && rightLettersDict.contains(character)){
        //                print("Caracter de la posible palabra")
        //                let aux = "L" + String(character).capitalized
        //                actrAI.dm.chunks[aux]?.setSlot(slot: "used", value: "true")
        //                setPossibleWordBool(state: true)
        //                return character
        //
        //            }
        //            if(wrongLettersDict.contains(character)){
        //                setPossibleWordBool(state: false)
        //                break
        //            }
        //        }
        for character in possibleWordString.characters {
            if(!rightLettersDict.contains(character)){
                print("Got one letter from word")
                print(rightLettersDict)
                print(character)
                return character
            }
        }
        possibleWordBool = false
        return getRandomLetter()
        
    }
    
    func getGuessWord()-> (String){
        let possibleWord = getGuessWordACTR()
        let aux = checkLettersInWord(possibleWord: possibleWord)
        if(aux){
            possibleWordBool = true
            setPossibleWordString(word: possibleWord)
            return(possibleWordString)
        }
        possibleWordBool = false
        return ("No right")
    }
    
    func getGuessWordACTR() -> String {
//        if (!flag){
//            actrAI.run()
//            print("Run flag")
//        }
//        flag = false
        actrAI.run()
        print("Letras usadas")
        print(usedLetters)
        let aux = actrAI.lastAction("guessWord")!
        print(aux)
        return aux
        
    }
    func setUsedLetters(letter: String){
        usedLetters.append(letter)
    }
    func resetLetrasUsadas(){
        
    }
    func setPossibleWordBool(state: Bool){
        possibleWordBool = state
    }
    func getPossibleWordBool()->Bool{
        return possibleWordBool
    }
    func setTheSizeOfHiddenWord(size: Int){
        sizeOfHiddenWord = size
        
    }
    func setPossibleWordString(word: String){
        possibleWordString = word
        print("setPossibleWordString")
        print(setPossibleWordString)
    }
    func checkLettersInWord(possibleWord: String)->Bool{
        var isCorrect = true
        print("Size of the words")
        print(possibleWord)
        print(possibleWord.characters.count)
        print(sizeOfHiddenWord)
        if(!(possibleWord.characters.count == sizeOfHiddenWord)) {
            isCorrect = false
        }
        for character in possibleWord.characters {
            if(wrongLettersDict.contains(character)){
                isCorrect = false
            }
        }
        return isCorrect
    }
    
    func updateDictWrongLetters(dictionary: [Character]){
        print("Wrong letters dictionary")
        print(dictionary)
        wrongLettersDict = dictionary
    }
    func updateDictRightLetters(dictionary: [Character]){
        print("Right letters dictionary")
        print(dictionary)
        rightLettersDict = dictionary
    }
    func resetDictionaries(){
        print("Reset dictionaries and variables")
        rightLettersDict = [Character]()
        wrongLettersDict = [Character]()
        usedLetters = ""
        possibleWordBool = false
    }
    
    func setFeedback(value: String, enoughtLettersToGuessed: Bool, firstLetterKnown: Bool, firstLetter: String, wordSize: String) {
        print("Aqui está el feedback")
        print(value, enoughtLettersToGuessed, firstLetterKnown, firstLetter, wordSize)
        actrAI.modifyLastAction(slot: "feedback", value: value)
        actrAI.modifyLastAction(slot: "enoughtLettersToGuessed", value: String(enoughtLettersToGuessed) )
        actrAI.modifyLastAction(slot: "firstLetterKnown", value: String(firstLetterKnown))
        actrAI.modifyLastAction(slot: "firstLetter", value: firstLetter)
        actrAI.modifyLastAction(slot: "wordSize", value: wordSize)
    }
    
    func restoreChunkUsedValue(){
        for (key) in actrAI.dm.chunks {
            if (key.key.characters.first!.description == "L"){
                actrAI.dm.chunks[key.key]?.setSlot(slot: "used", value: "false")
            }
            if (key.key.characters.first!.description == "w"){
                actrAI.dm.chunks[key.key]?.setSlot(slot: "used", value: "false")
            }
        }
    }
    func printSpreadActivationChunks(){
        for (key) in actrAI.dm.chunks {
            if (key.key.characters.first!.description == "w"){
                print(actrAI.dm.chunks[key.key]?.spreadingActivation() ?? "Error")
                
            }
        }
        
    }
    func memorizeLetter(letter: Character){
        let aux = "L" + letter.description.capitalized
        historyChunks[aux] = historyChunks[aux]!+1
        print(historyChunks)
        
        
    }
    
    func storePreviousGamesChunks(){
        UserDefaults.standard.setValue(historyChunks, forKey: "previousGames")
    }
    
    func chargeMemoryPreviousGamesInActr(){
        if ( UserDefaults.standard.value(forKey: "previousGames") != nil){
            historyChunks = UserDefaults.standard.value(forKey: "previousGames")! as? [String : Int] ?? [String : Int]()
        }
        for (key) in actrAI.dm.chunks {
            if (key.key.characters.first!.description == "L"){
            print(key.key)
            print(historyChunks)
            print(historyChunks[key.key] ?? "Error")
            actrAI.dm.chunks[key.key]?.setBaseLevel(timeDiff: -100, references: historyChunks[key.key]!)
            }
        
        }

    }
    
}
