//
//  HomeViewController.swift
//  FairShare
//
//  Created by Dustin Hsiang on 7/10/17.
//  Copyright © 2017 Dustin Hsiang. All rights reserved.
//
import UIKit
import Crashlytics
import Fabric

class HomeViewController: UIViewController {
    
    //MARK: - IBOutlet Variables
    @IBOutlet weak var tipSlider: UISlider!
    @IBOutlet weak var tipPercentLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var taxAmountTextField: UITextField!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var addItemButton: UIBarButtonItem!
    @IBOutlet weak var removeAllButton: UIButton!
    @IBOutlet weak var numberOfPeopleLabel:  UILabel!
    @IBOutlet weak var numberOfPeopleStepper: UIStepper!
    @IBOutlet weak var taxInputTypeSelector: UISegmentedControl!
    @IBOutlet weak var wholeBottomHalfView: UIView!
    
    //MARK: - Variables
    
    var items = [Item]()
    
    var checkButtons = [Bool]()
    
    var itemNumber = 0
    
    var price = 0.0
    
    var totalCheckedAmount: Double = 0.0
    
    var taxPlusTotalCheckedAmount: Double = 0.0
    
    var totalWithTipPercentCheckedAmount: Double = 0.0
    
    var splittedTaxPlusTotalCheckedAmount: Double = 0.0
    
    var allItemsPriceAmount: Double = 0.0
    
    var allItemsWithTipPercentAmount: Double = 0.0
    
    var allItemsPlusTaxAmount: Double = 0.0
    
    var allItemsSplittedEqually: Double = 0.0
    
