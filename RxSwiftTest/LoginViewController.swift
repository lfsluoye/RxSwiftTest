//
//  LoginViewController.swift
//  RxSwiftTest
//
//  Created by lfs on 2017/3/25.
//  Copyright © 2017年 lfs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class LoginViewController: UIViewController {

    @IBOutlet weak var loginUsernameTextField: UITextField!
    @IBOutlet weak var loginUsernameLabel: UILabel!
    @IBOutlet weak var loginPasswordTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    var viewModel: LoginViewModel!
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = LoginViewModel(input: (username: loginUsernameTextField.rx.text.orEmpty.asDriver(),
                                           password: loginPasswordTF.rx.text.orEmpty.asDriver(),
                                           loginTaps: loginButton.rx.tap.asDriver()),
                                   service: ValidationService.instance)
        viewModel.usernameUsable.drive(loginUsernameLabel.rx.validationResult).addDisposableTo(disposeBag)
        viewModel.loginButtonEnabled.drive(onNext: { [unowned self] (vaild) in
            self.loginButton.isEnabled = vaild
            self.loginButton.alpha = vaild ? 1 : 0.5
        }).addDisposableTo(disposeBag)
        viewModel.loginResult.drive(onNext: { (result) in
            switch result {
            case let .ok(message):
//                self.performSegue(withIdentifier: "container", sender: self)
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
    
    
    @IBAction func clickLoginBtn(_ sender: UIButton) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
