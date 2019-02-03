//
//  ContactTVC.swift
//  LaApp
//
//  Created by Miyo Alpízar on 2/3/19.
//  Copyright © 2019 Efrain Emigdio Navarrete Alpízar. All rights reserved.
//

import UIKit

class ContactTVC: UITableViewController {
    
    private let PROFILE_CELL = "PROFILE_CELL"
    private let ACTION_CELL = "ACTION_CELL"
    private let MIDDLE_ACTION_CELL = "MIDDLE_ACTION_CELL"
    private let TEXT_VIEW_CELL = "TEXT_VIEW_CELL"
    
    public var contactProfile = [ContactProfileGroup]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        setupTableView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return contactProfile.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let info = contactProfile[section]
        switch info.type {
        case .contact, .description, .save:
            return 1
        case .emails, .phones:
            if let emails = info.data as? [String] {
                return emails.count
            }
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let info = contactProfile[indexPath.section]
        switch info.type {
        case .contact:
            let cell = tableView.dequeueReusableCell(withIdentifier: PROFILE_CELL, for: indexPath) as! ProfileCell
            cell.contact = info.data as? Contact
            return cell
        case .emails, .phones:
            let cell = tableView.dequeueReusableCell(withIdentifier: ACTION_CELL, for: indexPath) as! ActionTextCell
            let text = info.data as! [String]
            cell.titleText = text[indexPath.item]
            return cell
        case .description:
            let cell = tableView.dequeueReusableCell(withIdentifier: TEXT_VIEW_CELL, for: indexPath) as! TextViewCell
            cell.textView.text = info.data as? String
            return cell
        case .save:
            let cell = tableView.dequeueReusableCell(withIdentifier: MIDDLE_ACTION_CELL, for: indexPath) as! MiddleActionCell
            cell.titleText = info.data as! String
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let info = contactProfile[indexPath.section]
        switch info.type {
        case .contact:
            return 90
        case .description:
            return 120
        default:
            return 50
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let info = contactProfile[section]
        var title = ""
        switch info.type {
        case .contact, .save:
            return nil
        case .emails:
            title = "Correos"
        case .phones:
            title = "Telefonos"
        case .description:
            title = "Descripción"
        }
        
        let view = TitleHeaderView()
        view.title = title
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let info = contactProfile[section]
        switch info.type {
        case .contact:
            return CGFloat.leastNormalMagnitude
        default:
            return 40
        }
    }
}

extension ContactTVC {
    
    private func setupController() {
        title = "Información"
        navigationItem.largeTitleDisplayMode = .never
        
    }
    
    private func setupTableView() {
        tableView.register(ProfileCell.self, forCellReuseIdentifier: PROFILE_CELL)
        tableView.register(ActionTextCell.self, forCellReuseIdentifier: ACTION_CELL)
        tableView.register(MiddleActionCell.self, forCellReuseIdentifier: MIDDLE_ACTION_CELL)
        tableView.register(TextViewCell.self, forCellReuseIdentifier: TEXT_VIEW_CELL)
        tableView.estimatedRowHeight = 80
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        tableView.keyboardDismissMode = .onDrag
    }
    
}
