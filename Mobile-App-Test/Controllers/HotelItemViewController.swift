//
//  HotelItemViewController.swift
//  Mobile-App-Test
//
//  Created by Ashen Ishanka on 2024-06-27.
//

import UIKit

// MARK: - This class will be responsible for show selected hotel item details, including title, descripition and option to see location in the mapp
class HotelItemViewController: UIViewController {

    @IBOutlet weak var barButtonNavigation: UIBarButtonItem!
    var hotelItem : HotelItem?
    override func viewDidLoad() {
        super.viewDidLoad()

        barButtonNavigation.image = UIImage(systemName: "location.fill")
        print("hotelItem \(hotelItem)")
        setHotelInformation()
        loadHotelImage()
    }
   
    
    @IBOutlet weak var hotelDescription: UITextView!
    @IBOutlet weak var hotelImage: UIImageView!
    
    @IBOutlet weak var hotelTitle: UILabel!
    func showAlertController(_ title: String, _ message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default,handler: nil))
        self.present(alert, animated: true)
    }
    func setHotelInformation(){
        if hotelItem?.title.isEmpty == true || hotelItem?.description.isEmpty == true{
            showAlertController("Error", "Unable to show Hotel details")
        }
        else{
            hotelTitle.text = hotelItem?.title
            hotelDescription.text = hotelItem?.description
        }
    }
    func loadHotelImage(){
        
        guard let url = URL(string: hotelItem?.image.large ?? "") else{
            self.hotelImage.image = UIImage(named: "cat_thumbnail")
            print("Wrong url")
            return
        }
           
            
        //going to get the image data from the url then we can show that in the imageview
        let loadImageTask = URLSession.shared.dataTask(with: url){[weak self] data, response, error in
            guard let strongSelf = self else{
                print("Error occurred")
                return
            }
            if let error = error{
                print("Error occurred")
            }
            guard let imageData = data, let mImage = UIImage(data: imageData)else{
                print("invalid image")
                //now we are going to set the hotel image to the image that we added to the assets
                DispatchQueue.main.async {
                    
                
                strongSelf.hotelImage.image = UIImage(named: "cat_thumbnail")
                }
                return
            }
            DispatchQueue.main.async {
                strongSelf.hotelImage.image = mImage
            }
            print("image changed")
        }.resume()
    }

    @IBAction func btnShowMapClicked(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showMap", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap"{
            if let mMapVC = segue.destination as? MapViewController{
                mMapVC.lat = hotelItem?.latitude
                mMapVC.lang = hotelItem?.longitude
                mMapVC.hotelTitle = hotelItem?.title
                mMapVC.hotelAddress = hotelItem?.address
            }
        }
    }
}
