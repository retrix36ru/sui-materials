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



struct FlightStatusBoard: View {
  @State var flights: [FlightInformation]
  var flightToShow: FlightInformation?
  @State private var hidePast = false
  @State var highlightedIds: [Int] = []
  @AppStorage("FlightStatusCurrentTab") var selectedTab: FlightDirection = FlightDirection.all
  var shownFlights: [FlightInformation] {
    hidePast ? flights.filter { $0.localTime >= Date()} : flights
  }
  var shortDateString: String {
    let dateF = DateFormatter()
    dateF.timeStyle = .none
    dateF.dateFormat = "MMM d"
    return dateF.string(from: Date())
  }
  
  func lastUpdateString(_ date: Date) -> String {
    let dateF = DateFormatter()
    dateF.timeStyle = .short
    dateF.dateFormat = .none
    return "Last updated: \(dateF.string(from: Date()))"
  }

  var body: some View{
    TimelineView(.periodic(from: .now, by: 60)) { contex in
      VStack{
        Text(lastUpdateString(contex.date))
          .font(.footnote)
        TabView(selection: $selectedTab){
          Tab("Arrivals", image: "descending-airplane", value: FlightDirection.arrival){
            FlightList(flights: shownFlights.filter { $0.direction == .arrival}, highlightedIds: $highlightedIds)
          }
          .badge(shownFlights.filter {$0.direction == .arrival}.count)
          Tab("All", systemImage: "airplane", value: FlightDirection.all){
            FlightList(flights: shownFlights, highlightedIds: $highlightedIds)
          }
          .badge(shortDateString)
          Tab("Departures", image: "ascending-airplane", value: FlightDirection.departure){
            FlightList(flights: shownFlights.filter { $0.direction == .departure}, highlightedIds: $highlightedIds)
          }.badge(shownFlights.filter {$0.direction == .departure}.count)
        }.refreshable{
          await flights = FlightData.refreshFlights()
        }
        .navigationTitle("Flight Status")
        .toolbar{
          Toggle("Hide Past", isOn: $hidePast)
        }.toggleStyle(.switch)
      }
    }
  }
}

struct FlightStatusBoard_Previews: PreviewProvider {
  static var previews: some View {
    FlightStatusBoard(flights: FlightData.generateTestFlights(date: Date()))
  }
}
