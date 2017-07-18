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
    @IBOutlet weak var addItemButton: UIButton!
    @IBOutlet weak var numberOfPeopleTextField: UITextField!
    @IBOutlet weak var taxAmountTextField: UITextField!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var scanBillButton: UIButton!
    
    var isSelected = true
    
    var globlaKeyboardSize: CGRect! = CGRect.zero
    
    var activeField: UITextField?
    
    var itemCells = [ItemCell]()
    
    var priceAmounts = [Double]()
    
    var totalAmount: Double = 0.0
    
    var taxPlusTotalAmount: Double = 0.0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.intializeItems()
        
        calculateButton.layer.cornerRadius = 6
        addItemButton.layer.cornerRadius = 6
        scanBillButton.layer.cornerRadius = 6
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        numberOfPeopleTextField.tag = 1
        taxAmountTextField.tag = 2
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) //This will hide the keyboard
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        {
            globlaKeyboardSize = keyboardSize
            
            if let temporaryActiveField = activeField
            {
                textFieldShouldBeginEditing(temporaryActiveField)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        {
            globlaKeyboardSize = keyboardSize
            
            if let temporaryActiveField = activeField
            {
                textFieldShouldEndEditing(temporaryActiveField)
            }
        }
    }
    
    @IBAction func tipPercentValueChanged(_ sender: UISlider) {
        
        let currentPercent = String(Int(tipSlider.value))
        
        tipPercentLabel.text = "Tip \(currentPercent)%:"
        
    }
    
    @IBAction func tipSliderDrag(_ sender: Any) {
        
        tipSlider.isContinuous = true
        
    }
    
    @IBAction func addItemButton(_ sender: UIButton) {
        
        items.append(Item(itemNumber: itemNumber, isChecked: false))
                
        print(items.count)
        itemNumber = 0
        
        for item in items {
            item.itemNumber = itemNumber + 1
        }
        
        tableView.reloadData()
        
        let lastRowIndexPath = IndexPath(row: items.count-1, section: 0)
        
        tableView.scrollToRow(at: lastRowIndexPath, at: .none, animated: true)
        
    }
    
    func intializeItems() {
        
        for _ in 1...5 {
            
            itemNumber += 1
            items.append(Item(itemNumber: itemNumber, isChecked: false))
            
            print(items.count)
        }
    }
    
    @IBAction func calculateButtonTapped(_ sender: UIButton) {
        
        priceAmounts.removeAll()
        
        for cell in itemCells {
        
            if let priceAmount = Double(cell.itemPriceTextField.text!) {
                
                let tipPercent = Double(tipSlider.value)
                
                print(tipPercent)
                
                let roundedPriceAmount = (100*priceAmount)/100
                
                print(roundedPriceAmount)
                
                let tipAmount = tipPercent*roundedPriceAmount
                
                
                let roundedTipAmount = (100*tipAmount)/100
                
                print(roundedTipAmount)
                
                
                totalAmount = roundedPriceAmount+roundedTipAmount
                
                taxPlusTotalAmount = totalAmount + Double(taxAmountTextField.text!)!
                
                print(taxPlusTotalAmount)
                
                priceAmounts.append(priceAmount)
                
                print(priceAmount)
                
            } else {
                
                let aC = UIAlertController(title: "Error", message: "Invalid text for item price.", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                aC.addAction(okButton)
                present(aC, animated: true, completion: nil)
                break
            
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "calculate" {
            
            let calculationResultsViewController = segue.destination as! CalculationResultsViewController
            calculationResultsViewController.calculatedAmount = taxPlusTotalAmount
        }
    }
}



//MARK: -
extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemTableViewCell", for: indexPath) as! ItemCell
        let item = items[indexPath.row]
        
        cell.delegate = self
        cell.itemPriceTextField.delegate = self
        
        cell.itemTitleTextLabel.text = item.itemLabel
        cell.itemNumberLabel.text = String(indexPath.row + 1)
        cell.itemPriceTextField.text = String(format: "%.02f", item.itemPrice)
        
        if item.isChecked {
            cell.isCheckedButton.setImage(#imageLiteral(resourceName: "Select"), for: .normal)
        } else {
            cell.isCheckedButton.setImage(#imageLiteral(resourceName: "Reveal"), for: .normal)
        }

        
//        itemCells.append(cell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
//            itemCells.remove(at: indexPath.row)
            items.remove(at: indexPath.row)
            
            itemNumber = 0
            
            for item in items {
                item.itemNumber = itemNumber + 1
            }
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
    }
}

extension HomeViewController: ItemCheckList {
    
    func getInfo(cell: ItemCell) {
        
        let itemAtThisCell = Item(itemNumber: Int(cell.itemNumberLabel.text!)!, isChecked: cell.isChecked)
        
        itemAtThisCell.isChecked = !itemAtThisCell.isChecked
        
        
    }
}

extension HomeViewController: UITextFieldDelegate
{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        activeField = textField
        
        if textField.tag == 1 || textField.tag == 2 && globlaKeyboardSize.height != 0.0
        {
            if self.view.frame.origin.y == 0
            {
                self.view.frame.origin.y -= globlaKeyboardSize.height
            }
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        
        if textField.tag == 1 || textField.tag == 2 && globlaKeyboardSize.height != 0.0
        {
            if self.view.frame.origin.y != 0
            {
                self.view.frame.origin.y += globlaKeyboardSize.height
            }
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
        print("editing")
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let contentView = textField.superview as! UIView
        if let cell = contentView.superview as? UITableViewCell {
            let indexPath = tableView.indexPath(for: cell)
            
            let itemAtThisCell = items[(indexPath?.row)!]
            
            if textField.text != "" {
                itemAtThisCell.itemPrice = Double(textField.text!)!
            } else {
                itemAtThisCell.itemPrice = 0.0
            }
        } else {
            print("not located in a cell")
        }

    }
}
