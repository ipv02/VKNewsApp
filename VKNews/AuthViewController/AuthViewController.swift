

import UIKit

class AuthViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    
    private var authService: AuthService!

    override func viewDidLoad() {
        super.viewDidLoad()
        button.layer.cornerRadius = 10
        
        authService = SceneDelegate.shared().authService
        view.backgroundColor = .systemBlue
    }


    @IBAction func signInTouch(_ sender: UIButton) {
        authService.wakeUpSession()
    }
}

