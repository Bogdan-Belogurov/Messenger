//
//  ProfileViewController.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 28/09/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import UIKit
import CoreData

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
    var dataSavePicker: SaveProfileProtocol = GCDDataManager()
    var profile: UserProfile = UserProfile(name: "Name", description: "Description", image: UIImage(named: "placeholder-user")) 

    @IBOutlet var gcdButton: UIButton!
    @IBOutlet var operationButton: UIButton!
    @IBAction func textFieldAction(_ sender: UITextField) {
        gcdButton.isEnabled = true
        operationButton.isEnabled = true
    }
    
    func printDataFromCore() {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserProfileCore")
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "userName") as! String)
                print(data)
            }
            
        } catch {
            
            print("Failed")
        }
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
            let dataFromCore = UserProfileCore(context: context)
            dataFromCore.userName = nameTextField.text
            dataFromCore.userDescription = descriptionTextField.text
            do {
                
                try context.save()
                print("Сохранение  удалось!")
            } catch let error as NSError {
                print("Не удалось сохранить данные \(error), \(error.userInfo)")
            }
            
            printDataFromCore()
        }
        
        
        
        
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
        observeKeyboardNotifications()
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
            
            if !(UIImagePickerController.isSourceTypeAvailable(.camera)) {
                let warningAlert = UIAlertController(title: "Ошибка!", message: "Невозможно использовать камеру", preferredStyle: .alert);
                let closeAction = UIAlertAction(title: "Ок", style: .cancel, handler: nil)
                
                warningAlert.addAction(closeAction)
                self.present(warningAlert, animated: true, completion: nil)
            } else {
                self.imagePicker.allowsEditing = true
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
            }
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
    
    fileprivate func observeKeyboardNotifications()
    {
        let notifier = NotificationCenter.default
        notifier.addObserver(self, selector: #selector(keyboardShow), name: UIWindow.keyboardWillShowNotification, object: nil)
        notifier.addObserver(self, selector: #selector(keyboardHide), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardShow() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.view.frame = CGRect (x: 0, y: -(self.userImage.frame.height-50), width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
        
    }
    
    
    @objc func keyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.view.frame = CGRect (x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
        
    }
    
}
