#!/usr/bin/env python3
"""
🚀 OPUS MAX CLOUD DEBUGGER
GitHub Actions integration for automated Claude-powered code analysis
"""

import os
import json
import anthropic
import subprocess
from pathlib import Path

class OpusMaxCloudDebugger:
    def __init__(self):
        self.api_key = os.getenv('ANTHROPIC_API_KEY')
        if not self.api_key:
            print("❌ ANTHROPIC_API_KEY not found in secrets!")
            exit(1)
            
        self.client = anthropic.Anthropic(api_key=self.api_key)
        self.project_path = Path('.')
        
    def get_changed_files(self):
        """Get list of changed Swift files from git"""
        try:
            result = subprocess.run(['git', 'diff', '--name-only', 'HEAD~1'], 
                                  capture_output=True, text=True)
            files = result.stdout.strip().split('\n')
            return [f for f in files if f.endswith('.swift') and Path(f).exists()]
        except:
            # Fallback: analyze all Swift files
            return list(self.project_path.rglob('*.swift'))
    
    def analyze_with_opus_max(self, files):
        """Send files to Claude for Opus Max level analysis"""
        
        file_contents = {}
        for file_path in files[:10]:  # Limit to 10 files to avoid token limits
            try:
                with open(file_path, 'r', encoding='utf-8') as f:
                    file_contents[str(file_path)] = f.read()
            except:
                continue
        
        if not file_contents:
            return "No Swift files to analyze."
            
        prompt = f"""
🚀 OPUS MAX CLOUD ANALYSIS - Planet ProTrader

You are Opus Max, the most advanced SwiftUI debugging AI in the cloud! Analyze these files with MAXIMUM INTELLIGENCE:

FILES TO ANALYZE:
{json.dumps(list(file_contents.keys()), indent=2)}

CODE:
{chr(10).join([f"=== {path} ==={chr(10)}{content}{chr(10)}" for path, content in file_contents.items()])}

OPUS MAX ANALYSIS REQUIREMENTS:
🔍 CRITICAL ISSUES (Fix immediately):
- Compilation errors that will break the build
- Memory leaks and retain cycles  
- Threading issues (@MainActor violations)
- Force unwrapping that could crash
- Performance bottlenecks

⚡ SWIFTUI OPTIMIZATIONS:
- @State/@StateObject lifecycle issues
- Unnecessary view redraws
- List/LazyVStack performance improvements
- Animation performance issues
- Memory-efficient view updates

🧠 ADVANCED IMPROVEMENTS:
- Modern SwiftUI patterns (iOS 17+)
- Combine optimization opportunities
- Architecture improvements (MVVM)
- Error handling enhancements
- Code quality improvements

🎯 TRADING-SPECIFIC ANALYSIS:
- Real-time data processing optimizations
- Bot performance improvements
- Risk management code review
- Supabase integration issues
- Firebase connection optimizations

RESPONSE FORMAT:
## 🚨 Critical Issues Found
- List urgent problems that need immediate fixing

## ⚡ Performance Optimizations  
- Specific improvements for speed/memory

## 🔧 Code Quality Improvements
- Best practices and modern Swift patterns

## 🎯 Trading Platform Enhancements
- Domain-specific improvements for trading features

## ⭐ Overall Assessment
- Rate the code quality (1-10) and provide summary

Make it ACTIONABLE and SPECIFIC - like a senior iOS architect reviewing the code!
"""

        try:
            response = self.client.messages.create(
                model="claude-3-opus-20240229",
                max_tokens=4000,
                temperature=0.3,
                messages=[{"role": "user", "content": prompt}]
            )
            
            return response.content[0].text
        except Exception as e:
            return f"❌ Opus Max analysis failed: {str(e)}"
    
    def generate_action_items(self, analysis):
        """Generate GitHub Issues from Opus Max analysis"""
        
        # Extract critical issues and create actionable items
        action_prompt = f"""
Based on this Opus Max analysis, create GitHub issue-ready action items:

ANALYSIS:
{analysis}

Create 3-5 specific, actionable GitHub issues with:
- Clear title
- Problem description  
- Specific solution steps
- Priority level (High/Medium/Low)
- Estimated effort (Small/Medium/Large)

Format as JSON array of issues.
"""
        
        try:
            response = self.client.messages.create(
                model="claude-3-haiku-20240307",  # Faster model for this task
                max_tokens=1500,
                temperature=0.1,
                messages=[{"role": "user", "content": action_prompt}]
            )
            
            return response.content[0].text
        except:
            return "Could not generate action items"
    
    def save_analysis_results(self, analysis, action_items):
        """Save results to files for GitHub Actions to use"""
        
        # Main analysis file
        with open('opus-analysis.md', 'w') as f:
            f.write(f"""# 🤖 Opus Max Cloud Analysis Results

*Analyzed by Claude Opus Max at {os.getenv('GITHUB_SHA', 'unknown commit')}*

{analysis}

---

## 🎯 Recommended Actions

{action_items}

## 📊 Analysis Metadata
- **Repository**: {os.getenv('GITHUB_REPOSITORY', 'keontapeat/Planet-ProTrader')}
- **Commit**: {os.getenv('GITHUB_SHA', 'unknown')}
- **Timestamp**: {subprocess.run(['date'], capture_output=True, text=True).stdout.strip()}
- **Analyzer**: Opus Max Cloud Debugger v2.0

*Generated automatically by GitHub Actions + Claude Opus Max*
""")
        
        # Summary for PR comments
        summary = analysis.split('\n')[:10]  # First 10 lines
        with open('opus-summary.md', 'w') as f:
            f.write(f"""🤖 **Opus Max Quick Analysis**

{chr(10).join(summary)}

[View Full Analysis](opus-analysis.md)
""")
            
        print("✅ Opus Max analysis complete!")
        print("📁 Results saved to opus-analysis.md")

def main():
    print("🚀 Starting Opus Max Cloud Analysis...")
    print(f"📁 Repository: {os.getenv('GITHUB_REPOSITORY', 'Unknown')}")
    print(f"🔧 Commit: {os.getenv('GITHUB_SHA', 'Unknown')[:8]}")
    
    debugger = OpusMaxCloudDebugger()
    
    # Get files to analyze
    changed_files = debugger.get_changed_files()
    print(f"📊 Analyzing {len(changed_files)} files...")
    
    # Run Opus Max analysis
    analysis = debugger.analyze_with_opus_max(changed_files)
    action_items = debugger.generate_action_items(analysis)
    
    # Save results
    debugger.save_analysis_results(analysis, action_items)
    
    print("🎉 Opus Max Cloud Analysis Complete!")

if __name__ == "__main__":
    main()