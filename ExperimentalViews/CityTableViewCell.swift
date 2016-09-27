//
//  ParallaxTableViewCell.swift
//  ExperimentalViews
//
//  Created by Wesley Matlock on 9/26/16.
//  Copyright © 2016 net.insoc. All rights reserved.
//

import UIKit

class CityTableViewCell: UITableViewCell {

    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var anImage: UIImageView!
    @IBOutlet weak var imageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageBottomConstraint: NSLayoutConstraint!
    
    let parallaxFactor: CGFloat = 40
    var imageTopInitialConstraint: CGFloat!
    var imageBottomInitialConstraint: CGFloat!
    
    var currentCity: City! {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        clipsToBounds = true
        imageBottomConstraint.constant -= 2 * parallaxFactor
        imageTopInitialConstraint = imageTopConstraint.constant
        imageBottomInitialConstraint = imageBottomConstraint.constant
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func updateView() {
        
        anImage.image = UIImage(named: currentCity.image)
        place.text = currentCity.name
    }
    
    func setBackGroundOffset( _ offset: CGFloat) {
        
        let boundOffSet = max(0, min(1, offset))
        let pixelOffSet = (1 - boundOffSet) * 2 * parallaxFactor
        
        imageTopConstraint.constant = imageTopInitialConstraint - pixelOffSet
        imageBottomConstraint.constant = imageBottomInitialConstraint + pixelOffSet
    }
}
