import UIKit
import RxSwift
import RxCocoa
import CoreLocation
import MapKit

class ViewController: UIViewController {
  @IBOutlet private var searchCityName: UITextField!
  @IBOutlet private var tempLabel: UILabel!
  @IBOutlet private var humidityLabel: UILabel!
  @IBOutlet private var iconLabel: UILabel!
  @IBOutlet private var cityNameLabel: UILabel!
  @IBOutlet private var tempSwitch: UISwitch!
  @IBOutlet private var activityIndicator: UIActivityIndicatorView!
  @IBOutlet private var geoLocationButton: UIButton!
  @IBOutlet private var mapButton: UIButton!
  @IBOutlet private var mapView: MKMapView!
  @IBOutlet weak var keyButton: UIButton!
  var keyTextField: UITextField?

  typealias Weather = ApiController.Weather

  private let bag = DisposeBag()
  private let locationManager = CLLocationManager()
  private var cache = [String: Weather]()

  override func viewDidLoad() {
    super.viewDidLoad()
    let maxAttempts = 4
//    style()
//
//    keyButton.rx.tap
//      .subscribe(onNext: { [weak self] _ in
//        self?.requestKey()
//      })
//      .disposed(by:bag)
//
//    mapView.rx
//     .setDelegate(self)
//     .disposed(by: bag)
//
//    mapButton.rx.tap
//      .subscribe(onNext: {
//        self.mapView.isHidden.toggle()
//      })
//      .disposed(by: bag)
//
//    let mapInput = mapView.rx.regionDidChangeAnimated
//      .skip(1)
//      .map { _ in
//        CLLocation(latitude: self.mapView.centerCoordinate.latitude,
//                   longitude: self.mapView.centerCoordinate.longitude)
//      }
//
//    let geoInput = geoLocationButton.rx.tap
//      .flatMapLatest { _ in
//        self.locationManager.rx.getCurrentLocation()
//      }
//
//    let geoSearch = Observable.merge(geoInput, mapInput)
//      .flatMapLatest { location in
//        ApiController.shared
//          .currentWeather(at: location.coordinate)
//          .catchErrorJustReturn(.empty)
//    }
//
//    let retryHandler: (Observable<Error>) -> Observable<Int> = { e in
//      return e.enumerated().flatMap { attempt, error -> Observable<Int> in
//        if attempt >= maxAttempts - 1 {
//          return Observable.error(error)
//        } else if let casted = error as? ApiError, casted == .invalidKey {
//          return ApiController.shared.apiKey
//            .filter { !$0.isEmpty }
//            .map { _ in 1 }
//        }
//        print("== retrying after \(attempt + 1) seconds ==")
//        return Observable<Int>.timer(.seconds(attempt + 1),
//                                     scheduler: MainScheduler.instance)
//                              .take(1)
//      }
//    }
//
//    let searchInput = searchCityName.rx
//      .controlEvent(.editingDidEndOnExit)
//      .map { self.searchCityName.text ?? "" }
//      .filter { !$0.isEmpty }
//      .retryWhen(retryHandler)
//
//    let textSearch = searchInput.flatMap { text in
//      return ApiController.shared
//        .currentWeather(for: text)
//        .do(onNext: { [weak self] data in
//          self?.cache[text] = data
//        }, onError: { error in
//          DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//            self.showError(error: error)
//          }
//        })
//        .catchError { error in
//          return Observable.just(self.cache[text] ?? .empty)
//        }
//    }
//
//    let search = Observable
//      .merge(geoSearch, textSearch)
//      .asDriver(onErrorJustReturn: .empty)
//
//    search
//      .map { $0.overlay() }
//      .drive(mapView.rx.overlay)
//      .disposed(by: bag)
//
//    let running = Observable
//      .merge(
//        searchInput.map { _ in true },
//        geoInput.map { _ in true },
//        mapInput.map { _ in true },
//        search.map { _ in false }.asObservable())
//      .startWith(true)
//      .asDriver(onErrorJustReturn: false)
//
//    running
//      .skip(1)
//      .drive(activityIndicator.rx.isAnimating)
//      .disposed(by: bag)
//
//    running
//      .drive(tempLabel.rx.isHidden)
//      .disposed(by: bag)
//    running
//      .drive(iconLabel.rx.isHidden)
//      .disposed(by: bag)
//    running
//      .drive(humidityLabel.rx.isHidden)
//      .disposed(by: bag)
//    running
//      .drive(cityNameLabel.rx.isHidden)
//      .disposed(by: bag)
//
//    search
//      .map { w in
//        if self.tempSwitch.isOn {
//          return "\(Int(Double(w.temperature) * 1.8 + 32))° F"
//        } else {
//          return "\(w.temperature)° C"
//        }
//      }
//      .drive(tempLabel.rx.text)
//      .disposed(by: bag)
//
//    search.map(\.icon)
//      .drive(iconLabel.rx.text)
//      .disposed(by: bag)
//
//    search.map { "\($0.humidity)%" }
//      .drive(humidityLabel.rx.text)
//      .disposed(by: bag)
//
//    search.map(\.cityName)
//      .drive(cityNameLabel.rx.text)
//      .disposed(by: bag)
    
    geoLocationButton.rx.tap
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }

        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
      })
      .disposed(by: bag)
    
    locationManager.rx.didUpdateLocations
      .subscribe(onNext: { locations in
        print(locations)
      })
      .disposed(by: bag)

    let currentLocation = locationManager.rx.didUpdateLocations
      .map { locations in locations[0] }
      .filter { location in
        return location.horizontalAccuracy < kCLLocationAccuracyHundredMeters
      }
    let geoInput = geoLocationButton.rx.tap.asObservable()
      .do(onNext: {
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
      })

    let geoLocation = geoInput.flatMap {
      return currentLocation.take(1)
    }
    let geoSearch = geoLocation.flatMap { location in
      return ApiController.shared.currentWeather(at: location.coordinate)
        .catchErrorJustReturn(.empty)
    }
    
    let searchInput = searchCityName.rx.controlEvent(.editingDidEndOnExit)
        .map {
            self.searchCityName.text ?? ""
        }
        .filter { !$0.isEmpty }
        
    let textSearch = searchInput
        .flatMap {
            ApiController.shared.currentWeather(for: $0)
                .catchErrorJustReturn(.empty)
        }
    
    let search = Observable.merge(geoSearch,textSearch)
        .asDriver(onErrorJustReturn: .empty)
        
    let running = Observable.merge(
        searchInput.map { _ in true},
        geoInput.map { _ in true },
        search.map { _ in false }.asObservable()
    )
    .startWith(true)
    .asDriver(onErrorJustReturn: false)
    
    
    search.map { "\($0.temperature)° C" }
      .drive(tempLabel.rx.text)
      .disposed(by: bag)

    search.map { $0.icon }
      .drive(iconLabel.rx.text)
      .disposed(by: bag)

    search.map { "\($0.humidity)%" }
      .drive(humidityLabel.rx.text)
      .disposed(by: bag)

    search.map { $0.cityName }
      .drive(cityNameLabel.rx.text)
      .disposed(by: bag)

    running
        .skip(1)
        .drive(activityIndicator.rx.isAnimating)
        .disposed(by: bag)
    running
      .drive(tempLabel.rx.isHidden)
      .disposed(by: bag)

    running
      .drive(iconLabel.rx.isHidden)
      .disposed(by: bag)

    running
      .drive(humidityLabel.rx.isHidden)
      .disposed(by: bag)

    running
      .drive(cityNameLabel.rx.isHidden)
      .disposed(by: bag)
    
    

  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    Appearance.applyBottomLine(to: searchCityName)
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func requestKey() {
    func configurationTextField(textField: UITextField!) {
      self.keyTextField = textField
    }

    let alert = UIAlertController(title: "Api Key",
                                  message: "Add the api key:",
                                  preferredStyle: UIAlertController.Style.alert)

    alert.addTextField(configurationHandler: configurationTextField)

    alert.addAction(UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
      ApiController.shared.apiKey.onNext(self?.keyTextField?.text ?? "")
    })

    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive))

    self.present(alert, animated: true)
  }

  private func showError(error e: Error) {
    guard let e = e as? ApiError else {
      InfoView.showIn(viewController: self, message: "An Error has ocurred")
      return
    }
    switch e {
    case .cityNotFound:
      InfoView.showIn(viewController: self, message: "City name was not found")
    case .serverFailure:
      InfoView.showIn(viewController: self, message: "Server error")
    case .invalidKey:
      InfoView.showIn(viewController: self, message: "Key is invalid")
    }
  }

  // MARK: - Style

  private func style() {
    view.backgroundColor = UIColor.aztec
    searchCityName.attributedPlaceholder = NSAttributedString(string: "City's Name",
                                                              attributes: [.foregroundColor: UIColor.textGrey])
    searchCityName.textColor = UIColor.ufoGreen
    tempLabel.textColor = UIColor.cream
    humidityLabel.textColor = UIColor.cream
    iconLabel.textColor = UIColor.cream
    cityNameLabel.textColor = UIColor.cream
  }
}

extension ViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    guard let overlay = overlay as? ApiController.Weather.Overlay else {
      return MKOverlayRenderer()
    }
    return ApiController.Weather.OverlayView(overlay: overlay, overlayIcon: overlay.icon)
  }
}
