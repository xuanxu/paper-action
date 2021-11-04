paper_md_path = ARGV[0].to_s

if paper_md_path.empty?
  raise "   !! ERROR: The paper path is empty"
else
  paper_pdf_path = File.dirname(paper_md_path)+"/paper.pdf"
  if File.exist?(paper_pdf_path)
    system("echo '::set-output name=paper_pdf_path::#{paper_pdf_path}'")
    system("echo 'Success! PDF file generated at: #{paper_pdf_path}'")
  else
    raise "   !! ERROR: Failed to generate PDF file"
  end

  paper_jats_path = File.dirname(paper_md_path)+"/paper.jats"
  if File.exist?(paper_jats_path)
    system("echo '::set-output name=paper_jats_path::#{paper_jats_path}'")
    system("echo 'Success! JATS file generated at: #{paper_jats_path}'")
  else
    raise "   !! ERROR: Failed to generate JATS file"
  end
end

