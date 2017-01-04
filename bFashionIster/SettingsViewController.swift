//
//  SettingsViewController.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/12/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import UIKit

class SettingsViewController: MeuItemViewController {

    @IBOutlet weak var tableView: UITableView!
    let items = AboutItem.all()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.reloadData()
    }
}

// Mark: UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutCell", for: indexPath) as! AboutTableViewCell
        cell.item = items[indexPath.row]
        
        return cell
    }
}

// Mark: UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // do something
    }
}
