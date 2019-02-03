//
//  ContactCell.swift
//  LaApp
//
//  Created by Miyo Alpízar on 2/2/19.
//  Copyright © 2019 Efrain Emigdio Navarrete Alpízar. All rights reserved.
//

import UIKit
import SnapKit

class ContactCell: UITableViewCell {

    private let IMAGE_SIZE: CGFloat = 54
    
    public var contact: Contact? {
        didSet {
            if let contact = contact {
                initalsLabel.isHidden = false
                if let image = contact.image {
                    imageContact.image = UIImage.init(data: image)
                    initalsLabel.isHidden = true
                }
                nameContact.text = contact.fullName
                phoneContact.text = contact.firstNumber.digits
                initalsLabel.text = contact.initials
            }
        }
    }
    
    
    private let imageContact: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.primary
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let initalsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.black)
        label.textAlignment = .center
        label.textColor = UIColor.textPrimary
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let stackContact: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = UIStackView.Distribution.equalCentering
        stack.alignment = UIStackView.Alignment.fill
        return stack
    }()
    
    private let nameContact: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.black)
        label.textColor = UIColor.textPrimary
        label.numberOfLines = 1
        return label
    }()
    
    private let phoneContact: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)
        label.textColor = UIColor.textMuted
        label.numberOfLines = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = UIColor.bgPrimary
        accessoryType = .disclosureIndicator
        addSubview(imageContact)
        imageContact.addSubview(initalsLabel)
        addSubview(stackContact)
        stackContact.addArrangedSubview(nameContact)
        stackContact.addArrangedSubview(phoneContact)
        
        imageContact.makeCornerRadius(cornerRadius: IMAGE_SIZE/2)
        
        imageContact.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(17)
            make.width.equalTo(IMAGE_SIZE)
            make.height.equalTo(IMAGE_SIZE)
            make.centerY.equalToSuperview()
        }
        
        initalsLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
        }
        
        stackContact.snp.makeConstraints { (make) in
            make.leading.equalTo(imageContact.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-35)
            make.centerY.equalToSuperview()
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageContact.image = nil
        initalsLabel.isHidden = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
