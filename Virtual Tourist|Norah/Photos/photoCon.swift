//
//  photoCon.swift
//  Virtual Tourist|Norah
//
//  Created by نورة . on 20/09/2019.
//  Copyright © 2019 نورة . All rights reserved.
//

import Foundation

import Foundation
import MapKit
import CoreData

extension PhotoFliViewController: MKMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {
    
    //number of ITEMS in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return fetchedResultsController.fetchedObjects!.count
    }
    
    //cell for item
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "phCollectionViewCell", for: indexPath) as! PhCollectionViewCell
        
        
        let photo = fetchedResultsController.object(at: indexPath)
        
        if let data = photo.imageData {
            cell.image.image = UIImage(data: data)
        } else {
            //  activityIndicator(cell: cell, status: true)
            cell.contentView.alpha = 1.0
            
            loadImage(imagePath: photo.imageurl!) { imageData, errorString in
                if let imageData = imageData {
                    DispatchQueue.main.async {
                        //   self.activityIndicator(cell: cell, status: false)
                        cell.image.image = UIImage(data: imageData)
                    }
                    photo.imageData = imageData
                    try? self.dataController.viewContext.save()
                }
            }
        }
        
        return cell
    }
    
    //did select item at
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = fetchedResultsController.object(at: indexPath)
        dataController.viewContext.delete(photo)
        try? dataController.viewContext.save()
        
    }
    
    //did des item at
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.contentView.alpha = 1.0
        
        if let index = listphoto.firstIndex(of: indexPath) {
            listphoto.remove(at: index)
        }
    }
    
    
    
    //MARK: delete Selected Photos
    func deleteSelectedPhotos() {
        let photos = listphoto.map() { fetchedResultsController.object(at: $0) }
        photos.forEach() { photo in
            dataController.viewContext.delete(photo)
            listphoto.removeAll()
            
            try? dataController.viewContext.save()
        }
        
        
    }
  
    
    //MARK:  func
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            self.collectionView.insertItems(at: [newIndexPath!])
            
        case .delete:
            self.collectionView.deleteItems(at: [indexPath!])
        case .move:
            self.collectionView.moveItem(at: indexPath!, to: newIndexPath!)
        case .update:
            self.collectionView.reloadItems(at: [indexPath!])
        }
    }
    
    // MARK:load Image func
    func loadImage( imagePath:String, completionHandler: @escaping (_ imageData: Data?, _ errorString: String?) -> Void){
        
        let imgURL = NSURL(string: imagePath)
        let request: NSURLRequest = NSURLRequest(url: imgURL! as URL)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {data, response, downloadError in
            if downloadError != nil {
                completionHandler(nil, " can not load image  \(imagePath)")
            } else {
                completionHandler(data, nil)
            }
        }
        task.resume()
    }
    
}

