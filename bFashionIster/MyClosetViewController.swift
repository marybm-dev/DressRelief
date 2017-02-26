//
//  MyClosetViewController.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/12/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import UIKit
import RealmSwift

class MyClosetViewController: MeuItemViewController {
    
//    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var topsCollectionView: UICollectionView!
    @IBOutlet weak var bottomsCollectionView: UICollectionView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var emptyView: UIView!
    
    let realm = try! Realm()
    var subscriptions = [NotificationToken]()
    var articles: Results<Article>!
    var tops: Results<Article>!
    var bottoms: Results<Article>!
    let itemsPerRow: CGFloat = 1
    let itemsPerCol: CGFloat = 1
    let sectionInsets = UIEdgeInsets(top: 0.0, left: 25.0, bottom: 0.0, right: 25.0)
    var viewHasLoaded = false

    var outfits: Results<Outfit>!
    var outfitToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        likeButton.round(corners: [.allCorners], radius: (likeButton.frame.size.width/2), borderColor: .flatGray(), borderWidth: 5.0)

        let nib = UINib(nibName: "OutfitArticleCollectionViewCell", bundle: nil)
        topsCollectionView.register(nib, forCellWithReuseIdentifier: "OutfitTopCell")
        bottomsCollectionView.register(nib, forCellWithReuseIdentifier: "OutfitBottomCell")

        outfits = realm.objects(Outfit.self)
        articles = realm.objects(Article.self)
        tops = getTops()
        bottoms = getBottoms()
        
        let topsSubscription = notificationSubscription(for: tops)
        let bottomsSubscription = notificationSubscription(for: bottoms)
        subscriptions = [topsSubscription, bottomsSubscription]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.toggleHidden()
        
        if viewHasLoaded {
            self.scrollToCenter(collectionView: topsCollectionView)
            self.scrollToCenter(collectionView: bottomsCollectionView)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewHasLoaded = true
        self.updateLikeButtonImage(isLiked: nil)
    }

    deinit {
        for notificationToken in subscriptions {
            notificationToken.stop()
        }
    }
    
    @IBAction func didTapLikeButton(_ sender: Any) {
        let outfitResult = outfitExists()
        let exists = outfitResult.exists
        var isLiked = exists
        
        // update the database
        try! realm.write {
            // like or dislike it if it exists
            if exists {
                let outfit = outfitResult.outfit
                guard outfit != nil else {
                    return
                }
                
                if (outfit?.isLiked)! {
                    print("liked -> unliked")
                    self.unfavorite(outfit!)
                } else {
                    print("unliked -> liked")
                    self.favorite(outfit!)
                }
                isLiked = (outfit?.isLiked)!
                
            // create it since it doesn't exist
            } else {
                guard outfitResult.top != nil,
                    outfitResult.bottom != nil else {
                        return
                }
                print("new -> liked")
                let newOutfit = Outfit(top: outfitResult.top!, bottom: outfitResult.bottom!)
                self.favorite(newOutfit, isNew: true, theTop: outfitResult.top!, theBottom: outfitResult.bottom!)
                
                isLiked = true
            }
        }
        self.updateLikeButtonImage(isLiked: isLiked)
    }
    
    func favorite(_ outfit: Outfit, isNew: Bool = false, theTop: Article? = nil, theBottom: Article? = nil) {
        outfit.isLiked = true
        print("outfit liked")
        print(outfit)
        
        if isNew {
            realm.add(outfit)
            print("new outfit added")
            
            guard theTop != nil,
                theBottom != nil else {
                    print("failed to update top or bottom like counts of new outfit")
                    return
            }
            
            theTop?.countLikes += 1
            theBottom?.countLikes += 1
            print("top/bottom countLikes += 1")
        
        } else {
            guard let top = Article.find(by: outfit.topId, withRealm: realm),
                let bottom = Article.find(by: outfit.bottomId, withRealm: realm) else {
                    print("didn't find top or bottom to update as favorite")
                    return
            }
            
            top.first?.countLikes += 1
            bottom.first?.countLikes += 1
            print("top/bottom countLikes += 1")
        }
    }
    
    func unfavorite(_ outfit: Outfit) {
        outfit.isLiked = false
        print("outfit disliked")
        print(outfit)
        
        guard let top = Article.find(by: outfit.topId, withRealm: realm),
            let bottom = Article.find(by: outfit.bottomId, withRealm: realm) else {
                print("didn't find top or bottom to update as dis liked")
                return
        }
        
        top.first?.countLikes -= 1
        bottom.first?.countLikes -= 1
        print("top/bottom countLikes -= 1")
    }
    
    func toggleHidden() {
        emptyView.isHidden = (tops?.count == 0 || bottoms?.count == 0) ? false : true
    }
    
