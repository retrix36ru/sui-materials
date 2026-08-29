/// Copyright (c) 2023 Kodeco Inc.
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI


struct WelcomeView: View {
  @State var flightInfo = FlightData()
  @State var showNextFlight = false
  @State var lastFlightInfo = FlightNavigationInfo()

  var body: some View {
    NavigationStack {
      ZStack(alignment: .topLeading) {
        Image("welcome-background")
          .resizable()
          .frame(height: 250)
        ScrollView{
          VStack{
            NavigationLink(value: Date()){
              WelcomeButtonView(
                title: "Flight Status",
                subTitle: "Departure and arrival information"
              )
            }.navigationDestination(for: Date.self){ date in
              FlightStatusBoard(
                flights: flightInfo.getDaysFlights(date))
            }
            NavigationLink{
              SearchFlights(flightData: flightInfo.flights)
            } label: {
              WelcomeButtonView(
                title: "Search Flights",
                subTitle: "Search Upcoming Flights")
            }
            if let id = lastFlightInfo.lastFlightId,
               let lastFlight = flightInfo.getFlightById(id) {
              
              NavigationLink(value: lastFlight) {
                WelcomeButtonView(
                  title: "Last Flight \(lastFlight.flightName)",
                  subTitle: "Show Next Flight Departing or Arriving at Airport"
                )
              }
            }
          }
          Spacer()
        }.font(.title)
        .foregroundColor(.white)
        .padding()
      } .navigationDestination(for: FlightInformation.self) { flight in
        FlightDetails(flight: flight)
    }
      .navigationTitle("Mountain Airport")
      // End Navigation View
    }.environment(lastFlightInfo)
  }
}
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    WelcomeView()
  }
}
