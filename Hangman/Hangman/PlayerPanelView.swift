//
//  PlayerPanelView.swift
//  Hangman
//
//  Created by Andrey Isachenko on 04/03/2017.
//  Copyright © 2017 University of Groningen. All rights reserved.
//

import UIKit

protocol PlayerPanelViewDelegate {
    func letterClicked(letter: Character)
}

@IBDesignable
class PlayerPanelView: UIView, KeyboardDelegate {
    
    var delegate: PlayerPanelViewDelegate?
    
    var nameLabel = UILabel()
    var keyboardView = KeyboardView()
    var lifeView = LifeView()
    var wordLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addComponents()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        addComponents()
    }
    
    private func addComponents() {
        nameLabel.text = "player name"
        nameLabel.textColor = UIColor.white
        nameLabel.backgroundColor = UIColor.black
        nameLabel.textAlignment = .center
        
        
        wordLabel.text = "_____"
        wordLabel.textColor = UIColor.white
        wordLabel.backgroundColor = UIColor.black
        wordLabel.textAlignment =  .center
        
        keyboardView.delegate = self
        
        let subViews = [nameLabel as UIView, wordLabel as UIView, keyboardView as UIView, lifeView as UIView]
        let stackView = UIStackView(arrangedSubviews: subViews)
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 1
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        
        let viewsDictionary = ["stackView":stackView]
        let stackView_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[stackView]-5-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        let stackView_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[stackView]-5-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: viewsDictionary)
        self.addConstraints(stackView_H)
        self.addConstraints(stackView_V)
        
        lifeView.backgroundColor = UIColor.black
        lifeView.contentMode = .redraw
        keyboardView.backgroundColor = UIColor.black
        keyboardView.contentMode = .redraw
    }
    
    var word: String {
        get {
            return wordLabel.text!
        }
        set {
            wordLabel.text = newValue
        }
    }
    
    var name: String {
        get {
            return nameLabel.text!
        }
        set {
            nameLabel.text = newValue
        }
    }
    
    func letterClicked(letter: Character) {
        delegate?.letterClicked(letter: letter)
    }

}
