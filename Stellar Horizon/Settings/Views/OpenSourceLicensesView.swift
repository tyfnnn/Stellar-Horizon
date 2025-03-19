//
//  OpenSourceLicensesView.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 19.03.25.
//


import SwiftUI

struct OpenSourceLicensesView: View {
    // Model for license entries
    struct License: Identifiable {
        var id = UUID()
        let name: String
        let license: String
        let url: URL?
        let version: String
        
        init(name: String, license: String, urlString: String? = nil, version: String = "") {
            self.name = name
            self.license = license
            self.url = urlString != nil ? URL(string: urlString!) : nil
            self.version = version
        }
    }
    
    // List of all third-party libraries/components used
    let licenses: [License] = [
        License(
            name: "Firebase",
            license: "Apache 2.0",
            urlString: "https://firebase.google.com",
            version: "10.18.0"
        ),
        License(
            name: "FeedKit",
            license: "MIT",
            urlString: "https://github.com/nmdias/FeedKit",
            version: "9.1.2"
        ),
        License(
            name: "Lottie",
            license: "Apache 2.0",
            urlString: "https://github.com/airbnb/lottie-ios",
            version: "4.3.3"
        ),
        License(
            name: "Google Sign-In",
            license: "Apache 2.0",
            urlString: "https://developers.google.com/identity/sign-in/ios",
            version: "7.0.0"
        ),
        License(
            name: "Berkeley Earth Temperature Data",
            license: "CC BY 4.0",
            urlString: "https://berkeleyearth.org/data/",
            version: "2025-01-06"
        ),
        License(
            name: "NASA APIs",
            license: "NASA Open Data Agreement",
            urlString: "https://api.nasa.gov",
            version: "v1"
        ),
        License(
            name: "ESA Data",
            license: "ESA Terms of Use",
            urlString: "https://www.esa.int/Services/Terms_and_conditions",
            version: "2025"
        ),
        License(
            name: "Flickr API",
            license: "Flickr API Terms of Service",
            urlString: "https://www.flickr.com/services/api/",
            version: "v1"
        ),
        License(
            name: "n2yo.com Satellite Data",
            license: "n2yo API Terms",
            urlString: "https://www.n2yo.com/api/",
            version: "v1"
        )
    ]
    
    // Full MIT license text for display
    let mitLicenseText = """
    MIT License

    Copyright (c) 2025 Tayfun Ilker

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
    """
    
    let apache2LicenseText = """
    Apache License
    Version 2.0, January 2004
    http://www.apache.org/licenses/

    TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION

    1. Definitions.

    "License" shall mean the terms and conditions for use, reproduction, and distribution as defined by Sections 1 through 9 of this document.

    "Licensor" shall mean the copyright owner or entity authorized by the copyright owner that is granting the License.

    [...]

    Copyright 2023 The respective project authors

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
    """
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // App License
                VStack(alignment: .leading, spacing: 10) {
                    Text("Stellar Horizon License")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("This application is licensed under the MIT License:")
                        .fontWeight(.medium)
                    
                    Text(mitLicenseText)
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                .padding(.bottom)
                
                // Third-party components
                VStack(alignment: .leading, spacing: 10) {
                    Text("Third-Party Components")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Stellar Horizon incorporates several open source libraries and data sources, each with their own licenses:")
                        .padding(.bottom, 5)
                    
                    // List all licenses
                    VStack(alignment: .leading, spacing: 15) {
                        ForEach(licenses) { license in
                            LicenseItemView(license: license)
                        }
                    }
                }
                
                // Apple frameworks
                VStack(alignment: .leading, spacing: 10) {
                    Text("Apple Frameworks")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    Text("This application uses standard Apple frameworks including SwiftUI, SceneKit, MapKit, WebKit, and Charts, which are subject to the [Apple SDK License Agreement](https://developer.apple.com/terms/).")
                }
                
                // Attribution Notes
                VStack(alignment: .leading, spacing: 10) {
                    Text("Attribution Notes")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    Text("Earth and space imagery provided by NASA and ESA is used according to their respective media usage guidelines.")
                        .padding(.bottom, 5)
                    
                    Text("Temperature data is provided by Berkeley Earth Land/Ocean Temperature Record and is used under Creative Commons Attribution 4.0 International License.")
                }
                
                
                Text("Last updated: March 15, 2025")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.top)
            }
            .padding()
        }
        .navigationTitle("Open Source Licenses")
        .background(Color("bgColors"))
    }
}

struct LicenseItemView: View {
    let license: OpenSourceLicensesView.License
    @State private var showingDetails = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(license.name)
                    .font(.headline)
                
                Spacer()
                
                if !license.version.isEmpty {
                    Text(license.version)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color(.systemGray5))
                        .cornerRadius(4)
                }
            }
            
            Text("License: \(license.license)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            if let url = license.url {
                Link(destination: url) {
                    HStack(spacing: 4) {
                        Text("Visit website")
                            .font(.caption)
                        Image(systemName: "arrow.up.right")
                            .font(.caption)
                    }
                    .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

#Preview {
    NavigationStack {
        OpenSourceLicensesView()
    }
}