//
//  ImageService.swift
//  AnimeClassifier
//
//  Created by Ali Eldeeb on 1/22/23.
//

import UIKit
import FirebaseStorage

struct ImageService {
    static let shared = ImageService()
    private var imageUrls = NSCache<NSData, NSString>()
    
    func registerImage(animeImage: UIImage, completion: @escaping(String) -> ()) {
        //convert the anime image from its current state into a data object, if you dont compress the image the file it uploads can potentially be very large and it will take longer for your device to download/load the image when you are making the api call to fetch it,
        guard let imageData = animeImage.jpegData(compressionQuality: 0.3) else{ return }
        
        //check if the imageData key is in our cache, if it isnt it will be a cache miss and the rest of the function will execute and it will later be stored in the cache
        if let imageUrl = imageUrls.object(forKey: imageData as NSData) {
            completion(imageUrl as String)
            return
        }
        
        //now that we have the imageData we need to make a unique filename for our data
        let filename = NSUUID().uuidString
        
        //create a storage reference, i.e. where we want to put our data
        let storageRef = STORAGE_ANIME_IMAGES.child(filename)
        
        //upload that data into the database
        storageRef.putData(imageData) { meta, error in
            //how to get the download url
            storageRef.downloadURL { url, error in
                guard let animeImageUrl = url?.absoluteString else{ return }
                imageUrls.setObject(animeImageUrl as NSString, forKey: imageData as NSData)
                completion(animeImageUrl)
            }
        }
    }
}
