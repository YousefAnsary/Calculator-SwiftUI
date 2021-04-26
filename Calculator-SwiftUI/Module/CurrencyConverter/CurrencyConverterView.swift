//
//  CurrencyConverterView.swift
//  Calculator-SwiftUI
//
//  Created by Yousef on 4/25/21.
//

import SwiftUI

///View of CurrencyConverterScene
struct CurrencyConverterView: View {
    
    ///View Model
    @ObservedObject var viewModel = CurrencyConverterViewModel()
    
    ///View
    var body: some View {
        VStack() {
            TextField("EGP", text: $viewModel.egpAmount)
                .keyboardType(.decimalPad)
                .padding(8)
                .frame(height: 45.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding(.top, 16)
                .padding(24)
            
            Button("Convert", action: viewModel.convert)
                .disabled(viewModel.isConvertBtnDisabled)
            
            Text(viewModel.result)
                .padding(.top, 18)
            
            Spacer()
        }.alert(item: $viewModel.alert) { alertData -> Alert in
            return alertData.alert
        }
    }
    
}

///Preview of Currency Converter Scene
struct CurrencyConverterView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyConverterView()
    }
}
