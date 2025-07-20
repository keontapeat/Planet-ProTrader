#!/usr/bin/env python3
"""
GOLDEX AI Firebase Screenshot Uploader
Uploads trading screenshots to Firebase Storage with metadata
"""

import os
import sys
import json
import datetime
from pathlib import Path
import firebase_admin
from firebase_admin import credentials, storage
from PIL import Image
import subprocess
import hashlib

class GoldexFirebaseUploader:
    def __init__(self):
        # Initialize Firebase
        cred_path = os.path.expanduser('~/goldex_ai/firebase_credentials.json')
        if not os.path.exists(cred_path):
            raise FileNotFoundError(f"Firebase credentials not found at {cred_path}")
        
        try:
            cred = credentials.Certificate(cred_path)
            firebase_admin.initialize_app(cred, {
                'storageBucket': 'goldex-ai.appspot.com'
            })
        except ValueError:
            # App already initialized
            pass
        
        self.bucket = storage.bucket()
        self.screenshots_dir = os.path.expanduser('~/goldex_ai/screenshots')
        os.makedirs(self.screenshots_dir, exist_ok=True)
        
        # Create logs directory
        self.logs_dir = os.path.expanduser('~/goldex_ai/logs')
        os.makedirs(self.logs_dir, exist_ok=True)
        
        print("✅ Firebase uploader initialized")
    
    def capture_screenshot(self, filename_prefix="trade"):
        """Capture screenshot of current display"""
        timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
        filename = f"{filename_prefix}_{timestamp}.png"
        filepath = os.path.join(self.screenshots_dir, filename)
        
        try:
            # Capture screenshot using scrot with display :99
            subprocess.run([
                'scrot', 
                '--select', '0,0,1024,768',  # Capture specific area
                filepath
            ], check=True, env={'DISPLAY': ':99'}, timeout=30)
            
            print(f"📸 Screenshot captured: {filename}")
            return filepath
            
        except subprocess.TimeoutExpired:
            print("⏰ Screenshot capture timed out")
            return None
        except subprocess.CalledProcessError as e:
            print(f"❌ Screenshot capture failed: {e}")
            # Try alternative method
            try:
                subprocess.run([
                    'import', 
                    '-window', 'root',
                    '-display', ':99',
                    filepath
                ], check=True, timeout=30)
                print(f"📸 Screenshot captured (alternative method): {filename}")
                return filepath
            except:
                print("❌ Alternative screenshot method also failed")
                return None
    
    def optimize_image(self, filepath):
        """Optimize image for upload"""
        try:
            with Image.open(filepath) as img:
                # Resize if too large
                if img.width > 1920 or img.height > 1080:
                    img.thumbnail((1920, 1080), Image.Resampling.LANCZOS)
                
                # Convert to RGB if needed
                if img.mode != 'RGB':
                    img = img.convert('RGB')
                
                # Save optimized version
                img.save(filepath, 'PNG', optimize=True, quality=85)
                print(f"🎨 Image optimized: {os.path.basename(filepath)}")
                
        except Exception as e:
            print(f"⚠️ Image optimization failed: {e}")
    
    def generate_file_hash(self, filepath):
        """Generate MD5 hash of file"""
        try:
            with open(filepath, 'rb') as f:
                return hashlib.md5(f.read()).hexdigest()
        except:
            return None
    
    def upload_to_firebase(self, filepath, trade_data=None):
        """Upload screenshot to Firebase Storage"""
        try:
            filename = os.path.basename(filepath)
            timestamp = datetime.datetime.now().strftime("%Y/%m/%d")
            blob_name = f"playbook/trades/{timestamp}/{filename}"
            
            blob = self.bucket.blob(blob_name)
            
            # Generate file hash
            file_hash = self.generate_file_hash(filepath)
            
            # Get file size
            file_size = os.path.getsize(filepath)
            
            # Prepare metadata
            metadata = {
                'timestamp': datetime.datetime.now().isoformat(),
                'source': 'goldex_ai_vps',
                'type': 'trading_screenshot',
                'file_hash': file_hash,
                'file_size': str(file_size),
                'display': ':99',
                'capture_method': 'scrot'
            }
            
            # Add trade data to metadata
            if trade_data:
                if isinstance(trade_data, str):
                    try:
                        trade_data = json.loads(trade_data)
                    except json.JSONDecodeError:
                        trade_data = {'raw_data': trade_data}
                
                metadata.update(trade_data)
            
            # Set metadata
            blob.metadata = metadata
            
            # Upload file
            blob.upload_from_filename(filepath)
            
            # Make public
            blob.make_public()
            
            print(f"🚀 Uploaded to Firebase: {blob_name}")
            print(f"🔗 Public URL: {blob.public_url}")
            
            # Log upload
            self.log_upload(blob_name, blob.public_url, metadata)
            
            return blob.public_url
            
        except Exception as e:
            print(f"❌ Upload failed: {e}")
            self.log_error(f"Upload failed: {e}")
            return None
    
    def log_upload(self, blob_name, url, metadata):
        """Log successful upload"""
        log_entry = {
            'timestamp': datetime.datetime.now().isoformat(),
            'blob_name': blob_name,
            'url': url,
            'metadata': metadata
        }
        
        log_file = os.path.join(self.logs_dir, 'uploads.jsonl')
        with open(log_file, 'a') as f:
            f.write(json.dumps(log_entry) + '\n')
    
    def log_error(self, error_message):
        """Log error"""
        log_entry = {
            'timestamp': datetime.datetime.now().isoformat(),
            'error': error_message
        }
        
        log_file = os.path.join(self.logs_dir, 'errors.jsonl')
        with open(log_file, 'a') as f:
            f.write(json.dumps(log_entry) + '\n')
    
    def capture_and_upload(self, prefix="trade", trade_data=None):
        """Capture screenshot and upload to Firebase"""
        print(f"📱 Starting capture and upload for: {prefix}")
        
        # Capture screenshot
        filepath = self.capture_screenshot(prefix)
        if not filepath:
            return None
        
        # Optimize image
        self.optimize_image(filepath)
        
        # Upload to Firebase
        url = self.upload_to_firebase(filepath, trade_data)
        
        # Clean up local file after upload
        try:
            os.remove(filepath)
            print(f"🗑️ Local file cleaned up: {os.path.basename(filepath)}")
        except Exception as e:
            print(f"⚠️ Failed to clean up local file: {e}")
        
        return url
    
    def test_connection(self):
        """Test Firebase connection"""
        try:
            # Try to access bucket
            blobs = list(self.bucket.list_blobs(prefix='playbook/trades/', max_results=1))
            print("✅ Firebase connection test successful")
            return True
        except Exception as e:
            print(f"❌ Firebase connection test failed: {e}")
            return False

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 firebase_uploader.py <prefix> [trade_data_json]")
        sys.exit(1)
    
    prefix = sys.argv[1]
    trade_data = None
    
    if len(sys.argv) > 2:
        trade_data = sys.argv[2]
    
    try:
        uploader = GoldexFirebaseUploader()
        
        # Test connection first
        if not uploader.test_connection():
            print("❌ Firebase connection failed")
            sys.exit(1)
        
        # Capture and upload
        url = uploader.capture_and_upload(prefix, trade_data)
        
        if url:
            print(f"✅ Success! Screenshot uploaded")
            print(f"📱 URL: {url}")
        else:
            print("❌ Failed to upload screenshot")
            sys.exit(1)
            
    except Exception as e:
        print(f"❌ Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()