//
//  View+Modifiers.swift
//  CoverSheets
//
//  Created by Peter Ent on 12/9/20.
//

import SwiftUI

/**
 * Extension to View to make it easy to add Half- and QuarterSheet overlays to any view.
 *
 * <Your View>
 *     .halfSheet(isPresented: self.$showHalfSheet) {
 *          the content of your sheet goes here
 *     }
 *
 *  If you want your app to switch to a .sheet when running on an iPad, this is a good place to make
 *  that choice. Use UIDevice.current.userInterfaceIdiom to test for the device at runtime and use
 *  .sheet instead of .modifier
 */
extension View {
    func halfSheet<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) -> some View {
        self.modifier(PartialSheetModifier(isPresented: isPresented, heightFactor: 0.5, sheet: AnyView(content())))
    }
    
    func quarterSheet<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) -> some View {
        self.modifier(PartialSheetModifier(isPresented: isPresented, heightFactor: 0.25, sheet: AnyView(content())))
    }
}

/**
 * A ViewModifier to display the PartialSheet in an overlay, subject to the isPresented flag. Passing
 * in the heightFactor down to the PartialSheet.
 */
struct PartialSheetModifier: ViewModifier {
    @Binding var isPresented: Bool
    var heightFactor: CGFloat
    let sheet: AnyView
    
    func body(content: Content) -> some View {
        content
            .blur(radius: isPresented ? 4.0 : 0.0)
            .overlay(
                Group {
                    if isPresented {
                        PartialSheet(isPresented: self.$isPresented, heightFactor: heightFactor) { sheet }
                    } else {
                        EmptyView()
                    }
                }
            )
    }
}
