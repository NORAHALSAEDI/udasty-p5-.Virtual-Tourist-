//
//  PhotoFliViewController.swift
//  Virtual Tourist|Norah
//
//  Created by نورة . on 20/09/2019.
//  Copyright © 2019 نورة . All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotoFliViewController: UIViewController {
    
    //MARK:IBOutlet
    
    @IBOutlet weak var massLabel: UILabel!
    @IBOutlet weak var ButtonUpdate: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var Activityindicator: UIActivityIndicatorView!
    
    //MARK: Variables
    var pageNumber = 1
    var isDeletingEverything = false
    var pin: Pin!
    var dataController: DataController!
    var fetchedResultsController: NSFetchedResultsController<Photos>!
    var listphoto: [IndexPath]! = []
    
    
    //MARK: viewDidLoad & viewWillAppear functions
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name:"EuphemiaUCAS",size: 50)!], for:.normal)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataController = appDelegate.dataController
        collectionView.allowsMultipleSelection = true
        collectionView.delegate = self
        collectionView.dataSource = self
        setupFetchedResultsController()}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()}
    
    //MARK: Cheek
    var check: Bool {
        return (fetchedResultsController.fetchedObjects?.count ?? 0) != 0}
    
    //MARK: updatePhtotsaction
    @IBAction func updatePhtotsaction(_ sender: Any) {
        update(processing: true)
        if check {
            isDeletingEverything = true
            for photo in fetchedResultsController.fetchedObjects! {
                dataController.viewContext.delete(photo)
                try? dataController.viewContext.save()
            }
            isDeletingEverything = false
        }
        loadPhotosforflickr()
    }
    
    
    //MARK: update Photos
    func update(processing: Bool) {
        
        collectionView.isUserInteractionEnabled = !processing
        if processing {
            ButtonUpdate.title = ""
        } else {
            ButtonUpdate.title = "New Collection"
        }
    }
    
    //MARK: setupFetchedResultsController func
    func setupFetchedResultsController() {
        
        let fetchRequest:NSFetchRequest<Photos> = Photos.fetchRequest()
        let predicate = NSPredicate(format: "pin == %@", pin)
        
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = []
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)

        //MARK:from controller func
        fetchedResultsController.delegate = self
        do{
            try fetchedResultsController.performFetch()
            if check {
                update(processing: false)
            } else {
                 updatePhtotsaction(self)
            }
            
        }catch{
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    //MARK: loadPhotosforflickr func
    func loadPhotosforflickr() {
        
        let flickrCall = Network.sharedInstance
        
        flickrCall.getPhotosLocation(pin.latitude, pin.longitude, pageNumber:pageNumber) { (success, photos) in
            DispatchQueue.main.async {
                self.update(processing: false)
             self.activityIndicator(status: false)
                if success == false {

                    self.showAlert(message: "Unable to download images from Flickr", vc: self)
                    return
                }
                
                if photos!.count == 0 {
                   self.massLabel.isHidden = false
                    self.ButtonUpdate.isEnabled = false
                }
                else {
                    print("Flickr images fetched : \(photos!.count)")
                }
                
                photos!.forEach() { photo_url in
                    let photo = Photos(context: self.dataController.viewContext)
                    photo.imageurl = URL(string: photo_url["url_m"] as! String)?.absoluteString
                    photo.pin = self.pin
                    self.activityIndicator(status: true)
                    do {
                        // Saves to CoreData
                        try self.dataController.viewContext.save()
                    } catch  {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        pageNumber += 1
    }
    

     
    
    
    
}

