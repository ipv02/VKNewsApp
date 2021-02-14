

import UIKit

class AuthViewController: UIViewController {
    
    private var authService: AuthService!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        authService = SceneDelegate.shared().authService
        view.backgroundColor = .systemBlue
    }


    @IBAction func signInTouch(_ sender: UIButton) {
        authService.wakeUpSession()
    }
}

