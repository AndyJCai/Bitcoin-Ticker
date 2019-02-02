//
//  LoadNameVController.swift
//  BitcoinTicker
//
//  Created by Andy Cai on 1/30/19.
//

import UIKit
import Foundation


class LoadNameVController: UIViewController {
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var enterName: UITextField!
    
    @IBAction func onClick(_ sender: Any) {
        if let text = enterName.text, !text.trimmingCharacters(in: .whitespaces).isEmpty{
            //Checks if the text is empty or filled with white spaces, if not, proceed
            saveDataToPlist(object: text) //saves data to Info.plist
            performSegue(withIdentifier: "goToBitCoin", sender: self) //performs Segue to the
        }
        else
        {
            //if the space is still empty, prompt the alert
            alertNoName()
        }
    }
    
    //Saves username to Info.plist
    func saveDataToPlist(object: String)
    {
        self.defaults.set(object, forKey: "UserName")
    }
    
    //prepares for segue transitioning to the Bitcoin page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        _ = segue.destination as! ViewController
    }
    
    //MARK: Textfield Delegate
    // When user press the return key in keyboard, resigns keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //
    override func viewDidLoad() {
        if defaults.string(forKey: "UserName") != nil
            //Check if the user has already entered their name, if yes, goes to the BitCoin page.
        {
            performSegue(withIdentifier: "goToBitCoin", sender: self)
        }
        okButton.layer.cornerRadius = 10 //renders the OK button corners round
        okButton.clipsToBounds = true //same as above
    }
    
    
    //alert the user that they have not entered a name
    func alertNoName() {
        let alert = UIAlertController(title: "No Name Entered!", message: "Please enter your name to enter the next page!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            }}))
        self.present(alert, animated: true, completion: nil)
    }
}
