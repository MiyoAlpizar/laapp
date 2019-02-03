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
    private let searchController = UISearchController(searchResultsController: nil)
    
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
        return contacts.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! ContactCell
        cell.contact = contacts[indexPath.item]
        return cell
    }

}

extension ContactsTVC {
    
    private func loadContacts() {
        ContactsHelper.shared.getContacts()
        .done { [weak self] (contactResult) in
            guard let `self` = self else { return }
            self.contacts = contactResult
            self.tableView.reloadData()
        }.catch { [weak self] (error) in
            guard let `self` = self else { return }
            self.alert(message: error.localizedDescription)
        }
    }
    
    private func setupTableView() {
        tableView.register(ContactCell.self, forCellReuseIdentifier: CELL_ID)
        tableView.rowHeight = 70
    }
    
    private func setupController() {
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationItem.title = "Contactos"
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Buscar"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
}

extension ContactsTVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
