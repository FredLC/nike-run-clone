//
//  SecondViewController.swift
//  NikeRunClone
//
//  Created by Fred Lefevre on 2019-03-15.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import UIKit

class LogRunVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }


}

extension LogRunVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Run.getRuns()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "runLogCell") as? RunLogCell {
            guard let run = Run.getRuns()?[indexPath.row] else {
                return RunLogCell()
            }
            cell.configureCell(run: run)
            return cell
        }
        return UITableViewCell()
    }
    
    
}
