//
//  SettingsViewController.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/12/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import UIKit
import MessageUI

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
        
        if indexPath.row == 0 {         // version row
        
        } else if indexPath.row == 1 {  // feedback row
            self.sendEmail()
        
        } else if indexPath.row == 2 {  // icons8 row
            UIApplication.shared.open(URL(string: "https://icons8.com/")!)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// Mark: MFMailComposeViewControllerDelegate
extension SettingsViewController: MFMailComposeViewControllerDelegate {
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["mlmartinez85@gmail.com"])
            mail.setSubject("App Feedback")
            mail.setMessageBody("You're so awesome!", isHTML: false)
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
