//
//  ContentView.swift
//  CoverSheets
//
//  Created by Peter Ent on 12/8/20.
//

import SwiftUI

// MARK: - SAMPLE SHEET CONTENT

/**
 * This is what is displayed in the sheet. Use a ScrollView if the content is
 * larger than the sheet itself.
 */
struct SheetContents: View {
    let title: String
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Spacer()
                Text(title)
                    .font(.title)
                    .padding()
                Spacer()
            }
            Divider()
            Spacer()
            Text("Something to show in this sheet")
            Text("Whatever you want.")
            Spacer()
        }.background(Color.white)
    }
}

// MARK: - MAIN CONTENT VIEW

/**
 * The content for the app.
 */
struct ContentView: View {
    @State private var showHalfSheet = false
    @State private var showQuarterSheet = false
    
    var body: some View {
        
        // some buttons to trigger the sheets to appear. note that the buttons use
        // withAnimation{} to change their toggles; this enables the transitions set
        // on the sheet components to activate.
        
        VStack {
            HStack {
                Spacer()
                Text("Hello, world!")
                Spacer()
            }
            Button("Show 1/2 Sheet") {
                withAnimation {
                    self.showHalfSheet.toggle()
                }
            }.padding()
            Button("Show 1/4 Sheet") {
                withAnimation {
                    self.showQuarterSheet.toggle()
                }
            }.padding()
            Spacer()
        }
        .padding()
        
        // attach the sheet you want to display to the view.
        
        .halfSheet(isPresented: self.$showHalfSheet) {
            SheetContents(title: "1/2 with Modifier")
        }
        .quarterSheet(isPresented: self.$showQuarterSheet) {
            SheetContents(title: "1/4 with Modifier")
        }

    }
}

// MARK: - PREVIEW

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


