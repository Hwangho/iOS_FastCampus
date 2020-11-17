//
//  DetailVC.swift
//  FastCampus
//
//  Created by 송황호 on 2020/11/17.
//

import UIKit

class DetailVC: UIViewController {

    @IBOutlet weak var boutyImg: UIImageView!
    @IBOutlet weak var nameTx: UILabel!
    @IBOutlet weak var bountyTx: UILabel!
    
    var image : String?
    var name : String?
    var bounty : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI(){
        
        if let image = self.image, let name = self.name, let bounty = self.bounty {
            self.boutyImg.image = UIImage(named: image)
            self.nameTx.text = name
            self.bountyTx.text = " \(bounty)"
        }
    }

    @IBAction func backPressBtn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    

}
