# Open Journals :: Paper

This action looks for a `paper.md` file in the specified repository and uses it to compile a Open Journals paper, generating PDF, Crossref XML and JATS outputs.

Under the hood it uses the [openjournals/inara action](https://github.com/openjournals/inara) to generate the output files.

## Usage

Usually this action is used as a step in a workflow that also includes other steps to upload or process the paper after it is generated.

### Inputs

The action accepts the following inputs:

- **issue_id**: Required. The review issue id of the submission for the paper.
- **repository_url**: Required. The repository URL of the submission containing the paper file.
- **branch**: Optional. Git branch where the paper is located.
- **journal**: Optional. The journal data to use for the paper. Default value is `joss`.
- **journal_template**: Optional. The journal template to compile the paper with. Default value is `joss`.
- **compile_mode**: Optional. Compile a draft PDF or a final accepted paper. Possible values are 'draft' (default) or 'accepted'.

### Outputs

- **pdf_path**: The path to the generated PDF file
- **jats_path**: The path to the generated JATS file
- **crossref_path**: The path to the generated Crossref XML file
- **citation_file_path**: The path to the generated CITATION.cff file (generated when compilation mode is 'accepted')
- **paper_file_path**: Path to the paper's .md/.tex source file
- **paper_title**: The title of the paper
- **track_name**: Parameterized name of the paper's track

### Example

Use it adding it as a step in a workflow `.yml` file in your repo's `.github/workflows/` directory and passing your custom input values.

````yaml
on:
  workflow_dispatch:
   inputs:
      issue_id:
        description: 'The issue number of the submission'
jobs:
  compiling:
    runs-on: ubuntu-latest
    steps:
      - name: Compile Paper
        uses: xuanxu/paper-action@main
        with:
          issue_id: {{ github.event.inputs.issue_id }}
          repository_url: http://github.com/${{ github.repository }}
          branch: docs
          journal: joss
```
