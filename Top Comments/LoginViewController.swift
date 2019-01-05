import VK_ios_sdk
import UIKit
import Nuke

struct User: Decodable {
    let id: Int
    let first_name: String
    let last_name: String
    let photo_100: String
}

struct Response<T: Decodable>: Decodable {
    let response: T
}

class LoginViewController: UIViewController, VKSdkUIDelegate, VKSdkDelegate {

    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var greetingView: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    let scope = ["email", "wall", "friends"]
    let vkInstance = VKSdk.initialize(withAppId: "6786594")!
    var isViewResumed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vkInstance.register(self)
        vkInstance.uiDelegate = self
//        VKSdk.forceLogout()
        prepareViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        VKSdk.wakeUpSession(scope) { (state, error) in
            if (state == VKAuthorizationState.authorized) {
                self.greetingView.isHidden = false
                self.getUserAvatar()
            } else {
                self.loginView.isHidden = false
            }
        }
    }
    
    @IBAction func onLoginPressed(_ sender: UIButton) {
        VKSdk.authorize(self.scope)
    }
    
    func prepareViews() {
        avatar.layer.masksToBounds = false
        avatar.layer.cornerRadius = avatar.frame.height/2
        avatar.clipsToBounds = true
    }
    
    func getUserAvatar() {
        let request = VKRequest(method: "users.get", andParameters: ["fields":"photo_100"], andHttpMethod: "GET")
        request?.execute(resultBlock: {(response) -> Void in
            let data = response?.responseString.data(using: .utf8)!
            let user = try! JSONDecoder().decode(Response<[User]>.self, from: data!)
            
            self.name.text = "\(user.response[0].first_name) \(user.response[0].last_name)"
            
            let url = URL(string: user.response[0].photo_100)!
            Nuke.loadImage(
                with: url,
                options: ImageLoadingOptions(
                    placeholder: nil,
                    transition: .fadeIn(duration: 0.33)
                ),
                into: self.avatar
            )
        }, errorBlock: {(error) -> Void in
            print("error")
        })
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if (result.token == nil) {
            showWarning(message: "Для работы приложения необходим доступ к вашему аккаунту ВКонтакте")
        } else {
            self.loginView.isHidden = true
            self.greetingView.isHidden = true
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        showWarning(message: "Для работы приложения необходим доступ к вашему аккаунту ВКонтакте")
    }
    
    func showWarning(message: String) {
        let alert = UIAlertController(title: "Авторизация", message: "\n\(message)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in})
        alert.addAction(okAction)
        present(alert, animated: true) {() -> Void in }
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        if (presentedViewController != nil) {
            dismiss(animated: true, completion: {self.present(controller, animated: true, completion: {})})
        } else {
            present(controller, animated: true, completion: {})
        }
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {}
}
