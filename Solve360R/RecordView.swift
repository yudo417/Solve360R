

import SwiftUI

struct RecordView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var isRecordSheet: Bool
    var body: some View {

        NavigationStack{
            ZStack{
                Colors.background

                VStack{
                    ScrollView(showsIndicators: false){
                        ForEach(0..<10, id: \.self) { i in
                            RecordRow(recordRank: "\(i + 1)", recordScore: "\(i + 1)", recordDate: Date())
                                .padding(.vertical)
                        }
                    }
                }
                .toolbar{
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }

                    }
                }

            }
        }
    }
}

#Preview {
    RecordView(isRecordSheet: .constant(false))
}
