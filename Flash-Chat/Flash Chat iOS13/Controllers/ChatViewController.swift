//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class ChatViewController: UIViewController {

    let db = Firestore.firestore()

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    var messages : [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        messageTextfield.delegate = self
        title = K.appName
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
    }
    func loadMessages(){
        
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener() { (querySnapshot, err) in
            self.messages = []
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let docs = querySnapshot?.documents {
                    for doc in docs {
                        if let message = doc.data()[K.FStore.bodyField] as? String , let sender = doc.data()[K.FStore.senderField] as? String {
                            let newMessage = Message(body: message, sender: sender)
                            self.messages.append(newMessage)
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                if !self.messages.isEmpty {
                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                    self.tableView.scrollToRow(at: indexPath,
                                               at: .top,
                                               animated: false)
                }
            }
        }
    }
    func sendMessage() {

        if let message = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            if message.isEmpty {
                return
            }
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: messageSender,
                K.FStore.bodyField: message ,
                K.FStore.dateField : NSDate().timeIntervalSince1970
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Data added successfuly")
                }
            }
        }
        messageTextfield.endEditing(true)
    }
    @IBAction func sendPressed(_ sender: UIButton) {
        sendMessage()
    }
    
    @IBAction func LogOutPressed(_ sender: UIBarButtonItem) {
          do {
              try Auth.auth().signOut()
              navigationController?.popToRootViewController(animated: true)
              
          } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
          }
    }
    
}

//MARK: - UITableViewDataSource

extension ChatViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        
        // send by current user
        if message.sender == Auth.auth().currentUser?.email{
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.messageText.textColor = UIColor(named: K.BrandColors.purple)
        } else {
            cell.rightImageView.isHidden = true
            cell.leftImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.messageText.textColor = UIColor(named: K.BrandColors.lightPurple)
        }

        
        cell.messageText.text = message.body
        
        /*    USE IT From ios 14 and newer because cell.textLabel will be removed
         
                 var content = cell.defaultContentConfiguration()

                 // Configure content.
                 content.image = UIImage(systemName: "star")
                 content.text = messages[indexPath.row].body

                 // Customize appearance.
                 content.imageProperties.tintColor = .purple

                 cell.contentConfiguration = content
         */

        return cell
    }
    
}

//MARK: - UITextFieldDelegate

extension ChatViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        messageTextfield.text = ""
    }

}
