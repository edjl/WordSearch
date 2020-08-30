//
//  ViewController.swift
//  WordSearchGame
//
//  Created by Edward Lee on 2020-08-27.
//  Copyright © 2020 Edward Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var swiftWord: UILabel!
    @IBOutlet weak var kotlinWord: UILabel!
    @IBOutlet weak var objectivecWord: UILabel!
    @IBOutlet weak var variableWord: UILabel!
    @IBOutlet weak var javaWord: UILabel!
    @IBOutlet weak var mobileWord: UILabel!
    @IBOutlet weak var wordsFound: UILabel!
    
    let model = LetterModel()
    var grid = [[Letter]]()
    var line = [[Int]]()
    var direction = [Int]()
    var found = [false, false, false, false, false, false]
    var foundNum = 0
    var xCo = 0.0, yCo = 0.0, sideLength = 0.0, perUnit = Float(0.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        grid = model.getLetters()
        
        // Set the view controller as the data source and delegate of the collection view
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let card = UIView()
        collectionView.addSubview(card)
        collectionView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture)))
        
        xCo = Double(collectionView.frame.minX)
        yCo = Double(collectionView.frame.minY)
        sideLength = Double(collectionView.frame.width)
        perUnit = Float(sideLength / 10)
    }
    
    // If the user is swiping/panning
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self.view)
        let x = Float(location.x)
        let y = Float(location.y)-Float(yCo)
        
        if (gesture.state == .began) {
            direction = []
            line.removeAll()
            var coordinates = [Int]()
            coordinates.append(Int(x/perUnit))
            coordinates.append(Int(y/perUnit))
            line.append(coordinates)
            
            grid[coordinates[1]][coordinates[0]].selected = true
            collectionView.reloadData()
        }
        else if (gesture.state == .changed && [Int(x/perUnit),Int(y/perUnit)] != line[line.endIndex-1]) {
            if (direction == []) {
                direction.append(Int(x/perUnit) - line[line.endIndex-1][0])
                direction.append(Int(y/perUnit) - line[line.endIndex-1][1])
            }
            else if (direction != [Int(x/perUnit) - line[line.endIndex-1][0], Int(y/perUnit) - line[line.endIndex-1][1]]) {
                return
            }
            
            var coordinates = [Int]()
            coordinates.append (Int(x/perUnit))
            coordinates.append (Int(y/perUnit))
            line.append(coordinates)
            
            grid[coordinates[1]][coordinates[0]].selected = true
            collectionView.reloadData()
            
        }
        else if (gesture.state == .ended) {
            checkIfFound()
            
            for coordinates in line {
                grid[coordinates[1]][coordinates[0]].selected = false
            }
            collectionView.reloadData()
            
            checkForWin()
        }
    }
    
    func checkIfFound() {
        var word = ""
        for coordinates in line {
            word += grid[coordinates[1]][coordinates[0]].letter
        }
        
        for i in 0...5 {
            if (word == model.words[i] && !found[i]) {
                found[i] = true
                
                matched()
                
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: model.words[i])
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                if (i == 0) {
                    swiftWord.attributedText = attributeString
                }
                else if (i == 1) {
                    kotlinWord.attributedText = attributeString
                }
                else if (i == 2) {
                    objectivecWord.attributedText = attributeString
                }
                else if (i == 3) {
                    variableWord.attributedText = attributeString
                }
                else if (i == 4) {
                    javaWord.attributedText = attributeString
                }
                else if (i == 5) {
                    mobileWord.attributedText = attributeString
                }
                break
            }
        }
    }
    
    func matched() {
        for coordinates in line {
            grid[coordinates[1]][coordinates[0]].matched = true
        }
        foundNum += 1
        wordsFound.text = "Total Words Found: "+String(foundNum)
    }
    
    func checkForWin() {
        for i in 0...5 {
            if (!found[i]) {
                return
            }
        }
        
        let alert = UIAlertController(title: "You Won!", message: "Congratulations! You found all 6 words!", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        let againAction = UIAlertAction(title: "Play Again", style: .cancel) { (againAction) in
            self.again()
        }
        alert.addAction(againAction)
        alert.addAction(okayAction)
        present(alert, animated:true, completion:nil)
    }
    
    // Resetting everything to play again
    func again() {
        grid = model.getLetters()
        found = [false, false, false, false, false, false]
        foundNum = 0
        wordsFound.text = "Total Words Found: 0"
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, 0))
        swiftWord.attributedText = attributeString
        kotlinWord.attributedText = attributeString
        objectivecWord.attributedText = attributeString
        variableWord.attributedText = attributeString
        javaWord.attributedText = attributeString
        mobileWord.attributedText = attributeString
        
        swiftWord.text = "SWIFT"
        kotlinWord.text = "KOTLIN"
        objectivecWord.text = "OBJECTIVEC"
        variableWord.text = "VARIABLE"
        javaWord.text = "JAVA"
        mobileWord.text = "MOBILE"
        
        collectionView.reloadData()
    }

    // MARK: - Collection View Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LetterCell", for: indexPath) as! LetterCollectionViewCell
        
        cell.configureCell(letter: grid[indexPath.row/10][indexPath.row%10], grid[indexPath.row/10][indexPath.row%10].matched, grid[indexPath.row/10][indexPath.row%10].selected)
        
        
        return cell
    }
}

