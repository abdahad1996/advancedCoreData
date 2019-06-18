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

class CreateCompanyController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var delegate:createCompanyControllerDelegate?
    
    //if company already exists than show everything for editing
    var company:Company?{
        didSet {
            nameTextField.text = company?.name
            
            if let imageData = company?.image{
                companyImageView.image = UIImage(data: imageData)
                setupCircularImageStyle()
            }
            
            guard let founded = company?.founded else { return }
            
            datePicker.date = founded
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
    
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.translatesAutoresizingMaskIntoConstraints = false
        return dp
    }()

    
    lazy var companyImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true // remember to do this, otherwise image views by default are not interactive
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
        
        return imageView
    }()
    
    @objc private func handleSelectPhoto() {
        print("Trying to select photo...")
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
  
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            companyImageView.image = editedImage
        }
        else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            companyImageView.image = originalImage

        }
        setupCircularImageStyle()
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func setupCircularImageStyle(){
        companyImageView.layer.cornerRadius = companyImageView.frame.width / 2
        companyImageView.clipsToBounds = true
        companyImageView.layer.borderColor = UIColor.darkBlue.cgColor
        companyImageView.layer.borderWidth = 2
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationItem.title = company == nil ? "Create Company" : "Edit Company"
    }
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
        lightBlueBackgroundView.heightAnchor.constraint(equalToConstant: 350).isActive = true
        
        view.addSubview(companyImageView)
        companyImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        companyImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        companyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        companyImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: companyImageView.bottomAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        //        nameLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        
        // setup the date picker here
        
        view.addSubview(datePicker)
        datePicker.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        datePicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        datePicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: lightBlueBackgroundView.bottomAnchor).isActive = true
        
      
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
      
        //        }
        
        // temporary area
        // context associated with main queue
        let context =  CoreDataManager.shared.container.viewContext
        
        //craete new object for company entity  in coredata
        //entityname and attribute key already set in data model
        
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        company.setValue(nameTextField.text, forKey: "name")
        company.setValue(datePicker.date, forKey: "founded")
        if let companyImage = companyImageView.image {
            let imageData = companyImage.jpegData(compressionQuality: 0.4)
            company.setValue(imageData, forKey: "image")
        }
        
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
        company?.founded = datePicker.date
        
        if let companyImage = companyImageView.image {
            let imageData = companyImage.jpegData(compressionQuality: 0.8)
            company?.image = imageData
        }
        
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
