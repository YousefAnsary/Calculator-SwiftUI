//
//  ContentView.swift
//  Calculator-SwiftUI
//
//  Created by Yousef on 4/25/21.
//

import SwiftUI

struct CalculatorView: View {
    
    @ObservedObject var viewModel = CalculatorViewModel()
    
    var body: some View {
        VStack {
            Text(viewModel.result).padding(.top, 32)
            TextField("EGP", text: $viewModel.secondOperand)
                .keyboardType(.decimalPad)
                .padding(8)
                .frame(height: 45.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding(.top, 12)
                .padding(.bottom, 12)
                .padding(.leading, 24)
                .padding(.trailing, 24)
            HStack {
                Button("Undo", action: viewModel.undoBtnTapped).disabled(viewModel.undoBtnDisabled)
                operationBtn(withTitle: "+", selectBinder: viewModel.addBtnSelected, action: viewModel.addBtnTapped)
                operationBtn(withTitle: "-", selectBinder: viewModel.minusBtnSelected, action: viewModel.minusBtnTapped)
                operationBtn(withTitle: "*", selectBinder: viewModel.multiplyBtnSelected, action: viewModel.multiplyBtnTapped)
                operationBtn(withTitle: "/",
                             selectBinder: viewModel.divisionBtnSelected,
                             action: viewModel.divisionBtnTapped)
                Button("=", action: viewModel.equalBtnTapped).disabled(viewModel.equalBtnDisabled)
                Button("Redo", action: viewModel.redoBtnTapped).disabled(viewModel.redoBtnDisabled)
            }
            ScrollView {
                LazyVGrid(columns: [
                            GridItem(.adaptive(minimum: 65)),
                ], spacing: 15,  content: {
                    
                    ForEach(viewModel.operations, id: \.id) { item in
                        Text("\(item.operator.rawValue)\(item.secondOperand.asFormattedString())").background(Color.black)
                        .padding()
                        .border(Color.white, width: 3)
                        .foregroundColor(.white)
                        .onTapGesture {
                            viewModel.itemTapped(item)
                        }
                }
            })
            }.padding(12).background(Color.black)
            Spacer()
        }.alert(item: $viewModel.alert) { alertData -> Alert in
            return alertData.alert
        }
    }
    
    private func operationBtn(withTitle title: String,
                              selectBinder: Bool,
                              action: @escaping ()-> Void) -> some View {
        
        Button(" \(title) ", action: action)
            .font(.title3)
            .background(selectBinder ? Color.blue : Color.white)
            .foregroundColor(selectBinder ? Color.white : Color.blue)
            .padding(4)
            .frame(width: 35, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        
    }
    
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
    }
}

struct DismissableTextfield: UIViewRepresentable {

    @Binding var text: String
    var keyType: UIKeyboardType
    var placeholder: String?

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.keyboardType = keyType
        textField.placeholder = placeholder

        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textField.frame.size.width, height: 44))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(title: "Done", image: nil, primaryAction: UIAction { _ in
            self.hideKeyboard()
        })

        toolBar.setItems([spacer, doneButton], animated: true)
        textField.inputAccessoryView = toolBar

        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
}

class Coordinator: NSObject, UITextFieldDelegate {
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
}
