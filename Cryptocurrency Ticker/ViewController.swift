//
//  ViewController.swift
//  Cryptocurrency Ticker
//
//  Created by liroy yarimi on 24.5.2018.
//  Copyright © 2018 Liroy Yarimi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/"
    
    let countryArray = ["🇺🇸 USD","🇮🇱 ILS", "🇧🇷 BRL","🇨🇦 CAD","🇨🇳 CNY","🇪🇺 EUR","🇬🇧 GBP","🇭🇰 HKD","🇮🇩 IDR","🇮🇳 INR","🇯🇵 JPY","🇲🇽 MXN","🇳🇴 NOK","🇳🇿 NZD","🇵🇱 PLN","🇷🇴 RON","🇷🇺 RUB","🇸🇪 SEK","🇸🇬 SGD","🇦🇺 AUD","🇿🇦 ZAR"]
    let coinArray = ["BTC","BCH","LTC","ETH","XRP","XMR"]//,"DASH"]
    let coinSymbol = ["$","₪", "R$", "$", "¥", "€", "£", "$", "Rp", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    
    
    //Bitcoin (BTC), Bitcoin Cash (BCH), Litecoin (LTC), Ethereum (ETH), Dash (DASH), Ripple (XRP), Monero (XMR)
    var finalURL = ""
    var coinImageArray = ["bitcoin","Bitcoin Cash","Litecoin","Ethereum","Ripple","Monero"]
    var coin = "BTC"
    var country = "USD"
    var symbol = "$"
    
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet var coinImage: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
        getBitcoinData(url: baseURL + coin + country)//, parameters: ["":""])
    }
    
    
    //MARK: - Flag country
    /***************************************************************/
    
    
    //determine how many columns we want in our picker.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    //we need to tell Xcode how many rows this picker should have
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return coinArray.count
        }
        else if component == 1{
            return countryArray.count
        }
        return 0
    }
    
    //Finally, let’s fill the picker row titles with the Strings from our currencyArray using the pickerView:titleForRow: method.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0{
            return coinArray[row]
        }
        else if component == 1{
            return countryArray[row]
        }
        return nil
    }
    
    //This will get called every time(!) the picker is scrolled. When that happens it will record the row that was selected.
    //every time that user stop scroll, row get number between 0 to "currencyArray.count" (20)
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
            coin = coinArray[row]
            coinImage.image = UIImage(named: coinImageArray[row])
        }
        else{
            let indexCodeStart = countryArray[row].index(countryArray[row].startIndex, offsetBy: 2)
            let indexCodeEnd = countryArray[row].endIndex
            
            country = String(countryArray[row][indexCodeStart ..< indexCodeEnd])
            symbol = coinSymbol[row]
        }
        //        //let finalURL = baseURL + currencyArray[row]
        let finalURL = baseURL + coin + country
        print(finalURL)
        
        getBitcoinData(url: finalURL)//, parameters: ["":""])
    }
    
    
    //MARK: - Networking
    /***************************************************************/
    //get call to website with parameters
    
    
    func getBitcoinData(url : String){ //get call to website with out parameters
        
        Alamofire.request(url , method : .get).responseJSON{
            response in
            if response.result.isSuccess{ //check if we get succeed in the process
                print("Success! Got the Bitcoin data")
                
                let BitJSON : JSON = JSON(response.result.value!)
                //print(BitJSON)
                self.updateUIWithBitcoinPrice(json: BitJSON)
            }
            else {
                print("Error \(String(describing: response.result.error))")
                self.bitcoinPriceLabel.text = "Connection Issues"
            }
        }
    }
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    
    func updateUIWithBitcoinPrice(json : JSON){
        
        //if let tempResult = json["averages"]["day"].double {
        if let tempResult = json["last"].double {
            let finalResult = Double(round(tempResult * 100) / 100) //how to print with 2 decimal places
            bitcoinPriceLabel.text = "\(symbol) \(finalResult)"
        }
        else{
            bitcoinPriceLabel.text = "Price Unavailable"
        }
    }
    
    
}

