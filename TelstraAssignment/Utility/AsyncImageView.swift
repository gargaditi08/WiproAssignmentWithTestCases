//
//  AsyncImageView.swift
//  TelstraAssignment
//
//  Created by Aditi Garg on 15/04/20.
//  Copyright © 2020 Aditi Garg. All rights reserved.
//

import UIKit

//Marck: -  'asyncImageCacheArray' is a global variable cached UIImage
var asyncImageCacheArray = NSCache<NSString, UIImage>()

class AsyncImageView: UIImageView {
    
    //Marck : Variables
    private var currentURL : NSString?
    
    //Mark: - Public Methods
    
    func loadAsyncFrom(url : String, placeholder : UIImage?) {
       
        let imageURL = url as NSString
        
        //To check is image is already in cache then load it
        
        if let cachedImage = asyncImageCacheArray.object(forKey: imageURL) {
            image = cachedImage
            return
        }
        image = placeholder
        currentURL = imageURL
        guard let requestURL = URL(string: url) else { image = Utils.placeholderImg; return}
        URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            DispatchQueue.main.async { [weak self] in
                if error == nil {
                    
                    if let imageData = data {
                        if self?.currentURL == imageURL {
                           
                            if let imageToPresent = UIImage (data: imageData){
                              asyncImageCacheArray.setObject(imageToPresent, forKey: imageURL)
                                self?.image = imageToPresent
                            } else {
                                self?.image = Utils.placeholderImg
                            }
                        }
                    } else {
                        self?.image = Utils.placeholderImg
                    }
                } else {
               self?.image = Utils.placeholderImg
            }
        }
        
    }.resume()
    
    
    }
    
}

