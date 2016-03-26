//
//  PopularFeedViewController.swift
//  SnapyTag
//
//  Created by Rishi Mukherjee on 07/02/16.
//  Copyright © 2016 snapyTag. All rights reserved.
//

import UIKit

class PopularFeedViewController: UITableViewController {

    let snapFeedCellIdentifier = "SnapFeedCell"


    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        view.tag = 1
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationController?.navigationBar.translucent = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 350.0
        tableView.showsVerticalScrollIndicator = false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: SnapFeedCell
        if tableView.dequeueReusableCellWithIdentifier(snapFeedCellIdentifier) == nil {
            cell = SnapFeedCell()
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier(snapFeedCellIdentifier) as! SnapFeedCell
        }
        
        if indexPath.row == 1 {
            cell.snapImageView.image = UIImage(named: "image_login_user")
            cell.descriptionLabel.text = "Hi I am awesome"
            cell.directionButton.setTitle("250 m away", forState: .Normal)
            cell.voteCountLabel.text = "10000"
        }
        return cell
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

}
