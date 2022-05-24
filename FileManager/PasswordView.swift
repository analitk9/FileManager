
import UIKit
import SnapKit

class PasswordView: UIView {
    
    var passwordTextField: UITextField = {
        let edit = UITextField()
        edit.placeholder = "enter password"
        edit.layer.borderWidth = 1
        edit.layer.borderColor = UIColor.black.cgColor
        edit.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        edit.leftViewMode = .always
        edit.keyboardType = .default
        edit.autocapitalizationType = .none
        edit.isSecureTextEntry = true
       
        return edit
    }()
    
    var validationButton: UIButton = {
        let but = UIButton(type: .custom)
        but.setTitle("press to login", for: .normal)
        but.setTitleColor( UIColor.black, for: .normal)
        but.layer.cornerRadius = 5
        but.clipsToBounds = true
        but.layer.borderColor = UIColor.black.cgColor
        but.layer.borderWidth = 1
        return but
    }()
    
    var vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        
        
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(vStack)
        vStack.addArrangedSubview(passwordTextField)
        vStack.addArrangedSubview(validationButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        validationButton.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        vStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
       
    }
}
