//
//  ChatViewController.swift
//  chat
//
//  Created by Xiu Chen on 6/26/17.
//  Copyright © 2017 Xiu Chen. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var chatField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var ChatPFObject: [PFObject]?

    
    // var PFObject: [
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self as? UITableViewDelegate
        tableView.dataSource = self
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ChatPFObject == nil{
            return 0
        }
        return ChatPFObject!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCellTableViewCell
        let object = ChatPFObject![indexPath.row]
        let message = object["text"] as? String
        if let user = object["user"] as? PFUser {
            cell.userLabel.text = user.username
        } else {
            cell.userLabel.text = "No Name"
        }
        
        cell.chatLabel.text = message
        return cell
    }
    
    func onTimer() {
        let query = PFQuery(className: "Message_fbu2017")
        query.addDescendingOrder("createdAt")
        query.includeKey("user")
        query.findObjectsInBackground { (messages: [PFObject]?, error: Error?) in
            self.ChatPFObject = messages
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        let chatMessage = PFObject(className: "Message_fbu2017")
        chatMessage["text"] = chatField.text ?? ""
        
        let user = PFUser.current()
        
        chatMessage["user"] = user
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
                self.chatField.text = ""
                
                
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
