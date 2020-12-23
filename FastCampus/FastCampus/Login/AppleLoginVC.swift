//
//  AppleLoginVC.swift
//  FastCampus
//
//  Created by 송황호 on 2020/12/20.
//

import UIKit
import AuthenticationServices
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKTalk


class AppleLoginVC: UIViewController{
    
    
    @IBOutlet weak var appleSignInButton: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProviderLoginView()
    }
    
    func setupProviderLoginView() {
        //apple 에서 제공하는 로그인 이미지 활용
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        button.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        self.appleSignInButton.addArrangedSubview(button)
    }
    
    @objc func handleAuthorizationAppleIDButtonPress() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    
    @IBAction func kakaoPressBtn(_ sender: Any) {
        // 카카오톡 설치 여부 확인
        if (AuthApi.isKakaoTalkLoginAvailable()) {
            AuthApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")

                    //do something
                    _ = oauthToken
                    
                    guard let VC = self.storyboard?.instantiateViewController(withIdentifier: "LogOutVC") as? LogOutVC else { return}
                    
                    self.present(VC, animated: true, completion: nil)
                    
                    // 사용자 액세스 토큰 정보 조회
                    UserApi.shared.accessTokenInfo {(accessTokenInfo, error) in
                        if let error = error {
                            print(error)
                        }
                        else {
                            print("accessTokenInfo() success.")
                            
                            //do something
                            _ = accessTokenInfo
                        }
                    }
                }
            }
        }
    }
}

// MARK: ASAuthorizationControllerDelegate 관련
extension AppleLoginVC: ASAuthorizationControllerDelegate{
    // 성공시 인증 정보를 반환 받는다.
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
        // 첫 로그인시
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            print("#1", userIdentifier)
            print("#2", fullName)
            print("#3", email)
            
        // 그 이후 로그인 시
        case let passwordCredential as ASPasswordCredential:
            let userName = passwordCredential.user
            let password = passwordCredential.password
            
            print("#4", userName)
            print("#5", password)
            
        default:
            break
        }
    }
    
    // 인증 에러
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
        print("#6", error)
    }
}

// Apple ID 연동 실패 시
func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
}

// MARK: ASAuthorizationControllerPresentationContextProviding 관련
extension AppleLoginVC: ASAuthorizationControllerPresentationContextProviding{
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(
            forUserID: "TESTUSERID_00.a2i2ii222"
        ) { (credentialState, error) in

            switch credentialState {
            case .authorized:
                // The Apple ID credential is valid.
                print("해당 ID는 연동되어있습니다.")
            case .revoked:
            // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
            print("해당 ID는 연동되어있지않습니다.")
            case .notFound:
                // The Apple ID credential is either was not found, so show the sign-in UI.
                print("해당 ID를 찾을 수 없습니다.")
            default:
                break
            }
        }
        return true
    }
}

