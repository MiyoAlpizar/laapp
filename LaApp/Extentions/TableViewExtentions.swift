//
//  TableViewExtentions.swift
//  LaApp
//
//  Created by Miyo Alpízar on 2/2/19.
//  Copyright © 2019 Efrain Emigdio Navarrete Alpízar. All rights reserved.
//

import UIKit

extension UITableView {
    
    func emptyMessage(message: String = "Sin resultados") {
        let lblMsg = UILabel()
        lblMsg.text = message
        lblMsg.textAlignment = .center
        lblMsg.textColor = UIColor.textMuted
        lblMsg.font = UIFont.systemFont(ofSize: 26, weight: UIFont.Weight.medium)
        
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        bgView.addSubview(lblMsg)
        
        lblMsg.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        backgroundView = bgView
        separatorStyle = .none
    }
    
    func resetEmptyMessage() {
        backgroundView = nil
        separatorStyle = .singleLine
    }
    
}


