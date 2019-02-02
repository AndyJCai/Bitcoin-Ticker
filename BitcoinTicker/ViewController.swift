//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Andy Cai on 1/30/19.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let defaults = UserDefaults.standard
    
    let apiURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencies = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbols = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = ""
    var currencyType = ""

    //Pre-setup IBOutlets
    @IBOutlet weak var userGreeting: UITextView!
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self //set the currency PickerView's delegate to self
        currencyPicker.dataSource = self //set the currency Picker's data source to self
        userGreeting.text = "Hello, "+defaults.string(forKey: "UserName")! //change the greetings sign to "Hello username"
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = apiURL+currencies[row] //Get the url to the selected currency row
        currencyType = currencySymbols[row] //change currency symbol
        getBitcoinData(url: finalURL) //pull Bitcoin data from API website
    }
    
    
    
    //Use Alamofire to request url and get the JSON data from API website
    func getBitcoinData(url: String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {

                    print("Bitcoin data retrieved!")
                    let BitcoinJSON : JSON = JSON(response.result.value!)

                    self.updateBitcoinData(json: BitcoinJSON)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }
    
    
    //JSON Parsing to update bitcoin data
    //If data not available, label changes to "Price Unavailable"
    
    func updateBitcoinData(json : JSON) {
        
        if let bitcoinResult = json["ask"].double {
            bitcoinPriceLabel.text = String(bitcoinResult)+currencyType
        } else {
            bitcoinPriceLabel.text = "Price Unavailable"
        }
    }
//
}

