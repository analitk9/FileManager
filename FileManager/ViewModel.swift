
import Foundation
import KeychainAccess

class ViewModel {
    
    private(set) var state: ModelState = .initial {
        didSet {
            onStateChanged?(state) // сюда модель сообщает о изменении своего состояния
        }
    }
    
    private let token = Keychain(service: Bundle.main.bundleIdentifier!)
    var onStateChanged: ((ModelState) -> Void)?
    var sortType: SortType = .asc
    var passwordMode: PasswordMode
    private var tempPass: String = ""
    var validationButtonText: String {
        passwordMode.rawValue
    }
    
    init(passwordMode: PasswordMode) {
        self.passwordMode = passwordMode
    }
    
    func validationButtonPress(enterPassword: String) {
      
        if enterPassword.count < 4 {
            state = .wrongPass(.wrondRulePassword)
            return
        }
        
        switch passwordMode {
            
        case .createPassword:
            tempPass = enterPassword
            passwordMode = .confirmPassword
            state = .confirmPassword
            
        case .confirmPassword:
            if tempPass != enterPassword {
                passwordMode = .createPassword
                state = .wrongPass(.wrongPasswordConfirm)
                
            } else {
                token[Bundle.main.bundleIdentifier!] = enterPassword //сохраняем пароль
                state = .login
                
            }
            
        case .enterPassword:
            let savePassword = token[Bundle.main.bundleIdentifier!]
            if savePassword == enterPassword {
                state = .login
            } else {
                state = .wrongPass(.wrongEnterPassword)
            }
        }
    }
}

enum PasswordMode: String {
    case createPassword = "Create password"
    case enterPassword = "Enter password"
    case confirmPassword = "Confirm password"
}
enum SortType: String {
    case asc = "По возрастанию"
    case dec = "По убыванию"
    
    func returnIndex()->Int{
        switch self {
        case .asc:
            return 0
        case .dec:
            return 1
        }
    }
}
extension ViewModel {
    enum ModelState {
        case initial
        case createPassword
        case confirmPassword
        case wrongPass(LoginError)
        case login
    }
}
