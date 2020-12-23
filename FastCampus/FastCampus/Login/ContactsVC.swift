//
//  ContactsVC.swift
//  FastCampus
//
//  Created by 송황호 on 2020/12/23.
//

import UIKit
import Contacts

class ContactsVC: UIViewController {

    @IBOutlet weak var contactTable: UITableView!
    
    var contacts: NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(takeContacts), name: .init("contacts"), object: nil)
        contactTable.delegate = self
        contactTable.dataSource = self
    }
    
    @objc func takeContacts(_ notification: Notification){
        guard  let userInfo = notification.userInfo as? [String? : Any] else {return}
        guard let contacts = userInfo["contact"] as? NSMutableArray else{ return }
        
        self.contacts = contacts
    }
    
    
    @IBAction func backPressButton(_ sender: Any) {
        print("주소로오오오옥 --> \(self.contacts)")
        dismiss(animated: true, completion: nil)
    }

}

extension ContactsVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = contactTable.dequeueReusableCell(withIdentifier: ContactsTVCell.identifier, for: indexPath) as? ContactsTVCell else { return UITableViewCell() }
        
//               let section = filteredSections[indexPath.section]
//               let contact = section.value[indexPath.row]
//               cell.configure(contact)
        

               
               return cell
    }
}

extension ContactsVC: UITableViewDelegate{
    
}

//MARK: TableViewCell 관련

class ContactsTVCell: UITableViewCell{
    
    static let identifier = "ContactsTVCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func bind(name: String, phone: String){
        self.nameLabel.text = name
        self.phoneNumLabel.text = "\(phone)"
    }
}


// MARK: Struct 만들기
struct informations{
    let fullNmae: String
    let phoneNumber: Int
}

