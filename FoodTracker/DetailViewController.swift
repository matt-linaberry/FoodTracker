//
//  DetailViewController.swift
//  FoodTracker
//
//  Created by Matthew Linaberry on 4/20/15.
//  Copyright (c) 2015 Matthew Linaberry. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var usdaItem: USDAItem?
    
    @IBOutlet weak var textView: UITextView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "usdaItemDidComplete:", name: kUSDAItemCompleted, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if usdaItem != nil {
            textView.attributedText = createAttributedString(usdaItem!)
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)  // need to remove the observer when we don't need it anymore!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func eatItButtonPressed(sender: UIBarButtonItem) {
    }
    
    func usdaItemDidComplete(notification: NSNotification) {
        println("USDAItem did complete called in detail view controller!")
        // assign the usda item passed in
        usdaItem = notification.object as? USDAItem
        
        if self.isViewLoaded() && self.view.window != nil {
            textView.attributedText = createAttributedString(usdaItem!)
        }
    }
    
    func createAttributedString(usdaItem: USDAItem) -> NSAttributedString {
        var itemAttributedString = NSMutableAttributedString()
        // set up a paragraph style for the textview
        var centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = NSTextAlignment.Center
        centeredParagraphStyle.lineSpacing = 10.0
        // now set up the attributes for the title -- put it in the dictionary!
        var titleAttributesDictionary = [
            NSForegroundColorAttributeName : UIColor.blackColor(),
            NSFontAttributeName : UIFont.boldSystemFontOfSize(22.0),
            NSParagraphStyleAttributeName : centeredParagraphStyle
        ]
        
        let titleString = NSAttributedString(string: "\(usdaItem.name)\n", attributes: titleAttributesDictionary)
        
        itemAttributedString.appendAttributedString(titleString)
        
        var leftAlignedParagraphStyle = NSMutableParagraphStyle()
        leftAlignedParagraphStyle.alignment = NSTextAlignment.Left
        leftAlignedParagraphStyle.lineSpacing = 20.0
        var styleFirstWordAttributesDictionary = [
            NSForegroundColorAttributeName : UIColor.blackColor(),
            NSFontAttributeName : UIFont.boldSystemFontOfSize(18.0),
            NSParagraphStyleAttributeName : leftAlignedParagraphStyle
        ]
        var style1AttributesDictionary = [
            NSForegroundColorAttributeName : UIColor.darkGrayColor(),
            NSFontAttributeName : UIFont.systemFontOfSize(18.0),
            NSParagraphStyleAttributeName : leftAlignedParagraphStyle
        ]
        var style2AttributesDictionary = [
            NSForegroundColorAttributeName : UIColor.lightGrayColor(),
            NSFontAttributeName : UIFont.systemFontOfSize(18.0),
            NSParagraphStyleAttributeName : leftAlignedParagraphStyle
        ]
        
        let calciumTitleString = NSAttributedString(string: "Calcium ", attributes: styleFirstWordAttributesDictionary)
        let calciumBodyString = NSAttributedString(string: "\(usdaItem.calcium)% \n", attributes: style1AttributesDictionary)
        itemAttributedString.appendAttributedString(calciumTitleString)
        itemAttributedString.appendAttributedString(calciumBodyString)
        
        let carbohydrateTitleString = NSAttributedString(string: "Carbs ", attributes: styleFirstWordAttributesDictionary)
        let carbohydrateBodyString = NSAttributedString(string: "\(usdaItem.carbohydrate)% \n", attributes: style2AttributesDictionary)
        itemAttributedString.appendAttributedString(carbohydrateTitleString)
        itemAttributedString.appendAttributedString(carbohydrateBodyString)
        
        let cholesterolTitleString = NSAttributedString(string: "Cholesterol ", attributes: styleFirstWordAttributesDictionary)
        let cholesterolBodyString  = NSAttributedString(string: "\(usdaItem.cholesterol)% \n", attributes: style1AttributesDictionary)
        itemAttributedString.appendAttributedString(cholesterolTitleString)
        itemAttributedString.appendAttributedString(cholesterolBodyString)
        
        // Energy
        let energyTitleString = NSAttributedString(string: "Energy ", attributes: styleFirstWordAttributesDictionary)
        let energyBodyString = NSAttributedString(string: "\(usdaItem.energy)% \n", attributes: style2AttributesDictionary)
        itemAttributedString.appendAttributedString(energyTitleString)
        itemAttributedString.appendAttributedString(energyBodyString)
        
        // Fat Total
        let fatTotalTitleString = NSAttributedString(string: "FatTotal ", attributes: styleFirstWordAttributesDictionary)
        let fatTotalBodyString = NSAttributedString(string: "\(usdaItem.fatTotal)% \n", attributes: style1AttributesDictionary)
        itemAttributedString.appendAttributedString(fatTotalTitleString)
        itemAttributedString.appendAttributedString(fatTotalBodyString)
        
        // Protein
        let proteinTitleString = NSAttributedString(string: "Protein ", attributes: styleFirstWordAttributesDictionary)
        let proteinBodyString = NSAttributedString(string: "\(usdaItem.protein)% \n", attributes: style2AttributesDictionary)
        itemAttributedString.appendAttributedString(proteinTitleString)
        itemAttributedString.appendAttributedString(proteinBodyString)
        
        // Sugar
        let sugarTitleString = NSAttributedString(string: "Sugar ", attributes: styleFirstWordAttributesDictionary)
        let sugarBodyString = NSAttributedString(string: "\(usdaItem.sugar)% \n", attributes: style1AttributesDictionary)
        itemAttributedString.appendAttributedString(sugarTitleString)
        itemAttributedString.appendAttributedString(sugarBodyString)
        
        // Vitamin C
        let vitaminCTitleString = NSAttributedString(string: "Vitamin C ", attributes: styleFirstWordAttributesDictionary)
        let vitaminCBodyString = NSAttributedString(string: "\(usdaItem.vitaminC)% \n", attributes: style2AttributesDictionary)
        itemAttributedString.appendAttributedString(vitaminCTitleString)
        itemAttributedString.appendAttributedString(vitaminCBodyString)
        
        return itemAttributedString
    }

}
