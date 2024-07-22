//
//  Protocols.swift
//  YearLongProject
//
//  Created by Derek Stengel on 7/2/24.
//

import Foundation

protocol NewPostViewControllerDelegate: AnyObject {
    func didCreatePost(_ post: Post)
}

protocol PostCreationNotifcationDelegate: AnyObject {
    func didCreatePost(_ post: Post)
}

protocol SettingsDelegate: AnyObject {
    func didUpdateProfile(name: String?, bio: String?, interests: String?)
}

