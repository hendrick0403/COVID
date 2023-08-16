# COVID-19 final project
Title: **Repurposing Cancer Genomics Cloud for COVID-19 Research**

This repo contains all files related to workflow used in the project:\
-Code.cwl > the source code to be implemented in the cloud platform.\
-SRA_meta.txt > the file used to fetch all data in one execution turn.\
-SupplementaryFile.xlsx > the detailed result for each sample.\
-UShER.json > the file to visualize the phylogenetics tree.\
-UShER_meta.tsv > the additional metadata in visualizing the phylogenetics tree.\
-VirusViz.json.gz > the file to visualize the variant comparison.\
-viral.tar > the reference index used in the project

## How to Use
1. Login to [Cancer Genomics Cloud](https://cgc-accounts.sbgenomics.com/auth/login) platform.
2. Enter your own **Projects**.
3. On the top left menu, select **Apps** option.
4. Click **Add app** button on the top right corner.
5. Select **Create New App**,then click **Create a Workflow** button.
6. Type the workflow name, then click **Create** button.
7. Select **Code** to change the layout view.
8. Replace all appeared default code with our workflow code provided in this page called *Code.cwl*.
9. Click **Save and Run** button on the top right corner to make the workflow available in your own project.

## Related Publications
1. **Lim, H. G. M.**, Fann, Y. C., & Lee, Y. C. G. (2023). COWID: an efficient cloud-based genomics workflow for scalable identification of SARS-COV-2. *Briefings in Bioinformatics*, https://doi.org/10.1093/bib/bbad280.
2. **Lim, H. G. M.**, Hsiao, S. H., Fann, Y. C., & Lee, Y. C. G. (2022). Robust mutation profiling of SARS-CoV-2 variants from multiple raw illumina sequencing data with cloud workflow. *Genes*, https://doi.org/10.3390/genes13040686.
3. **Lim, H. G. M.**, Hsiao, S. H., & Lee, Y. C. G. (2021). Orchestrating an optimized next-generation sequencing-based cloud workflow for robust viral identification during pandemics. *Biology*, https://doi.org/10.3390/biology10101023.
4. **Lim, H. G. M.** & Lee, Y. C. G. (2020). Empowering cloud technology for SARS-CoV2 identification. *F1000Research*, https://doi.org/10.7490/f1000research.1118152.1.
