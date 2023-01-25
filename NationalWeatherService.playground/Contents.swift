//: A MapKit based Playground

import MapKit
import NationalWeatherService
import CoreLocation
import PlaygroundSupport


let nws = NationalWeatherService(userAgent: "(github.com/WeatherProvider, NationalWeatherService-Swift)")
let location = CLLocationCoordinate2DMake(47.6174, -122.2017)  // Bellvue, Washington

// Create a map annotation
let annotation = MKPointAnnotation()

annotation.coordinate = location
annotation.title = "title"
annotation.subtitle = "subtitle"

// Gets the forecast, organized into time periods (such as Afternoon, Evening, etc).
NationalWeatherService.units = .fahrenheit
nws.forecast(for: location) { result in
  switch result {
    case .success(let forecast):
      print(forecast)
      
      let period = forecast.periods.first!
      print(period)
      
      print(period.shortForecast)
      annotation.title = period.shortForecast

      print(period.detailedForecast)
      annotation.subtitle = period.detailedForecast

    case .failure(let error):
      print(error)
  }
}

// Now let's create a MKMapView
let mapView = MKMapView(frame: CGRect(x:0, y:0, width:640, height:480))

// Define a region for our map view
var mapRegion = MKCoordinateRegion()

let mapRegionSpan = 0.2
mapRegion.center = location
mapRegion.span.latitudeDelta = mapRegionSpan
mapRegion.span.longitudeDelta = mapRegionSpan

mapView.setRegion(mapRegion, animated: true)

mapView.addAnnotation(annotation)

// Add the created mapView to our Playground Live View
PlaygroundPage.current.liveView = mapView
