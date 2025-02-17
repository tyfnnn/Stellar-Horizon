//
//  DatePickerView.swift
//  TraumJobs
//
//  Created by Tayfun Ilker on 09.12.24.
//

import SwiftUI

struct DatePickerView: View {
    @Binding var birthdate: Double
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                DatePicker(
                    "Geburtsdatum",
                    selection: Binding(
                        get: { Date(timeIntervalSince1970: birthdate) },
                        set: { birthdate = $0.timeIntervalSince1970 }
                    ),
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding()
            }
            .navigationTitle("Geburtsdatum wählen")
            .toolbar {
                Button("Fertig") {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    DatePickerView(birthdate: .constant(21.01))
}
