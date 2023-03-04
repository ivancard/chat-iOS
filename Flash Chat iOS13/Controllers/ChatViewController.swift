//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    let db = Firestore.firestore()

    var messages: [Message] = []

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier )
        loadMessages()
    }

    private func loadMessages() {

        db.collection(Constants.FStore.collectionName).order(by: Constants.FStore.dateField).addSnapshotListener { (querySnapshot, error) in
            self.messages = []
            if let error = error {
                print(error)
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for document in snapshotDocuments {
                        let data = document.data()
                        if let sender = data[Constants.FStore.senderField] as? String,
                           let body = data[Constants.FStore.bodyField] as? String {
                            let newMessage = Message(sender: sender, body: body)
                            self.messages.append(newMessage)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text,
           let messageSender = Auth.auth().currentUser?.email {

            db.collection(Constants.FStore.collectionName)
                .addDocument(data: [
                    Constants.FStore.bodyField:messageBody,
                    Constants.FStore.senderField:messageSender,
                    Constants.FStore.dateField:Date().timeIntervalSince1970]) { error in
                    if let error = error {
                        print(error)
                    } else {
                        print("Success saved data")
                        DispatchQueue.main.async {
                            self.messageTextfield.text = ""
                        }
                    }
                }
        }
    }
    
    @IBAction func logOutAction(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()

        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError{
            print("Error signing out, reasons: \(signOutError)")
        }
    }

}

//MARK: - TableViewDelegate and DataSource

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! MessageTableViewCell
        cell.messageLabel.text = message.body

        if message.sender == Auth.auth().currentUser?.email {
            cell.otherProfilePicture.isHidden = true
            cell.profilePicture.isHidden = false
//            cell.messageBubble.backgroundColor = UIColor(named: "Primary")
        } else {
            cell.otherProfilePicture.isHidden = false
            cell.profilePicture.isHidden = true
//            cell.messageBubble.backgroundColor = UIColor(named: "primary")
        }


        return cell
    }


}
