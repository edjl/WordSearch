//
//  LetterModel.swift
//  WordSearch
//
//  Created by Edward Lee on 2020-08-27.
//  Copyright © 2020 Edward Lee. All rights reserved.
//


import Foundation

class LetterModel {
    var allowedLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    var words = ["SWIFT", "KOTLIN", "OBJECTIVEC", "VARIABLE", "JAVA", "MOBILE"]
    
    func getLetters() -> [[Letter]] {
        
        var generatedLetters = [[Letter]]()
        
        // 10 x 10 grid of "."
        for _ in 0...9 {
            var row = [Letter]()
            for _ in 0...9 {
                let newLetter = Letter ()
                newLetter.letter = "."
                row.append(newLetter)
            }
            generatedLetters.append(row)
        }
        
        // Insert OBJECTIVEC
        generatedLetters = insertWord(grid: generatedLetters, originalWord: "OBJECTIVEC")
        
        // Insert VARIABLE
        generatedLetters = insertWord(grid: generatedLetters, originalWord: "VARIABLE")
        
        // Insert KOTLIN
        generatedLetters = insertWord(grid: generatedLetters, originalWord: "KOTLIN")
        
        // Insert MOBILE
        generatedLetters = insertWord(grid: generatedLetters, originalWord: "MOBILE")
        
        // Insert SWIFT
        generatedLetters = insertWord(grid: generatedLetters, originalWord: "SWIFT")
        
        // Insert JAVA
        generatedLetters = insertWord(grid: generatedLetters, originalWord: "JAVA")
        
        
        // Fills in the rest of the letters
        for y in 0...9 {
            for x in 0...9 {
                if (generatedLetters[x][y].letter == ".") {
                    let randomNum = Int.random(in: 0...25)
                    let index = allowedLetters.index(allowedLetters.startIndex, offsetBy: randomNum)
                    generatedLetters[x][y].letter = String(allowedLetters[index])
                }
            }
        }
        
        return generatedLetters
    }
    
    func insertWord(grid: [[Letter]], originalWord: String) -> [[Letter]] {
        var newGrid = grid
        var works = true
        var location = 0
        var word = ""
        
        repeat {
            works = true
            word = ""
            // Total number of possible locations a word can be in
            location = Int.random(in: 0...(11-originalWord.count)*10*2*2-1)
            
            // 50% chance of the word being reversed
            if (location >= (11-originalWord.count)*10*2) {
                location -= (11-originalWord.count)*10*2
                word = String(originalWord.reversed())
            }
            else {
                word = originalWord
            }
            
            if (location <= (11-originalWord.count)*10-1) {                                 // Horizontal
                for i in 0...originalWord.count-1 {
                    if (newGrid[location/(11-originalWord.count)][location%(11-originalWord.count)+i].letter != "." && newGrid[location/(11-originalWord.count)][location%(11-originalWord.count)+i].letter != String(word[word.index(word.startIndex,offsetBy: i)])) {
                        works = false
                        break
                    }
                }
                if (works) {
                    for i in 0...originalWord.count-1 {
                        let index = word.index(word.startIndex, offsetBy: i)
                        let newLetter = Letter ()
                        newLetter.letter = String(word[index])
                        newGrid[location/(11-originalWord.count)][location%(11-originalWord.count)+i] = newLetter
                    }
                }
            }
            else if (location <= (11-originalWord.count)*10*2-1) {                          // Vertical
                location -= (11-originalWord.count)*10
                for i in 0...originalWord.count-1 {
                    if (newGrid[location%(11-originalWord.count)+i][location/(11-originalWord.count)].letter != "." && newGrid[location%(11-originalWord.count)+i][location/(11-originalWord.count)].letter != String(word[word.index(word.startIndex,offsetBy: i)])) {
                        works = false
                        break
                    }
                }
                if (works) {
                    for i in 0...originalWord.count-1 {
                        let index = word.index(word.startIndex, offsetBy: i)
                        let newLetter = Letter ()
                        newLetter.letter = String(word[index])
                        newGrid[location%(11-originalWord.count)+i][location/(11-originalWord.count)] = newLetter
                    }
                }
            }
            
        } while(!works);
        
        return newGrid
    }
}
