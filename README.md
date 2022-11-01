# FindMyCar

---

This week, we will make an app that allows users to track where their car is parked and where they are relative to the car. We will be using MapKit, SwiftUI, Location, and plists to save car data. Here is a sneak peak of the final app, but let's dive in!

<img src=https://i.imgur.com/ML2VVGv.png width="25%"/> <img src=https://i.imgur.com/t736gnC.png width="25%"/>

## Part 1: Model

1. Create a new `SingleViewApp` using `SwiftUI` for the user interface called `FindMyCar`.

2. The first thing you need to do when working with locations is getting permission from the user to use their location. To do this, go into the `Info.plist` file found in the file explorer and add a new property list item called `NSLocationWhenInUseUsageDescription` and add in the text "This app would like to use your location." (This can be done by clicking the `+` icon shown by hovering over "Information Property List"). This is the message that will be displayed when your app requests permission from the phone to use location services.

3. Create a model file called `Location.swift`. After `import Foundation` add in the directive `import CoreLocation`. Then add in the following code:

   ```swift
   class Location: NSObject {
     
     var latitude: CLLocationDegrees
     var longitude: CLLocationDegrees
     var locationManager = CLLocationManager()
     
     override init() {
       self.latitude = 0.00
       self.longitude = 0.00
       super.init()
     }
     
     func getCurrentLocation() {
       locationManager.requestWhenInUseAuthorization()
       if CLLocationManager.locationServicesEnabled() {
         locationManager.distanceFilter = kCLDistanceFilterNone
         locationManager.desiredAccuracy = kCLLocationAccuracyBest
         locationManager.startUpdatingLocation()
       }
       
       if let currLocation = locationManager.location {
         self.latitude = currLocation.coordinate.latitude
         self.longitude = currLocation.coordinate.longitude
       }
     }
   }
   ```

   Right now this class mostly tracks (and will later store) a location's latitude and longitude, but it also has the `getCurrentLocation()` method. One thing to note in `getCurrentLocation()` is that the first thing the app will do is verify that it has permission to use the phone's location services. The user will only have to give permission once (they can later change it in their phone's settings) but the app will always check to see that it has permission before calculating the current location. In some cases the initial granting of approval can take a second or two for the device to process, so the initial location will be at (0.00, 0.00) because the authorization hasn't been processed yet even though the user literally just gave permission.

## Part 2: Views

1. Go the `ContentView.swift` and add two button: `Here's My Car` and `Where's My Car?`. At this point, you app should look like the left screen at the beginning of the lab. (You may need to add `Spacer()`s to get the spacing right.)

2. Create a new `SwiftUI View` called `MapView.swift`.

3.  Add in the following functions:

   ```swift
   func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
     let coordinate = CLLocationCoordinate2D(latitude: 40.4454261, longitude: -79.9437277
     )
     let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
     let region = MKCoordinateRegion(center: coordinate, span: span)
     uiView.setRegion(region, animated: true)
   }
   
   func makeUIView(context: Context) -> MKMapView {
     let mapView = MKMapView(frame: .zero)
     return mapView
   }
   ```

   4. Now, replace the `Where's My Car?` button in the `ContentView` with a `NavigationLink` to the `MapView`.
   5. Test out the app! The `Here's My Car` button is not yet functional, but when you press on the other button, you should see your car near the Tepper Quad. Feel free to experiment with the `MKCoordinateSpan` to find a radius that you like best. Also note you can hold down the `option` key in the simulator and drag around to perform a pinch-to-zoom effect.

## Part 3: Controller / Adding In Current Location

1. Create a new controller file called `ViewController.swift`. In this controller, create two instances of `Location`--one for the user's current location and one for the location of the car.

2. Right now, let's just look at the user's current location. Create an instance of the`ViewController` in the `ContentView.swift` and a variable to reference it in the `MapViewController`. Change the constructor in the `MapView_Previews` accordingly like we did in the last lab. Update your `NavigationLink` as well.

3. Now in the `MapViewController`, let's make sure that the map is always centered around the user. To do so, add a line to get the user's current location at the top of the `updateUIView` method and change the hardcoded values for latitude and longitude to be the user's current latitude and longitude.

4. Let's also create a pin for our location. Luckily, doing this in iOS is super easy; just add the following code to the end within the `makeUIView` function:

   1. ```swift
      let droppedPin = MKPointAnnotation()
      droppedPin.coordinate = CLLocationCoordinate2D(
      	latitude: // fill in with your current location latitude ,
      	longitude: // fill in with your current location longitude
      )
      droppedPin.title = "You are Here"
      droppedPin.subtitle = "Look it's you!"
      ```

      Add `mapView.addAnnotation(droppedPin)` right before you `return mapView`.

      Also, make sure you keep the comma between latitude and longitude above :)

   2. Rerun the project to see the pin and the title beneath. Note the subtitle after you click on the pin. You should see something like the second screenshot at the top of the lab.

5. Test this out in the simulator!

Note: Your simulator doesn't have GPS in it, but you can give it coordinates that it might have gotten from a GPS unit. To do this, go to your simulator and choose `Debug > Location > Custom Location`.

## Part 4: Finding and Mapping Locations

