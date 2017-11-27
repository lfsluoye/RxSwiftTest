//
//  RegisterViewModel.swift
//  RxSwiftTest
//
//  Created by lfs on 2017/3/17.
//  Copyright © 2017年 lfs. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
class RegisterViewModel {
    //input:
    let userName = Variable<String>("") //初始值""
    let password = Variable<String>("")
    let repeatPassword = Variable<String>("")
    let registerTaps = PublishSubject<Void>()
    
    //output:
    let userNameUsable: Observable<Result>
    let passwordUsable: Observable<Result>    //密码是否可用
    let repeatPasswordUsable: Observable<Result> //密码确定是否正确
    
    let registerButtonEnbled: Observable<Bool>
    let registerResult: Observable<Result>
    init() {
       let service = ValidationService.instance
        userNameUsable = userName.asObservable().flatMapLatest{ userName in
        return service.validateUsername(userName).observeOn(MainScheduler.instance).catchErrorJustReturn(.failed(message: "用户名检测出错"))
        }.shareReplay(1)
        
        passwordUsable = password.asObservable().map({ (password)  in
            return service.validatePassword(password)
        }).shareReplay(1)
        repeatPasswordUsable = Observable.combineLatest(password.asObservable(), repeatPassword.asObservable(), resultSelector: {
            return service.validateRepeatedPassword($0, repeatedPasswordword: $1)
        }).shareReplay(1)
        registerButtonEnbled = Observable.combineLatest(userNameUsable, passwordUsable, repeatPasswordUsable, resultSelector: { (username, password, repassword)  in
            username.isValid && password.isValid && repassword.isValid
        }).distinctUntilChanged().shareReplay(1)
        
        let usernameAndPassword = Observable.combineLatest(userName.asObservable(), password.asObservable()) {
            ($0,$1)
        }
        registerResult = registerTaps.asObservable().withLatestFrom(usernameAndPassword).flatMapLatest({ (username, password) in
            return service.register(username, password: password).observeOn(MainScheduler.instance).catchErrorJustReturn(.failed(message: "注册出错")).shareReplay(1)
        })
    }
}
