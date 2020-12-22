//
//  LogOutVC.swift
//  FastCampus
//
//  Created by 송황호 on 2020/12/22.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser

class LogOutVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func LogPutPressButton(_ sender: Any) {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("logout() success.")
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cutLogPressBtn(_ sender: Any) {
        UserApi.shared.unlink {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("unlink() success.")
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
