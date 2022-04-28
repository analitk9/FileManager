//
//  DetailViewController.swift
//  FileManager
//
//  Created by Denis Evdokimov on 4/28/22.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {
   
    var image: UIImageView = {
        let imageView = UIImageView()
       
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(image)
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        image.snp.makeConstraints { make in
            make.size.equalTo(view.bounds.width)
            make.center.equalToSuperview()
        }
    }
    

   

}
