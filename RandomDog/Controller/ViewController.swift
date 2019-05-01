//
//  ViewController.swift
//  RandomDog
//
//  Created by 中尾 佳代 on 2019/03/20.
//  Copyright © 2019 Kayo Nakao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var breeds: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
       
        DogAPI.requestAllBreed(completion: handleBreedListResponse(breeds:error:))
    }

    func handleBreedListResponse(breeds:[String], error:Error?){
        self.breeds = breeds
        DispatchQueue.main.async {
            self.pickerView.reloadAllComponents()
        }
    }
    
    func handleRandomImageResponse(imageData:DogImage?, error: Error?){
        guard let imageUrl = URL(string: imageData?.message ?? "") else {return}
        
        DogAPI.requestDogImage(url: imageUrl, completion: { (image, error) in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        })
    }

    
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breeds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return breeds[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        DogAPI.requestRandomImageData(breed: breeds[row], completion: handleRandomImageResponse(imageData:error:))
        
    }
}

