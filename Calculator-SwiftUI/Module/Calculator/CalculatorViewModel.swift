//
//  CalculatorViewModel.swift
//  Calculator-SwiftUI
//
//  Created by Yousef on 4/25/21.
//

import SwiftUI

class CalculatorViewModel: ObservableObject {
    
    private var lastCalculationResult: Double = 0 {
        didSet {
            result = "Result = \(lastCalculationResult.asFormattedString())"
        }
    }
    @Published var alert: AlertData?
    @Published var result = "Result = 0"
    @Published var undoBtnDisabled = true
    @Published var redoBtnDisabled = true
    @Published var equalBtnDisabled = true
    @Published var addBtnSelected = false
    @Published var minusBtnSelected = false
    @Published var multiplyBtnSelected = false
    @Published var divisionBtnSelected = false
    @Published var secondOperand = "" {
        didSet {
            equalBtnDisabled = secondOperand.isEmpty ||
                !(addBtnSelected || minusBtnSelected ||
                 multiplyBtnSelected || divisionBtnSelected)
        }
    }
    
    @Published var operations = [MathOperation]()
    private let stateManager: ClaculatorStateManager
    var mediator: CurrencyCalculatorMediator?
    
    init() {
        stateManager = ClaculatorStateManager()
    }
    
    /// Called to undo operation at given index
    /// - Parameter index: IndexPath of tapped cell to undo its operation
    func cellTapped(AtIndex index: IndexPath) {
        stateManager.undo(operationAt: index.row)
        updateState()
    }
    
    func itemTapped(_ item: MathOperation) {
        guard let index = operations.firstIndex(where: {item.id == $0.id}) else {return}
        stateManager.undo(operationAt: index)
        updateState()
    }
    
    func undoBtnTapped() {
        stateManager.undo()
        updateState()
    }
    
    func addBtnTapped() {
        addBtnSelected.toggle()
        minusBtnSelected = false
        multiplyBtnSelected = false
        divisionBtnSelected = false
        equalBtnDisabled = secondOperand.isEmpty || !addBtnSelected
    }
    
    func minusBtnTapped() {
        addBtnSelected = false
        minusBtnSelected.toggle()
        multiplyBtnSelected = false
        divisionBtnSelected = false
        equalBtnDisabled = secondOperand.isEmpty || !minusBtnSelected
    }
    
    func multiplyBtnTapped() {
        addBtnSelected = false
        minusBtnSelected = false
        multiplyBtnSelected.toggle()
        divisionBtnSelected = false
        equalBtnDisabled = secondOperand.isEmpty || !multiplyBtnSelected
    }
    
    func divisionBtnTapped() {
        addBtnSelected = false
        minusBtnSelected = false
        multiplyBtnSelected = false
        divisionBtnSelected.toggle()
        equalBtnDisabled = secondOperand.isEmpty || !divisionBtnSelected
    }
    
    func equalBtnTapped() {
        
        var operation: MathOperator!
        
        switch (true) {
        case addBtnSelected:
            operation = .add
        case minusBtnSelected:
            operation = .substract
        case multiplyBtnSelected:
            operation = .multiply
        case divisionBtnSelected:
            operation = .divise
        default:
            fatalError("No Selected Known Operation")
        }
        
        guard let secondOperand = Double(secondOperand) else { fatalError("Second Operand is not a valid number") }
        
        if case MathOperator.divise = operation!, secondOperand == 0 {
            alert = AlertData(title: "Math Error", msg: "Can't Divide on zero")
            return
        }
        
        stateManager.newCalculation(MathOperation(operator: operation, firstOperand: lastCalculationResult, secondOperand: secondOperand))
        
        updateState()
        resetCalculator()
        
    }
    
    func redoBtnTapped() {
        stateManager.redo()
        updateState()
    }
    
    private func updateState() {
        lastCalculationResult = stateManager.current.finalResult
        operations = stateManager.current.operations
        undoBtnDisabled = !stateManager.canUndo()
        redoBtnDisabled = !stateManager.canRedo()
        mediator?.notify(res: lastCalculationResult.asFormattedString(), sender: self)
    }
    
    private func resetCalculator() {
        addBtnSelected = false
        minusBtnSelected = false
        multiplyBtnSelected = false
        divisionBtnSelected = false
        secondOperand = ""
    }
    
}

//MARK: - Mediator
extension CalculatorViewModel: CalculatorMediator {
    
    func currencyConversionMade(fromGivenAmount amount: String) {
        guard let amount = Double(amount) else {return}
        if amount == lastCalculationResult {return}
        let finalRes = lastCalculationResult
        let op: MathOperator = finalRes > amount ? .substract : .add
        let diff = abs(finalRes - amount)
        stateManager.newCalculation(MathOperation(operator: op, firstOperand: stateManager.current.finalResult, secondOperand: diff))
        updateState()
    }
    
}


extension Array {
    mutating func mutateEach(by transform: (inout Element) throws -> Void) rethrows {
        self = try map { el in
            var el = el
            try transform(&el)
            return el
        }
     }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
