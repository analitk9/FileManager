

import Foundation

enum LoginError: Error {
    case wrongEnterPassword
    case wrondRulePassword
    case wrongPasswordConfirm
}
extension LoginError {
    var errorDescription: String {
        switch self {
        case .wrongEnterPassword:
           return "Введен не верный пароль"
        case .wrondRulePassword:
            return  "Длинна пароля должна быть не менее 4 символов"
        case .wrongPasswordConfirm:
            return  "Пароль не совпадает с ранее введеным"
        }
    }
}
