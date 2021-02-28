

import Foundation
import VKSdkFramework

protocol AuthServiceDelegateProtocol: class {
    func authServiceShouldShow(viewController: UIViewController)
    func authServiceSignIn()
    func authServiceSignInFail()
}

class AuthService: NSObject, VKSdkDelegate, VKSdkUIDelegate {
    
    private let appId = "7761353"
    private let vkSdk: VKSdk
    
    override init() {
        vkSdk = VKSdk.initialize(withAppId: appId)
        super.init()
        print("VKSdk.initialize")
        vkSdk.register(self)
        vkSdk.uiDelegate = self
    }
    
    weak var delegate: AuthServiceDelegateProtocol?
    
    var token: String? {
        return VKSdk.accessToken()?.accessToken
    }
    
    var userId: String? {
        return VKSdk.accessToken()?.userId
    }
    
    func wakeUpSession() {
        let scope = ["wall", "friends"]
        VKSdk.wakeUpSession(scope) { (state, error) in
            switch state {
            case .initialized:
                print("initialized")
                VKSdk.authorize(scope)
            case .authorized:
                print("authorized")
                self.delegate?.authServiceSignIn()
            default:
                self.delegate?.authServiceSignInFail()
            }
        }
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        print(#function)
        if result.token != nil {
            delegate?.authServiceSignIn()
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        print(#function)
        delegate?.authServiceSignInFail()
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        print(#function)
        delegate?.authServiceShouldShow(viewController: controller)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print(#function)
    }
}
