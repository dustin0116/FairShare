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
    var tipPercentageAddedTotalAmount: Double = 0.0
    var tipPercentageAmount: Double = 0.0
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
        // Adds done button above the keyboard.
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
        // Allows done button to to dismiss the keyboard for Tax Amount Text Field.
        self.taxAmountTextField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Dismisses keyboard if anywhere is tapped outside of the keyboard.
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification : NSNotification) {
        // Keyboard shows and moves view up when Tax Amount Text Field is editing so that it doesn't block the text field.
        if taxAmountTextField.isEditing {
            let info:NSDictionary = notification.userInfo! as NSDictionary
            let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            
            self.view.frame.origin.y = self.view.frame.origin.y - keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification : NSNotification) {
        // Dismisses keyboard and moves view back down to its original position.
        if taxAmountTextField.resignFirstResponder() {
            let info:NSDictionary = notification.userInfo! as NSDictionary
            let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            self.view.frame.origin.y = self.view.frame.origin.y + keyboardSize.height
        }
    }
    
    func initializeItems() {
        // Initializes 5 items as default.
        for _ in 1...5 {
            itemNumber += 1
            items.append(Item(itemNumber: itemNumber, isChecked: false, itemPrice: price))
            checkButtons.append(false)
        }
    }
    
    
    @IBAction func numberOfPeopleStepperAction(_ sender: UIStepper) {
        // Changes number of people value by tapping on stepper buttons.
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        // Triggers haptic feedback when tapping.
        numberOfPeopleLabel.text = String(Int(sender.value))
        
    }
    
    @IBAction func tipPercentValueChanged(_ sender: UISlider) {
        // Changes tip percent value as user slides.
        let currentPercent = String(Int(tipSlider.value))
        tipPercentLabel.text = "Tip \(currentPercent)%:"

    }
    
    @IBAction func tipSliderDrag(_ sender: Any) {
        // Allows continious dragging on Tip Percentage Slider.
        tipSlider.isContinuous = true
    }
    
    @IBAction func tipSliderTouchUpInside(_ sender: Any) {
        // Adds haptic feedback when slider is at either end.
        let currentPercent = String(Int(tipSlider.value))
        tipPercentLabel.text = "Tip \(currentPercent)%:"
    }
    
    //MARK: - Buttons
    @IBAction func addItemButtonTapped(_ sender: UIBarButtonItem) {
        // Appends an item (itemTableViewCell) to the Items Table View.
        items.append(Item(itemNumber: itemNumber, isChecked: false, itemPrice: price))
        checkButtons.append(false)
        // Appended item should be appended as an unchecked item.
        
        itemNumber = 0
        // Item numbering variable
        for item in items {
            // Item number for each new item will be the previous one incremented by 1.
            item.itemNumber = itemNumber + 1
        }
        
        tableView.reloadData()
        // Reloads tableView so that the item number would refresh.
        
        let lastRowIndexPath = IndexPath(row: items.count - 1, section: 0)
        tableView.scrollToRow(at: lastRowIndexPath, at: .none, animated: true)
        // Table View scrolls down if added item would be added below what the screen can show.
        
        Answers.logCustomEvent(withName: "User adds item", customAttributes: nil)
        // For Fabric.io logging when user adds item.
        
    }
    
    @IBAction func removeAllButtonTapped(_ sender: UIButton) {
        // Removes all items (itemTableViewCell) from Items Table View.
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        // Haptic feedback when "Remove All" Button is tapped.
        self.view.endEditing(true)
        if items.isEmpty {
            // Alert for when user removes when there are nothing to be removed.
            let aC = UIAlertController(title: "Empty", message: "There are no items to be removed.", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
            okButton.setValue(UIColor(red:0.43, green:0.66, blue:0.84, alpha:1.0), forKey: "titleTextColor")
            aC.addAction(okButton)
            present(aC, animated: true, completion: nil)
        }
        else {
            // Alert for maing sure if user wants to remove all items.
            let aC = UIAlertController(title: "Remove All Items", message: "Are you sure you want to remove all items?", preferredStyle: .alert)
            
            let yesButton = UIAlertAction(title: "Yes", style: .default, handler: {(action: UIAlertAction!) in
                self.items.removeAll()
                self.checkButtons.removeAll()
                let range = NSMakeRange(0, self.tableView.numberOfSections)
                let sections = NSIndexSet(indexesIn: range)
                self.tableView.reloadSections(sections as IndexSet, with: .fade)
                self.tableView.rowHeight = 53
                
                Answers.logCustomEvent(withName: "User Removes All Items", customAttributes: nil)
                // Fabric.io for logging when user completes remove all items action.
            })
            
            yesButton.setValue(UIColor(red:0.43, green:0.66, blue:0.84, alpha:1.0), forKey: "titleTextColor")
            // Set color for "Yes" Button
            let noButton = UIAlertAction(title: "No", style: .cancel, handler: nil)
            // Set "No" Button and its color
            noButton.setValue(UIColor(red:0.43, green:0.66, blue:0.84, alpha:1.0), forKey: "titleTextColor")
            aC.addAction(yesButton)
            aC.addAction(noButton)
            present(aC, animated: true, completion: nil)
            // Adds actions to AlertController and presents it.
        }
    }
    
    @IBAction func calculateButtonTapped(_ sender: UIButton) {
        // Calculates.
        tipPercentageAmount = 0.0
        tipPercentageAddedTotalAmount = 0.0
        splittedTaxPlusTotalCheckedAmount = 0.0
        totalCheckedAmount = 0.0
        allItemsPlusTaxAmount = 0.0
        allItemsPriceAmount = 0.0
        allItemsWithTipPercentAmount = 0.0
        allItemsSplittedEqually = 0.0
        
        taxAmountTextField.resignFirstResponder()
        // Assures that keyboard will dismiss if it is still on Tax Amount Text Field or else will crash.
        let tipPercent = Double(Int(tipSlider.value)) / 100
        let roundedTipPercent = String(format: "%.2f", tipPercent)
        var taxAmount = 0.0
        var taxPercentage = 0.0
        
        switch taxInputTypeSelector.selectedSegmentIndex {
        // Cases for Tax Type Switch.
        case 0: if taxAmountTextField.text != "" {
            taxAmount = Double(taxAmountTextField.text!)!
            for i in 0..<items.count {
                if items[i].itemPrice >= 0 {
                    let priceAmount = items[i].itemPrice
                    // Calculation for all items regardless of being checked or not.
                    allItemsPriceAmount += priceAmount
                    allItemsWithTipPercentAmount = (allItemsPriceAmount * Double(roundedTipPercent)!) + allItemsPriceAmount
                    allItemsPlusTaxAmount = allItemsWithTipPercentAmount + taxAmount
                    if priceAmount == 0.0 || checkButtons[i] == false {
                        // Checks if item is checked and whether it has a price or not.
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
            // Calculation for checked items.
            tipPercentageAmount = (allItemsPriceAmount * Double(roundedTipPercent)!) / Double(numberOfPeopleLabel.text!)!
            let splittedTaxAmount = taxAmount / Double(numberOfPeopleLabel.text!)!
            tipPercentageAddedTotalAmount = tipPercentageAmount + totalCheckedAmount
            splittedTaxPlusTotalCheckedAmount = tipPercentageAddedTotalAmount + splittedTaxAmount
        } else {
            taxAmount = 0.0
            }
        case 1: if taxAmountTextField.text != "" {
            taxAmount = Double(taxAmountTextField.text!)! / 100
            for i in 0..<items.count {
                if items[i].itemPrice >= 0 {
                    let priceAmount = items[i].itemPrice
                    allItemsPriceAmount += priceAmount
                    allItemsWithTipPercentAmount = (allItemsPriceAmount * Double(roundedTipPercent)!) + allItemsPriceAmount
                    taxPercentage = taxAmount * allItemsPriceAmount
                    allItemsPlusTaxAmount = allItemsWithTipPercentAmount + taxPercentage
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
            tipPercentageAmount = (allItemsPriceAmount * Double(roundedTipPercent)!) / Double(numberOfPeopleLabel.text!)!
            let splittedTaxAmount = (taxAmount * allItemsPriceAmount) / Double(numberOfPeopleLabel.text!)!
            tipPercentageAddedTotalAmount = tipPercentageAmount + totalCheckedAmount
            splittedTaxPlusTotalCheckedAmount = tipPercentageAddedTotalAmount + splittedTaxAmount
        } else {
            taxAmount = 0.0
            }
        default: break
        }
        if items.count == 0  {
            // Alert for if there are no items in Items Table View.
            let aC = UIAlertController(title: "No Items", message: "Please add items.", preferredStyle: .alert)
            let oKButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            oKButton.setValue(UIColor(red:0.43, green:0.66, blue:0.84, alpha:1.0), forKey: "titleTextColor")
            aC.addAction(oKButton)
            present(aC, animated: true, completion: nil)
        } else if splittedTaxPlusTotalCheckedAmount == 0 && allItemsPriceAmount == 0 {
            // Alert for if there are no prices.
            let aC = UIAlertController(title: "No Values", message: "Please input prices.", preferredStyle: .alert)
            let oKButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            oKButton.setValue(UIColor(red:0.43, green:0.66, blue:0.84, alpha:1.0), forKey: "titleTextColor")
            aC.addAction(oKButton)
            present(aC, animated: true, completion: nil)
        }
        Answers.logCustomEvent(withName: "User Calculates", customAttributes: nil)
        // Fabric.io for logging when user calculates.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Segue to other ViewControllers
        if segue.identifier == "calculate" {
            // Segue to CalculationResultsViewController and transferring values of variables.
            let calculationResultsViewController = segue.destination as! CalculationResultsViewController
            calculationResultsViewController.calculatedAmount = allItemsPlusTaxAmount
            calculationResultsViewController.amountPerPerson = splittedTaxPlusTotalCheckedAmount
        }
        if segue.identifier == "about" {
            // Segue to AboutViewController
            _ = segue.destination as! AboutViewController
        }
    }
}

//MARK: -
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    // Sets Table View.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Sets how many items there are in the Table View.
        return items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Sets height for each itemTableViewCell.
        return 53
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Sets Table View Cells.
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
        // Removes itemTableViewCell.
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
            // Reloads Table View.
            })
        }
    }
}

extension HomeViewController: ItemCheckList {
    // Sets check button for itemTableViewCell.
    func getInfo(row: Int, cell: ItemCell) {
        let itemAtThisCell = Item(itemNumber: itemNumber, isChecked: cell.isChecked, itemPrice: price)
        checkButtons[row] = itemAtThisCell.isChecked
    }
}

extension HomeViewController: UITextFieldDelegate {
    // Sets text field of itemTableViewCell and formats.
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
    // Adding toolbar with done button for keyboard in Items Table View.
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.addHideinputAccessoryView()
    }
    
    func addHideinputAccessoryView() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        toolbar.barStyle = UIBarStyle.default
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.resignFirstResponder))
        doneButton.tintColor = UIColor(red:0.43, green:0.66, blue:0.84, alpha:1.0)
        toolbar.setItems([doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        self.inputAccessoryView = toolbar
    }
}
