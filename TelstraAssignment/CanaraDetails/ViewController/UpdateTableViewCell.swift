//
//  UpdateTableViewCell.swift
//  TelstraAssignment
//
//  Created by Aditi Garg on 15/04/20.
//  Copyright © 2020 Aditi Garg. All rights reserved.
//

import UIKit

class UpdateTableViewCell: UITableViewCell {
    
    var updates : Rows? {
        didSet{
            guard let listItem = updates else  {return}
            
            if let title = listItem.title{
                titleLabel.text = title
        }
        updatesImageView.image = nil
        if let imageURL = listItem.imageHref {
            updatesImageView.loadAsyncFrom(url: imageURL, placeholder: Utils.placeholderImg)
        }
            
            
        if let description = listItem.description{
            descriptionLabel.text = description
           
        }
    }
}
    
    let updatesImageView: AsyncImageView = {
        let img = AsyncImageView()
        img.contentMode = .scaleAspectFill //image will never scretch
        img.translatesAutoresizingMaskIntoConstraints = false // enable Autolayout
        img.layer.cornerRadius = 25
        img.clipsToBounds = true
        return img
    }()

    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style : style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(updatesImageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(descriptionLabel)
       
        
        
        updatesImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        updatesImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
        updatesImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        updatesImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let marginGuide = contentView.layoutMarginsGuide
        

        titleLabel.leadingAnchor.constraint(equalTo: self.updatesImageView.trailingAnchor, constant: 10).isActive = true
        titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        titleLabel.numberOfLines = 0
      
        descriptionLabel.leadingAnchor.constraint(equalTo: self.updatesImageView.trailingAnchor,constant: 10).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
         descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        descriptionLabel.numberOfLines = 0
        
    }
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
}
}
