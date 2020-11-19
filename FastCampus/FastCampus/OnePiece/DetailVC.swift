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
    @IBOutlet weak var nameLabelCenter: NSLayoutConstraint!
    @IBOutlet weak var bountyLabelCenter: NSLayoutConstraint!
        
    var image : String?
    var name : String?
    var bounty : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        prepareanimation()
    }
    
    // 나타 날 것이다
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAnimation()
    }
    
    private func prepareanimation(){
//        nameLabelCenter.constant = view.bounds.width
//        bountyLabelCenter.constant = view.bounds.width
        
        nameTx.transform = CGAffineTransform(translationX: view.bounds.width, y: 0).scaledBy(x: 3, y: 3).rotated(by: 180)   // ScaleBy = 3, 180도 회전 되어 있으며 화면 오른쪽에서 나타 남
        bountyTx.transform = CGAffineTransform(translationX: view.bounds.width, y: 0).scaledBy(x: 3, y: 3).rotated(by: 180)
        
        nameTx.alpha = 0        // 투명도
        bountyTx.alpha = 0
    }
    
    private func showAnimation(){
        nameLabelCenter.constant = 0
        bountyLabelCenter.constant = 0

        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 2, options: .allowUserInteraction, animations: {
            self.nameTx.transform = CGAffineTransform.identity
            self.nameTx.alpha = 1
        }, completion: nil)
        UIView.animate(withDuration: 0.8, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 2, options: .allowUserInteraction, animations: {
            self.bountyTx.transform = CGAffineTransform.identity
            self.bountyTx.alpha = 1
        }, completion: nil)
        
        UIView.transition(with: boutyImg, duration: 0.3, options: .transitionFlipFromLeft,animations: nil, completion: nil)
    }
    
    
    func updateUI(){
        if let image = self.image, let name = self.name, let bounty = self.bounty {
            self.boutyImg.image = UIImage(named: image)
            self.nameTx.text = name
            self.bountyTx.text = "\(bounty)"
        }
    }

    @IBAction func backPressBtn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    

}
