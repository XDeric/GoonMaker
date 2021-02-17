//
//  LeaderboardViewController.swift
//  GoonMaker
//
//  Created by Neema on 2/15/21.
//

import UIKit


class LeaderboardViewController: UIViewController {
    
    
    @IBOutlet weak var leaderboardTableView: UITableView!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leaderboardTableView.delegate = self
        leaderboardTableView.dataSource = self
        view.backgroundColor = .systemTeal
        
    }
    
}
extension LeaderboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = leaderboardTableView.dequeueReusableCell(withIdentifier: "leaderboardCell", for: indexPath)
//        cell.textLabel?.text = 
//         cell.detailTextLabel?.text =
        return cell
        
    }
    
    func tableView(_ tableView:UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRow = indexPath.row
        print(selectedRow)
    }
}
