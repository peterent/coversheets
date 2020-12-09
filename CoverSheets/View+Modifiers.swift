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
        self.modifier(HalfSheetModifier(isPresented: isPresented, sheet: AnyView(content())))
    }
    func quarterSheet<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) -> some View {
        self.modifier(QuarterSheetModifier(isPresented: isPresented, sheet: AnyView(content())))
    }
}

/**
 * A ViewModifier to display the HalfSheet in an overlay, subject to the isPresented flag.
 */
private struct HalfSheetModifier: ViewModifier {
    @Binding var isPresented: Bool
    let sheet: AnyView
    
    func body(content: Content) -> some View {
        content
            .blur(radius: isPresented ? 4.0 : 0.0)
            .overlay(
                Group {
                    if isPresented {
                        HalfSheet(isPresented: self.$isPresented) {
                            sheet
                        }
                    } else {
                        EmptyView()
                    }
                }
            )
    }
}

/**
 * A ViewModifier to display the QuarterSheet in an over, subject to the iPresented flag.
 */
private struct QuarterSheetModifier: ViewModifier {
    @Binding var isPresented: Bool
    let sheet: AnyView
    
    func body(content: Content) -> some View {
        content
            .blur(radius: isPresented ? 4.0 : 0.0)
            .overlay(
                Group {
                    if isPresented {
                        QuarterSheet(isPresented: self.$isPresented) {
                            sheet
                        }
                    } else {
                        EmptyView()
                    }
                }
            )
    }
}
