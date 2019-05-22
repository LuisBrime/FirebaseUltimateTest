//
//  TeamsTableViewController.swift
//  
//
//  Created by Luis Eduardo Brime Gomez on 5/21/19.
//

import UIKit
import Firebase

class TeamsTableViewController: UITableViewController {
    var materiaID:String?
    
    var teams = [DocumentReference]()
    
    var ts = [Any]()
    var ids = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Firestore.firestore().collection("groups").document(materiaID!).getDocument() { (document, err) in
            if let document = document, let data = document.data() {
                if let tt = data["teams"] as? [DocumentReference] {
                    for id in tt {
                        self.teams.append(id)
                    }
                    
                    for team in self.teams {
                        team.getDocument() { (document, err) in
                            if let err = err {
                                print("Error \(err)")
                            } else {
                                let data = document?.data()
                                print("Hehe \(data)")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "teams", for: indexPath)
        
        let t = ts[indexPath.row] as! [String:Any]
        let s = t["nombreEquipo"] as! String
        
        cell.textLabel?.text = s
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is StudentsTableViewController {
            let vc = segue.destination as! StudentsTableViewController
            vc.teamID = ids[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
}
