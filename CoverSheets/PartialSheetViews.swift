//
//  PartialSheetViews.swift
//  CoverSheets
//
//  Created by Peter Ent on 12/8/20.
//

import SwiftUI

// MARK: - BLOCKING VIEW

/**
 * The BlockingView's job is to act as a tap shield between the sheet
 * and the app's content. It appears a darkened screen. But it has
 * its own tap gesture so that the user can just dismiss the overlay
 * by tapping on this shield.
 */
private struct BlockingView: View {
    @Binding var isPresented: Bool
    @Binding var showingContent: Bool
    
    // showContent is called when the Color appears and then delays the
    // appearance of the sheet itself so the two don't appear simultaneously.
    
    func showContent() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            withAnimation {
                self.showingContent = true
            }
        }
    }

    // hides the sheet first, then after a short delay, makes the blocking
    // view disappear.
    
    func hideContent() {
        withAnimation {
            self.showingContent = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            withAnimation {
                self.isPresented = false
            }
        }
    }
    
    var body: some View {
        Color.black.opacity(0.35)
            .onTapGesture {
                self.hideContent()
            }
            .onAppear {
                self.showContent()
            }
    }
}

// MARK: - PARTIAL SHEET

/**
 * This is the structure of the overlay itself. It is a ZStack with the BlockingView
 * below the content. Note that each child of the ZStack has a fixed zIndex. If the
 * zIndex is not set, adding and removing children will not have the transitions work
 * correctly as SwiftUI will think it is not adding and removing the same child.
 */
private struct PartialSheet<Content: View>: View {
    @Binding var isPresented: Bool
    var content: Content
    let height: CGFloat
    
    @State private var showingContent = false
    
    var body: some View {
        GeometryReader { reader in
            ZStack(alignment: .bottom) {
                BlockingView(isPresented: self.$isPresented, showingContent: self.$showingContent)
                    .zIndex(0) // important to fix the zIndex so that transitions work correctly
                
                if showingContent {
                    self.content
                        .zIndex(1) // important to fix the zIndex so that transitins work correctly
                        .frame(width: reader.size.width, height: reader.size.height * self.height)
                        .clipped()
                        .shadow(radius: 10)
                        .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)))
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

// MARK: - HALF SHEET

/**
 * Displays a sheet that's half as high as the screen.
 */
struct HalfSheet<Content: View>: View {
    @Binding var isPresented: Bool
    var content: Content
        
    init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
        _isPresented = isPresented
        self.content = content()
    }
    
    var body: some View {
        PartialSheet(isPresented: self.$isPresented, content: content, height: 0.5)
    }
}

// MARK: - QUARTER SHEET

/**
 * Displays a sheet that's a quarter of the screen's height.
 */
struct QuarterSheet<Content: View>: View {
    @Binding var isPresented: Bool
    var content: Content
        
    init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
        _isPresented = isPresented
        self.content = content()
    }
    
    var body: some View {
        PartialSheet(isPresented: self.$isPresented, content: content, height: 0.25)
    }
}
