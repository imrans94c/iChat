//
//  PicturesCollectionViewCell.swift
//  iChat
//
//  Created by Imran Rahman on 11/7/18.
//  Copyright © 2018 Imran Rahman. All rights reserved.
//

import UIKit

class PicturesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func generteCell(image:UIImage){
        self.imageView.image = image
    }
    
}
