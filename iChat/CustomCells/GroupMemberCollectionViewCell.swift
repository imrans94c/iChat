//
//  GroupMemberCollectionViewCell.swift
//  iChat
//
//  Created by Imran Rahman on 11/10/18.
//  Copyright © 2018 Imran Rahman. All rights reserved.
//

import UIKit


protocol GroupMemberCollectionViewCellDelegate {
    func didClickDeleteButton(indexPath : IndexPath)
}

class GroupMemberCollectionViewCell: UICollectionViewCell {
    
    var indexPth : IndexPath!
    
    var delegate : GroupMemberCollectionViewCellDelegate?
    
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    func generateCell(user : FUser, indexPath : IndexPath){
        
        self.indexPth = indexPath
        nameLabel.text = user.firstname
        
        if user.avatar != "" {
            imageFromData(pictureData: user.avatar) { (avatarImage) in
                
                if avatarImage != nil {
                    self.avatarImageView.image = avatarImage!.circleMasked 
                }
            }
        }
    }
    

    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        
        delegate!.didClickDeleteButton(indexPath: indexPth)
    }
    
    
}
