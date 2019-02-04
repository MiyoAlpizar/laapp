//
//  TextViewCell.swift
//  LaApp
//
//  Created by Miyo Alpízar on 2/3/19.
//  Copyright © 2019 Efrain Emigdio Navarrete Alpízar. All rights reserved.
//

import UIKit

protocol TextViewCellDelegate:class {
    func textChanged(cell: TextViewCell, text: String)
}

class TextViewCell: UITableViewCell {

    weak var delegate: TextViewCellDelegate?
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = true
        textView.keyboardAppearance = .dark
        textView.backgroundColor = UIColor.primary
        textView.textColor = UIColor.textPrimary
        textView.textContainerInset = UIEdgeInsets(top: 6, left: 6, bottom: 4, right: 5)
        textView.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    private func setupViews() {
        selectionStyle = .none
        addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 16, left: 17, bottom: 16, right: 10))
        }
        textView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TextViewCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        guard let delegate = delegate else {
            return
        }
        delegate.textChanged(cell: self, text: textView.text)
    }
    
}
