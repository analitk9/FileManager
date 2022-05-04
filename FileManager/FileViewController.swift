
import UIKit
import SnapKit

enum photoSource {
    case camera
    case disk
}

class FileViewController: UIViewController {
    
    var photoBank  = [Photo]()
    var source: photoSource = .disk
    var model: ViewModel
    
    let tableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    init(model: ViewModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
       
        configureNavigateBar()
        loadData()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .gray
        view.addSubview(tableView)
        configureTabBarItem()
    
  
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sorting()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    func sorting() {
        if model.sortType == .asc{
            photoBank.sort{ $0.sign < $1.sign }
            
        } else {
            photoBank.sort{ $0.sign > $1.sign }
        }
        tableView.reloadData()
    }
    
    func configureTabBarItem() {

        navigationController?.tabBarItem.title = "Files"
        navigationController?.tabBarItem.image = UIImage(systemName: "tray.full")
        navigationController?.tabBarItem.selectedImage = UIImage(systemName: "tray.full.fill")
        navigationController?.tabBarItem.tag = 20

    }
    

    func configureNavigateBar(){
        navigationItem.title = "File Manager"
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        let addNavButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNavButtonPress))
        navigationItem.rightBarButtonItem = addNavButton
    }

    @objc func addNavButtonPress(){
        choiceSource()
    }
    
    func editSign (index: Int) {
        let ac = UIAlertController(title: "Edit name", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let action = UIAlertAction(title: "Ok", style: .default){[weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else {return}
            self?.photoBank[index].sign = newName
            self?.sorting()
            self?.tableView.reloadData()
            self?.saveData()
            
        }
        ac.addAction(action)
        
        present(ac, animated: true, completion: nil)
    }
    
    func getDocumentsDirectory() -> URL {
       FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func saveData(){
        let jsonEncoder = JSONEncoder()
        if let data = try?  jsonEncoder.encode(photoBank) {
            UserDefaults.standard.setValue(data, forKey:"photoBank")
        }else {
            print("problem with save data")
        }
    }
    
    func loadData() {
        guard let data =  UserDefaults.standard.object(forKey: "photoBank") as? Data else {return}
         do
             {
                  photoBank = try JSONDecoder().decode([Photo].self, from: data)
             }
         catch {
             print("problem with load data")
        }
    }
    
    func choiceSource() {
        let ac = UIAlertController(title: "Источник", message: "", preferredStyle: .actionSheet)
        let cameraBut = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            self?.source = .camera
            self?.showPhotoPicker()
        }
        let fileBut = UIAlertAction(title: "File", style: .default) { [weak self] _ in
            self?.source = .disk
            self?.showPhotoPicker()
        }
        ac.addAction(cameraBut)
        ac.addAction(fileBut)
        
        present(ac, animated: true, completion: nil)
    }
    
    func showPhotoPicker() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate  = self
        if source == .camera && UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        
        present(picker, animated: true)
    }
    
    
}

extension FileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        photoBank.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
                                                        TableViewCell.reuseIdentifier) as? TableViewCell else {
            fatalError()
        }
        let curPhoto =  photoBank[indexPath.section]
        cell.labelName.text = curPhoto.sign
        cell.photoImage.image = UIImage(contentsOfFile: getDocumentsDirectory().appendingPathComponent(curPhoto.id).path)
  
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = DetailViewController()
        let curPhoto = photoBank[indexPath.section]
        let detailImage = UIImage(contentsOfFile: getDocumentsDirectory().appendingPathComponent(curPhoto.id).path)
        vc.image.image = detailImage
        
        present(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        110
    }
   
    
}

extension FileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let imageData = info[.editedImage] as? UIImage else { return}
        let name = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(name)
        try! imageData.jpegData(compressionQuality: 0.7)?.write(to: imagePath)
        let newPhoto = Photo(id: name, sign: "none")
        photoBank.append(newPhoto)

        dismiss(animated: true)
        editSign(index: photoBank.count - 1)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let fileManager = FileManager.default
            let curPhoto = photoBank[indexPath.section]
            
            let imagePath = getDocumentsDirectory().appendingPathComponent(curPhoto.id)
            do {
                try fileManager.removeItem(at: imagePath)
                photoBank.remove(at: indexPath.row)
                tableView.reloadData()
            }
            catch let error {
                print(error)
            }

        }
    }
    
}
