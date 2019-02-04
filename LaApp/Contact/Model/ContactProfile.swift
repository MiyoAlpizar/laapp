//
//  ContactProfile.swift
//  LaApp
//
//  Created by Miyo Alpízar on 2/3/19.
//  Copyright © 2019 Efrain Emigdio Navarrete Alpízar. All rights reserved.
//

import Foundation

enum ContactProfileType {
    case contact,emails,phones,description, save
}

struct ContactProfileGroup {
    let title: String?
    let type: ContactProfileType
    var data: Any?
}

