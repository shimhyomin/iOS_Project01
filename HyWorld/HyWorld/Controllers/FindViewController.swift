//
//  FindViewController.swift
//  HyWorld
//
//  Created by shm on 2021/10/08.
//

import UIKit
import Firebase

class FindViewController: UITableViewController {

    var friendList: [String] = ["Alex", "Jemy", "Hyomin", "Lion", "Ale", "LAlex", "Alexx"]
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FirendCell", for: indexPath)
        
        cell.textLabel?.text = friendList[indexPath.row]
        
        return cell
    }
    
}

//MARK: - UISearchBarDelegate
extension FindViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("textDidChange")
    }
}
