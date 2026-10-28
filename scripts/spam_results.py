"""Typeset the verified chapter-4 result fixture and its interpreted readouts."""
import re
import subprocess
import tomllib

from render_new_chapters import ROOT, pandoc_command


def result_fragments(r):
    n, tn, fn, fp, tp = (r[k] for k in ('test_count', 'true_ham', 'missed_spam', 'blocked_ham', 'true_spam'))
    return {
        'predictions': f"The first five predictions are `{r['first_predictions']}`: ham, ham, spam, ham, spam.\nEach 0 means ham and each 1 means spam. Now let's compare them with the labels.",
        'accuracy': f"Our filter gets **{100*r['accuracy']:.2f}%** of the held-out messages right: **{tn+tp:,} out of {n:,}**.\nThat leaves {fp+fn} mistakes. We used the fixed seed {r['seed']}, smoothing $\\alpha=1$,\nand every known word in each email.",
        'prevalence': f"Spam accounts for **{100*r['spam_fraction']:.2f}%** of the whole dataset. In our test set,\na filter that always delivers everything would score **{100*r['all_ham_accuracy']:.2f}%**\naccuracy without catching a single spam message. Our model does much better\nthan that baseline, but we still need to find out which mistakes it makes.",
        'confusion': f"| Model prediction | Actual ham | Actual spam |\n|:--|--:|--:|\n| Ham | {tn} | {fn} |\n| Spam | {fp} | {tp} |\n\nWe caught **{tp} spam messages**, but **{fn} slipped through**. The other mistake\nmay be more annoying: **{fp} legitimate messages were marked as spam**. A high\naccuracy does not tell us how costly those two kinds of mistakes are.",
        'recall': f"| Class | Correctly identified / actual total | Recall |\n|:--|--:|--:|\n| Ham | {tn} / {tn+fp} | {100*r['ham_recall']:.2f}% |\n| Spam | {tp} / {tp+fn} | {100*r['spam_recall']:.2f}% |\n\nThe two recalls are close: **{100*r['ham_recall']:.2f}% for ham** and **{100*r['spam_recall']:.2f}% for spam**.\nSo our good overall score is not hiding a filter that ignores spam. Still,\nwould you trust it with your inbox after seeing those {fp} blocked legitimate\nmessages? Chapter 14 returns to that question by assigning different costs\nto different mistakes. These numbers describe this one held-out split; a\nnew mailbox or a different split can give a different result.",
    }


SECTIONS = [
    ('Preprocessing the Data', 'preprocessing-the-data', 'The Naive Bayes Approach', '4.3', [3, 4]),
    ('The Naive Bayes Approach', 'the-naive-bayes-approach', 'Training the Model', '4.4', [5, 6, 7]),
    ('Making Predictions', 'making-predictions', 'Evaluating the Accuracy', '4.6', [10, 12, 13, 14, 15]),
    ('Evaluating the Accuracy', 'evaluating-the-accuracy', 'Summary', '4.7', [17, 18, 20, 22, 23, 25, 27]),
]


def sync_spam_results(source, page):
    result = tomllib.loads((ROOT / '04_naive_bayes/book_results.toml').read_text())
    for name, fragment in result_fragments(result).items():
        pattern = rf'(<!-- spam-result:{name} -->).*?(<!-- /spam-result:{name} -->)'
        source, count = re.subn(pattern, lambda m: m[1] + '\n' + fragment + '\n' + m[2], source, flags=re.S)
        if count != 1:
            raise ValueError(f'Missing unique spam result marker: {name}')
    for title, slug, following, number, blocks in SECTIONS:
        body = source.split('## ' + title + '\n', 1)[1].split('## ' + following + '\n', 1)[0]
        body = re.sub(r'^```\{julia[^\n]*\}', '```julia', body, flags=re.M)
        rendered = subprocess.check_output(pandoc_command() + ['--from=markdown', '--to=html4', '--mathjax', '--wrap=none'], input=body, text=True, cwd=ROOT).strip()
        ids = re.findall(r'<div class="sourceCode" id="(cb\d+)"', rendered)
        if len(ids) != len(blocks):
            raise ValueError(f'Changed code block count in {title}; update preserved IDs')
        mapping = dict(zip(ids, [f'cb{i}' for i in blocks]))
        rendered = re.sub(r'\bcb\d+\b', lambda m: mapping[m[0]], rendered)
        rendered = re.sub(r'<a href="#(cb\d+-\d+)"', lambda m: f'<a href="spam-filter.html#{m[1]}" aria-hidden="true"', rendered)
        replacement = f'<div id="{slug}" class="section level2 hasAnchor" number="{number}">\n<h2><span class="header-section-number">{number}</span> {title}<a href="spam-filter.html#{slug}" class="anchor-section" aria-label="Anchor link to header"></a></h2>\n{rendered}\n</div>\n'
        pattern = rf'<div id="{slug}" class="section level2.*?(?=<div id="[^"]+" class="section level2)'
        page, count = re.subn(pattern, lambda _: replacement, page, count=1, flags=re.S)
        if count != 1:
            raise ValueError(f'Missing legacy section {slug}')
    return source, page
