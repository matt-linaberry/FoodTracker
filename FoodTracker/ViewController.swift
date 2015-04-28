//
//  ViewController.swift
//  FoodTracker
//
//  Created by Matthew Linaberry on 4/20/15.
//  Copyright (c) 2015 Matthew Linaberry. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    
    var searchController:UISearchController!
    var suggestedSearchFoods:[String] = []
    var filterSuggestedSearchFoods:[String] = []
    var scopeButtonTitles:[String] = ["Recommended", "Search Results", "Saved"]
    
    var jsonResponse:NSDictionary!
    var apiSearchForFoods:[(name:String, idValue:String)] = []
    var dataController:DataController = DataController()
    let kAppID = "01437f95"
    let kAppKey = "07a9d73c587af46d55537259f2877376"
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchController = UISearchController(searchResultsController: nil) // could define an additional table view controller to show results.
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0)  // can't set the height with the frame
        tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchBar.scopeButtonTitles = scopeButtonTitles
        self.searchController.searchBar.delegate = self
        self.definesPresentationContext = true // search results controller will be displayed in the current view controller.
        self.suggestedSearchFoods = ["apple", "bagel", "banana", "beer", "bread", "carrots", "cheddar cheese", "chicken breast", "chili with beans", "chocolate chip cookie", "coffee", "cola", "corn", "egg", "graham cracker", "granola bar", "green beans", "ground beef patty", "hot dog", "ice cream", "jelly doughnut", "ketchup", "milk", "mixed nuts", "mustard", "oatmeal", "orange juice", "peanut butter", "pizza", "pork chop", "potato", "potato chips", "pretzels", "raisins", "ranch salad dressing", "red wine", "rice", "salsa", "shrimp", "spaghetti", "spaghetti sauce", "tuna", "white wine", "yellow cake"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        var foodName:String
        let selectedScopeButtonIndex = self.searchController.searchBar.selectedScopeButtonIndex
        if selectedScopeButtonIndex == 0 {
            if self.searchController.active {
                foodName = filterSuggestedSearchFoods[indexPath.row]
            }
            else {
                foodName = suggestedSearchFoods[indexPath.row]
            }
        }
        else if selectedScopeButtonIndex == 1 {
            foodName = apiSearchForFoods[indexPath.row].name
        }
        else {
            foodName = ""
        }
        cell.textLabel?.text = foodName
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let selectedScopeButtonIndex = self.searchController.searchBar.selectedScopeButtonIndex
        if selectedScopeButtonIndex == 0 {
            if self.searchController.active {
                // if the search controller is turned on, use the filtered list
                return self.filterSuggestedSearchFoods.count
            }
            else {
                return self.suggestedSearchFoods.count
            }
        }
        else if selectedScopeButtonIndex == 1 {
            return self.apiSearchForFoods.count
        }
        else {
            return 0
        }
    }
    
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedScopeButtonIndex = self.searchController.searchBar.selectedScopeButtonIndex
        if selectedScopeButtonIndex == 0 {
            var searchFoodName: String
            if self.searchController.active {
                searchFoodName = filterSuggestedSearchFoods[indexPath.row]
            }
            else {
                searchFoodName = suggestedSearchFoods[indexPath.row]
            }
            self.searchController.searchBar.selectedScopeButtonIndex = 1
            makeRequest(searchFoodName)
        }
        else if selectedScopeButtonIndex == 1 {
            let idValue = apiSearchForFoods[indexPath.row].idValue
            self.dataController.saveUSDAItemForId(idValue, json: self.jsonResponse)
        }
        else if selectedScopeButtonIndex == 2 {
            
        }
    }
    
    //MARK: UISearchResultsUpdating Delegate methods
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = self.searchController.searchBar.text
        let selectedScopeButtonIndex = self.searchController.searchBar.selectedScopeButtonIndex
        self.filterContentForSearch(searchString, scope: selectedScopeButtonIndex)
        self.tableView.reloadData()
    }
    
    func filterContentForSearch(searchText: String, scope:Int) {
        self.filterSuggestedSearchFoods = self.suggestedSearchFoods.filter({ (food:String) -> Bool in
            var foodMatch = food.rangeOfString(searchText)
            return foodMatch != nil
        })
    }
    
    // MARK: UISearchBar delegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        // update the index of the selected scope button
        self.searchController.searchBar.selectedScopeButtonIndex = 1
        
        makeRequest(searchBar.text)  // when we hit the search button, do the request!
        
    }
    
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.tableView.reloadData()
    }
    
    func makeRequest(searchString: String) {
        // this makes an HTTP GET request!
//        let url = NSURL(string: "https://api.nutritionix.com/v1_1/search/\(searchString)?results=0%3A20&cal_min=0&cal_max=50000&fields=item_name%2Cbrand_name%2Citem_id%2Cbrand_id&appId=\(kAppID)&appKey=\(kAppKey)")  // this was officially from the API
//        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
//            var stringData = NSString(data: data, encoding: NSUTF8StringEncoding)
//            println(stringData)
//            println(response)
//        })
//        
//        task.resume()  // executes the NSURLSession request
        
        var request = NSMutableURLRequest(URL: NSURL(string: "https://api.nutritionix.com/v1_1/search/")!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        var params = [
            "appId":kAppID,
            "appKey":kAppKey,
            "fields":["item_name", "brand_name", "keywords", "usda_fields"],
            "limit": "50",
            "query": searchString,
            "filter":["exists":["usda_fields":true]]
        ]
        
        var error: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &error)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        // this task happens when the connection works
        var task = session.dataTaskWithRequest(request, completionHandler: { (data, response, err) -> Void in
//            var stringData = NSString(data: data, encoding: NSUTF8StringEncoding)
//            println(stringData)
            var conversionError:NSError?
            var jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &conversionError) as? NSDictionary
            println(jsonDictionary)
            // what if theres a problem???
            if conversionError != nil {
                println(conversionError!.localizedDescription)
                let errorString = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error in Parsing\(errorString)")
            }
            else {
                if jsonDictionary != nil {
                    // save the JSON dictionary
                    self.jsonResponse = jsonDictionary!
                    self.apiSearchForFoods = DataController.jsonAsUSDAIdAndNameSearchResults(jsonDictionary!)
                    // Put this in the main thread!!!!
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                    })
                }
                else {
                    let errorString = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error: Could not parse JSON \(errorString)")
                }
            }
        })
        task.resume()
        
    }
}

