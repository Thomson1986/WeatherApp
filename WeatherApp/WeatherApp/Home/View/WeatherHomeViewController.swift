//
//  ViewController.swift
//  WeatherApp
//
//  Created by Thomson Varghese on 6/13/23.
//

import UIKit

//Weather Home Page to display weather details for user entered city
//TODO - Can do click each tile to more details and forecast details - further scope....
final class WeatherHomeViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var feelLikeValueLabel: UILabel!
    @IBOutlet weak var windValueLabel: UILabel!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var weatherHomeViewModel: WeatherHomeViewModel?
    private var weatherRespository: WeatherRespository?
    private var locationRepository: LocationRepository?

    override func viewDidLoad() {
        super.viewDidLoad()

        containerView.isHidden = true
        errorLabel.isHidden = true
        
        initialViewSetup()
        setupViewModel()
    }

    // MARK: View Set Up Methods
    private func initialViewSetup() {
        
        containerView.layer.cornerRadius = 15.0
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowRadius = 4.0
        
        weatherImageView.image = UIImage(named: "Placeholder")
    }
    
    // MARK: ViewModel Setup
    private func setupViewModel() {
        
        weatherRespository = WeatherServiceManager()
        locationRepository = LocationServiceManager()
        guard let weatherRespository = weatherRespository,
              let locationRepository = locationRepository else { return }
        weatherHomeViewModel = WeatherHomeViewModel(weatherRespository, locationRepository)
        weatherHomeViewModel?.showResult = { [weak self] (response)in
            DispatchQueue.main.async {
                self?.loadWeatherData(response)
            }
        }
        weatherHomeViewModel?.updateProgress = { [weak self] (status) in
            
            DispatchQueue.main.async {
                self?.updateProgress(status)
            }
        }
        
        weatherHomeViewModel?.showError = { [weak self] in
            DispatchQueue.main.async {
                self?.showError()
            }
        }
        weatherHomeViewModel?.viewDidLoad()
    }
    
    // MARK: Data Update Methods
    //Show error label
    private func showError() {
        
        containerView.isHidden = true
        errorLabel.isHidden = false
        view.bringSubviewToFront(errorLabel)
    }
    
    //Show activity indicator
    private func updateProgress(_ progress: Bool) {
        
        activityIndicator.isHidden = !progress
        view.isUserInteractionEnabled = !progress
        if progress {
            view.bringSubviewToFront(activityIndicator)
            activityIndicator.startAnimating()
        }
        else {
            activityIndicator.stopAnimating()
        }
    }
    
    //Show weather data
    private func loadWeatherData(_ data: WeatherResponse) {
        
        containerView.isHidden = false
        errorLabel.isHidden = true
        
        cityNameLabel.text = data.name
        temperatureLabel.text = data.main?.temperature?.toString()
        descriptionLabel.text = data.weather?.first?.description ?? ""
        feelLikeValueLabel.text = data.main?.feelsLike?.toString()
        windValueLabel.text = data.wind?.speed?.toString()
        if let icon = data.weather?.first?.icon,
           let url = URL(string: WeatherConstants.imageBaseURL + icon + "@2x.png") {
            
            weatherImageView.load(url: url, placeholder: UIImage(named: "Placeholder"))
        }
        
    }
}

// MARK: TextField Delegate Methods
extension WeatherHomeViewController : UITextFieldDelegate {
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        weatherHomeViewModel?.getWeatherDetails(for: textField.text ?? "")
        textField.text = ""
        return false
    }
}
