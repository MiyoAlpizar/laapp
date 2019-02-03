//
//  StringExtentions.swift
//  LaApp
//
//  Created by Miyo Alpízar on 2/2/19.
//  Copyright © 2019 Efrain Emigdio Navarrete Alpízar. All rights reserved.
//

import Foundation

extension String {
    
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
    
    var forSearch: String {
        return self.lowercased().folding(options: [.diacriticInsensitive, .caseInsensitive], locale: nil)
    }
    
}
