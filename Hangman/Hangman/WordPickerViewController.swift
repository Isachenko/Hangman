//
//  WordPickerViewController.swift
//  Hangman
//
//  Created by Andrey Isachenko on 26/02/2017.
//  Copyright © 2017 University of Groningen. All rights reserved.
//

import UIKit

protocol WordPickerViewControllerDelegate {
    func wordChosen(word: String)
}

class WordPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var delegate: WordPickerViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.picker.delegate = self
        self.picker.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var picker: UIPickerView!
    
    var pickerData: [String] = [String]()
    
    func setWords(words: [String]) {
        pickerData = words
    }
    
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    @IBAction func doneClicked(_ sender: UIButton) {
        if let del = delegate {
            del.wordChosen(word: pickerData[picker.selectedRow(inComponent: 0)])
        }
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
