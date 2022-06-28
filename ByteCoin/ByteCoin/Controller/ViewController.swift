//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var coinManager = CoinManager()
    
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyValueLabel: UILabel!
    @IBOutlet weak var currencyPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        currencyPickerView.dataSource = self
        currencyPickerView.delegate = self
        coinManager.delegate = self
        
    }


}

//MARK: - UIPickerViewDataSource && UIPickerViewDelegate

extension ViewController : UIPickerViewDataSource,UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currencySelcted = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: currencySelcted)
    }
}

//MARK: -

extension ViewController : CoinableDelegate {
    func updateCoinData(rate: Double?) {
        if rate != nil {
            DispatchQueue.main.async {
                self.currencyValueLabel.text = String(format: "%.2f", rate!)
            }
        }
        
    }
    
    func errorHappned(error: Error) {
        print(error)
    }
    
}
