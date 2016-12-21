//
//  ArticleCreateViewController.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/20/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import UIKit
import RealmSwift

class ArticleCreateViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var articleImage: UIImage!
    var articleImagePath: String!
    var articleType: String!
    
    var categories = Category.allValues
    var colors = Color.allValues
    var textures = Texture.allValues
    
    var shouldDisplayAllCategories = false
    var shouldDisplayAllTextures = false
    var shouldDisplayAllColors = false
    
    var selectedCategory = Category.display.description
    var selectedCategoryIndex = 10
    
    var selectedColor = Color.display.description
    var selectedColorIndex = 0
    
    var selectedTexture = Texture.display.description
    var selectedTextureIndex = 0
    
    var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        saveButton = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ArticleCreateViewController.didTapSaveButton))
        navigationItem.setRightBarButton(saveButton, animated: true)
    }
    
    func didTapSaveButton() {
        // 1. validate we have all data
        // TODO: provide visual feedback when failing a validation
        guard articleImagePath != nil else { return }
        guard selectedCategory != Category.display.description else { return }
        guard selectedColor != Color.display.description else { return }
        guard selectedTexture != Texture.display.description else { return }
        guard articleType != nil else { return }
        
        // 2. save to Realm
        let article = Article(imgUrl: articleImagePath, color: selectedColor, texture: selectedTexture, category: selectedCategory, type: articleType)
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(article)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    // Mark: - UITableViewDataSource
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        } else if section == 1 {
            return "Category"
        } else if section == 2 {
            return "Color"
        } else if section == 3 {
            return "Texture"
        }
        return nil
    }
    
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
            if indexPath.row == 0 && !shouldDisplayAllCategories && selectedCategory != Category.display.description {
                cell.checkedImageView.image = UIImage(named: "checked")
            } else {
                cell.checkedImageView.image = nil
            }
            return cell
            
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleColorCell", for: indexPath) as! ArticleCreateTableViewCell
            // determine if we need to display the checked image
            let checkedOrNil = selectedColorIndex == indexPath.row ? UIImage(named: "checked") : nil
            cell.checkedImageView.image = checkedOrNil
            // determine which label to display
            let text = (indexPath.row == 0) ? selectedColor : colors[indexPath.row-1]
            cell.descriptionLabel.text = text
            // if distances are collapsed, show the checked circle in the first row
            if indexPath.row == 0 && !shouldDisplayAllColors && selectedColor != Color.display.description {
                cell.checkedImageView.image = UIImage(named: "checked")
            } else {
                cell.checkedImageView.image = nil
            }
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTextureCell", for: indexPath) as! ArticleCreateTableViewCell
            // determine if we need to display the checked image
            let checkedOrNil = selectedColorIndex == indexPath.row ? UIImage(named: "checked") : nil
            cell.checkedImageView.image = checkedOrNil
            // determine which label to display
            let text = (indexPath.row == 0) ? selectedTexture : textures[indexPath.row-1]
            cell.descriptionLabel.text = text
            // if distances are collapsed, show the checked circle in the first row
            if indexPath.row == 0 && !shouldDisplayAllTextures && selectedTexture != Texture.display.description {
                cell.checkedImageView.image = UIImage(named: "checked")
            } else {
                cell.checkedImageView.image = nil
            }
            return cell
        }
    }
    
    // Mark: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                shouldDisplayAllCategories = !shouldDisplayAllCategories
                selectedCategory = Category.display.description
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
        
        }  else if indexPath.section == 2 {
            if indexPath.row == 0 {
                shouldDisplayAllColors = !shouldDisplayAllColors
                selectedColor = Color.display.description
                if !shouldDisplayAllColors {
                    selectedColorIndex = indexPath.row
                }
                tableView.reloadData()
                return
            }
            if shouldDisplayAllColors {
                // updated the selected color
                let cell = tableView.cellForRow(at: indexPath) as! ArticleCreateTableViewCell
                cell.checkedImageView.image = UIImage(named: "checked")
                selectedColorIndex = indexPath.row
                selectedColor = cell.descriptionLabel.text!
            }
            // reload the tableView
            shouldDisplayAllColors = !shouldDisplayAllColors
            tableView.reloadData()
        
        } else if indexPath.section == 3 {
            if indexPath.row == 0 {
                shouldDisplayAllTextures = !shouldDisplayAllTextures
                selectedTexture = Texture.display.description
                if !shouldDisplayAllTextures {
                    selectedTextureIndex = indexPath.row
                }
                tableView.reloadData()
                return
            }
            if shouldDisplayAllTextures {
                // updated the selected texture
                let cell = tableView.cellForRow(at: indexPath) as! ArticleCreateTableViewCell
                cell.checkedImageView.image = UIImage(named: "checked")
                selectedTextureIndex = indexPath.row
                selectedTexture = cell.descriptionLabel.text!
            }
            // reload the tableView
            shouldDisplayAllTextures = !shouldDisplayAllTextures
            tableView.reloadData()
        }
    }
}
