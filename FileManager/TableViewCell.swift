//
//  TableViewCell.swift
//  FileManager
//
//  Created by Denis Evdokimov on 4/28/22.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    static var reuseIdentifier: String {
        String(describing: TableViewCell.self)
    }
    
    
    var labelName: UILabel = {
        let label = UILabel()
        
        return label
    }()
    var photoImage: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(photoImage)
        contentView.addSubview(labelName)
   
    }
    
    override func layoutSubviews() {
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLayout() {
        photoImage.snp.makeConstraints { make in
            make.width.equalTo(110)
            make.height.equalTo(110)
            make.leading.equalToSuperview().offset(16)
            make.top.bottom.equalToSuperview()
          
        }
        labelName.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(photoImage.snp.trailing).offset(16)
            make.trailing.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        labelName.text = nil
        photoImage.image = nil
    }

}
