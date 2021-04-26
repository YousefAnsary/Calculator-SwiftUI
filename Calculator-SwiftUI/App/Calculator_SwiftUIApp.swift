//
//  Calculator_SwiftUIApp.swift
//  Calculator-SwiftUI
//
//  Created by Yousef on 4/25/21.
//

import SwiftUI

@main
struct Calculator_SwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                AppCoordinator.main.configurateCalculatorScene().tabItem {
                    Label("Calculator", systemImage: "x.squareroot")
                }
                AppCoordinator.main.configurateCurrencyConverterScene().tabItem {
                    Label("CurrencyConverter", systemImage: "dollarsign.circle.fill")
                }
            }
        }
    }
}

class AppCoordinator {
    
    let mediator = CurrencyCalculatorMediator()
    static let main = AppCoordinator()
    
    private init() {}
    
    func configurateCalculatorScene()-> some View {
        let calcVM = CalculatorViewModel()
        mediator.setCalculatorMediator(calcVM)
        calcVM.mediator = mediator
        return CalculatorView(viewModel: calcVM)
    }
    
    func configurateCurrencyConverterScene()-> some View {
        let currencyConverterVM = CurrencyConverterViewModel()
        mediator.setCurrencyConverterMediator(currencyConverterVM)
        currencyConverterVM.mediator = mediator
        return CurrencyConverterView(viewModel: currencyConverterVM)
    }
    
}
