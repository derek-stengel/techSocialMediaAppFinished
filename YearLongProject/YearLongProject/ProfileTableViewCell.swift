//
//  ProfileTableViewCell.swift
//  YearLongProject
//
//  Created by Derek Stengel on 7/2/24.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var profileName: UILabel!
    @IBOutlet var profileBio: UILabel!
    @IBOutlet var interests: UILabel!
    @IBOutlet var settingsButton: UIButton!
    
    static let identifier = "ProfileTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ProfileTableViewCell", bundle: nil)
    }
    
    func configure(with profile: Profile) {
        profileName.text = profile.name
        profileBio.text = profile.bio
        interests.text = profile.interests
    }
    
}
