//
//  RatingView.swift
//  MovieApp
//
//  Created by kadagarw on 02/06/24.
//

import SwiftUI

/// `RatingView` is a SwiftUI view that displays a movie's rating as a circular progress bar.
///
/// The progress bar is green if the rating is 7.0 or above, yellow if it's between 4.0 and 6.9, and red if it's below 4.0.
/// The rating is also displayed as a number in the center of the circle.
///
/// The `init` method initializes the view with a `Double` value representing the movie's rating.
/// The `body` property defines the UI of the view.
struct RatingView: View {
    var value: Double
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 40, height: 40)
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.value, 1.0)))
                .stroke(value >= 0.7 ? Color.green : (value >= 0.4 ? Color.yellow : Color.red), style: StrokeStyle(lineWidth: 6, lineCap: .round))
                .rotationEffect(Angle(degrees: -90))
                .frame(width: 40, height: 40)
            Text(String(format: "%.1f", min(self.value, 1.0)*10.0))
                .font(.footnote)
                .bold()
        }
    }
}
