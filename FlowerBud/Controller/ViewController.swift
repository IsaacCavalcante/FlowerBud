//
//  ViewController.swift
//  FlowerBud
//
//  Created by Isaac Cavalcante on 30/03/21.
//

import UIKit
import CoreML
import Vision
import SDWebImage

class ViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var flowerDescriptionLabel: UILabel!
    let imagePicker = UIImagePickerController()
    var flowerManager = FlowerManager()
    var imagePicked: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        flowerManager.delegate = self
        // Do any additional setup after loading the view.
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {

        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openPhotoSource(photoSource: UIImagePickerController.SourceType.camera)
        }))

        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openPhotoSource(photoSource: UIImagePickerController.SourceType.photoLibrary)
        }))

        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    func openPhotoSource(photoSource: UIImagePickerController.SourceType){
        imagePicker.sourceType = photoSource
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func detect(image: CIImage){
        
        guard let model = try? VNCoreMLModel(for: FlowerClassifier(configuration: .init()).model) else {
            fatalError("Load CoreML model failed")
        }
        
        let request = VNCoreMLRequest(model: model) { [self] (request2, error) in
            guard let results = request2.results as? [VNClassificationObservation] else {
                fatalError("Model fail to process image")
            }
            
            if let principalResult = results.first?.identifier {
                LanguageAssistentSingleton.shared.englishPortugueseTranslator!.translate(principalResult) { translatedText, error in
                    if error != nil {
                        navigationItem.title = principalResult.capitalized
                        flowerManager.getFlowerInformation(flowerName: principalResult)
                    } else if translatedText != nil {
                        navigationItem.title = translatedText?.capitalized
                        flowerManager.getFlowerInformation(flowerName: translatedText!, language: K.Languages.pt)
                    }
                }
                
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            
        }
    }
    
}

//MARK: - UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        
        if let imagePickedByUser = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            imagePicked = imagePickedByUser
            guard let ciimage = CIImage(image: imagePickedByUser) else {
                fatalError("Couldn't convert to CIImage")
            }
            detect(image: ciimage)
        }
    }
}

//MARK: - FlowerManagerDelegate

extension ViewController: FlowerManagerDelegate {
    func updateFlowerInformation(_ flowerManager: FlowerManager, flowerInformation: String, flowerImageUrl: String) {
        flowerDescriptionLabel.text = flowerInformation
        if (flowerImageUrl != ""){
            imageView.sd_setImage(with: URL(string: flowerImageUrl))
        } else {
            imageView.image = imagePicked
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}
