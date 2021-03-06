//
//  HeaderView.swift
//  LaApp
//
//  Created by Miyo Alpízar on 2/3/19.
//  Copyright © 2019 Efrain Emigdio Navarrete Alpízar. All rights reserved.
//

import UIKit

class HeaderView: UIView {

    var title: String = "" {
        didSet {
            titleLbl.text = title.uppercased()
        }
    }
    
    private let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.tintPrimary
        lbl.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        lbl.numberOfLines = 1
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = UIColor.bgDarker
        addSubview(titleLbl)
        titleLbl.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(17)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
