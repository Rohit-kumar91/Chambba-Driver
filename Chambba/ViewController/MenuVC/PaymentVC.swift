//
//  PaymentVC.swift
//  Chambba
//
//  Created by Mayur chaudhary on 22/02/19.
//  Copyright © 2019 Mayur chaudhary. All rights reserved.
//

import UIKit

class PaymentVC: UIViewController {

    @IBOutlet weak var cashBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    //MARK:- UIViewController Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK:- Memory Warning Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK:- IBAction Method
    @IBAction func cashBtnAction(_ sender: UIButton) {
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
