//
//  LeaderboardViewController.swift
//  GoonMaker
//
//  Created by Neema on 2/15/21.
//

import UIKit


class LeaderboardViewController: UIViewController {
    
    
    @IBOutlet weak var leaderboardTableView: UITableView!
    
    var leaderBoardArray = [UserInfo]() {
        didSet {
            leaderboardTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leaderboardTableView.delegate = self
        leaderboardTableView.dataSource = self
        loadLeaderboard()
        navigationController?.navigationBar.prefersLargeTitles = true

    }
    func loadLeaderboard() {
        FirestoreService.manager.getLeaderBoard { (results) in
            switch results {
            case .failure(let appError):
                print("there was an error loading the leaderboard: \(appError)")
            case .success(let leaderBoard):
                let sortedLeaderBoard = leaderBoard.sorted(by: {$0.score > $1.score})
                // birdData.sorted(by: {$0.commonName < $1.commonName})
                self.leaderBoardArray = sortedLeaderBoard
            }
        }
    }
}
extension LeaderboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaderBoardArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = leaderboardTableView.dequeueReusableCell(withIdentifier: "leaderboardCell", for: indexPath)
        let score = leaderBoardArray[indexPath.row]
        cell.textLabel?.text = ("Score:\(score.score)")
        cell.detailTextLabel?.text = ("Name: \(score.name)")
        return cell
        
    }
    
    func tableView(_ tableView:UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRow = indexPath.row
        print(selectedRow)
    }
}
