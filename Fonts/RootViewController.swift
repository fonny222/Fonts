//
//  RootViewController.swift
//  Fonts
//
//  Created by Christopher Fontana on 3/12/17.
//  Copyright © 2017 Christopher Fontana. All rights reserved.
//

import UIKit

class RootViewController: UITableViewController {

    private var familyNames: [String]!
    private var cellPointSize: CGFloat!
    private var favoritesList: FavoritesList!
    private static let familyCell = "FamilyName"
    private static let favoritesCell = "Favorites"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        familyNames = (UIFont.familyNames as [String]).sorted()
        let preferredTableViewFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        cellPointSize = preferredTableViewFont.pointSize
        favoritesList = FavoritesList.sharedFavoritesList
        tableView.estimatedRowHeight = cellPointSize
    }

    // if a user adds something to their favorites this reloads the tableview
    // so that the favorites list appears *** use for your stuff
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    /* this method uses the UIFont class to find all the font names for the given family name
     and then grab the first font name within that family
     if family has no font names it returns nil
 */
    func fontForDisplay(atIndexPath indexPath: NSIndexPath) -> UIFont?{
        if indexPath.section == 0 {
            let familyName = familyNames[indexPath.row]
            let fontName = UIFont.fontNames(forFamilyName: familyName).first
            
            return fontName != nil ?
            UIFont(name: fontName!, size: cellPointSize) : nil
        }else{
            return nil
        }
    }
    
    // looks up number of sections  uses favorites list to determine whether we want to show second sectin
    override func numberOfSections(in tableView: UITableView)-> Int {
        return favoritesList.favorites.isEmpty ? 1 : 2
    }
    
    /* we use the section number to determine whether the section is showing all family names or a single cell
     linkiong to the list of favorites.
 */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)-> Int{
        // return the number of rows in the section
        return section == 0 ? familyNames.count : 1
    }
    
    /* uses section numbers to determine which header title to use.
 */
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int)-> String? {
        return section == 0 ? "All Font Families" : "My Favorite Fonts"
    }
    
    
    
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell {
        
        if indexPath.section == 0{
            
            // the font names list
            let cell = tableView.dequeueReusableCell(withIdentifier: RootViewController.familyCell, for: indexPath)
            
            cell .textLabel?.font = fontForDisplay(atIndexPath: indexPath as NSIndexPath)
            cell.textLabel?.text = familyNames[indexPath.row]
            cell.detailTextLabel?.text = familyNames[indexPath.row]
            
            return cell
        }else {
            // the favorites list
            return tableView.dequeueReusableCell(withIdentifier: RootViewController.favoritesCell, for: indexPath)
        }
    }
    
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        // get the new view controller using [segue destinationViewController]
        // pass the selected object to the new view controller.
        let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
        let listVC = segue.destination as! FontListViewController
        
        if indexPath.section == 0 {
            // Font names list
            let familyName = familyNames[indexPath.row]
            listVC.fontNames = (UIFont.fontNames(forFamilyName: familyName) as [String]).sorted()
            listVC.navigationItem.title = familyName
            listVC.showsFavorites = false
        }else{
            // favorites list
            listVC.fontNames = favoritesList.favorites
            listVC.navigationItem.title = "Favorites"
            listVC.showsFavorites = true
        }
        
    }
    
    
    
}
