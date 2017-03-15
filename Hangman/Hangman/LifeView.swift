//
//  LifeView.swift
//  Hangman
//
//  Created by Andrey Isachenko on 26/02/2017.
//  Copyright © 2017 University of Groningen. All rights reserved.
//

import UIKit

@IBDesignable
class LifeView: UIView {

    @IBInspectable
    private var maxLife: Int = 5 { didSet { self.setNeedsDisplay() } }
    @IBInspectable
    private var currentLife: Int = 3 { didSet { self.setNeedsDisplay() } }
    
    private func getPathForLife(index: Int) -> UIBezierPath{
        let radius = min(bounds.size.height, bounds.size.width / CGFloat(maxLife)) / 2
        let center = CGPoint(x: ((bounds.size.width / CGFloat(maxLife))*CGFloat(index)) + radius, y: radius)
        
        let life = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2*CGFloat(M_PI), clockwise:
            true)
        
        
        
        
        life.lineWidth = 1
        #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).set()
        life.fill()
        return life
    }
    
    
    
    
    
    override func draw(_ rect: CGRect) {
        for i in 0..<maxLife {
            let life = getPathForLife(index: i)
            if i < currentLife {
                
                #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1).set()
                life.fill()
            }
            #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).set()
            life.stroke()
        }
    }
    
    var max : Int{
        set {
            maxLife = newValue
        }
        get {
            return maxLife
        }
    }
    var cur: Int {
        set {
            currentLife = newValue
        }
        get {
            return currentLife
        }
    }
 

}
