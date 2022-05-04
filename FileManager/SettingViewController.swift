
import UIKit
import SnapKit

class SettingViewController: UIViewController {
    
    var model: ViewModel
    
    let passwordButton: UIButton = {
        let but = UIButton(type: .roundedRect)
        but.setTitle("сменить пароль", for: .normal)
        return but
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Сортировка"
        return label
    }()
    let sortsegmented: UISegmentedControl = {
        let segmented = UISegmentedControl(items: ["Asc", "Dec"])
        return segmented
    }()
    
    let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 20
        
        return stack
    }()

    init(model: ViewModel){
        self.model =  model
        super.init(nibName: nil, bundle: nil)
        sortsegmented.selectedSegmentIndex = model.sortType.returnIndex()
        sortsegmented.addTarget(self, action: #selector(changeSort), for: .valueChanged)
        configureTabBarItem()
        passwordButton.addTarget(self, action: #selector(changepassword), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(sortsegmented)
        stack.addArrangedSubview(passwordButton)
        
        view.addSubview(stack)
    }
    
    
    
    override func viewWillLayoutSubviews() {
        stack.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

    }
    
    
    func configureTabBarItem() {
        tabBarItem.title = "Setting"
        tabBarItem.image = UIImage(systemName: "folder.badge.gearshape")
        tabBarItem.selectedImage = UIImage(systemName: "folder.fill.badge.gearshape")
        tabBarItem.tag = 10
    }
    

    @objc func changepassword(){
        model.passwordMode = .createPassword
        let loginVC = LoginViewController(model: model)
        
        present(loginVC, animated: true)
    }
    
    @objc func changeSort(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            model.sortType = .asc
        case 1:
            model.sortType = .dec
        default :
            print("default")
        }
        
        UserDefaults.standard.set(model.sortType.rawValue, forKey: "sortType")
    }
}
