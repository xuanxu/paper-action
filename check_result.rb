paper_md_path = ARGV[0].to_s
formats = ARGV[1].to_s.downcase.split(",")

if paper_md_path.empty?
  raise "   !! ERROR: The paper path is empty"
else
  paper_pdf_path = File.dirname(paper_md_path)+"/paper.pdf"
  if File.exist?(paper_pdf_path)
    system("echo '::set-output name=paper_pdf_path::#{paper_pdf_path}'")
    system("echo 'Success! PDF file generated at: #{paper_pdf_path}'")
  else
    raise "   !! ERROR: Failed to generate PDF file" if formats.include?("pdf")
  end

  paper_crossref_path = File.dirname(paper_md_path)+"/paper.crossref"
  if File.exist?(paper_crossref_path)
    system("echo '::set-output name=paper_crossref_path::#{paper_crossref_path}'")
    system("echo 'Success! Crossref XML file generated at: #{paper_crossref_path}'")
  else
    raise "   !! ERROR: Failed to generate Crossref XML file" if formats.include?("crossref")
  end

  paper_jats_path = File.dirname(paper_md_path)+"/paper.jats"
  if File.exist?(paper_jats_path)
    system("echo '::set-output name=paper_jats_path::#{paper_jats_path}'")
    system("echo 'Success! JATS file generated at: #{paper_jats_path}'")
  else
    raise "   !! ERROR: Failed to generate JATS file" if formats.include?("jats")
  end
end

