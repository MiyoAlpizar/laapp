//
//  ProfileCell.swift
//  LaApp
//
//  Created by Miyo Alpízar on 2/3/19.
//  Copyright © 2019 Efrain Emigdio Navarrete Alpízar. All rights reserved.
//

import UIKit

protocol ProfileCellDelegate: class {
    func onSendMessagePressed()
}

class ProfileCell: UITableViewCell {
    
    weak var delegate: ProfileCellDelegate?
    
    private let IMAGE_SIZE: CGFloat = 74
    
    var contact: Contact? = nil {
        didSet {
            if let contact = contact {
                initalsLabel.isHidden = false
                if let image = contact.image {
                    imageContact.image = UIImage.init(data: image)
                    initalsLabel.isHidden = true
                }
                nameContact.text = contact.fullName
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
    
    private let nameContact: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.black)
        label.textColor = UIColor.textPrimary
        label.numberOfLines = 2
        return label
    }()
    
    private let btnMessage: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.setImage(#imageLiteral(resourceName: "icons8-speech_bubble"), for: UIControl.State.normal)
        btn.tintColor = UIColor.white
        btn.backgroundColor = UIColor.tintPrimary
        btn.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    private func setupViews() {
        selectionStyle = .none
        addSubview(imageContact)
        imageContact.addSubview(initalsLabel)
        addSubview(nameContact)
        addSubview(btnMessage)
        
        imageContact.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(IMAGE_SIZE)
            make.height.equalTo(IMAGE_SIZE)
            make.leading.equalToSuperview().offset(17)
        }
        
        initalsLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
        }
        
        nameContact.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(imageContact.snp.trailing).offset(8)
            make.trailing.equalTo(btnMessage.snp.leading).offset(-8)
        }
        
        let BTN_SIZE: CGFloat = 36
        
        btnMessage.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-14)
            make.width.equalTo(BTN_SIZE)
            make.height.equalTo(BTN_SIZE)
            make.centerY.equalToSuperview()
        }
        
        btnMessage.makeCornerRadius(cornerRadius: BTN_SIZE/2)
        imageContact.makeCornerRadius(cornerRadius: IMAGE_SIZE/2)
        btnMessage.addTarget(self, action: #selector(btnPressed), for: UIControl.Event.touchUpInside)
        
    }
    
    @objc private func btnPressed() {
        guard let delegate = delegate else {
            return
        }
        delegate.onSendMessagePressed()
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
