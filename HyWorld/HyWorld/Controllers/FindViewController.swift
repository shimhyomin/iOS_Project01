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
    
    var friendList: [User] = []
    
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
        //!!!ChattingManager 함수로 만들기!!!
        db.collection("users").addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Fail retrieving data from Firestore, \(error)")
            } else {
                
                if let documents = querySnapshot?.documents {
                    self.friendList = documents.compactMap({ doc -> User? in
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: doc.data(), options: [])
                            let user = try JSONDecoder().decode(User.self, from: jsonData)
                            return user
                        } catch let error {
                            print("Fail JSON Parsing, \(error)")
                            return nil
                        }
                    })
                    //???dispatchQueue.main.async 필요한가???
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
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
        cell.textLabel?.text = friendList[indexPath.row].nickname
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ChattingViewController") as? ChattingViewController else { return }
        
        //viewController.opponent = friendList[indexPath.row]
        viewController.opponentUID = friendList[indexPath.row].uid
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

//MARK: - UISearchBarDelegate
extension FindViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // todo
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // users collection에서 nickname이 searchText와 일치하는 document를 가져온다.
    }
}
