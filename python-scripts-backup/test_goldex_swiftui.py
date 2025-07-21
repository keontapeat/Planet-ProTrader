import os
import json
import time
import requests
from bs4 import BeautifulSoup
import openai

class GoldexSwiftUIAI:
    def __init__(self, api_key, cache_dir="./swiftui_cache"):
        self.api_key = api_key
        openai.api_key = self.api_key
        self.cache_dir = cache_dir
        os.makedirs(cache_dir, exist_ok=True)
        self.base_url = "https://developer.apple.com/documentation/swiftui/"
        self.docs_index_file = os.path.join(cache_dir, "index.json")
        self.docs = {}

    def fetch_and_cache_docs(self):
        """Scrape and cache all SwiftUI docs pages."""
        to_visit = [self.base_url]
        visited = set()
        while to_visit:
            url = to_visit.pop(0)
            if url in visited:
                continue
            print(f"[SwiftUI Docs] Fetching {url}")
            try:
                resp = requests.get(url)
                resp.raise_for_status()
                html = resp.text
            except Exception as e:
                print(f"Failed to fetch {url}: {e}")
                continue

            # Save page
            filename = url.replace("https://developer.apple.com/documentation/swiftui/", "").replace("/", "_") or "root"
            filepath = os.path.join(self.cache_dir, f"{filename}.html")
            with open(filepath, "w", encoding="utf-8") as f:
                f.write(html)
            print(f"[SwiftUI Docs] Saved {filepath}")

            # Parse links for more docs pages
            soup = BeautifulSoup(html, "html.parser")
            links = soup.find_all("a", href=True)
            for a in links:
                href = a['href']
                if href.startswith("/documentation/swiftui") and href not in visited and href not in to_visit:
                    full_url = "https://developer.apple.com" + href
                    to_visit.append(full_url)
            visited.add(url)

        print("[SwiftUI Docs] Finished fetching all docs.")

    def load_cached_docs(self):
        """Load cached docs from files into memory."""
        print("[SwiftUI Docs] Loading cached docs...")
        for filename in os.listdir(self.cache_dir):
            if filename.endswith(".html"):
                path = os.path.join(self.cache_dir, filename)
                with open(path, "r", encoding="utf-8") as f:
                    self.docs[filename] = f.read()
        print(f"[SwiftUI Docs] Loaded {len(self.docs)} docs.")

    def extract_text_from_html(self, html):
        """Extract meaningful text and code snippets from Apple docs HTML."""
        soup = BeautifulSoup(html, "html.parser")

        # Extract title
        title = soup.find("h1")
        title_text = title.text.strip() if title else "No Title"

        # Extract code blocks
        code_blocks = [code.get_text() for code in soup.find_all("pre")]

        # Extract paragraphs
        paragraphs = [p.get_text().strip() for p in soup.find_all("p")]

        content = f"Title: {title_text}\n\n"
        content += "Paragraphs:\n"
        for para in paragraphs:
            content += para + "\n"
        content += "\nCode Samples:\n"
        for code in code_blocks:
            content += code + "\n---\n"

        return content

    def prepare_knowledge_base(self):
        """Prepare combined knowledge base text from all docs."""
        combined_text = ""
        for filename, html in self.docs.items():
            extracted = self.extract_text_from_html(html)
            combined_text += extracted + "\n\n=====\n\n"
        return combined_text

    def query_gpt(self, prompt, max_tokens=500, temperature=0.1):
        """Query OpenAI GPT with given prompt."""
        try:
            response = openai.ChatCompletion.create(
                model="gpt-4",
                messages=[{"role": "user", "content": prompt}],
                max_tokens=max_tokens,
                temperature=temperature,
            )
            return response.choices[0].message.content.strip()
        except Exception as e:
            print(f"[GPT Error] {e}")
            return None

    def generate_swiftui_code(self, user_prompt):
        """Generate or fix SwiftUI code using GPT and cached docs."""
        kb = self.prepare_knowledge_base()
        prompt = f"""
You are a world-class SwiftUI expert with access to official Apple SwiftUI documentation.
Here is the knowledge base extracted from docs:

{kb}

Based on this, help the user with the following SwiftUI request or error fix:

{user_prompt}

Provide the best SwiftUI code or solution possible.
"""
        return self.query_gpt(prompt)

    def log_interaction(self, user_prompt, ai_response):
        log_file = os.path.join(self.cache_dir, "interaction_log.json")
        entry = {
            "timestamp": time.time(),
            "prompt": user_prompt,
            "response": ai_response
        }
        try:
            if os.path.exists(log_file):
                with open(log_file, "r") as f:
                    data = json.load(f)
            else:
                data = []
            data.append(entry)
            with open(log_file, "w") as f:
                json.dump(data, f, indent=2)
        except Exception as e:
            print(f"[Log Error] {e}")

    # Example autopilot integration method
    def fix_swiftui_error(self, error_description):
        print("[GOLDEX AI] Fixing SwiftUI error...")
        response = self.generate_swiftui_code(f"Fix this SwiftUI error or problem:\n{error_description}")
        self.log_interaction(error_description, response)
        return response

if __name__ == "__main__":
    # Example usage:
    API_KEY = "SECURE_API_KEY_FROM_KEYCHAIN"  # Replace with your real key or pass from env

    ai = GoldexSwiftUIAI(API_KEY)

    # Step 1: Fetch docs (only once)
    # ai.fetch_and_cache_docs()

    # Step 2: Load docs from cache
    ai.load_cached_docs()

    # Step 3: Example fix call
    example_error = "SwiftUI view not updating after state changes"
    fix = ai.fix_swiftui_error(example_error)
    print("=== Suggested fix by GOLDEX AI ===")
    print(fix)
