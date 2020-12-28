//
//  ContactsVC.swift
//  FastCampus
//
//  Created by 송황호 on 2020/12/23.
//

import UIKit
import Contacts

class ContactsVC: UIViewController {

    static let identifier = "ContactsVC"
    
    @IBOutlet weak var contactTable: UITableView!
    
    var contactList = [informations]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactTable.delegate = self
        contactTable.dataSource = self
        
        readContacts()
    }
    
    // 주소록 읽어오기
    private func readContacts() {
        
        let store = CNContactStore()
  
        store.requestAccess(for: .contacts) { (granted, err) in
            if let err = err{
                print("faild" , err)
                return
            }
            if granted{
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                
                let request = CNContactFetchRequest(keysToFetch:keys as [CNKeyDescriptor])
                
                do {
                    request.sortOrder = CNContactSortOrder.userDefault
                    
                    try store.enumerateContacts(with: request, usingBlock: {(contacts, stopPointerIfYouWantToStopEnumerating) in
                        
                        let phone_number = contacts.phoneNumbers.first?.value.stringValue ?? ""
                        
                        if phone_number != "" {
                            let full_name = contacts.givenName + " " + contacts.familyName
                            
                            let contact_model = informations(fullNmae: full_name, phoneNumber: phone_number)
                            
                            self.contactList.append(contact_model)
                        }
                    })
                    self.contactTable.reloadData()
                }catch let err{
                    print("err", err)
                }
            }

        }
    }
    
    
    @IBAction func backPressButton(_ sender: Any) {
        print("주소로오오오옥 --> \(self.contactList.count)")
        self.navigationController?.popViewController(animated: true)
//        dismiss(animated: true, completion: nil)
    }

}

extension ContactsVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contactList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = contactTable.dequeueReusableCell(withIdentifier: ContactsTVCell.identifier, for: indexPath) as? ContactsTVCell else { return UITableViewCell() }
        
        let rowdata = self.contactList[indexPath.row]
        
        cell.bind(name: rowdata.fullNmae, phone: rowdata.phoneNumber)

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
    var fullNmae: String
    var phoneNumber: String
}

