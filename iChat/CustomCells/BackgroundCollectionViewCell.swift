//
//  BackgroundCollectionViewCell.swift
//  iChat
//
//  Created by Imran Rahman on 11/9/18.
//  Copyright © 2018 Imran Rahman. All rights reserved.
//

import UIKit

class BackgroundCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    func generateCell(image: UIImage){
        self.imageView.image = image
    }
}
