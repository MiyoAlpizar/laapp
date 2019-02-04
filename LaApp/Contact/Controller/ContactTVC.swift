//
//  ContactTVC.swift
//  LaApp
//
//  Created by Miyo Alpízar on 2/3/19.
//  Copyright © 2019 Efrain Emigdio Navarrete Alpízar. All rights reserved.
//

import UIKit
import PromiseKit
import MessageUI

class ContactTVC: UITableViewController {
    
    private let PROFILE_CELL = "PROFILE_CELL"
    private let ACTION_CELL = "ACTION_CELL"
    private let MIDDLE_ACTION_CELL = "MIDDLE_ACTION_CELL"
    private let TEXT_VIEW_CELL = "TEXT_VIEW_CELL"
    
    public var contact: Contact!
    private var contactProfile = [ContactProfileGroup]()
    
    private var descriptionIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactProfile = contact.toContactProfile()
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
            cell.contact = contact
            cell.delegate = self
            return cell
        case .emails, .phones:
            let cell = tableView.dequeueReusableCell(withIdentifier: ACTION_CELL, for: indexPath) as! ActionTextCell
            let text = info.data as! [String]
            cell.titleText = text[indexPath.item]
            return cell
        case .description:
            descriptionIndex = indexPath.section
            let cell = tableView.dequeueReusableCell(withIdentifier: TEXT_VIEW_CELL, for: indexPath) as! TextViewCell
            cell.textView.text = contact.detail
            cell.delegate = self
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
        guard let title = info.title else {
            return nil
        }
        let view = TitleHeaderView()
        view.title = title
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let info = contactProfile[section]
        switch info.type {
        case .contact, .save:
            return CGFloat.leastNormalMagnitude
        default:
            return 40
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = contactProfile[indexPath.section]
        switch info.type {
        case .save:
            saveContact()
        default:
            return
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
    
    private func saveContact() {
        ContactsHelper.shared.saveContact(contact: contact)
        .done { [weak self] () in
            guard let `self` = self else { return }
            self.navigationController?.popViewController(animated: true)
        }.catch { [weak self] (error) in
            guard let `self` = self else { return }
            self.alert(message: error.localizedDescription)
        }
    }
    
}

extension ContactTVC: TextViewCellDelegate, ProfileCellDelegate, MFMessageComposeViewControllerDelegate {
    
    func onSendMessagePressed() {
        if contact.numbers.count == 1 {
            sendMessage(to: contact.numbers.first!)
        }else {
            selectNumber()
        }
    }
    
    func selectNumber() {
        let alert = UIAlertController(title: nil, message: "Elige destino", preferredStyle: UIAlertController.Style.actionSheet)
        contact.numbers.forEach { (number) in
            alert.addAction(UIAlertAction(title: number, style: UIAlertAction.Style.default, handler: { [weak self] (_) in
                guard let `self` = self else { return }
                self.sendMessage(to: number)
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func textChanged(cell: TextViewCell, text: String) {
        contact.detail = text
    }
    
    func sendMessage(to: String) {
        let messageVC = MFMessageComposeViewController()
        messageVC.body = ""
        messageVC.recipients = [to]
        messageVC.messageComposeDelegate = self
        self.present(messageVC, animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
        self.delayWithSeconds(0.45) { [weak self] in
            guard let `self` = self else { return }
            switch result {
            case .cancelled:
                return
            case .sent:
                self.alert(message: "Mensaje enviado con éxito")
            case .failed:
                self.alert(message: "Error al enviar mensaje")
            }
        }
    }
}
