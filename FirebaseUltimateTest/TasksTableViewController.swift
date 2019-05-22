//
//  TasksTableViewController.swift
//  FirebaseUltimateTest
//
//  Created by Luis Eduardo Brime Gomez on 5/21/19.
//  Copyright © 2019 Luis Eduardo Brime Gomez. All rights reserved.
//

import UIKit
import Firebase

class TasksTableViewController: UITableViewController {
    var studentID:String?
    
    var tasks = [DocumentReference]()
    
    var ts = [Any]()
    var ids = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        Firestore.firestore().collection("students").document(studentID!).getDocument() { (document, err) in
            if let document = document, let data = document.data() {
                if let resultedT = data["tasks"] as? [DocumentReference] {
                    for id in resultedT {
                        self.tasks.append(id)
                    }
                    
                    for task in self.tasks {
                        task.getDocument() { (document, err) in
                            if let err = err {
                                print("Error \(err)")
                            } else {
                                let data = document?.data()
                                self.ts.append(data)
                                self.ids.append(document!.documentID)
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (ts.count)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tasks", for: indexPath)
        
        let t = ts[indexPath.row] as! [String:Any]
        lett s = t["name"] as! String
        
        cell.textLabel?.text = s
        
        return cell
    }
}
