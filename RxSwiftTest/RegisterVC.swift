//
//  RegisterVC.swift
//  RxSwiftTest
//
//  Created by lfs on 2017/3/17.
//  Copyright © 2017年 lfs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterVC: UIViewController {
    
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var userNameLB: UILabel!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordLB: UILabel!
    @IBOutlet weak var rePasswordTF: UITextField!
    @IBOutlet weak var rePasswordLB: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
       let viewModel = RegisterViewModel()
        
        userNameTF.rx.text.orEmpty.bindTo(viewModel.userName).addDisposableTo(disposeBag)
        viewModel.userNameUsable.bindTo(userNameLB.rx.validationResult).addDisposableTo(disposeBag)
        viewModel.userNameUsable.bindTo(passwordTF.rx.inputEnabled).addDisposableTo(disposeBag)
        
        
        passwordTF.rx.text.orEmpty.bindTo(viewModel.password).addDisposableTo(disposeBag)
        viewModel.passwordUsable.bindTo(passwordLB.rx.validationResult).addDisposableTo(disposeBag)
        viewModel.passwordUsable.bindTo(rePasswordTF.rx.inputEnabled).addDisposableTo(disposeBag)
        rePasswordTF.rx.text.orEmpty.bindTo(viewModel.repeatPassword).addDisposableTo(disposeBag)
        
        viewModel.repeatPasswordUsable.bindTo(rePasswordLB.rx.validationResult).addDisposableTo(disposeBag)
        
        registerBtn.rx.tap.bindTo(viewModel.registerTaps).addDisposableTo(disposeBag)
        viewModel.registerButtonEnbled.subscribe(onNext: {[unowned self] (valid) in
            self.registerBtn.isEnabled = valid
            self.registerBtn.alpha = valid ? 1.0 : 0.5
        }).addDisposableTo(disposeBag)
        
        viewModel.registerResult.subscribe(onNext: {[unowned self] (result) in
            switch result {
            case let .ok(message):
                self.showAlert(message: message)
            case .empty:
                self.showAlert(message: "")
            case let .failed(message):
                self.showAlert(message: message)
            }
        }).addDisposableTo(disposeBag)
        
        
    }
    func showAlert(message: String) {
        let action = UIAlertAction(title: "确定", style: .default, handler: nil)
        let alertViewController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertViewController.addAction(action)
        present(alertViewController, animated: true, completion: nil)
    }
    @IBAction func clickRegisterBtn(_ sender: UIButton) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}

