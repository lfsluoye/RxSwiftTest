//
//  ValidationService.swift
//  RxSwiftTest
//
//  Created by lfs on 2017/3/17.
//  Copyright © 2017年 lfs. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
class ValidationService{
    static let instance =  ValidationService()
    private init() {}
    
    let minCharNum = 6
    
    func validateUsername(_ userName: String) -> Observable<Result>{
        if userName.count == 0 {
            return .just(.empty)
        }
        if userName.count < minCharNum {
            return .just(.failed(message: "号码长度至少6个字符"))
        }
        if usernameValid(userName){//检查用户名已经存在
            return .just(.failed(message: "账号已存在"))
        }
        
        return .just(.ok(message: "用户名可用"))
    }
    
    func validatePassword(_ password: String) -> Result{
        if password.characters.count == 0 {
            return .empty
        }
        
        if password.characters.count < minCharNum {
            return .failed(message: "密码长度至少6个字符")
        }
        
        return .ok(message: "密码可用")
    }
    func validateRepeatedPassword(_ password: String, repeatedPasswordword: String) -> Result {
        if repeatedPasswordword.characters.count == 0 {
            return .empty
        }
        
        if repeatedPasswordword == password {
            return .ok(message: "密码可用")
        }
        
        return .failed(message: "两次密码不一样")
    }
    // 从本地数据库中检测用户名是否已经存在
    func usernameValid(_ username: String) -> Bool {
        let filePath = NSHomeDirectory() + "/Documents/users.plist"
        let userDic = NSDictionary(contentsOfFile: filePath)

        let usernameArray = userDic!.allKeys as NSArray
        if usernameArray.contains(username) {
            return true
        } else {
            return false
        }
    }
    func register(_ username: String, password: String) ->Observable<Result>{
        let userDic = [username: password]
        
        let filePath = NSHomeDirectory() + "/Documents/users.plist"
        if (userDic as NSDictionary).write(toFile: filePath, atomically: true) {
            return .just(.ok(message: "注册成功"))
        }
        return .just(.failed(message: "注册失败"))
    }
    
    func loginUsernameValid(_ username: String) -> Observable<Result>{
        if username.characters.count == 0 {
            return .just(.empty)
        }
        if usernameValid(username) {
            return .just(.ok(message: "用户名可用"))
        }
        
        return .just(.failed(message: "用户名不存在"))
    }
    
    func login(_ username: String, password: String) -> Observable<Result> {
        let filePath = NSHomeDirectory() + "/Documents/users.plist"
        let userDic = NSDictionary(contentsOfFile: filePath)
        if let userPass = userDic?.object(forKey: username) as? String {
            if  userPass == password {
                return .just(.ok(message: "登录成功"))
            }
        }
        return .just(.failed(message: "密码错误"))
    }
}
