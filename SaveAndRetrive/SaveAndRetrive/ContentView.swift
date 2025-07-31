//
//  ContentView.swift
//  SaveAndRetrive
//
//  Created by nika razmadze on 01.08.25.
//

import SwiftUI

// MARK: - File Helper
enum FileHelper {
    
    static func save(_ text: String, as file: String) throws {
        try text.write(to: url(for: file), atomically: true, encoding: .utf8)
    }
    
    static func load(from file: String) throws -> String {
        try String(contentsOf: url(for: file), encoding: .utf8)
    }
    
    private static func url(for file: String) -> URL {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(file)
    }
}

// MARK: - UI
struct ContentView: View {
    @State private var text: String = ""
    @State private var status: String?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                TextEditor(text: $text)
                    .padding()
                    .frame(height: 200)
                    .overlay(RoundedRectangle(cornerRadius: 8)
                             .stroke(Color.gray.opacity(0.4)))
                
                HStack {
                    Button("Save")  { save()  }
                        .buttonStyle(.borderedProminent)
                    Button("Load")  { load()  }
                        .buttonStyle(.bordered)
                }
                
                if let status {
                    Text(status).foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Private Note")
        }
    }
    
    // MARK: - Actions
    private func save() {
        do {
            try FileHelper.save(text, as: "note.txt")
            status = "✅ Saved to Documents."
            text = ""               
        } catch {
            status = "❌ Save failed: \(error.localizedDescription)"
        }
    }
    
    private func load() {
        do {
            text = try FileHelper.load(from: "note.txt")
            status = "📄 Loaded from file."
        } catch {
            status = "❌ Load failed: \(error.localizedDescription)"
        }
    }
}

//#Preview {
//    ContentView()
//}
