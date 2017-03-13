

import UIKit

class SignUpViewController: UIViewController {
 
    @IBOutlet weak var mainLogo: UIImageView!
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var welcomeTitle: UILabel!
    @IBOutlet weak var enterNameTitle: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var confirmButton: roundButton!
    @IBOutlet weak var startButton: roundButton!
    
    var foundname: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainLogo.alpha = 0
        mainTitle.alpha = 0
        welcomeTitle.alpha = 0
        enterNameTitle.alpha = 0
        nameTextField.alpha = 0
        confirmButton.alpha = 0
        startButton.alpha = 0
        
        
        
       

     /*
         
       var userName: String=""
       let filename="info"
        let DocumentDirUrl = try! FileManager.default.url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = DocumentDirUrl.appendingPathComponent(filename).appendingPathExtension(".txt")
        do{
            userName = try String(contentsOf: fileURL)
            if(userName == "")
            {foundname = false
                
                
            }else{
                foundname = true
                
            }
            
        }catch let error as NSError{
            print("Failed to read from URL")
            print(error)
           
        }
        */
        
        viewDidApear()


    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 func viewDidApear ()
    {
        
        UIView.animate(withDuration: 1, animations: {
            self.mainLogo.alpha = 1
        }) { (true) in
            self.loadTitle()
        }
            
    }
 
    @IBAction func acceptedName(_ sender: Any) {
        UIView.animate(withDuration: 1, animations: {
            self.startButton.alpha = 1
        }) 
    }
func loadwelcome(){
    UIView.animate(withDuration: 1, animations: {
        self.welcomeTitle.text = "Welcome"
        self.welcomeTitle.alpha = 1
    }) { (true) in
        self.loadTitle()
    }
}
    func loadTitle(){
        UIView.animate(withDuration: 1, animations: {
            self.mainTitle.alpha = 1
        }) { (true) in
            if (self.foundname == true){
                self.loadwelcome()
                print("True")
            }else{
                self.loadEnterinfo()
                print("false")
            }
        }
    }
    
func loadEnterinfo(){
    UIView.animate(withDuration: 1, animations: {
        self.enterNameTitle.alpha = 1
           self.nameTextField.alpha = 1
           self.confirmButton.alpha = 1
    })
    
}
    
    
   func writeFile()
   {
    let filename="info"
    let DocumentDirUrl = try! FileManager.default.url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    let fileURL = DocumentDirUrl.appendingPathComponent(filename).appendingPathExtension(".txt")
    print("filepath: \(fileURL.path)")
    
    do{
        let username = nameTextField.text
        //writing to the file
        try username!.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
        
    }catch let error as NSError{
       print("Failed to write to URL")
        print(error)
    }
    
    }

 
    
    
    
}
