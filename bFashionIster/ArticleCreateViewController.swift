//
//  ArticleCreateViewController.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/20/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import UIKit

class ArticleCreateViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var articleImage: UIImage!
    var articleImagePath: String!
    
    var categories = Category.allValues
    var colors = Color.allValues
    var textures = Texture.allValues
    
    var shouldDisplayAllCategories = false
    var shouldDisplayAllTextures = false
    var shouldDisplayAllColors = false
    
    var selectedCategory = "Select a Category..."
    var selectedCategoryIndex = 10
    
    var selectedColor = "Select a Color"
    var selectedColorIndex = 0
    
    var selectedTexture = "Select a Texture"
    var selectedTextureIndex = 0
    
    override func viewDidLoad() {
        // do stuff
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return shouldDisplayAllCategories ? categories.count + 1 : 1
        } else if section == 2 {
            return shouldDisplayAllColors ? colors.count + 1 : 1
        } else if section == 3 {
            return shouldDisplayAllTextures ? textures.count + 1 : 1
        }
        return 0
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0 {
//            return nil
//        } else if section == 1 {
//            return "Category"
//        } else if section == 2 {
//            return "Color"
//        } else if section == 3 {
//            return "Texture"
//        }
//        return nil
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 300.0
        }
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleImageCell", for: indexPath) as! ArticleCreateImageTableViewCell
            cell.articleImageView.image = self.articleImage
            return cell
            
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCategoryCell", for: indexPath) as! ArticleCreateTableViewCell
            // determine if we need to display the checked image
            let checkedOrNil = selectedCategoryIndex == indexPath.row ? UIImage(named: "checked") : nil
            cell.checkedImageView.image = checkedOrNil
            // determine which label to display
            let text = (indexPath.row == 0) ? selectedCategory : categories[indexPath.row-1]
            cell.descriptionLabel.text = text
            // if distances are collapsed, show the checked circle in the first row
            if indexPath.row == 0 && !shouldDisplayAllCategories && selectedCategory != "Select a Category..." {
                cell.checkedImageView.image = UIImage(named: "checked")
            }
            return cell
            
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleColorCell", for: indexPath) as! ArticleCreateTableViewCell
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTextureCell", for: indexPath) as! ArticleCreateTableViewCell
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                shouldDisplayAllCategories = !shouldDisplayAllCategories
                selectedCategory = "Select a Category..."
                if !shouldDisplayAllCategories {
                    selectedCategoryIndex = indexPath.row
                }
                tableView.reloadData()
                return
            }
            if shouldDisplayAllCategories {
                // updated the selected category
                let cell = tableView.cellForRow(at: indexPath) as! ArticleCreateTableViewCell
                cell.checkedImageView.image = UIImage(named: "checked")
                selectedCategoryIndex = indexPath.row
                selectedCategory = cell.descriptionLabel.text!
            }
            // reload the tableView
            shouldDisplayAllCategories = !shouldDisplayAllCategories
            tableView.reloadData()
        }
    }
}
