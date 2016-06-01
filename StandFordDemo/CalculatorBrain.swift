//
//  CalculatorBrain.swift
//  StandFordDemo
//
//  Created by yishain chen on 2016/5/27.
//  Copyright © 2016年 yishain. All rights reserved.
//

import Foundation

//func multiply(op1 :Double, op2 : Double) -> Double {
//    return op1 * op2
//}

class CalculatorBrain {
    
    private var accumulator = 0.0
    
    private var internalProgram = [AnyObject]()
    
    func setOperand(operand:Double)  {
        accumulator = operand
        internalProgram.append(operand)
        
        
    }
    
    private var operations : Dictionary<String,Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E), // M_E
        "√" : Operation.UnaryOperation(sqrt), //sqrt
        "cos" : Operation.UnaryOperation(cos), //cos
        "x" : Operation.BinaryOperation({$0 * $1}),
        "÷" : Operation.BinaryOperation({$0 / $1}),
        "+" : Operation.BinaryOperation({$0 + $1}),
        "-" : Operation.BinaryOperation({$0 - $1}),
        "=" : Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double,Double) -> Double)
        case Equals
    }
    

    func performOperation(symbol :String) {
        internalProgram.append(symbol)
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value): accumulator = value
            case .UnaryOperation(let function): accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals :
                executePendingBinaryOperation()
            }
        }
    }
    
    private func executePendingBinaryOperation () {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand : Double
    }
    
    typealias PropertyList = AnyObject
    
    var program : PropertyList {
        get {
            return internalProgram
        }
        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand)
                    } else if let operand = op as? String {
                        performOperation(operand)
                    
                    }
                }
            }
        }
    }
    func clear() {
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    
    var result : Double{
        get {
            return accumulator
        }
        
    }
}