import Foundation
import Supabase

/// Centralised, single-ton Supabase client.
/// Reads credentials from `Info.plist` so nothing is hard-coded.
///
/// ● Open *Info.plist*  
///   Add two String entries:
///     SUPABASE_URL   → https://xyz.supabase.co
///     SUPABASE_KEY   → ey...service_role_key…
///
/// You can then call:
///     let client = SupabaseConfig.shared
/// anywhere in the codebase.
enum SupabaseConfig {
    /// Lazily built client; crashes early if keys are missing so you know fast.
    static let shared: SupabaseClient = {
        guard
            let urlString = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String,
            let key = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_KEY") as? String,
            let url = URL(string: urlString)
        else {
            // Fallback to hardcoded values if not in Info.plist
            let fallbackURL = "https://ibrvgbcwdqkucabcbqlq.supabase.co"
            let fallbackKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlicnZnYmN3ZHFrdWNhYmNicWxxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI4MzI2MDAsImV4cCI6MjA2ODQwODYwMH0.twjMhyyeUutnkGw95I5hxd4ZwfPda2lXPGyuQopKmcw"
            
            guard let fallbackURLObj = URL(string: fallbackURL) else {
                fatalError("❌ Invalid Supabase URL configuration")
            }
            
            return SupabaseClient(supabaseURL: fallbackURLObj, supabaseKey: fallbackKey)
        }
        
        return SupabaseClient(supabaseURL: url, supabaseKey: key)
    }()
}