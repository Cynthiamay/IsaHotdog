//
//  ViewController.swift
//  SeeFood
//
//  Created by Treinamento on 9/16/19.
//  Copyright © 2019 cynthiamayumiwatanabeyamaoto. All rights reserved.
//

import UIKit
import CoreML
import Vision
import Social

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    var classificationResults : [VNClassificationObservation] = []
    
    let imagePicker = UIImagePickerController()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        //imagePicker.sourceType = .camera
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
    }
    
    // Use the image that the user picked in the image picker controller
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
             imageView.image = userPickedImage
            
            // convert the image into a CI image
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert UIImage into CIImage")
            }
            //passing the CI image into our detect image
            detect(image: ciimage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)

    }
    //once that image goes in to this detect image method. We do a couple of things here:
    func detect(image: CIImage){
        
        //first we load up our model using the imported inceptionv3 model...
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML Model Failed")
        }
        // and then we create a request that asked the model to classify whatever data that we passed.
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image.")
            }
            //print out the results that we got
            //print(results)
            
            //saiynig if it is a hotdog, or not
            if let firstResult = results.first{
                if firstResult.identifier.contains("hotdog"){
                    self.navigationItem.title = "Hotdog !"
                }else{
                    self.navigationItem.title = "Not Hotdog !"
                }
                
                
            }
            
            
            
        }
        
        // The data that we passed, it is defined over here using the handler.
        let handler = VNImageRequestHandler(ciImage: image)
        
        //We use that image handler to perform the request of classifying the image
        
        //Once the process completes the this callback gets triggered an we get back a request or an error
        do {
            try handler.perform([request])
        }catch{
            print(error)
        }
        
        //forcing to execute this line
        //try! handler.perform([request])
    }
    
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
}

