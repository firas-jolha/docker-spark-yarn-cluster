import sys

current_word = None
current_docs = []  # Store document IDs for current word

for line in sys.stdin:
    line = line.strip()
    
    if not line:
        continue
    
    # Parse input
    try:
        word, doc_id = line.split('\t', 1)
    except ValueError:
        continue
    
    # New word encountered
    if current_word != word:
        # Output previous word's document list
        if current_word:
            # Remove duplicates by converting to set, then sort
            unique_docs = sorted(set(current_docs))
            docs_str = '[' + ','.join(unique_docs) + ']'
            print(f"{current_word}\t{docs_str}")
        
        # Reset for new word
        current_word = word
        current_docs = [doc_id]
    else:
        # Same word, add document ID
        current_docs.append(doc_id)

# Output last word
if current_word:
    unique_docs = sorted(set(current_docs))
    docs_str = '[' + ','.join(unique_docs) + ']'
    print(f"{current_word}\t{docs_str}")
