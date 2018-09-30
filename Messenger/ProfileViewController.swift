//
//  ProfileViewController.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 28/09/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var newImageButton: UIButton!
    
    let imagePicker = UIImagePickerController()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       // print(editButton.frame) //выдает ошибку так как обект класса еще не создался и метод sizeAndLayoutSettings еще не вызван.
    }
    
    @IBAction func selectNewImage(_ sender: Any) {
        print("Выбери изображение профиля")
        setAlertControllerForSelectNewImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testFrameEditButton()
        sizeAndLayoutSettings()
        imagePicker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        testFrameEditButton() //frame отличается так как к ProfileViewController добавилась кнопка "Редактировать" вызвалась функция sizeAndLayoutSettings() и задействовались констрейнты
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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
    }

    private func testFrameEditButton(caller: String = #function) {
        print("Caller func \(caller), frame edit button = \(editButton.frame)")
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
    
    //MARK: - Delegates For Image Picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let chosenImage = info[.originalImage] as? UIImage {
        userImage.contentMode = .scaleToFill
        userImage.image = chosenImage
        }
        dismiss(animated:true, completion: nil)
    }
    
}
