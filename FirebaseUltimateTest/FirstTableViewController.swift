//
//  FirstTableViewController.swift
//  FirebaseUltimateTest
//
//  Created by Luis Eduardo Brime Gomez on 5/7/19.
//  Copyright © 2019 Luis Eduardo Brime Gomez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class FirstTableViewController: UITableViewController {
    var groups = [Any]()
    var ids = [String]()
    @IBOutlet var signOutButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Firestore.firestore().collection("groups").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.groups.append(document.data())
                    self.ids.append(document.documentID)
                }
                self.tableView.reloadData()
            }
            
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (groups.count)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groups", for: indexPath)

        let g = groups[indexPath.row] as! [String:Any]
        let s = g["nombreMateria"] as! String 
        
        cell.textLabel?.text = s

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is TeamsTableViewController {
            let vc = segue.destination as! TeamsTableViewController
            vc.materiaID = ids[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    @IBAction func signOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "logoutSegue", sender: nil)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