    //MARK: - Functions
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.initializeItems()
        
        
        calculateButton.layer.cornerRadius = 6
        removeAllButton.layer.cornerRadius = 6
        numberOfPeopleStepper.layer.cornerRadius = 5
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.addDoneButtonOnKeyboard()
        
    }
    
    func addDoneButtonOnKeyboard() {
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(HomeViewController.doneButtonAction))
        
        done.tintColor = UIColor(red:0.43, green:0.66, blue:0.84, alpha:1.0)
        
        doneToolbar.isTranslucent = false
        
        var items = [UIBarButtonItem]()
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.taxAmountTextField.inputAccessoryView = doneToolbar
        
    }
    
    @objc func doneButtonAction() {
        
        self.taxAmountTextField.resignFirstResponder()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        self.view.endEditing(true)

    }
    
    @objc func keyboardWillShow(notification : NSNotification) {
        
        if taxAmountTextField.isEditing {
            let info:NSDictionary = notification.userInfo! as NSDictionary
            let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            
            self.view.frame.origin.y = self.view.frame.origin.y - keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification : NSNotification) {
        
        if taxAmountTextField.resignFirstResponder() {
            let info:NSDictionary = notification.userInfo! as NSDictionary
            let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
                self.view.frame.origin.y = self.view.frame.origin.y + keyboardSize.height
            }
    }
    
    func initializeItems() {
        
        for _ in 1...5 {
            
            itemNumber += 1
            
            items.append(Item(itemNumber: itemNumber, isChecked: false, itemPrice: price))
            
            checkButtons.append(false)
            
            print("Items: \(items.count)")
        }
    }
    
    
    @IBAction func numberOfPeopleStepperAction(_ sender: UIStepper) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        numberOfPeopleLabel.text = String(Int(sender.value))
        
    }
    
    @IBAction func tipPercentValueChanged(_ sender: UISlider) {
        let currentPercent = String(Int(tipSlider.value))
        
        tipPercentLabel.text = "Tip \(currentPercent)%:"
        
        print("Tip Amount: \(currentPercent)%")
        
    }
    
    @IBAction func tipSliderDrag(_ sender: Any) {
        tipSlider.isContinuous = true
        
    }
    
    
    //MARK: - Buttons
    
    @IBAction func addItemButtonTapped(_ sender: UIBarButtonItem) {
        
        items.append(Item(itemNumber: itemNumber, isChecked: false, itemPrice: price))
        
        checkButtons.append(false)
        
        print("Items: \(items.count)")
        
        itemNumber = 0
        
        for item in items {
            item.itemNumber = itemNumber + 1
        }
        
        tableView.reloadData()
        
        let lastRowIndexPath = IndexPath(row: items.count - 1, section: 0)
        
        tableView.scrollToRow(at: lastRowIndexPath, at: .none, animated: true)
        
        Answers.logCustomEvent(withName: "User adds item", customAttributes: nil)
        
    }
    
    @IBAction func removeAllButtonTapped(_ sender: UIButton) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        self.view.endEditing(true)
        if items.isEmpty {
            let aC = UIAlertController(title: "Empty", message: "There are no items to be removed.", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
            okButton.setValue(UIColor(red:0.43, green:0.66, blue:0.84, alpha:1.0), forKey: "titleTextColor")
            aC.addAction(okButton)
            present(aC, animated: true, completion: nil)
        }
        else {
            let aC = UIAlertController(title: "Remove All Items", message: "Are you sure you want to remove all items?", preferredStyle: .alert)
            
            let yesButton = UIAlertAction(title: "Yes", style: .default, handler: {(action: UIAlertAction!) in
                
                self.items.removeAll()
                
                self.checkButtons.removeAll()
                
                let range = NSMakeRange(0, self.tableView.numberOfSections)
                let sections = NSIndexSet(indexesIn: range)
                self.tableView.reloadSections(sections as IndexSet, with: .fade)
                
                self.tableView.rowHeight = 53
                
                print("Items: \(self.items.count)")
                
                Answers.logCustomEvent(withName: "User Removes All Items", customAttributes: nil)
                
            })
            
            yesButton.setValue(UIColor(red:0.43, green:0.66, blue:0.84, alpha:1.0), forKey: "titleTextColor")
            
            let noButton = UIAlertAction(title: "No", style: .cancel, handler: nil)
            
            noButton.setValue(UIColor(red:0.43, green:0.66, blue:0.84, alpha:1.0), forKey: "titleTextColor")
            aC.addAction(yesButton)
            aC.addAction(noButton)
            
            present(aC, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func calculateButtonTapped(_ sender: UIButton) {
        
        totalWithTipPercentCheckedAmount = 0.0
        
        taxPlusTotalCheckedAmount = 0.0
        
        splittedTaxPlusTotalCheckedAmount = 0.0
        
        totalCheckedAmount = 0.0
        
        allItemsPlusTaxAmount = 0.0
        
        allItemsPriceAmount = 0.0
        
        allItemsWithTipPercentAmount = 0.0
        
        allItemsSplittedEqually = 0.0
        
        taxAmountTextField.resignFirstResponder()
        
        let tipPercent = Double(Int(tipSlider.value)) / 100
        
        let roundedTipPercent = String(format: "%.2f", tipPercent)
        
        print("Tip Percent: \(roundedTipPercent)")
        
        var taxAmount = 0.0
        
        switch taxInputTypeSelector.selectedSegmentIndex {
            
        case 0: if taxAmountTextField.text != "" {
            
            taxAmount = Double(taxAmountTextField.text!)!

        } else {
            
            taxAmount = 0.0
            
            }
            
        case 1: if taxAmountTextField.text != "" {
            
            taxAmount = Double(taxAmountTextField.text!)! / 100
            
        } else {
            taxAmount = 0.0
            }
            
        default: break
            
        }
        
        for i in 0..<items.count {
            
            if items[i].itemPrice >= 0 {
                
                let priceAmount = items[i].itemPrice
                
                
                allItemsPriceAmount += priceAmount
                
                print("Tip %: \(tipPercent)")
                
                allItemsWithTipPercentAmount = allItemsPriceAmount * Double(roundedTipPercent)!
                
                allItemsPlusTaxAmount = allItemsWithTipPercentAmount + taxAmount + allItemsPriceAmount
                
                print("Tax: \(taxAmount)")
                
                if priceAmount == 0.0 || checkButtons[i] == false {
                    
                    continue
                    
                }
                
                totalCheckedAmount += priceAmount
                
            } else {
                
                let aC = UIAlertController(title: "Error", message: "Invalid text for item price.", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                okButton.setValue(UIColor(red:0.43, green:0.66, blue:0.84, alpha:1.0), forKey: "titleTextColor")
                
                aC.addAction(okButton)
                present(aC, animated: true, completion: nil)
                break
                
            }
        }
        
        totalWithTipPercentCheckedAmount = totalCheckedAmount * Double(roundedTipPercent)!
        
        print("Total with Tip: \(totalWithTipPercentCheckedAmount)")
        
        let splittedTaxAmount = taxAmount / Double(numberOfPeopleLabel.text!)!
        
        taxPlusTotalCheckedAmount = totalWithTipPercentCheckedAmount + totalCheckedAmount
        
        splittedTaxPlusTotalCheckedAmount = totalWithTipPercentCheckedAmount + splittedTaxAmount + totalCheckedAmount
        
        print("TotalPlusSplittedTax: \(splittedTaxPlusTotalCheckedAmount)")
        
        
        if items.count == 0  {
            
            let aC = UIAlertController(title: "No Items", message: "Please add items.", preferredStyle: .alert)
            let oKButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            oKButton.setValue(UIColor(red:0.43, green:0.66, blue:0.84, alpha:1.0), forKey: "titleTextColor")
            
            aC.addAction(oKButton)
            present(aC, animated: true, completion: nil)
            
        } else if splittedTaxPlusTotalCheckedAmount == 0 && allItemsPriceAmount == 0 {
            
            let aC = UIAlertController(title: "No Values", message: "Please input prices.", preferredStyle: .alert)
            let oKButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            oKButton.setValue(UIColor(red:0.43, green:0.66, blue:0.84, alpha:1.0), forKey: "titleTextColor")
            aC.addAction(oKButton)
            present(aC, animated: true, completion: nil)
            
        }
        
        Answers.logCustomEvent(withName: "User Calculates", customAttributes: nil)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "calculate" {
            
            let calculationResultsViewController = segue.destination as! CalculationResultsViewController
            calculationResultsViewController.calculatedAmount = allItemsPlusTaxAmount
            calculationResultsViewController.amountPerPerson = splittedTaxPlusTotalCheckedAmount
            
        }
        
        if segue.identifier == "about" {
            
            _ = segue.destination as! AboutViewController
        }
    }
    
}



//MARK: -
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 53
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemTableViewCell", for: indexPath) as! ItemCell
        let row = indexPath.row
        let item = items[row]
        cell.item = item
        cell.row = row
        cell.delegate = self
        cell.itemPriceTextField.delegate = self
        cell.itemTitleTextLabel.text = item.itemLabel
        cell.itemNumberLabel.text = String(indexPath.row + 1)
        cell.itemPriceTextField.text = nil
        if item.itemPrice != 0.0 {
            cell.itemPriceTextField.text = String(format: "%.02f", item.itemPrice)
        }
        cell.isChecked = item.isChecked
        
        if item.isChecked == true {
            
            cell.isCheckedButton.setImage(#imageLiteral(resourceName: "Select"), for: .normal)
            
        }
        else{
            
            cell.isCheckedButton.setImage(#imageLiteral(resourceName: "Reveal"), for: .normal)
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            items.remove(at: indexPath.row)
            checkButtons.remove(at: indexPath.row)
            
            itemNumber = 0
            
            for item in items {
                item.itemNumber = itemNumber + 1
            }
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                
                tableView.reloadData()
                
            })
        }
    }
}

extension HomeViewController: ItemCheckList {
    
    func getInfo(row: Int, cell: ItemCell) {
        
        let itemAtThisCell = Item(itemNumber: itemNumber, isChecked: cell.isChecked, itemPrice: price)
        
        checkButtons[row] = itemAtThisCell.isChecked
    }
    
}

extension HomeViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let contentView = textField.superview!
        if let cell = contentView.superview as? UITableViewCell {
            let indexPath = tableView.indexPath(for: cell)
            let row = indexPath?.row
            if let row = row {
                
                let itemAtThisCell = items[row]
                
                if textField.text != "" {
                    if let textFieldText = textField.text {
                        if let price = Double(textFieldText) {
                            itemAtThisCell.itemPrice = price
                            textField.text = String(format: "%.02f", itemAtThisCell.itemPrice)
                        }
                    }
                    
                    
                } else {
                    
                    itemAtThisCell.itemPrice =  0.0
                    
                }
            } else {
                
                print("not located in a cell")
                
            }
        }
        
        if taxAmountTextField.text != "" {
            
            taxAmountTextField.text = String(format: "%.02f", Double(taxAmountTextField.text!)!)
            
        }
        
    }
    
}

extension UITextField {
    
    open override func awakeFromNib() {
        
        super.awakeFromNib()
        self.addHideinputAccessoryView()
        
    }
    
    func addHideinputAccessoryView() {
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        toolbar.barStyle = UIBarStyle.default
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done,
                                         
                                         target: self, action: #selector(self.resignFirstResponder))
        
        doneButton.tintColor = UIColor(red:0.43, green:0.66, blue:0.84, alpha:1.0)
        
        toolbar.setItems([doneButton], animated: true)
        
        toolbar.isUserInteractionEnabled = true
        
        self.inputAccessoryView = toolbar
        
}

}
