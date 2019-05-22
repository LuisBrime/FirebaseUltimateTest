//
//  StudentsTableViewController.swift
//  FirebaseUltimateTest
//
//  Created by Luis Eduardo Brime Gomez on 5/21/19.
//  Copyright © 2019 Luis Eduardo Brime Gomez. All rights reserved.
//

import UIKit
import Firebase

class StudentsTableViewController: UITableViewController {
    var teamID:String?
    
    var students = [DocumentReference]()
    
    var ss = [Any]()
    var ids = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        Firestore.firestore().collection("teams").document(teamID!).getDocument() { (document, err) in
            if let document = document, let data = document.data() {
                if let resultedS = data["students"] as? [DocumentReference] {
                    for id in resultedS {
                        self.students.append(id)
                    }
                    
                    for student in self.students {
                        student.getDocument() { (document, err) in
                            if let err = err {
                                print("Error \(err)")
                            } else {
                                let data = document?.data()
                                self.ss.append(data)
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
        return (ss.count)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "students", for: indexPath)
        
        let r = ss[indexPath.row] as! [String:Any]
        var s = r["nombre"] as! String
        s += r["apellidos"] as! String
        
        cell.textLabel?.text = s
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is TasksTableViewController {
            let vc = segue.destination as! TasksTableViewController
            vc.studentID = ids[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
}
