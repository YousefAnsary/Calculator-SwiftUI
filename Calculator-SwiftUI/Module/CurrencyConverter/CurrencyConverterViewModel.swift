//
//  CurrencyConverterViewModel.swift
//  Calculator-SwiftUI
//
//  Created by Yousef on 4/25/21.
//

import SwiftUI

/// ViewModel for CurrencyConverterScene
class CurrencyConverterViewModel: ObservableObject {
    
    ///Amount in EGP TextField
    @Published var egpAmount: String = "" {
        didSet {
            isConvertBtnDisabled = egpAmount.isEmpty
        }
    }
    ///Conversion Result to be shown
    @Published private(set) var result: String = ""
    ///Convert Button Disable Handler
    @Published private(set) var isConvertBtnDisabled = true
    ///Alert to show to user
    @Published var alert: AlertData?
    ///Mediator That notifies changes between currency converter and calculator
    var mediator: CurrencyCalculatorMediator?
    
    /// Converts given amount of EGPs to USD and updates published result
    func convert() {
        
        guard let amount = Double(egpAmount) else {return}
        
        result = "Loading..."
        
        CurrencyConvertService.EGP_USDRatio() { [weak self] res in
            guard let self = self else {return}
            switch res {
            case .success(let ratio):
                UserDefaultsManager.shared.EGP_USDRatio = ratio
                self.result = "\((ratio * amount).asFormattedString()) USD"
                self.mediator?.notify(res: String(amount), sender: self)
            case .failure(let err):
                self.alert = AlertData(title: "", msg: err.localizedDescription)
                self.result = ""
                return
            }
        }
        
    }
    
}

// MARK: - Mediator
extension CurrencyConverterViewModel: CurrencyConverterMediator {
    
    /// Called whenever calculator makes a new operation to store it to be used as currency input
    func caculationMade(withResult res: String) {
        egpAmount = res
    }
    
}
