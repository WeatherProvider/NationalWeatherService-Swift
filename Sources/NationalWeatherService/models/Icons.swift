//
//  Icons.swift
//  NationalWeatherService
//
//  Created by Alan Chu on 4/2/20.
//

public enum Icon: String, CustomStringConvertible {
    case skc
    case few
    case sct
    case bkn
    case ovc
    case wind_skc
    case wind_few
    case wind_sct
    case wind_bkn
    case wind_ovc
    case snow
    case rain_snow
    case rain_sleet
    case snow_sleet
    case fzra
    case rain_fzra
    case snow_fzra
    case sleet
    case rain
    case rain_showers
    case rain_showers_hi
    case tsra
    case tsra_sct
    case tsra_hi
    case tornado
    case hurricane
    case tropical_storm
    case dust
    case smoke
    case haze
    case hot
    case cold
    case blizzard
    case fog
    case other

    public var description: String {
        switch self {
        case .skc:              return "Fair/clear"
        case .few:              return "A few clouds"
        case .sct:              return "Partly cloudy"
        case .bkn:              return "Mostly cloudy"
        case .ovc:              return "Overcast"
        case .wind_skc:         return "Fair/clear and windy"
        case .wind_few:         return "A few clouds and windy"
        case .wind_sct:         return  "Partly cloudy and windy"
        case .wind_bkn:         return "Mostly cloudy and windy"
        case .wind_ovc:         return "Overcast and windy"
        case .snow:             return "Snow"
        case .rain_snow:        return "Rain/snow"
        case .rain_sleet:       return "Rain/sleet"
        case .snow_sleet:       return "Sleet/rain"
        case .fzra:             return "Freezing rain"
        case .rain_fzra:        return "Rain/freezing rain"
        case .snow_fzra:        return "Freezing rain/snow"
        case .sleet:            return "Sleet"
        case .rain:             return "Rain"
        case .rain_showers:     return "Rain showers (high cloud cover)"
        case .rain_showers_hi:  return "Rain showers (low cloud cover)"
        case .tsra:             return "Thunderstorm (high cloud cover)"
        case .tsra_sct:         return "Thunderstorm (medium cloud cover)"
        case .tsra_hi:          return "Thunderstorm (low cloud cover)"
        case .tornado:          return "Tornado"
        case .hurricane:        return "Hurricane conditions"
        case .tropical_storm:   return "Tropical storm conditions"
        case .dust:             return "Dust"
        case .smoke:            return "Smoke"
        case .haze:             return "Haze"
        case .hot:              return "Hot"
        case .cold:             return "Cold"
        case .blizzard:         return "Blizzard"
        case .fog:              return "Fog/mist"
        case .other:            return "Other"
        }
    }
}
