import sys

key   = None
total = 0
index = {}
for line in sys.stdin:
    word, loc  = line.split('\t', 1)
    word = word.strip()
    loc = loc.strip()
    if word in index:
        index[word].add(loc)
    else:
        index[word] = set([loc])

for word, docs in index.items():
    print('{}\t{}'.format(word, docs))