//
//  CreateCompanyController.swift
//  AdvancedCoreData
//
//  Created by prog on 5/31/19.
//  Copyright © 2019 prog. All rights reserved.
//

import UIKit
import CoreData


//delegating class is where the event is fired and the delegate class is the one that handles the event for the delegating class

// delegatingCLASS reguirements:
// 1-make protocoldelegate
// 2- optional variable for protocol delegate
// 3 - call the method in the protocol delegate where you want to fire the event

// delegate class reguirements:
// 1- use self to identify as delegate
// 2- confrom to protocol delegate
// 3 - implement the method


protocol createCompanyControllerDelegate{
    func createCompany(company:Company)
    func didEditCompany(company: Company)

}

class CreateCompanyController: ViewController {
    var delegate:createCompanyControllerDelegate?
    var company:Company?{
        didSet{
            nameTextField.text = company?.name ?? "incoorect "
        }
    }
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        //enable autolayout
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var  nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        navigationItem.title = "Create Company"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        
        view.backgroundColor = UIColor.darkBlue
        
    }
    private func setupUI() {
      
        
        let lightBlueBackgroundView = UIView()
        lightBlueBackgroundView.backgroundColor = UIColor.lightBlue
        lightBlueBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(lightBlueBackgroundView)
        lightBlueBackgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        lightBlueBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lightBlueBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lightBlueBackgroundView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        //        nameLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
      
    }
    //if company already present in coredata then do edit otherwise create new comapny object
    @objc private func handleSave() {
        if company == nil {
            createCompany()
        } else {
            saveCompanyChanges()
        }
    }
    private func createCompany(){
        guard let name = nameTextField.text else {return}
        //        let comp = Company(name: name, founded: Date())
        //        dismiss(animated: true) {
        //            self.delegate?.createCompany(company: comp)
        //        }
        
        // temporary area
        let context =  CoreDataManager.shared.container.viewContext
        //craete new object for company entity  in coredata
        //entityname and attribute key already set in data model
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        company.setValue(name, forKey: "name")
        
        // save in core data
        do{
            try  context.save()
            print("saving in coredata")
            dismiss(animated: true) {
                self.delegate?.createCompany(company: company as! Company)
            }
            
        }
        catch let err {
            print("Failed to save company:", err)
            
        }
        
        
    }
    private func saveCompanyChanges() {
        let context = CoreDataManager.shared.container.viewContext
        
        company?.name = nameTextField.text
        
        do {
            try context.save()
            
            // save succeeded
            dismiss(animated: true, completion: {
                self.delegate?.didEditCompany(company: self.company!)
            })
            
        } catch let saveErr {
            print("Failed to save company changes:", saveErr)
        }
    }
    
    @objc private func handleCancel() {
        dismiss(animated: true, completion: nil)
        
    }
    
    

   
}
