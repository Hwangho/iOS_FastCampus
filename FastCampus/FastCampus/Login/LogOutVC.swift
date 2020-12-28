//
//  LogOutVC.swift
//  FastCampus
//
//  Created by 송황호 on 2020/12/22.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKTalk         // 친구 목록

import Contacts             // 주소록 가져오기 위해서



class LogOutVC: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        
        let notificationCenter2 = NotificationCenter.default
        notificationCenter2.addObserver(self, selector: #selector(ComeBackToapp), name: UIApplication.didBecomeActiveNotification, object: nil)

    }
    
    @objc func appMovedToBackground() {
        print("App moved to background!")
    }
    @objc func ComeBackToapp() {
        print("come back to app!")
    }
    
    
    // 카카오톡 관련 
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
    
    @IBAction func profileAcesssAgree(_ sender: Any) {
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                if let user = user {

                    //필요한 scope을 아래의 예제코드를 참고해서 추가한다.
                    //아래 예제는 모든 스콥을 나열한것.
                    var scopes = [String]()

                    if (user.kakaoAccount?.emailNeedsAgreement == true) { scopes.append("account_email") }
                    if (user.kakaoAccount?.birthdayNeedsAgreement == true) { scopes.append("birthday") }
                    if (user.kakaoAccount?.birthyearNeedsAgreement == true) { scopes.append("birthyear") }
                    if (user.kakaoAccount?.ciNeedsAgreement == true) { scopes.append("account_ci") }
                    if (user.kakaoAccount?.legalNameNeedsAgreement == true) { scopes.append("legal_name") }
                    if (user.kakaoAccount?.legalBirthDateNeedsAgreement == true) { scopes.append("legal_birth_date") }
                    if (user.kakaoAccount?.legalGenderNeedsAgreement == true) { scopes.append("legal_gender") }

                    if (user.kakaoAccount?.phoneNumberNeedsAgreement == true) { scopes.append("phone_number") }
                    if (user.kakaoAccount?.profileNeedsAgreement == true) { scopes.append("profile") }
                    if (user.kakaoAccount?.ageRangeNeedsAgreement == true) { scopes.append("age_range") }

                    if scopes.count == 0  { return }
                    
                    //필요한 scope으로 토큰갱신을 한다.
                    AuthApi.shared.loginWithKakaoAccount(scopes: scopes) { (_, error) in
                        if let error = error {
                            print(error)
                        }
                        else {
                            UserApi.shared.me() { (user, error) in
                                if let error = error {
                                    print(error)
                                }
                                else {
                                    print("me() success.")
                                    
                                    //do something
                                    _ = user
                                }
                                
                            } //UserApi.shared.me()
                        }
                        
                    } //AuthApi.shared.loginWithKakaoAccount(scopes:)
                }
            }
        }
        TalkApi.shared.profile {(profile, error) in
            if let error = error {
                print(error)
                
            }
            else {
                print("profile() success.")
                
                //do something
                _ = profile
            }
        }
        
        TalkApi.shared.friends {(friends, error) in
            if let error = error {
                print(error)
                print("-----> 에러걸림")
                
            }
            else {
                //do something
                print("-----> \(friends?.totalCount)")
                _ = friends
            }
        }
    }

    @IBAction func firendsListPressButton(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(identifier: ContactsVC.identifier) as? ContactsVC else {return}
        
        vc.modalPresentationStyle = .fullScreen
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func callPressButton(_ sender: Any) {
        let number = "010-3443-9365"
        if let url = URL(string: "tel://\(number)") {
                  UIApplication.shared.openURL(url)
        }
    }
}


import MessageUI        // 메시지 보내기

extension LogOutVC: MFMessageComposeViewControllerDelegate{
    
    @IBAction func sendMessage(_ sender: Any) {
        let messageComposer = MFMessageComposeViewController()
        messageComposer.messageComposeDelegate = self
        if MFMessageComposeViewController.canSendText(){
            messageComposer.recipients = ["010-3443-9365"]
            messageComposer.body = ""
            
            self.present(messageComposer, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case MessageComposeResult.sent:
            print("전송 완료")
            break
        case MessageComposeResult.cancelled:
            print("취소")
            controller.dismiss(animated: true, completion: nil)
            break
        case MessageComposeResult.failed:
            print("전송 실패")
            break
        }
    }
}
