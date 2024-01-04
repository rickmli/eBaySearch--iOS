////
////  Toast.swift
////  ebaySearch--IOS
////
////  Created by Rick Li on 12/6/23.
////
//
import SwiftUI

struct Toast<Presenting, Content>: View where Presenting: View, Content: View {
    @Binding var isPresented: Bool
    let presenter: () -> Presenting
    let content: () -> Content
    let delay: TimeInterval = 0.7

    var body: some View {
        if self.isPresented {
            DispatchQueue.main.asyncAfter(deadline: .now() + self.delay) {
                withAnimation {
                    self.isPresented = false
                }
            }
        }

        return GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                self.presenter()

                ZStack {
                    Rectangle()
                        .fill(Color.black.opacity(0.8))
                        .cornerRadius(20)

                    self.content()
                } //ZStack (inner)
                .frame(width: geometry.size.width / 2, height: geometry.size.height / 10)
                .opacity(self.isPresented ? 1 : 0)
                .padding(.bottom, 60)
            } //ZStack (outer)
        } //GeometryReader
    } //body
} //Toast

extension View {
    func toast<Content>(isPresented: Binding<Bool>, content: @escaping () -> Content) -> some View where Content: View {
        Toast(
            isPresented: isPresented,
            presenter: { self },
            content: content
        )
    }
}
