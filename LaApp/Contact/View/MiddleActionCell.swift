//
//  MiddleActionCell.swift
//  LaApp
//
//  Created by Miyo Alpízar on 2/3/19.
//  Copyright © 2019 Efrain Emigdio Navarrete Alpízar. All rights reserved.
//

import UIKit

class MiddleActionCell: UITableViewCell {

    var titleText: String = "" {
        didSet {
            lblAction.text = titleText.uppercased()
        }
    }
    
    private let lblAction: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.secondary
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    private let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.bgDarker
        return view
    }()
    
    private func setupViews() {
        selectedBackgroundView = bgView
        
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
