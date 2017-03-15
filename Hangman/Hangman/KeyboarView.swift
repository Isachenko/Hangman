//
//  KeyboarView.swift
//  Hangman
//
//  Created by Andrey Isachenko on 26/02/2017.
//  Copyright © 2017 University of Groningen. All rights reserved.
//

import UIKit

protocol KeyboardDelegate {
    func letterClicked(letter: Character)
}

@IBDesignable
class KeyboardView: UIView {
    
    var delegate: KeyboardDelegate?
    
    var firstLineLetters = "QWERTYUIOP"
    var secondLineLetters = "ASDFGHJKL"
    var thirdLineLetters = "ZXCVBNM"
    var hightlightedLetters = ""
    
    //override init(){
    //    super.init()
    //}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addComponents()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        addComponents()
    }
    func getButtons(for letters: String) -> [UIButton] {
        //generate an array of buttons
        var buttonArray = [UIButton]()
        for letter in letters.characters {
            let button = UIButton(type: .system)
            //button.backgroundColor = .
            button.setTitle(String(letter), for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.setTitle(String(letter), for: UIControlState.normal)
            buttonArray += [button]
            button.addTarget(self, action: #selector(KeyboardView.letterClicked(_:)), for: .touchUpInside)
            button.backgroundColor = UIColor.black
            button.setTitleColor(UIColor.white, for: UIControlState.normal)
        }
        return buttonArray
    }
    
    private func getStack(for letters: String) -> UIStackView{
        let stackView = UIStackView(arrangedSubviews: getButtons(for: letters))
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 1
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }
    
    private func addComponents() {
        
        print("hi")
        
        //let segmentedControl = UISegmentedControl(items: ["Tweets", "Media", "Likes"])
        //self.addSubview(segmentedControl)
        
        let linesViews = [getStack(for: firstLineLetters), getStack(for: secondLineLetters), getStack(for: thirdLineLetters)]
        //let stackView = getStack(for: firstLineLetters)
        let stackView = UIStackView(arrangedSubviews: linesViews)
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        
        let viewsDictionary = ["stackView":stackView]
        let stackView_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[stackView]-5-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        let stackView_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[stackView]-5-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: viewsDictionary)
        self.addConstraints(stackView_H)
        self.addConstraints(stackView_V)
    }
    
    func letterClicked(_ sender: UIButton?) {
        delegate?.letterClicked(letter: (sender?.currentTitle)!.characters.first!)
    }
}
