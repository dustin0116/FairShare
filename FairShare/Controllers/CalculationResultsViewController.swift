//
//  CalculationResultsViewController.swift
//  FairShare
//
//  Created by Dustin Hsiang on 7/13/17.
//  Copyright © 2017 Dustin Hsiang. All rights reserved.
//

import UIKit

class CalculationResultsViewController: UIViewController {

    @IBOutlet weak var totalAmountTextField: UITextField!
    
    @IBOutlet weak var amountPerPersonTextField: UITextField!
    
    @IBOutlet weak var totalSplittedEquallyTextField: UITextField!
    
    var calculatedAmount: Double = 0.0
    
    var amountPerPerson: Double = 0.0
    
    var calculatedAmountSplitted: Double = 0.0
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        totalAmountTextField.text = String(format: "%.2f", calculatedAmount)
        amountPerPersonTextField.text = String(format: "%.2f", amountPerPerson)
        totalSplittedEquallyTextField.text = String(format: "%.2f", calculatedAmountSplitted)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
