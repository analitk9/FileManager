import UIKit
import SnapKit
//import SwiftUI

class LoginViewController: UIViewController {
    
    var model: ViewModel
    let passwordView = PasswordView()
    private var keyboardHelper: KeyboardHelper?
    private let errorAlertService = ErrorAlertService()
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.keyboardDismissMode = .onDrag
        scroll.backgroundColor = .green

        return scroll
    }()
    
    init( model: ViewModel){
    self.model = model
        super.init(nibName: nil, bundle: nil)
        passwordView.passwordTextField.delegate = self
        passwordView.validationButton.setTitle(model.validationButtonText, for: .normal)
       
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        passwordView.validationButton.addTarget(self, action: #selector(validationBattonPress), for: .touchUpInside)
       
        view.addSubview(scrollView)
        scrollView.addSubview(passwordView)
       
      setupKbHelper()
       setupViewModel()
    }
    

    
    func setupKbHelper() {
        keyboardHelper = KeyboardHelper { [unowned self] animation, keyboardFrame, duration in
            switch animation {
            case .keyboardWillShow:
                let activeRect = passwordView.validationButton.convert(passwordView.validationButton.bounds, to: scrollView)
                let keyBoardFrame = view.convert(keyboardFrame, to: view.window)
                scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyBoardFrame.size.height, right: 0)
                scrollView.scrollIndicatorInsets = scrollView.contentInset
                scrollView.scrollRectToVisible(activeRect, animated: true)
            case .keyboardWillHide:
                scrollView.contentInset = .zero
                scrollView.scrollIndicatorInsets = .zero
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
       
        scrollView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        passwordView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
    }
    
    private func setupViewModel(){
        model.onStateChanged = { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .createPassword:
                print("create")
            case .confirmPassword:
                self.passwordView.validationButton.setTitle(self.model.passwordMode.rawValue, for: .normal)
                self.passwordView.passwordTextField.text = nil
            case let .wrongPass(loginError):
                let alert = self.errorAlertService.createAlert(loginError.errorDescription)
                  self.present(alert,animated: true)
                self.passwordView.validationButton.setTitle(self.model.passwordMode.rawValue, for: .normal)
                self.passwordView.passwordTextField.text = nil
            case .login:
                self.passwordView.passwordTextField.backgroundColor = .green
                self.navigate()
            default:
                print("initial")
            }
        }
    }
    
    @objc func validationBattonPress(){
        model.validationButtonPress(enterPassword: passwordView.passwordTextField.text ?? "")
    }
    
    private func navigate(){
        let tabBarController = UITabBarController()
       
        let fileVC = FileViewController(model: model)
        let navController = UINavigationController(rootViewController: fileVC)
       
       
        
      
        tabBarController.setViewControllers([navController, SettingViewController(model: model)], animated: false)
        tabBarController.selectedViewController = tabBarController.viewControllers?.first
        view.window?.rootViewController = tabBarController
        view.window?.makeKeyAndVisible()
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//struct AdvancedProvider: PreviewProvider {
//    static var previews: some View {
//        ContainterView().edgesIgnoringSafeArea(.all)
//    }
//    
//    struct ContainterView: UIViewControllerRepresentable {
//        
//        let vc = LoginViewController()
//        func makeUIViewController(context: UIViewControllerRepresentableContext<AdvancedProvider.ContainterView>) -> LoginViewController {
//            return vc
//        }
//        
//        func updateUIViewController(_ uiViewController: AdvancedProvider.ContainterView.UIViewControllerType, context: UIViewControllerRepresentableContext<AdvancedProvider.ContainterView>) {
//            
//        }
//    }
//}
