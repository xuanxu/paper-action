require 'json'

paper_md_path = ARGV[0].to_s
formats = ARGV[1].to_s.downcase.split(",")

# Check for generated files presence
if paper_md_path.empty?
  raise "   !! ERROR: The paper path is empty"
else
  paper_pdf_path = File.dirname(paper_md_path)+"/paper.pdf"
  if File.exist?(paper_pdf_path)
    system("echo 'paper_pdf_path=#{paper_pdf_path}' >> $GITHUB_OUTPUT")
    system("echo 'Success! PDF file generated at: #{paper_pdf_path}'")
  else
    raise "   !! ERROR: Failed to generate PDF file" if formats.include?("pdf")
  end

  paper_crossref_path = File.dirname(paper_md_path)+"/paper.crossref"
  if File.exist?(paper_crossref_path)
    system("echo 'paper_crossref_path=#{paper_crossref_path}' >> $GITHUB_OUTPUT")
    system("echo 'Success! Crossref XML file generated at: #{paper_crossref_path}'")
  else
    raise "   !! ERROR: Failed to generate Crossref XML file" if formats.include?("crossref")
  end

  paper_jats_path = File.dirname(paper_md_path)+"/paper.jats"
  if File.exist?(paper_jats_path)
    system("echo 'paper_jats_path=#{paper_jats_path}' >> $GITHUB_OUTPUT")
    system("echo 'Success! JATS file generated at: #{paper_jats_path}'")
  else
    raise "   !! ERROR: Failed to generate JATS file" if formats.include?("jats")
  end

  citation_file_path = File.dirname(paper_md_path)+"/CITATION.cff"
  if File.exist?(citation_file_path)
    system("echo 'citation_file_path=#{citation_file_path}' >> $GITHUB_OUTPUT")
    system("echo 'Success! CITATION.cff file generated at: #{citation_file_path}'")
  end
end


# Check for warnings presence
pdf_log_path = paper_pdf_path + ".log"
crossref_log_path = paper_crossref_path + ".log"
jats_log_path = paper_jats_path + ".log"

warning_msgs = []

log_files_paths = []
#log_files_paths << pdf_log_path if formats.include?("pdf")
log_files_paths << crossref_log_path if formats.include?("crossref")
log_files_paths << jats_log_path if formats.include?("jats")

begin
  log_files_paths.each do |log_file_path|
    if warning_msgs.empty? && File.exist?(log_file_path)
      logs = JSON.load_file(log_file_path)
      warnings = logs.select { |entry| entry["verbosity"].to_s.upcase == "WARNING" }
      warning_msgs = warnings.map {|w| w["message"]}.compact
    end
  end
rescue JSON::ParserError
  system("echo 'Error parsing file #{log_file_path}'")
end

# If warnings found post them to the GitHub issue
# if warning_msgs.empty?
#   system("echo 'Paper and metadata files generated successfully: 0 warnings'")
# else
#   warning_msg = <<~PAPERWARNINGS
#     The paper's PDF and metadata files generation produced some warnings that could prevent the final paper from being published. Please fix them before the end of the review process.
#     ```
#     #{warning_msgs.join("\n```\n\n```\n")}
#     ```
#   PAPERWARNINGS

#   File.open('oj_warnings.txt', 'w') do |f|
#     f.write warning_msg
#   end
#   system("gh issue comment #{ENV['ISSUE_ID']} --body-file oj_warnings.txt")
# end
