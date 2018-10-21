//
//  ProfileViewController.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 28/09/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet var editButton: UIButton!
    @IBOutlet var saveStackView: UIStackView!
    @IBOutlet weak var newImageButton: UIButton!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var nameProfileLabel: UILabel!
    @IBOutlet var descriptonProfileLabel: UILabel!
    @IBOutlet var actitvityIndicator: UIActivityIndicatorView!
    
    private var isEditMode: Bool = false

    @IBOutlet var gcdButton: UIButton!
    @IBOutlet var operationButton: UIButton!
    @IBAction func textFieldAction(_ sender: UITextField) {
        gcdButton.isEnabled = true
        operationButton.isEnabled = true
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        actitvityIndicator.isHidden = false
        actitvityIndicator.startAnimating()
        profile.name = nameTextField.text
        profile.description = descriptionTextField.text
        profile.image = userImage.image
        
        let titleOfButton = sender.titleLabel?.text
        
        if titleOfButton == "GCD" {
            dataSavePicker = GCDDataManager()
        } else {
            dataSavePicker = OperationDataManager()
        }
        
        self.dataSavePicker.saveUserProfile(userProfile: profile) { (success) in
            self.actitvityIndicator.stopAnimating()
            self.actitvityIndicator.isHidden = true
            
            if success {
                self.successAlert()
                self.loadDataFromUserDefaults()
            } else {
                self.errorAlert(function: {self.saveButtonPressed(sender)})
            }
        }
        
        viewEditor(isEditMode)
    }
    
    
    var dataSavePicker: SaveProfileProtocol = GCDDataManager()
    var profile: UserProfile = UserProfile(name: "Name", description: "Description", image: UIImage(named: "placeholder-user"))
    
    
    @IBAction func editPressed(_ sender: Any) {
        viewEditor(isEditMode)
        gcdButton.isEnabled = false
        operationButton.isEnabled = false
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    let imagePicker = UIImagePickerController()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func selectNewImage(_ sender: Any) {
        print("Выбери изображение профиля")
        setAlertControllerForSelectNewImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // testFrameEditButton()
        imagePicker.delegate = self
        loadDataFromUserDefaults()
        viewEditor(isEditMode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.sizeAndLayoutSettings()
    }
    
    func sizeAndLayoutSettings() {
        userImage.layer.cornerRadius = 30
        userImage.clipsToBounds = true
        
        newImageButton.layer.cornerRadius = 30
        newImageButton.clipsToBounds = true
        
        editButton.layer.cornerRadius = 20
        editButton.layer.borderWidth = 1.0
        editButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        editButton.clipsToBounds = true
        
        actitvityIndicator.isHidden = true
        
    }
    
    private func viewEditor(_ state: Bool) {
        nameProfileLabel.isHidden = state
        descriptonProfileLabel.isHidden = state
        saveStackView.isHidden = !state
        nameTextField.isHidden = !state
        descriptionTextField.isHidden = !state
        newImageButton.isHidden = !state
        editButton.isHidden = state
        isEditMode = !isEditMode
    }
    
    private func  setAlertControllerForSelectNewImage() {
        let alertController = UIAlertController(title: NSLocalizedString("Истоник фотографий", comment: "Истоник фотографий"), message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: NSLocalizedString("Камера", comment: "Камера") , style: .default, handler: { (action) in
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .camera
            
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        let photoLibAction = UIAlertAction(title: NSLocalizedString("Фото", comment: "Фото"), style: .default, handler: { (action) in
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .photoLibrary
            
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Отмена", comment: "Отмена"), style: .cancel, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func successAlert() {
        let alertController = UIAlertController(title: "Changes saved!", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func errorAlert(function: @escaping () -> ()) {
        let alertController = UIAlertController(title: "Error", message: nil, preferredStyle: .alert)
        let repeatAction = UIAlertAction(title: "Save again", style: .default, handler: {
            (alert: UIAlertAction!) in function()
        })
        
        alertController.addAction(repeatAction)
        alertController.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Delegates For Image Picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let chosenImage = info[.originalImage] as? UIImage {
        userImage.contentMode = .scaleToFill
        userImage.image = chosenImage
        }
        dismiss(animated:true, completion: nil)
    }
    
    //MARK: - Save and Load Profile
    
    func loadDataFromUserDefaults() {
        self.dataSavePicker.loadUserProfile { (profile) in
            self.nameProfileLabel.text = profile?.name
            self.descriptonProfileLabel.text = profile?.description
            self.nameTextField.text = profile?.name
            self.descriptionTextField.text = profile?.description
            self.userImage.image = profile?.image
        }
    }
    
}
