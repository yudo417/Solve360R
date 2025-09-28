

import SwiftUI

struct BackButton: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack{
            HStack{
                Button {
                    dismiss()
                } label: {
                    ZStack {
                        // 背景円
                        Circle()
                            .fill(Color.white.opacity(0.9))
                            .frame(width: 44, height: 44)

                        // アイコン
                        Image(systemName: "arrowshape.turn.up.backward.fill")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                    }
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                }
                .buttonStyle(.plain)
                .padding()
                Spacer()
            }
            Spacer()
        }
    }
}

#Preview {
    BackButton()
}
