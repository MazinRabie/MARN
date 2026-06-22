import json
import os

log_path = r'C:\Users\karee\.gemini\antigravity-ide\brain\eb21cf2e-7ea9-4363-a857-64e54f854c6f\.system_generated\logs\transcript.jsonl'
files_to_restore = [
    'UserManagementTab.tsx',
    'PropertyModerationTab.tsx',
    'ReportsTab.tsx',
    'ModerationReportsTab.tsx',
    'ContractsModerationTab.tsx',
    'VerificationsTab.tsx'
]

# 1. Read the starting state from the disk (since we just ran git checkout HEAD)
# Wait, my previous python script that replaced delayDuration={200} to 700 also modified these files just now!
# So we should run `git checkout HEAD` first to make sure they are pristine.
os.system('git checkout HEAD -- src/app/pages/admin-dashboard/tabs/*.tsx')

file_contents = {}
for f in files_to_restore:
    path = f'c:/Coding/MARN AI/src/app/pages/admin-dashboard/tabs/{f}'
    if os.path.exists(path):
        with open(path, 'r', encoding='utf-8') as file:
            file_contents[f] = file.read()

# 2. Replay all edits from transcript
with open(log_path, 'r', encoding='utf-8') as f:
    for line in f:
        try:
            step = json.loads(line)
            if 'tool_calls' in step:
                for tc in step['tool_calls']:
                    name = tc.get('name')
                    args = tc.get('arguments', {})
                    if not args:
                        continue
                    
                    if name in ['default_api:multi_replace_file_content', 'multi_replace_file_content', 'default_api:replace_file_content', 'replace_file_content']:
                        tf = args.get('TargetFile', '')
                        filename = os.path.basename(tf.replace('\\', '/'))
                        if filename in file_contents:
                            chunks = args.get('ReplacementChunks', [])
                            if not chunks and 'TargetContent' in args: # replace_file_content format
                                chunks = [args]
                                
                            for chunk in chunks:
                                target = chunk.get('TargetContent', '')
                                replacement = chunk.get('ReplacementContent', '')
                                if target in file_contents[filename]:
                                    file_contents[filename] = file_contents[filename].replace(target, replacement)
                                else:
                                    print(f"Warning: Target content not found in {filename} for an edit step.")
        except Exception as e:
            pass

# 3. Write them back
for f, content in file_contents.items():
    path = f'c:/Coding/MARN AI/src/app/pages/admin-dashboard/tabs/{f}'
    with open(path, 'w', encoding='utf-8') as file:
        file.write(content)
print('Restored edits from transcript successfully.')
