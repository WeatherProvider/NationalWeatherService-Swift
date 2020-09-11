# National Weather Service
![Swift](https://github.com/ualch9/NationalWeatherService-Swift/workflows/Swift/badge.svg)

A Swift wrapper for the National Weather Service's weather.gov free-to-use public API.

## Platforms
- Apple platforms
- Ubuntu

## Installation
Swift Package Manager: 
```
https://github.com/WeatherProvider/NationalWeatherService-Swift.git
```

## Usage
```swift
import NationalWeatherService
import CoreLocation

let nws = NationalWeatherService(userAgent: "(MyWeatherApp, mycontact@example.com)")
let location = CLLocation(latitude: 47.6174, longitude: -122.2017)

// Gets the forecast, organized into time periods (such as Afternoon, Evening, etc).
nws.forecast(for: location) { result in
  switch result {
    case .success(let forecast):  print(forecast)
    case .failure(let error):     print(error)
  }
}

// Gets the forecast, organized into hours.
nws.hourlyForecast(for: location) { result in
  switch result {
    case .success(let forecast):  print(forecast)
    case .failure(let error):     print(error)
  }
}

// Gets the current condition.
nws.currentCondition(for: location) { result in
  switch result {
    case .success(let period):    print(period)
    case .failure(let error):     print(error)
  }
}
```

TODO: this

### Unit Tests
To do unit tests, you must specify an Environment Variable named `NWS_AGENT_CONTACT` with
the value of your email or some other contact information.

## License
The weather data provided by this library is sourced from weather.gov, which is a work of the 
United States federal government and thus in the public domain.

For more details on the API, see https://www.weather.gov/documentation/services-web-api

This Swift library is licensed under the MIT license.

```
Copyright © 2020 Alan Chu

Permission is hereby granted, free of charge, to any person obtaining a copy of 
this software and associated documentation files (the "Software"), to deal in 
the Software without restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the 
Software, and to permit persons to whom the Software is furnished to do so, 
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all 
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS 
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR 
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER 
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION 
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
