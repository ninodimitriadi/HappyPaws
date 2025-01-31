//
//  NetworkService.swift
//  HappyPaws
//
//  Created by nino on 1/22/25.
//

import Foundation
import CoreLocation

class NetworkService {
    private let apiKey = "AIzaSyBvmsKJffm7UV5iV9oqJ5BMZxAhb7Q-K1U"

    func fetchNearbySalons(location: String, radius: Int, completion: @escaping ([GroomingSalonModel]?) -> Void) {
        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(location)&radius=\(radius)&type=establishment&keyword=groomer&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let results = json["results"] as? [[String: Any]] {

                    var salons: [GroomingSalonModel] = []
                    for result in results {
                        guard let name = result["name"] as? String,
                              let placeID = result["place_id"] as? String,
                              let geometry = result["geometry"] as? [String: Any],
                              let location = geometry["location"] as? [String: Any],
                              let lat = location["lat"] as? Double,
                              let lng = location["lng"] as? Double else {
                            continue
                        }
                        
                        salons.append(GroomingSalonModel(placeID: placeID, name: name, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng), phoneNumber: result["phone_number"] as? String ?? "nill", rating: result["rating"] as? Double ?? 0))
                    }
                    completion(salons)
                } else {
                    print("No results found in API response")
                    completion(nil)
                }
            } catch {
                print("Error parsing data: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }



    func fetchSalonDetails(placeID: String, completion: @escaping (SalonDetailsModel?) -> Void) {
        let detailsURLString = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeID)&fields=name,formatted_address,formatted_phone_number,website,opening_hours&key=\(apiKey)"
        
        guard let url = URL(string: detailsURLString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let result = json["result"] as? [String: Any] {
                    let address = result["formatted_address"] as? String ?? ""
                    let phoneNumber = result["formatted_phone_number"] as? String ?? ""
                    let website = result["website"] as? String
                    let openingHours = result["opening_hours"] as? [String: Any]
                    let hours = openingHours?["weekday_text"] as? [String]

                    completion(SalonDetailsModel(
                        address: address,
                        phoneNumber: phoneNumber,
                        website: website,
                        openingHours: hours
                    ))

                } else {
                    completion(nil)
                }
            } catch {
                completion(nil)
            }
        }.resume()
    }
}
