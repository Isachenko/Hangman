

import UIKit

@IBDesignable
class roundButton: UIButton {

    @IBInspectable var cornorRadius : CGFloat = 0 {
        didSet{
            self.layer.cornerRadius = cornorRadius
        }
    }
    @IBInspectable var borderWidth : CGFloat = 0 {
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor : UIColor = UIColor.clear {
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
}
