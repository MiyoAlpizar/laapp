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
    private var filterdContacts = [Contact]()
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filterdContacts.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! ContactCell
        cell.contact = filterdContacts[indexPath.item]
        return cell
    }
    
    private func setupTableView() {
        tableView.register(ContactCell.self, forCellReuseIdentifier: CELL_ID)
        tableView.rowHeight = 70
        tableView.tableFooterView = UIView()
    }
    
    private func setupController() {
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = "Contactos"
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
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
    
    private func updateResults() {
        tableView.reloadData()
        guard filterdContacts.count > 0 else {
            tableView.emptyMessage()
            return
        }
        tableView.resetEmptyMessage()
    }
    
    private func filterContacts() {
        
        guard !lastFilter.isEmpty else {
            filterdContacts = contacts
            updateResults()
            return
        }
        
        filterdContacts = contacts.filter({ $0.firstName.forSearch.contains(lastFilter) || $0.lastName.forSearch.contains(lastFilter) || $0.firstNumber.forSearch.contains(lastFilter) })
        updateResults()
    }
    
    
}

extension ContactsTVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text else {
            filterdContacts = contacts
            updateResults()
            return
        }
        
        lastFilter = filter.forSearch
        filterContacts()
    }
    
    
}
