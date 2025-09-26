

import SwiftUI
import SwiftData

struct RecordView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query var records: [RecordData]
    @Binding var isRecordSheet: Bool
    var body: some View {

        NavigationStack{
            ZStack{
                Colors.background

                VStack{
                    ScrollView(showsIndicators: false){
                        ForEach(0..<10, id: \.self) { i in
                            if i < records.count {
                                       // 実際のデータがある場合
                                       let record = records[i]
                                       RecordRow(
                                           recordRank: "\(i + 1)",
                                           recordScore: "\(record.score)",
                                           recordDate: record.date
                                       )
                                       .padding(.vertical)
                                   } else {
                                       // データがない場合（空の順位）
                                       RecordRow(
                                           recordRank: "\(i + 1)",
                                           recordScore: "---",
                                           recordDate: nil
                                       )
                                       .padding(.vertical)
                                   }
                               }
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


#Preview {
    RecordView(isRecordSheet: .constant(false))
}
