//
//  ActionTextCell.swift
//  LaApp
//
//  Created by Miyo Alpízar on 2/3/19.
//  Copyright © 2019 Efrain Emigdio Navarrete Alpízar. All rights reserved.
//

import UIKit

class ActionTextCell: UITableViewCell {

    var titleText: String = "" {
        didSet {
            lblAction.text = titleText
        }
    }
    
    private let lblAction: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.tintPrimary
        label.numberOfLines = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    

    private func setupViews() {
        selectionStyle = .none
        addSubview(lblAction)
        lblAction.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(17)
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
