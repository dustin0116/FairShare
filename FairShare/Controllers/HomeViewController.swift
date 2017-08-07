//
//  HomeViewController.swift
//  FairShare
//

//  Created by Dustin Hsiang on 7/10/17.
//  Copyright © 2017 Dustin Hsiang. All rights reserved.
//
import UIKit
import Answers
import Fabric

class HomeViewController: UIViewController {

//MARK: - Variables
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
    
    var prevButton = UIBarButtonItem(title: "<", style: .plain, target: self, action: #selector(prevAction))
    
    var nextButton = UIBarButtonItem(title: ">", style: .plain, target: self, action: #selector(nextAction))
    
    var globlalKeyboardSize: CGRect! = CGRect.zero
    
    var activeField: UITextField?
    
    var items = [Item]()
    
    var textFields = [UITextField]()
    
    var itemPrices = [String]()
    
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
        
        
        calculateButton.layer.cornerRadius = 10
        removeAllButton.layer.cornerRadius = 10
        numberOfPeopleStepper.layer.cornerRadius = 5
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        taxAmountTextField.tag = -100
        
        self.addDoneButtonOnKeyboard()
        
    }
    
    func nextAction() {
        
//        let newTag: Int = tag + 1
//        if (self.delegate?.responds(to: Selector(("textField:moveToTextFieldWithTag:"))))! {
//            (delegate as! TableViewCellTextFieldDelegate).textField(self, moveToTextFieldWithTag: newTag)
//        }
//        else {
//            
//            endEditing(true)
//            
//        }
    }
    
    func prevAction() {
//        
//        let newTag: Int = tag - 1
//        if (delegate?.responds(to: Selector(("textField:moveToTextFieldWithTag:"))))! {
//            (delegate as! TableViewCellTextFieldDelegate).textField(self, moveToTextFieldWithTag: newTag)
//            
//        } else {
//            
//            endEditing(true)
//            
//        }
    }
    
    func addDoneButtonOnKeyboard() {
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(HomeViewController.doneButtonAction))
        
        doneToolbar.isTranslucent = false
        
        var items = [UIBarButtonItem]()
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.taxAmountTextField.inputAccessoryView = doneToolbar
        
    }
    
