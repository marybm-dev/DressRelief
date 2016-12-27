//
//  MyClosetViewController.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/12/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import UIKit
import Koloda
import RealmSwift

class MyClosetViewController: MeuItemViewController, KolodaViewDataSource, KolodaViewDelegate {
    
    var outfits: Results<Outfit>!
    
    @IBOutlet weak var kolodaView: KolodaView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let realm = try! Realm()
        outfits = realm.objects(Outfit.self)
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return outfits.count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let outfit = outfits[index]
        outfit.setImagePath()
        
        let image = Helper.articleImage(atPath: outfit.combinedImgUrl)
        
        return UIImageView(image: image)
    }
}
