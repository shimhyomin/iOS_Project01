//
//  FindViewController.swift
//  HyWorld
//
//  Created by shm on 2021/10/08.
//

import UIKit
import Firebase

class FindViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var friendList: [String] = []
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFirends()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    private func loadFirends() {
        db.collection("users").addSnapshotListener { querySnapshot, error in
            self.friendList = []
            
            if let error = error {
                print("Fail retrieving data from Firestore, \(error)")
            } else {
                if let document = querySnapshot?.documents {
                    print("document \(document)")
                    for doc in document {
                        print("data \(doc.data())")
                        print("data type \(type(of: doc.data()))")
                        
                        self.friendList.append("friend \(doc.data())")
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
            
        }
    }
    
    //MARK: - TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FirendCell", for: indexPath)
        cell.textLabel?.text = friendList[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ChattingViewController") as? ChattingViewController else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

//MARK: - UISearchBarDelegate
extension FindViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // users collection에서 nickname이 searchText와 일치하는 document를 가져온다.
    }
}
