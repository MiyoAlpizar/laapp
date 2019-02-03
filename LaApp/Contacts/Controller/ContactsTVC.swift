//
//  ContactsTVC.swift
//  LaApp
//
//  Created by Miyo Alpízar on 2/2/19.
//  Copyright © 2019 Efrain Emigdio Navarrete Alpízar. All rights reserved.
//

import UIKit

class ContactsTVC: UITableViewController {
    
    private let CELL_ID = "CELL_ID"
    
    private var contacts = [Contact]()
    private var groupedContacts = [[Contact]]()
    private let searchController = UISearchController(searchResultsController: nil)
    private var lastFilter = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        setupTableView()
        loadContacts()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return groupedContacts.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedContacts[section].count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let first = groupedContacts[section].first else {
            return nil
        }
        
        let headerView = HeaderView()
        let title: String
        switch first.type {
        case .inApp:
            title = "Contactos en La App"
        case .notIntApp:
            title = "Contactos no registrados"
        case .noName:
            title = "Contactos sin nombre"
        case .noNumber:
            title = "Contactos sin teléfono"
        }
        headerView.title = title
        return headerView
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! ContactCell
        cell.contact = groupedContacts[indexPath.section][indexPath.item]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = groupedContacts[indexPath.section][indexPath.item]
        guard contact.type != .noNumber else {
            return
        }
        let contactTVC = ContactTVC(style: .grouped)
        contactTVC.contactProfile = contact.toContactProfile()
        navigationController?.pushViewController(contactTVC, animated: true)
        
    }
    
    private func setupTableView() {
        tableView.register(ContactCell.self, forCellReuseIdentifier: CELL_ID)
        tableView.rowHeight = 70
        tableView.sectionHeaderHeight = 40
        tableView.tableFooterView = UIView()
    }
    
    private func setupController() {
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = "Contactos"
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.keyboardAppearance = .dark
        definesPresentationContext = true
        ContactsHelper.shared.delegate = self
        
    }

}

extension ContactsTVC: ContactsDelegate {
    
    func addressBookChanged() {
        loadContacts()
    }
    
    private func loadContacts() {
        ContactsHelper.shared.getContacts()
        .done { [weak self] (contactResult) in
            guard let `self` = self else { return }
            self.contacts = contactResult
            self.filterContacts()
        }.catch { [weak self] (error) in
            guard let `self` = self else { return }
            self.alert(message: error.localizedDescription)
        }
    }
    
    private func updateResults(contacts contactsToShow: [Contact]) {
        
        groupedContacts = ContactsHelper.shared.groupContacts(contacts: contactsToShow)
        
        tableView.reloadData()
        guard groupedContacts.count > 0 else {
            tableView.emptyMessage()
            return
        }
        tableView.resetEmptyMessage()
    }
    
    private func filterContacts() {
        
        guard !lastFilter.isEmpty else {
            updateResults(contacts: contacts)
            return
        }
        
        let filteredContacts = contacts.filter({
            $0.fullName.forSearch.contains(lastFilter)
            || $0.firstName.forSearch.contains(lastFilter)
            || $0.lastName.forSearch.contains(lastFilter)
            || $0.firstNumber.forSearch.contains(lastFilter) })
        
        updateResults(contacts: filteredContacts)
    }
    
    
}

extension ContactsTVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text else {
            updateResults(contacts: contacts)
            return
        }
        
        lastFilter = filter.forSearch
        filterContacts()
    }
    
    
}
