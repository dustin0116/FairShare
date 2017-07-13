//
//  HomeViewController.swift
//  FairShare
//
//  Created by Dustin Hsiang on 7/10/17.
//  Copyright © 2017 Dustin Hsiang. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var items = [Item]()
    
    var itemNumber = 0
    
    @IBOutlet weak var tipSlider: UISlider!
    @IBOutlet weak var tipPercentLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var isSelected = true
    
    var isCheckedArray = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.intializeItems()
    }
    
    @IBAction func tipPercentValueChanged(_ sender: UISlider) {
        
        let currentPercent = String(Int(tipSlider.value))
        
        tipPercentLabel.text = "Tip \(currentPercent)%:"
        
    }
    
    @IBAction func tipSliderDrag(_ sender: Any) {
        
        tipSlider.isContinuous = true
        
    }
    
    @IBAction func addItemButton(_ sender: UIButton) {
        
        itemNumber += 1
        
        items.append(Item.init(itemNumber: itemNumber))
        
        print(items.count)
        
        tableView.reloadData()
        
        let lastRowIndexPath = IndexPath(row: items.count-1, section: 0)
        
        tableView.scrollToRow(at: lastRowIndexPath, at: .none, animated: true)
        
    }
    
    func intializeItems() {
        
        for _ in 1...5 {
            
            itemNumber += 1
            items.append(Item.init(itemNumber: itemNumber))
            print(items.count)
            
        }
        
        for _ in 0...items.count-1 {
            self.isCheckedArray.append(true)
        }
        
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemTableViewCell", for: indexPath) as! ItemCell
        let item = items[indexPath.row]
        
        cell.itemTitleTextLabel.text = item.itemLabel
        cell.itemNumberLabel.text = String(indexPath.row + 1)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {

            items.remove(at: indexPath.row)
            
            tableView.reloadData()
            
        }
    }
}

extension HomeViewController: itemCheckList {
    
    func getInfo(for row: Int, to value: Bool) {
        isCheckedArray[row] = value
    }
}