1. Let's go back to the `ContentView.swift` and fill in the action for our `Here's My Car` Button. We are going to get the current location of the car like we did for the user but also display an alert that the car's location has been saved.

2. To do this, let's first generate the message the user is going to see. Add the following functions to your `ViewController.swift` so you can use them in the `ContentView`.

   ```swift
   func generateTitle() -> String {
     let message = "Your car is currently at:\n(\(self.carLocation.latitude), \(self.carLocation.longitude))"
     return message
   }
   
   func generateMessage() -> String {
     let message = "\nWhen you want to map to this location, simply press the \"Where is my car?\" button."
     return message
   }
   ```

3. Run your project and verify it is working as expected by tweaking the locations in the simulator to map to different locations.  FYI, the British Prime Minister's home is at (51.5034070, -0.1275920) and the White House is at (38.8976090, -77.0367350) if you want to try funky, non-Pittsburgh places to test. Here is an example of the alert:

   <img src="https://i.imgur.com/ZOjiNjn.png" width="25%" />

4. We want to test that the location we saved is reflected upon pressing the "Where's my car?" button. Make sure in the `MapView` that the pin we dropped earlier on our current location is eliminated and a new pin is now dropped on the current car's location. Feel free to also change the Title/Subtitle of the pin accordingly. In addition, change the map to center to on the car's location and not the initial location as we did earlier. 

4. We know where our car is and there is a pin dropped on the map to make it clear, but it'd be nice if we knew that location relative to our current position. This is easy, simply add the following line to your `updateUIView` method in your `MapView`:

   ```swift
     uiView.showsUserLocation = true
   ```

   In the simulator, assuming the car is still parked in Morewood (40.4454261, -79.9437277), change the location to Wean Hall (40.4426092, -79.9454014). When you press on the show me the car button, the red pin drops on the car and your location has a blue glowing button.  In a real mobile device with GPS, this blue dot will readjust as you move. 

   ## Part 5: Saving State

   Now we will take a look at implementing a way to save our car's state no matter what may happen to our device: the app dies or the phone shuts down to name a few. We will do this for now by using a plist file, which is essentially writing some information to a file. In future weeks we will talk about using CoreData, which is an iOS framework for accessing internal memory similar to a database.

   You can see the [Contacts example from lecture](https://github.com/profh/67442_ContactsLite) as a means of implementing plists in an app to save state.

   For now, let's step through the steps to implement saving and loading our coordinates in the `Location` object.

   ### Augmenting the Location Class

   1. Let's begin by adding this string extension to the top of the `Location.swift` file (outside of the `Location` class):

      ```swift
      extension String {
        // recreating a function that String class no longer supports in Swift 2.3
        // but still exists in the NSString class. (This trick is useful in other
        // contexts as well when moving between NS classes and Swift counterparts.)
        
        /**
         Returns a new string made by appending to the receiver a given string.  In this case, a new string made by appending 'aPath' to the receiver, preceded if necessary by a path separator.
         
         - parameter aPath: The path component to append to the receiver. (String)
         
         - returns: A new string made by appending 'aPath' to the receiver, preceded if necessary by a path separator. (String)
         
        */
        func stringByAppendingPathComponent(aPath: String) -> String {
          let nsSt = self as NSString
          return nsSt.appendingPathComponent(aPath)
        }
      }
      ```

      This extension allows us to append a filepath component to a given string, allowing us to create the filepath we will need to the plist file.

   2. Now, we must define the Swift functions *inside the `Location` class* to retrieve the appropriate directory for our plist file and the appropriate final filepath including our plist file in the device's memory:

      ```swift
      func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths[0]
      }
      
      func dataFilePath() -> String {
        return documentsDirectory().stringByAppendingPathComponent(aPath: "Coordinates.plist")
      }
      ```

      We should then print the dataFilePath out of the `init` function, so let's add that now as well.

   3. Now we are ready to write a function to save the location of the car which we will later call in several places around our app's files. This function will take our current latitude and longitude and save it to the plist. Add the `saveLocation` function in the `Location` class:

      ```swift
      func saveLocation() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(self.latitude, forKey: "latitude")
        archiver.encode(self.longitude, forKey: "longitude")
        archiver.finishEncoding()
        data.write(toFile: dataFilePath(), atomically: true)
      }
      ```

   4. Similarily, below the `saveLocation` function, add the `loadLocation` function which we will call to retrieve the latitude and logitude from the plist and save them to our location object:

      ```swift
      func loadLocation() {
        let path = dataFilePath()
        if FileManager.default.fileExists(atPath: path) {
          if let data = NSData(contentsOfFile: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data as Data)
            self.latitude = unarchiver.decodeDouble(forKey: "latitude")
            self.longitude = unarchiver.decodeDouble(forKey: "longitude") 
            unarchiver.finishDecoding()
          } else {
            print("\nFILE NOT FOUND AT: \(path)")
          }
        }
      }
      ```

   5. We should also write a function to clear out our latitude and longitude before saving. Add the `clearCarLocation` file to the `Location` class:

      ```swift
      func clearCarLocation () {
        self.latitude = 0.00
        self.longitude = 0.00
      }
      ```

   6. The last thing we need to do is update our `getCurrentLocation` function in the `Location` class to clear the car's location and save the updated location to the plist. Call `clearCarLocation` to the beginning of this function, and call `saveLocation` right at the end.

   ### Augmenting the MapView

   The only things that need to be done are to switch the call from `getCurrentLocation` to `loadLocation` so we load from the plist in `updateUIView` and to add `loadLocation` to the top of `makeUIView`.

   ### Augmenting the ContentView

   All that needs to be done here is to clear, get, and save the location of the car to our plist in the function attached to the button in the UI. Call the function to cleat the car location before getting and the function to save to the plist after getting the car's location.

   ### Augmenting the AppDelegate

   For `AppDelegate.swift` we must invoke our actions to save and load the location of the car on various triggers.

   The car's location should be (loaded first, and then) saved in:

   * `didDiscardSceneSessions`

   While the car's location should be just loaded in:

   * `didFinishLaunchingWithOptions`
   * `configurationForConnecting`

   Now the plist should be fully integrated into the app! Try adding location, killing the app, and checking to see it is there. If you are having issues with the plist, be sure it is being saved properly to the path printed when the `Location` object is initialized.