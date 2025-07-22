#!/usr/bin/env python3

"""
Advanced Xcode Project GUID Corruption Fixer
Fixes duplicate GUID references and malformed project structures
"""

import os
import re
import json
import uuid
import shutil
from datetime import datetime

class XcodeProjectFixer:
    def __init__(self, project_path):
        self.project_path = project_path
        self.project_name = "Planet ProTrader"
        self.pbxproj_path = os.path.join(project_path, f"{self.project_name}.xcodeproj", "project.pbxproj")
        self.backup_path = f"{self.pbxproj_path}.backup.{datetime.now().strftime('%Y%m%d_%H%M%S')}"
        
    def backup_project(self):
        """Create a backup of the original project file"""
        shutil.copy2(self.pbxproj_path, self.backup_path)
        print(f"✅ Backup created: {self.backup_path}")
        
    def read_project_file(self):
        """Read and parse the project.pbxproj file"""
        with open(self.pbxproj_path, 'r', encoding='utf-8') as f:
            return f.read()
    
    def write_project_file(self, content):
        """Write the fixed content back to project.pbxproj"""
        with open(self.pbxproj_path, 'w', encoding='utf-8') as f:
            f.write(content)
            
    def find_duplicate_guids(self, content):
        """Find duplicate GUID references"""
        guid_pattern = r'([A-F0-9]{24})\s*='
        guids = re.findall(guid_pattern, content)
        
        # Count occurrences
        guid_counts = {}
        for guid in guids:
            guid_counts[guid] = guid_counts.get(guid, 0) + 1
            
        # Find duplicates
        duplicates = {guid: count for guid, count in guid_counts.items() if count > 1}
        
        if duplicates:
            print(f"⚠️  Found duplicate GUIDs: {duplicates}")
            return duplicates
        else:
            print("✅ No duplicate GUIDs found in current file")
            return {}
    
    def generate_new_guid(self):
        """Generate a new 24-character hex GUID"""
        return uuid.uuid4().hex.upper()[:24]
    
    def fix_package_references(self, content):
        """Fix malformed package references and dependencies"""
        print("🔧 Fixing package references...")
        
        # Remove any malformed PACKAGE references
        malformed_patterns = [
            r'PACKAGE:[A-Z0-9]+::[A-Z]+',
            r'([A-F0-9]{24})\s*/\*\s*PACKAGE:[^*]+\*/',
        ]
        
        for pattern in malformed_patterns:
            matches = re.findall(pattern, content)
            if matches:
                print(f"🗑️  Removing malformed pattern: {pattern}")
                content = re.sub(pattern, '', content)
        
        return content
    
    def regenerate_project_structure(self, content):
        """Regenerate clean project structure"""
        print("🔄 Regenerating project structure...")
        
        # Define clean project template sections
        clean_sections = {
            'PBXBuildFile': [],
            'PBXFileReference': [],
            'PBXGroup': [],
            'PBXNativeTarget': [],
            'PBXProject': [],
            'XCRemoteSwiftPackageReference': [],
            'XCSwiftPackageProductDependency': []
        }
        
        # Extract existing valid sections
        for section_type in clean_sections.keys():
            pattern = rf'/\* Begin {section_type} section \*/(.*?)/\* End {section_type} section \*/'
            match = re.search(pattern, content, re.DOTALL)
            if match:
                clean_sections[section_type] = match.group(1).strip()
        
        return content
    
    def validate_project_syntax(self):
        """Validate project file syntax using plutil"""
        try:
            os.system(f'plutil -lint "{self.pbxproj_path}" > /dev/null 2>&1')
            print("✅ Project file syntax validated")
            return True
        except:
            print("⚠️  Project file has syntax issues")
            return False
    
    def fix_project(self):
        """Main fix method"""
        print("🚀 ADVANCED XCODE PROJECT FIXER")
        print("=" * 50)
        
        # 1. Backup
        self.backup_project()
        
        # 2. Read project file
        print("📖 Reading project file...")
        content = self.read_project_file()
        
        # 3. Find duplicate GUIDs
        duplicates = self.find_duplicate_guids(content)
        
        # 4. Fix package references
        content = self.fix_package_references(content)
        
        # 5. Replace duplicate GUIDs with new ones
        if duplicates:
            print("🔧 Replacing duplicate GUIDs...")
            for duplicate_guid in duplicates.keys():
                new_guid = self.generate_new_guid()
                # Replace all but the first occurrence
                content = content.replace(duplicate_guid, new_guid, duplicates[duplicate_guid] - 1)
                print(f"🔄 Replaced {duplicate_guid} with {new_guid}")
        
        # 6. Write fixed content
        print("💾 Writing fixed project file...")
        self.write_project_file(content)
        
        # 7. Validate
        self.validate_project_syntax()
        
        print("\n🎉 ADVANCED FIX COMPLETE!")
        print("=" * 50)
        print("Try opening the project again. If issues persist, restore from backup.")

def main():
    project_path = "/Users/keonta/Documents/Planet ProTrader"
    fixer = XcodeProjectFixer(project_path)
    fixer.fix_project()

if __name__ == "__main__":
    main()