    func getTops() -> Results<Article> {
        return articles.filter("articleType = %@", ArticleType.top.rawValue).sorted(byKeyPath: "created", ascending: false)
    }
    
    func getBottoms() -> Results<Article> {
        return articles.filter("articleType = %@", ArticleType.bottom.rawValue).sorted(byKeyPath: "created", ascending: false)
    }

    func outfitExists() -> OutfitResult {
        // grab the visible cells from both collectionViews
        let visibleTops = topsCollectionView.visibleCells
        let visibleBottoms = bottomsCollectionView.visibleCells
        guard visibleTops.count > 0,
            visibleBottoms.count > 0 else {
                return OutfitResult(exists: false, outfit: nil, top: nil, bottom: nil)
        }
        // get the current top and bottom
        let topCell = visibleTops.first as? OutfitArticleCollectionViewCell
        let bottomCell = visibleBottoms.first as? OutfitArticleCollectionViewCell
        guard let top = topCell?.article,
            let bottom = bottomCell?.article else {
                return OutfitResult(exists: false, outfit: nil, top: nil, bottom: nil)
        }
        
        // determine if this outfit exists and if it was previously liked
        let result = outfits.filter("topId == '\(top.articleId)' AND bottomId == '\(bottom.articleId)'")
        let exists = result.count > 0
        
        return OutfitResult(exists: exists, outfit: result.first, top: top, bottom: bottom)
    }
    
    func updateLikeButtonImage(isLiked: Bool?) {
        var imageToUse: UIImage!
        if isLiked != nil {
            imageToUse = isLiked! ? #imageLiteral(resourceName: "likeFilled") : #imageLiteral(resourceName: "likeButton")
        
        } else {
            let outfitResult = outfitExists()
            if !outfitResult.exists {
                imageToUse = #imageLiteral(resourceName: "likeButton")
            } else {
                imageToUse = (outfitResult.outfit?.isLiked)! ? #imageLiteral(resourceName: "likeFilled") : #imageLiteral(resourceName: "likeButton")
            }
        }
        
        self.likeButton.setImage(imageToUse, for: .normal)
    }
    
    // Mark: - Realm Subscription
    func notificationSubscription(for items: Results<Article>) -> NotificationToken {
        return items.addNotificationBlock({ [weak self] (changes: RealmCollectionChange<Results<Article>>) in
            self?.updateUI(with: changes)
        })
    }
    
    func updateUI(with changes: RealmCollectionChange<Results<Article>>) {
        switch changes {
        case .initial(_):
            print("closet initial")
            topsCollectionView.reloadData()
            bottomsCollectionView.reloadData()
            break
        case .update(_, let deletions, let insertions, let modifications):
            print("closet updates ... tops: \(tops.count) bottoms: \(bottoms.count) \ndel:\(deletions.count) \ndel:\(insertions.count) \nmod:\(modifications.count)")
            topsCollectionView.reloadData()
            bottomsCollectionView.reloadData()
            break
        case let .error(error):
            print("*** ERROR in closet notificationBlock ***")
            print(error.localizedDescription)
            break
        }
    }
}

extension MyClosetViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let collectionView: UICollectionView = (scrollView == topsCollectionView) ? topsCollectionView : bottomsCollectionView
        self.scrollToCenter(collectionView: collectionView)
        
        // wait to update likeButton
        let delayInSeconds = 0.0625
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
            self.updateLikeButtonImage(isLiked: nil)
        }
    }
    
    func scrollToCenter(collectionView: UICollectionView) {
        var currentCellOffset: CGPoint = collectionView.contentOffset
        currentCellOffset.x += collectionView.frame.size.width / 2
        if let indexPath = collectionView.indexPathForItem(at: currentCellOffset) {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

extension MyClosetViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topsCollectionView {
            print("numberOfItemInSection -tops- \(tops?.count)")
            return tops?.count ?? 0
            
        } else {
            print("numberOfItemInSection -bottoms- \(bottoms?.count)")
            return bottoms?.count ?? 0
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OutfitTopCell", for: indexPath) as! OutfitArticleCollectionViewCell
            let top = tops[indexPath.row]
            cell.article = top
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OutfitBottomCell", for: indexPath) as! OutfitArticleCollectionViewCell
            let bottom = bottoms[indexPath.row]
            cell.article = bottom
            return cell
        }
    }
}

// Mark: - UICollectionViewDelegateFlowLayout
extension MyClosetViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sidePaddingSpace = self.sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - sidePaddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        let bottomPaddingSpace = self.sectionInsets.bottom * itemsPerCol
        let availableHeight = collectionView.frame.height - bottomPaddingSpace
        let heightPerItem = availableHeight / itemsPerCol

        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

