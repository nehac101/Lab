import SwiftUI

struct ContentView: View {
  let viewController: ViewController = ViewController()
  @State private var showingAlert = false
  
  var body: some View {
    NavigationView {
       VStack {
         Spacer()
         Button(action: {
           self.viewController.carLocation.getCurrentLocation()
           self.showingAlert = true
         }) {
           Text("here's my car")
         }
         Spacer()
         NavigationLink(destination: MapView(viewController: viewController).navigationBarTitle("map view")) {
           Text("where's my car?")
         }
         Spacer()
       }
       .alert(isPresented: $showingAlert) {
         Alert(title: Text(viewController.generateTitle()), message: Text(viewController.generateMessage()))
       }
  }
}
  
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
