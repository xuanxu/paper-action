require "theoj"

issue_id = ENV["ISSUE_ID"]
repo_url = ENV["REPO_URL"]
repo_branch = ENV["PAPER_BRANCH"]
journal_alias = ENV['JOURNAL_ALIAS']

journal = Theoj::Journal.new(Theoj::JOURNALS_DATA[journal_alias.to_sym])
issue = Theoj::ReviewIssue.new(journal.data[:reviews_repository], issue_id)
issue.paper = Theoj::Paper.from_repo(repo_url, repo_branch)
submission = Theoj::Submission.new(journal, issue, issue.paper)

paper_path = issue.paper.paper_path

if paper_path.nil?
  raise "   !! ERROR: Paper file not found"
else
  system("echo '::set-output name=paper_file_path::#{paper_path}'")
end
