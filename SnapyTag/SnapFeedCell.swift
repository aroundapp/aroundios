//
//  SnapFeedCell.swift
//  SnapyTag
//
//  Created by Rishi Mukherjee on 06/03/16.
//  Copyright © 2016 snapyTag. All rights reserved.
//

import UIKit

class SnapFeedCell: UITableViewCell {

    @IBOutlet var backView: UIView!
    @IBOutlet var snapImageView: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var directionButton: UIButton!
    @IBOutlet var voteCountLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dislikeButton: UIButton!
    @IBOutlet var imageLoadingIndicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        designBackView()
        imageLoadingIndicator.hidesWhenStopped = true
        directionButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func designBackView() {
        let backViewLayer = self.backView.layer
        backViewLayer.shadowOffset = CGSizeZero
        backViewLayer.shadowColor = UIColor.blackColor().CGColor
        backViewLayer.shadowRadius = 2.0
        backViewLayer.shadowOpacity = 0.6
        self.backView.layer.shouldRasterize = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutSubviews()
    }

    @IBAction func directionButtonPressed(sender: UIButton) {
        
    }

}