    func doneButtonAction() {
        
        self.taxAmountTextField.resignFirstResponder()
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true) //This will hide the keyboard
        
    }

    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        {
            globlalKeyboardSize = keyboardSize
            
            if let temporaryActiveField = activeField
            {
                _ = textFieldShouldBeginEditing(temporaryActiveField)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        {
            globlalKeyboardSize = keyboardSize
            
            if let temporaryActiveField = activeField
            {
                _ = textFieldShouldEndEditing(temporaryActiveField)
            }
        }
    }
    
    func initializeItems() {
        
        for _ in 1...5 {
            
            itemNumber += 1
            
            items.append(Item(itemNumber: itemNumber, isChecked: false, itemPrice: price))
            
            itemPrices.append("")

            checkButtons.append(false)
            
            print("Items: \(items.count)")
        }
    }
    
    
    @IBAction func numberOfPeopleStepperAction(_ sender: UIStepper) {
        
        numberOfPeopleLabel.text = String(Int(sender.value))
        
    }
    
    @IBAction func tipPercentValueChanged(_ sender: UISlider) {
        
        let currentPercent = String(Int(tipSlider.value))
        
        tipPercentLabel.text = "Tip \(currentPercent)%:"
        
    }
    
    @IBAction func tipSliderDrag(_ sender: Any) {
        
        tipSlider.isContinuous = true
        
    }
    
    
    @IBAction func taxInputTypeSelectorValueChanged(_ sender: UISegmentedControl) {
        
        if taxInputTypeSelector.selectedSegmentIndex == 0 {
            taxAmountTextField.text = "0.00"
        } else if taxInputTypeSelector.selectedSegmentIndex == 1 {
            taxAmountTextField.text = "0"
        }
    }
    
//    func nextButtonTapped(_ sender: UIBarButtonItem) {
//        
//        for i in 0..<textFields.count {
//            
//            if textFields[i].isFirstResponder {
//                
//                textFields[i+1].becomeFirstResponder()
//                
//            }
//        }
//    }
//    
//    func previousButtonTapped(_ sender: UIBarButtonItem) {
//        
//        
//    }
    
//MARK: - Buttons
    
    @IBAction func addItemButtonTapped(_ sender: UIBarButtonItem) {
        
        items.append(Item(itemNumber: itemNumber, isChecked: false, itemPrice: price))
        
        itemPrices.append("")
        
        checkButtons.append(false)
        
        print("Items: \(items.count)")
        
        itemNumber = 0
        
        for item in items {
            item.itemNumber = itemNumber + 1
        }
        
        tableView.reloadData()
        
        let lastRowIndexPath = IndexPath(row: items.count - 1, section: 0)
        
        tableView.scrollToRow(at: lastRowIndexPath, at: .none, animated: true)
    }
    
    @IBAction func removeAllButtonTapped(_ sender: UIButton) {
        
        let aC = UIAlertController(title: "Remove All Items", message: "Are you sure you want to remove all items?", preferredStyle: .alert)
        
        let yesButton = UIAlertAction(title: "Yes", style: .default, handler: {(action: UIAlertAction!) in
            
            self.items.removeAll()
            
            self.itemPrices.removeAll()
            
            self.checkButtons.removeAll()
            
            let range = NSMakeRange(0, self.tableView.numberOfSections)
            let sections = NSIndexSet(indexesIn: range)
            self.tableView.reloadSections(sections as IndexSet, with: .fade)
            
            self.tableView.rowHeight = 53
            
            print("Items: \(self.items.count)")
        })
        
        
        let noButton = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        aC.addAction(yesButton)
        aC.addAction(noButton)
        
        present(aC, animated: true, completion: nil)
        

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
        
        let tipPercent = Double(tipSlider.value) / 100
        
        var taxAmount = 0.0
        
        switch taxInputTypeSelector.selectedSegmentIndex {
            
        case 0: taxAmount = Double(taxAmountTextField.text!)!
        case 1: taxAmount = Double(taxAmountTextField.text!)! / 100
        default: break
            
        }
        
        for i in 0..<itemPrices.count {
        
            if items[i].itemPrice >= 0 {
                
                let priceAmount = items[i].itemPrice
                
                print("Price: \(priceAmount)")
                
                
                let roundedForAllItemsPriceAmount = (100 * priceAmount) / 100
                
                
                allItemsPriceAmount += roundedForAllItemsPriceAmount
                
                allItemsWithTipPercentAmount = allItemsPriceAmount * tipPercent
                
                allItemsPlusTaxAmount = allItemsWithTipPercentAmount + taxAmount + allItemsPriceAmount
                
                allItemsSplittedEqually = allItemsPlusTaxAmount / Double(numberOfPeopleLabel.text!)!
                
                
                if priceAmount == 0.0 || checkButtons[i] == false {
                    
                    continue
                    
                    }
                
                let roundedPriceAmount = (100 * priceAmount) / 100
                
                print("Rounded Price: \(roundedPriceAmount)")
                
                totalCheckedAmount += roundedPriceAmount
                
                print("Total: \(totalCheckedAmount)")
                
            } else {
                
                let aC = UIAlertController(title: "Error", message: "Invalid text for item price.", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                aC.addAction(okButton)
                present(aC, animated: true, completion: nil)
                break
            
            }
        }
        
        totalWithTipPercentCheckedAmount = totalCheckedAmount * tipPercent
        
        print("Total with Tip: \(totalWithTipPercentCheckedAmount)")
        
        let splittedTaxAmount = taxAmount / Double(numberOfPeopleLabel.text!)!
        
        taxPlusTotalCheckedAmount = totalWithTipPercentCheckedAmount + totalCheckedAmount
        
        splittedTaxPlusTotalCheckedAmount = totalWithTipPercentCheckedAmount + splittedTaxAmount + totalCheckedAmount
        
        print("TotalPlusSplittedTax: \(splittedTaxPlusTotalCheckedAmount)")
        
        
        if items.count == 0 {
            
            let aC = UIAlertController(title: "No Items", message: "Please add items.", preferredStyle: .alert)
            let oKButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            aC.addAction(oKButton)
            present(aC, animated: true, completion: nil)
            
        } else if taxAmountTextField.text == "0.00" && splittedTaxPlusTotalCheckedAmount == 0 && allItemsPriceAmount == 0 {
            
            let aC = UIAlertController(title: "No Values", message: "Please input prices.", preferredStyle: .alert)
            let oKButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            aC.addAction(oKButton)
            present(aC, animated: true, completion: nil)
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "calculate" {
            
            let calculationResultsViewController = segue.destination as! CalculationResultsViewController
            calculationResultsViewController.calculatedAmount = allItemsPlusTaxAmount
            calculationResultsViewController.amountPerPerson = splittedTaxPlusTotalCheckedAmount
            calculationResultsViewController.calculatedAmountSplitted = allItemsSplittedEqually
            
        }
        
        if segue.identifier == "about" {
            
          _ = segue.destination as! AboutViewController
        }
        
        Answers.logCustomEvent(withName: "User Calculates", customAttributes: nil)
        
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
        
        cell.row = row
        cell.delegate = self
        cell.itemPriceTextField.delegate = self
//        cell.itemPriceTextField.moveTextFieldDelegate = self
        cell.tag = indexPath.row + 1
        cell.itemPriceTextField.tag = indexPath.row + 1
        cell.itemTitleTextLabel.text = item.itemLabel
        cell.itemNumberLabel.text = String(indexPath.row + 1)
        cell.itemPriceTextField.text = String(format: "%.02f", item.itemPrice)
        cell.item = item
        cell.isChecked = item.isChecked
        
        textFields.append(cell.itemPriceTextField)
        
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
            itemPrices.remove(at: indexPath.row)
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
        
//        itemAtThisCell.isChecked = !itemAtThisCell.isChecked
        
        checkButtons[row] = itemAtThisCell.isChecked
    }
    
    func addPriceToArray(row: Int, text: String) {
        
        itemPrices[row] = text
        
    }
}

extension HomeViewController: TableViewCellTextFieldDelegate {
    
    func textField(_ textField: TableViewCellTextField, moveToTextFieldWithTag tag: Int) {
        
        let celda: UITableViewCell = self.tableView.viewWithTag(tag) as! UITableViewCell
        let nextResponder: UIResponder? = celda.contentView.viewWithTag(tag)
        if nextResponder != nil {
            nextResponder?.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
    }
    
    

}

extension HomeViewController: UITextFieldDelegate
{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        
//        if textField.tag != -100 {
//            
//            let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
//            toolbar.barStyle = UIBarStyle.default
//            toolbar.sizeToFit()
//            
//            toolbar.setItems([nextButton, prevButton], animated: false)
//            
//            toolbar.isUserInteractionEnabled = true
//            
//            textField.inputAccessoryView = toolbar
//        }

        
        activeField = textField
        
        if (textField.tag == -100) && globlalKeyboardSize.height != 0.0
        {
            if self.view.frame.origin.y == 64
            {
            
                self.view.frame.origin.y -= globlalKeyboardSize.height
                
            }
        }
        
        return true
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        
        if (textField.tag == -100) && globlalKeyboardSize.height != 0.0
        {
            if self.view.frame.origin.y != 64
            {
                
                self.view.frame.origin.y += globlalKeyboardSize.height
                
            }
        }
        
        return true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
        print("editing")
        
        
    }
    
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
                        }
                    }
                    
                } else {
                    
                    itemAtThisCell.itemPrice =  0.0
                    
                }
            } else {
                
                print("not located in a cell")
                
            }
        }
        if taxAmountTextField.text == "" && taxInputTypeSelector.selectedSegmentIndex == 0 {
            
            taxAmountTextField.text = "0.00"
            
        } else if taxAmountTextField.text == "" && taxInputTypeSelector.selectedSegmentIndex == 1 {
            
            taxAmountTextField.text = "0"
            
        }
    }
    
}

//extension UITextField {
//    
//    open override func awakeFromNib() {
//        
//        super.awakeFromNib()
//        self.addHideinputAccessoryView()
//        
//    }
//    
//    func addHideinputAccessoryView() {
//        
//        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
//        toolbar.barStyle = UIBarStyle.default
//        toolbar.sizeToFit()
//        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done,
//                                         
//                                         target: self, action: #selector(self.resignFirstResponder))
//        
//        toolbar.setItems([doneButton], animated: true)
//        
//        let flexibleSpaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let fixedSpaceButton = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
//        
//        let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(TableViewCellTextField.nextAction))
//        
//        let previousButton = UIBarButtonItem(title: "Prev", style: .plain, target: self, action: #selector(TableViewCellTextField.prevAction))
//        
//        toolbar.setItems([doneButton, flexibleSpaceButton, previousButton, fixedSpaceButton, nextButton], animated: false)
//        
//        toolbar.isUserInteractionEnabled = true
//        
//        self.inputAccessoryView = toolbar
//
//    }
//    
//}
