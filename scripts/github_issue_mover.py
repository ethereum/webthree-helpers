
issues = requests.get(
    'https://api.github.com/repos/ethereum/cpp-ethereum/issues',
    params={'state': 'open'},
    headers=authheaders
)

cppIssues = 'https://github.com/ethereum/cpp-ethereum/issues'
webthreeIssues = 'https://github.com/ethereum/webthree-umbrella/issues'

for issue in issues.json():
    # Create a new issue
    body = ('Moved here from [cpp-ethereum](%s/%d)\n\n' % (cppIssues, issue['number'])) + issue['body']
    createdIssue = requests.post(
        'https://api.github.com/repos/ethereum/webthree-umbrella/issues',
        data=json.dumps({ 'title': issue['title'], 'body': body}),
        headers=authheaders
    )
    createdNumber = createdIssue.json()["number"]
    if int(createdNumber) == 0:
        break
    # Comment on the old issue
    requests.post(
        'https://api.github.com/repos/ethereum/cpp-ethereum/issues/%d/comments' % issue['number'],
        data=json.dumps({ 'body': 'Issue moved to [webthree-umbrella](%s/%d).' % (webthreeIssues, createdNumber) }),
        headers=authheaders
    )
    # Close old issue
    requests.post(
        'https://api.github.com/repos/ethereum/cpp-ethereum/issues/%d' % issue['number'],
        data=json.dumps({'state': 'closed' }),
        headers=authheaders
    )
print "Moved %d issues." % len(issues)
