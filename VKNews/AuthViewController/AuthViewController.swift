

import UIKit

class AuthViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    
    private var authService: AuthService!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        authService = SceneDelegate.shared().authService
        
        setupUIButton()
    }
    
    private func setupUIButton() {
        button.layer.cornerRadius = 10
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 2.5, height: 4)
    }

    @IBAction func signInTouch(_ sender: UIButton) {
        authService.wakeUpSession()
    }
}

