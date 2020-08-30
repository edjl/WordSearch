//
//  LetterCollectionViewCell.swift
//  WordSearchGame
//
//  Created by Edward Lee on 2020-08-27.
//  Copyright © 2020 Edward Lee. All rights reserved.
//

import UIKit

class LetterCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var letterView: UILabel!
    
    var letter:Letter?
    
    func configureCell(letter: Letter, _ found: Bool, _ touch: Bool) {
        
        self.letter = letter
        
        if (found) {
            letterView.textColor = UIColor.red
        }
        else {
            letterView.textColor = UIColor.white
        }
        if (touch) {
            letterView.backgroundColor = UIColor.green
        }
        else {
            letterView.backgroundColor = UIColor.clear
        }
        
        //Set the text to the letter it should be
        letterView.text = letter.letter
    }
}
