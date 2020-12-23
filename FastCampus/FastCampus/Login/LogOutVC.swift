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

    var contacts: NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        readContacts()
    }
    
    // 주소록 읽어오기
    private func readContacts() {
        
        let store = CNContactStore()
  
        // Permission 획득
        store.requestAccess(for: .contacts) { (granted, error) in
            guard granted else {
                return;
            }
            
            // Request 생성
            let request: CNContactFetchRequest = self.getCNContactFetchRequest()
                      
            // 주소록 읽을 때 정렬해서 읽어오도록 설정
            
            request.sortOrder = CNContactSortOrder.userDefault
                    
            // Contacts 읽기
            // 주소록이 1개씩 읽혀서 usingBlock으로 들어온다.
            try! store.enumerateContacts(with: request, usingBlock: { (contact, stop) in
                
                // Phone No가 없을때 return
                if contact.phoneNumbers.isEmpty {
                    return
                }
                // NSMutableArray Add contact
                // 읽어온 주소록을 NSMutableArray에 저장
                self.contacts.add(contact)
            })
        }
    }
    
    // Request 생성
    private func getCNContactFetchRequest() -> CNContactFetchRequest {
        
        // 주소록에서 읽어올 key 설정
        let keys: [CNKeyDescriptor] = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey, CNContactEmailAddressesKey] as! [CNKeyDescriptor]
    
        return CNContactFetchRequest(keysToFetch: keys)
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
    
    
    @IBAction func contactsPressButton(_ sender: Any) {
        
        print("주소로오오오옥 --> \(self.contacts.count)")
        
        NotificationCenter.default.post(name: .init("contacts"), object: nil, userInfo: ["contact": contacts])
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: ContactsNVC.identifier) as? ContactsNVC else{return }
        
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true, completion: nil)
    }

}
