//
//  HomeViewController.swift
//  Mobile-App-Test
//
//  Created by Ashen Ishanka on 2024-06-26.
//

import UIKit
import FirebaseAuth
class HotelHomeViewController: UIViewController {
    //when hotel item is selected from the list, we have to keep track of what item user has clicked, for that below variable is declared
    var selectedHotel: HotelItem?
    
    //creating the Hotel service class instance
    private var mHotelService: HotelService = HotelService(mNetworkManager: NetworkManager(apiHandler: APIHandler(), responseHandler: ResponseHandler()))
    
    override func viewWillAppear(_ animated: Bool) {
        //navigation bar will be hidden in the current view
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        //navigation bar will be visible in other views
        self.navigationController?.navigationBar.isHidden = false
    }
    // MARK: - Created sample hotel item to keep remember the structure of the api
    var hotel: [HotelsData] = [
        HotelsData(data: [HotelItem(id: 1, title: "Hello World", description: "Sample Description", address: "16/3, Kendagahawatta,\n Sri Hemananda Mawatha, Galle", postcode: "80000", phoneNumber: "+94710872212", latitude: "63.860500", longitude: "95.043317", image: HotelImage(small: "http://lorempixel.com/200/200/cats/4/", medium: "http://lorempixel.com/400/400/cats/4/", large: "http://lorempixel.com/800/800/cats/4/"))])
    ]
    //the array of hotel items that keep all hotel details fetched from the api
    var hotels: [HotelItem] = []
    
    @IBOutlet weak var tableViewHotels: UITableView!
    @IBOutlet weak var emailLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadEmail()
        setupTableView()
       
    }
    
    func setupTableView(){
       
        tableViewHotels.delegate = self
        
        //going to call to getAllHotels method in the hotel service. it will handle network manager class to fetch data
        mHotelService.getAllHotels{ [weak self] result in
            print("hotel service get all hotels method get executed")
            guard let strongSelf = self else { return }
            switch result {
            case .success(let hotels):
                //data recieved. now we are going to load the data in the table
                strongSelf.hotels = hotels
                DispatchQueue.main.async {
                    strongSelf.tableViewHotels.dataSource = strongSelf
                    strongSelf.tableViewHotels.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellReusableIdentifier)
                    strongSelf.tableViewHotels.reloadData()
                }
            case .failure(let error):
                print("Error occurred: \(error.localizedDescription)")
            }
        }
//        NetworkManager().getConnect {[weak self] result in
//            guard let strongSelf = self else{
//                return
//            }
//            switch result{
//            case .success(let hotelData):
//                
//                strongSelf.hotels = hotelData.data
//                
//                DispatchQueue.main.async{
//                    strongSelf.tableViewHotels.dataSource = self
//                    
//                    strongSelf.tableViewHotels.register(UINib(nibName: K.cellNibName, bundle: nil),forCellReuseIdentifier: K.cellReusableIdentifier)
//                    strongSelf.tableViewHotels.reloadData()
//                }
//            case .failure(_):
//                print("error occurred")
//            }
//        }
        
        
    }
    func loadEmail(){
        //going to load current user email from the firebase
        if let mAuth = Auth.auth().currentUser{
            let email = mAuth.email
            emailLabel.text = email ?? ""
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func btnLogoutClicked(_ sender: UIButton) {
        let alertConfirm = UIAlertController(title: "Confirm", message: "Do you really want to logout?", preferredStyle: .actionSheet)
        alertConfirm.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {[weak self]_ in
            do {
                try Auth.auth().signOut()
                guard let strongSelf = self else{return}
                strongSelf.openMainViewController()
            }catch{
                print("error")
            }
        }))
        alertConfirm.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertConfirm, animated: true)
    }
    func openMainViewController(){
        // Instantiate the main storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Instantiate the navigation controller
        guard let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController else {
            print("Failed to instantiate initial navigation controller")
            return
        }
        
        // Optionally, set the root view controller of the navigation controller if needed
        if let mainViewController = navigationController.viewControllers.first as? ViewController {
            // Perform additional setup if necessary
            print("Successfully instantiated ViewController")
        } else {
            print("Failed to find ViewController in navigation stack")
        }
        
        // Get the window scene and replace the current root view controller
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        } else {
            print("Failed to get the window scene or window.")
        }
    }
}
extension HotelHomeViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotels.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected row")
        tableView.deselectRow(at: indexPath, animated: true)
        selectedHotel = hotels[indexPath.row]
        self.performSegue(withIdentifier: "showHotelItem", sender: self)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellReusableIdentifier, for: indexPath) as! HotelTableViewCell
        
        cell.hotelTitleOutlet.text = hotels[indexPath.row].title
        cell.hotelAddressTextOutlet.text = hotels[indexPath.row].address
        
        
        cell.hotelImageOutet.image = UIImage(named: "cat")
        //        cell.hotelTitleOutlet.text = hotel[indexPath.row].data[0].title
        //        cell.hotelAddressTextOutlet.text = hotel[indexPath.row].data[0].address
        //        cell.hotelImageOutet.image = UIImage(named: "cat")
        
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showHotelItem"{
            if let hotelItemVC = segue.destination as? HotelItemViewController{
                hotelItemVC.hotelItem = selectedHotel
                
            }
        }
    }
    
}

