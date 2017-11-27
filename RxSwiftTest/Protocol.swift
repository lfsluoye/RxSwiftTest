//
//  RegisterProtocol.swift
//  RxSwiftTest
//
//  Created by lfs on 2017/3/17.
//  Copyright © 2017年 lfs. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
enum Result{
    case ok(message: String)
    case empty
    case failed(message: String)
}

extension Result{
    var isValid:Bool{
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}

extension Result {
    var textColor: UIColor{
        switch self {
        case .ok:
            return UIColor(red: 138.0 / 255.0, green: 221.0 / 255.0, blue: 109.0 / 255.0, alpha: 1.0)
        case .empty:
            return UIColor.black
        case .failed:
            return UIColor.red
        }
    }
}
extension Result {
    var description: String {
        switch self {
        case let .ok(message):
            return message
        case .empty:
            return ""
        case let .failed(message):
            return message
        }
    }
}


extension Reactive where Base: UILabel{
    var validationResult: UIBindingObserver<Base, Result>{
        return UIBindingObserver(UIElement: base, binding: { (label, result:Result) in
            label.textColor = result.textColor
            label.text = result.description
        })
    }
}

extension Reactive where Base: UITextField {
    var inputEnabled: UIBindingObserver<Base, Result>{
        return UIBindingObserver(UIElement: base, binding: { (textFiled, result) in
            textFiled.isEnabled = result.isValid
        })
    }
}
