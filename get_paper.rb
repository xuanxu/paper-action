require "theoj"
require "yaml"

issue_id = ENV["ISSUE_ID"]
repo_url = ENV["REPO_URL"]
repo_branch = ENV["PAPER_BRANCH"]
journal_alias = ENV["JOURNAL_ALIAS"]
acceptance = ENV["COMPILE_MODE"] == "accepted"

journal = Theoj::Journal.new(Theoj::JOURNALS_DATA[journal_alias.to_sym])
issue = Theoj::ReviewIssue.new(journal.data[:reviews_repository], issue_id)
issue.paper = Theoj::Paper.from_repo(repo_url, repo_branch)
submission = Theoj::Submission.new(journal, issue, issue.paper)

paper_path = issue.paper.paper_path

if paper_path.nil?
  system("echo 'CUSTOM_ERROR=Paper file not found.' >> $GITHUB_ENV")
  raise "   !! ERROR: Paper file not found"
else
  system("echo 'paper_file_path=#{paper_path}' >> $GITHUB_OUTPUT")
end

metadata = submission.article_metadata
if acceptance && metadata[:published_at].to_s.strip.empty?
  metadata[:published_at] = Time.now.strftime("%Y-%m-%d")
end

metadata[:submitted_at] = "0000-00-00" if metadata[:submitted_at].to_s.strip.empty?
metadata[:published_at] = "0000-00-00" if metadata[:published_at].to_s.strip.empty?

metadata[:editor].transform_keys!(&:to_s)
metadata[:authors].each {|author| author.transform_keys!(&:to_s) }
metadata.transform_keys!(&:to_s)

metadata_file_path = File.dirname(paper_path)+"/paper-metadata.yaml"

File.open(metadata_file_path, "w") do |f|
  f.write metadata.to_yaml
end

if File.exist?(metadata_file_path)
  title = metadata["title"]
  system("echo 'paper_title=#{title}' >> $GITHUB_OUTPUT")
  system("echo 'Metadata created for paper: #{title}'")

  system("echo ' ** Paper path: #{paper_path}'")
  system("echo ' ** Metadata file path: #{metadata_file_path}'")
else
  system("echo 'CUSTOM_ERROR=Paper metadata file could not be generated.' >> $GITHUB_ENV")
  raise "   !! ERROR: Paper metadata file could not be generated"
end

inara_args = "-m #{metadata_file_path} -l -o pdf,crossref,jats"
inara_args += ",cff -p" if acceptance

system("echo 'inara_args=#{inara_args}' >> $GITHUB_OUTPUT")

track = submission.track
track_name = track[:parameterized] || journal_alias
system("echo 'track_name=#{track_name}' >> $GITHUB_OUTPUT")
