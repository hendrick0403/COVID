{
    "class": "Workflow",
    "cwlVersion": "v1.2",
    "id": "hendrick.san/phd-finalproject/cowid/2",
    "label": "Cowid",
    "$namespaces": {
        "sbg": "https://sevenbridges.com"
    },
    "inputs": [
        {
            "id": "reference",
            "sbg:fileTypes": "FASTA, FA, FA.GZ, FASTA.GZ, TAR",
            "type": "File",
            "label": "Reference genome",
            "doc": "Input reference fasta of TAR file with reference and indices.",
            "sbg:x": -510.9156188964844,
            "sbg:y": 61.43376159667969
        },
        {
            "id": "input_reads",
            "sbg:fileTypes": "FASTQ, FASTQ.GZ, FQ, FQ.GZ",
            "type": "File[]",
            "label": "Input reads",
            "doc": "Input sequence reads.",
            "sbg:x": -513.5181884765625,
            "sbg:y": -370.4273681640625
        },
        {
            "id": "cache_file",
            "sbg:fileTypes": "TAR.GZ",
            "type": "File",
            "label": "Species annotation",
            "doc": "Cache file for the chosen species.",
            "sbg:x": -506.26495361328125,
            "sbg:y": 269.7831115722656
        },
        {
            "id": "centrifuge_index_archive",
            "sbg:fileTypes": "TAR, TAR.GZ",
            "type": "File",
            "label": "Reference index",
            "doc": "The basename of the index for the reference genomes. The basename is the name of any of the index files up to but not including the final .1.cf / etc. centrifuge looks for the specified index first in the current directory, then in the directory specified in the CENTRIFUGE_INDEXES environment variable.",
            "sbg:x": -513.0843505859375,
            "sbg:y": -207.72129821777344
        },
        {
            "id": "deduplication",
            "type": [
                "null",
                {
                    "type": "enum",
                    "symbols": [
                        "None",
                        "MarkDuplicates",
                        "RemoveDuplicates"
                    ],
                    "name": "deduplication"
                }
            ],
            "label": "PCR duplicate detection",
            "doc": "Use Biobambam2 for finding duplicates on sequence reads.",
            "sbg:exposed": true
        },
        {
            "id": "variant_class",
            "type": "boolean?",
            "label": "Output Sequence Ontology variant class",
            "doc": "Output the Sequence Ontology variant class. Not used by default.",
            "sbg:exposed": true
        },
        {
            "id": "pick",
            "type": "boolean?",
            "label": "Pick one line or block of consequence data per variant, including transcript-specific columns",
            "doc": "Pick one line or block of consequence data per variant, including transcript-specific columns. Consequences are chosen according to the criteria described here, and the order the criteria are applied may be customised with --pick_order. This is the best method to use if you are interested only in one consequence per variant. Not used by default.",
            "sbg:exposed": true
        },
        {
            "id": "species",
            "type": "string?",
            "label": "Species",
            "doc": "Species.",
            "sbg:exposed": true
        }
    ],
    "outputs": [
        {
            "id": "aligned_reads",
            "outputSource": [
                "bwa_mem_bundle_0_7_17/aligned_reads"
            ],
            "sbg:fileTypes": "SAM, BAM, CRAM",
            "type": "File?",
            "label": "Aligned BAM",
            "doc": "Aligned reads.",
            "sbg:x": 132.4631805419922,
            "sbg:y": -22.148195266723633
        },
        {
            "id": "output_file",
            "outputSource": [
                "bcftools_consensus/output_file"
            ],
            "sbg:fileTypes": "VCF, BCF, VCF.GZ, BCF.GZ",
            "type": "File?",
            "label": "Output genome",
            "doc": "Consensus sequence",
            "sbg:x": 685.4926147460938,
            "sbg:y": 24.482830047607422
        },
        {
            "id": "vep_output_file",
            "outputSource": [
                "variant_effect_predictor_101_0_cwl1_0/vep_output_file"
            ],
            "sbg:fileTypes": "VCF, TXT, JSON, TAB",
            "type": "File?",
            "label": "VEP output",
            "doc": "Output file (annotated VCF) from VEP.",
            "sbg:x": 686.9263305664062,
            "sbg:y": 146.44651794433594
        },
        {
            "id": "summary_file",
            "outputSource": [
                "variant_effect_predictor_101_0_cwl1_0/summary_file"
            ],
            "sbg:fileTypes": "HTML, TXT",
            "type": "File?",
            "label": "VEP summary",
            "doc": "Summary stats file, if requested.",
            "sbg:x": 685.5769653320312,
            "sbg:y": 262.6751708984375
        },
        {
            "id": "Centrifuge_report",
            "outputSource": [
                "centrifuge_classifier_1/Centrifuge_report"
            ],
            "sbg:fileTypes": "TSV",
            "type": "File?",
            "label": "Centrifuge report",
            "doc": "Centrifuge report.",
            "sbg:x": -42.25318908691406,
            "sbg:y": -322.4337463378906
        }
    ],
    "steps": [
        {
            "id": "bwa_index_0_7_17",
            "in": [
                {
                    "id": "reference",
                    "source": "reference"
                }
            ],
            "out": [
                {
                    "id": "indexed_reference"
                }
            ],
            "run": {
                "cwlVersion": "sbg:draft-2",
                "class": "CommandLineTool",
                "$namespaces": {
                    "sbg": "https://sevenbridges.com"
                },
                "id": "admin/sbg-public-data/bwa-index-0-7-17/2",
                "label": "BWA INDEX",
                "description": "BWA INDEX constructs the FM-index (Full-text index in Minute space) for the reference genome.\nGenerated index files will be used with BWA MEM, BWA ALN, BWA SAMPE and BWA SAMSE tools.\n\nIf input reference file has TAR extension it is assumed that BWA indices came together with it. BWA INDEX will only pass that TAR to the output. If input is not TAR, the creation of BWA indices and its packing in TAR file (together with the reference) will be performed.\n\nTAR also contains alt reference from bwa.kit suggested by the author of the tool for HG38 reference genome.",
                "baseCommand": [
                    {
                        "engine": "#cwl-js-engine",
                        "class": "Expression",
                        "script": "{\n  reference_file = $job.inputs.reference.path.split('/')[$job.inputs.reference.path.split('/').length-1]\n  ext = reference_file.split('.')[reference_file.split('.').length-1]\n  if(ext=='tar'){\n    return 'echo Index files passed without any processing!'\n  }\n  else{\n    \n    cp_alt_cmd = ''\n\n    if(!$job.inputs.do_not_add_alt_contig_to_reference){\n      if (reference_file.search('38') >= 0){\n        cp_alt_cmd = 'cp /opt/hs38DH.fa.alt ' + reference_file + '.alt ; '\n      }\n    }\n    \n    index_cmd = 'bwa index '+ reference_file + ' '\n    \n    return cp_alt_cmd + index_cmd\n  }\n}"
                    }
                ],
                "inputs": [
                    {
                        "sbg:category": "Configuration",
                        "sbg:toolDefaultValue": "auto",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "bwtsw",
                                    "is",
                                    "div"
                                ],
                                "name": "bwt_construction"
                            }
                        ],
                        "label": "Bwt construction",
                        "description": "Algorithm for constructing BWT index. Available options are:s\tIS linear-time algorithm for constructing suffix array. It requires 5.37N memory where N is the size of the database. IS is moderately fast, but does not work with database larger than 2GB. IS is the default algorithm due to its simplicity. The current codes for IS algorithm are reimplemented by Yuta Mori. bwtsw\tAlgorithm implemented in BWT-SW. This method works with the whole human genome. Warning: `-a bwtsw' does not work for short genomes, while `-a is' and `-a div' do not work not for long genomes.",
                        "id": "#bwt_construction"
                    },
                    {
                        "sbg:category": "Configuration",
                        "type": [
                            "null",
                            "string"
                        ],
                        "label": "Prefix of the index to be output",
                        "description": "Prefix of the index [same as fasta name].",
                        "id": "#prefix_of_the_index_to_be_output"
                    },
                    {
                        "sbg:category": "Configuration",
                        "sbg:toolDefaultValue": "10000000",
                        "type": [
                            "null",
                            "int"
                        ],
                        "label": "Block size",
                        "description": "Block size for the bwtsw algorithm (effective with -a bwtsw).",
                        "id": "#block_size"
                    },
                    {
                        "sbg:category": "Configuration",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "label": "Output index files renamed by adding 64",
                        "description": "Index files named as <in.fasta>64 instead of <in.fasta>.*.",
                        "id": "#add_64_to_fasta_name"
                    },
                    {
                        "sbg:category": "File input",
                        "sbg:stageInput": "link",
                        "type": [
                            "File"
                        ],
                        "label": "Reference",
                        "description": "Input reference fasta of TAR file with reference and indices.",
                        "sbg:fileTypes": "FASTA, FA, FA.GZ, FASTA.GZ, TAR",
                        "id": "#reference"
                    },
                    {
                        "sbg:category": "Configuration",
                        "type": [
                            "null",
                            "int"
                        ],
                        "label": "Total memory [Gb]",
                        "description": "Total memory [GB] to be reserved for the tool (Default value is 1.5 x size_of_the_reference).",
                        "id": "#total_memory"
                    },
                    {
                        "sbg:stageInput": null,
                        "sbg:toolDefaultValue": "False",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "label": "Do not add alt contigs file to TAR bundle",
                        "description": "Do not add alt contigs file to TAR bundle.",
                        "id": "#do_not_add_alt_contig_to_reference"
                    }
                ],
                "outputs": [
                    {
                        "type": [
                            "null",
                            "File"
                        ],
                        "label": "TARed fasta with its BWA indices",
                        "description": "TARed fasta with its BWA indices.",
                        "sbg:fileTypes": "TAR",
                        "outputBinding": {
                            "glob": {
                                "engine": "#cwl-js-engine",
                                "class": "Expression",
                                "script": "{\n  reference_file = $job.inputs.reference.path.split('/')[$job.inputs.reference.path.split('/').length-1]\n  ext = reference_file.split('.')[reference_file.split('.').length-1]\n  if(ext=='tar'){\n    return reference_file\n  }\n  else{\n    return reference_file + '.tar'\n  }\n}\n"
                            },
                            "sbg:metadata": {
                                "reference": {
                                    "engine": "#cwl-js-engine",
                                    "class": "Expression",
                                    "script": "{\n  path = [].concat($job.inputs.reference)[0].path.split('/')\n  last = path.pop()\n  return last\n}"
                                }
                            },
                            "sbg:inheritMetadataFrom": "#reference"
                        },
                        "id": "#indexed_reference"
                    }
                ],
                "requirements": [
                    {
                        "class": "ExpressionEngineRequirement",
                        "requirements": [
                            {
                                "class": "DockerRequirement",
                                "dockerPull": "rabix/js-engine"
                            }
                        ],
                        "id": "#cwl-js-engine"
                    }
                ],
                "hints": [
                    {
                        "class": "sbg:CPURequirement",
                        "value": 1
                    },
                    {
                        "class": "sbg:MemRequirement",
                        "value": {
                            "engine": "#cwl-js-engine",
                            "class": "Expression",
                            "script": "{\n  reference_file = $job.inputs.reference.path.split('/')[$job.inputs.reference.path.split('/').length-1]\n  ext = reference_file.split('.')[reference_file.split('.').length-1]\n  \n  GB_1 = 1024*1024*1024\n  reads_size = $job.inputs.reference.size\n\n  if(!reads_size) { reads_size = GB_1 }\n  \n  if($job.inputs.total_memory){\n    return $job.inputs.total_memory * 1024\n  } else if (ext=='tar'){\n    return 128\n  }\n    {\n    return (parseInt(1.5 * reads_size / (1024*1024)))\n  }\n}"
                        }
                    },
                    {
                        "class": "DockerRequirement",
                        "dockerImageId": "2f813371e803",
                        "dockerPull": "images.sbgenomics.com/vladimirk/bwa:0.7.17"
                    }
                ],
                "arguments": [
                    {
                        "position": 0,
                        "separate": true,
                        "valueFrom": {
                            "engine": "#cwl-js-engine",
                            "class": "Expression",
                            "script": "{\n  reference_file = $job.inputs.reference.path.split('/')[$job.inputs.reference.path.split('/').length-1]\n  ext = reference_file.split('.')[reference_file.split('.').length-1]\n  if(ext=='tar' || !$job.inputs.bwt_construction){\n    return ''\n  } else {\n    return '-a ' + $job.inputs.bwt_construction\n  }\n}"
                        }
                    },
                    {
                        "position": 0,
                        "separate": true,
                        "valueFrom": {
                            "engine": "#cwl-js-engine",
                            "class": "Expression",
                            "script": "{\n  reference_file = $job.inputs.reference.path.split('/')[$job.inputs.reference.path.split('/').length-1]\n  ext = reference_file.split('.')[reference_file.split('.').length-1]\n  if(ext=='tar' || !$job.inputs.prefix){\n    return ''\n  } else {\n    return '-p ' + $job.inputs.prefix\n  }\n}\n"
                        }
                    },
                    {
                        "position": 0,
                        "separate": true,
                        "valueFrom": {
                            "engine": "#cwl-js-engine",
                            "class": "Expression",
                            "script": "{\n  reference_file = $job.inputs.reference.path.split('/')[$job.inputs.reference.path.split('/').length-1]\n  ext = reference_file.split('.')[reference_file.split('.').length-1]\n  if(ext=='tar' || !$job.inputs.block_size){\n    return ''\n  } else {\n    return '-b ' + $job.inputs.block_size\n  }\n}\n\n"
                        }
                    },
                    {
                        "position": 0,
                        "separate": true,
                        "valueFrom": {
                            "engine": "#cwl-js-engine",
                            "class": "Expression",
                            "script": "{\n  reference_file = $job.inputs.reference.path.split('/')[$job.inputs.reference.path.split('/').length-1]\n  ext = reference_file.split('.')[reference_file.split('.').length-1]\n  if(ext=='tar' || !$job.inputs.add_64_to_fasta_name){\n    return ''\n  } else {\n    return '-6 '\n  }\n}\n"
                        }
                    },
                    {
                        "position": 0,
                        "separate": true,
                        "valueFrom": {
                            "engine": "#cwl-js-engine",
                            "class": "Expression",
                            "script": "{\n  reference_file = $job.inputs.reference.path.split('/')[$job.inputs.reference.path.split('/').length-1]\n  ext = reference_file.split('.')[reference_file.split('.').length-1]\n  if(ext=='tar'){\n    return ''\n  }\n  else{\n    extensions = ' *.amb' + ' *.ann' + ' *.bwt' + ' *.pac' + ' *.sa'\n    if(!$job.inputs.do_not_add_alt_contig_to_reference){\n      if (reference_file.search('38') >= 0){\n        extensions = extensions + ' *.alt ; '\n      }\n    }\n    tar_cmd = 'tar -cf ' + reference_file + '.tar ' + reference_file + extensions\n    return ' ; ' + tar_cmd\n  }\n}"
                        }
                    }
                ],
                "sbg:revisionsInfo": [
                    {
                        "sbg:revision": 0,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1558353195,
                        "sbg:revisionNotes": "Copy of vladimirk/bwa-mem-bundle-0-7-17-demo/bwa-index/3"
                    },
                    {
                        "sbg:revision": 1,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1558353196,
                        "sbg:revisionNotes": "With alt for hg38."
                    },
                    {
                        "sbg:revision": 2,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1649159193,
                        "sbg:revisionNotes": "update categories"
                    }
                ],
                "sbg:toolkit": "BWA",
                "sbg:links": [
                    {
                        "label": "Homepage",
                        "id": "http://bio-bwa.sourceforge.net/"
                    },
                    {
                        "label": "Source code",
                        "id": "https://github.com/lh3/bwa"
                    },
                    {
                        "label": "Wiki",
                        "id": "http://bio-bwa.sourceforge.net/bwa.shtml"
                    },
                    {
                        "label": "Download",
                        "id": "http://sourceforge.net/projects/bio-bwa/"
                    },
                    {
                        "label": "Publication",
                        "id": "http://www.ncbi.nlm.nih.gov/pubmed/19451168"
                    }
                ],
                "sbg:image_url": null,
                "sbg:job": {
                    "allocatedResources": {
                        "cpu": 1,
                        "mem": 1536
                    },
                    "inputs": {
                        "block_size": null,
                        "prefix_of_the_index_to_be_output": "prefix",
                        "total_memory": null,
                        "reference": {
                            "size": 0,
                            "class": "File",
                            "path": "/path/to/the/reference38.fasta",
                            "secondaryFiles": [
                                {
                                    "path": ".amb"
                                },
                                {
                                    "path": ".ann"
                                },
                                {
                                    "path": ".bwt"
                                },
                                {
                                    "path": ".pac"
                                },
                                {
                                    "path": ".sa"
                                }
                            ]
                        },
                        "do_not_add_alt_contig_to_reference": false,
                        "add_64_to_fasta_name": false,
                        "bwt_construction": null
                    }
                },
                "sbg:cmdPreview": "cp /opt/hs38DH.fa.alt reference38.fasta.alt ; bwa index reference38.fasta            ; tar -cf reference38.fasta.tar reference38.fasta *.amb *.ann *.bwt *.pac *.sa *.alt ;",
                "sbg:projectName": "SBG Public data",
                "sbg:license": "GNU Affero General Public License v3.0, MIT License",
                "sbg:toolAuthor": "Heng Li",
                "sbg:toolkitVersion": "0.7.17",
                "sbg:categories": [
                    "Indexing",
                    "FASTA Processing"
                ],
                "sbg:expand_workflow": false,
                "sbg:appVersion": [
                    "sbg:draft-2"
                ],
                "sbg:id": "admin/sbg-public-data/bwa-index-0-7-17/2",
                "sbg:revision": 2,
                "sbg:revisionNotes": "update categories",
                "sbg:modifiedOn": 1649159193,
                "sbg:modifiedBy": "admin",
                "sbg:createdOn": 1558353195,
                "sbg:createdBy": "admin",
                "sbg:project": "admin/sbg-public-data",
                "sbg:sbgMaintained": false,
                "sbg:validationErrors": [],
                "sbg:contributors": [
                    "admin"
                ],
                "sbg:latestRevision": 2,
                "sbg:publisher": "sbg",
                "sbg:content_hash": "ab238a3aa68961374e12b4b202542ff0b5a31c76eacff4cd1d85030523e5dd201",
                "sbg:workflowLanguage": "CWL"
            },
            "label": "BWA INDEX",
            "sbg:x": -242,
            "sbg:y": -48.216880798339844
        },
        {
            "id": "bwa_mem_bundle_0_7_17",
            "in": [
                {
                    "id": "reference_index_tar",
                    "source": "bwa_index_0_7_17/indexed_reference"
                },
                {
                    "id": "input_reads",
                    "source": [
                        "input_reads"
                    ]
                },
                {
                    "id": "deduplication",
                    "source": "deduplication"
                }
            ],
            "out": [
                {
                    "id": "aligned_reads"
                },
                {
                    "id": "dups_metrics"
                }
            ],
            "run": {
                "cwlVersion": "sbg:draft-2",
                "class": "CommandLineTool",
                "$namespaces": {
                    "sbg": "https://sevenbridges.com"
                },
                "id": "admin/sbg-public-data/bwa-mem-bundle-0-7-17/45",
                "label": "BWA MEM Bundle 0.7.17",
                "description": "**BWA-MEM** is an algorithm designed for aligning sequence reads onto a large reference genome. BWA-MEM is implemented as a component of BWA. The algorithm can automatically choose between performing end-to-end and local alignments. BWA-MEM is capable of outputting multiple alignments, and finding chimeric reads. It can be applied to a wide range of read lengths, from 70 bp to several megabases. \n\n## Common Use Cases\nIn order to obtain possibilities for additional fast processing of aligned reads, **Biobambam2 sortmadup** (2.0.87) tool is embedded together into the same package with BWA-MEM (0.7.17).\nIf deduplication of alignments is needed, it can be done by setting the parameter 'Duplication'. Biobambam2 sortmadup will be used internally to perform this action.\n\nBesides the standard BWA-MEM SAM output file, BWA-MEM package has been extended to support additional output options enabled by Biobambam2 sortmadup: BAM file, Coordinate Sorted BAM along with accompanying .bai file, queryname sorted BAM and CRAM. Sorted BAM is the default output of BWA-MEM. Parameter responsible for output type selection is *Output format*. Passing data from BWA-MEM to Biobambam2 sortmadup tool has been done through the linux pipes which saves processing times (up to an hour of the execution time for whole genome sample) of two read and write of aligned reads into the hard drive.\n\n## Common Issues and Important Notes\nFor input reads fastq files of total size less than 10 GB we suggest using the default setting for parameter 'total memory' of 15GB, for larger files we suggest using 58 GB of memory and 32 CPU cores.\n\nIn order to work BWA-MEM Bundle requires fasta reference file accompanied with **BWA Fasta indices** in TAR file.\n\nHuman reference genome version 38 comes with ALT contigs, a collection of diverged alleles present in some humans but not the others. Making effective use of these contigs will help to reduce mapping artifacts, however, to facilitate mapping these ALT contigs to the primary assembly, GRC decided to add to each contig long flanking sequences almost identical to the primary assembly. As a result, a naive mapping against GRCh38+ALT will lead to many mapQ-zero mappings in these flanking regions. Please use post-processing steps to fix these alignments or implement [steps](https://sourceforge.net/p/bio-bwa/mailman/message/32845712/) described by the author of BWA toolkit.\n\nWhen desired output is CRAM file without deduplication of the PCR duplicates, it is necessary to provide FASTA Index file as input.\n\nIf __Read group ID__ parameter is not defined, by default it will  be set to ‘1’. If the tool is scattered within a workflow it will assign the Read Group ID according to the order of the scattered folders. This ensures a unique Read Group ID when when processing multi-read group input data from one sample.",
                "baseCommand": [
                    {
                        "script": "{\n  cmd = \"/bin/bash -c \\\"\"\n  return cmd + \" export REF_CACHE=${PWD} ; \"\n}",
                        "class": "Expression",
                        "engine": "#cwl-js-engine"
                    },
                    {
                        "script": "{\n  reference_file = $job.inputs.reference_index_tar.path.split('/')[$job.inputs.reference_index_tar.path.split('/').length-1]\n  return 'tar -tvf ' +  reference_file + ' 1>&2; tar -xf ' + reference_file + ' ; '\n  \n}",
                        "class": "Expression",
                        "engine": "#cwl-js-engine"
                    },
                    "bwa",
                    "mem"
                ],
                "inputs": [
                    {
                        "sbg:category": "Input files",
                        "sbg:stageInput": "link",
                        "type": [
                            "File"
                        ],
                        "label": "Reference Index TAR",
                        "description": "Reference fasta file with BWA index files packed in TAR.",
                        "sbg:fileTypes": "TAR",
                        "id": "#reference_index_tar"
                    },
                    {
                        "sbg:category": "Input files",
                        "sbg:stageInput": "link",
                        "type": [
                            {
                                "type": "array",
                                "items": "File"
                            }
                        ],
                        "label": "Input reads",
                        "description": "Input sequence reads.",
                        "sbg:fileTypes": "FASTQ, FASTQ.GZ, FQ, FQ.GZ",
                        "id": "#input_reads"
                    },
                    {
                        "sbg:category": "Execution",
                        "sbg:toolDefaultValue": "8",
                        "type": [
                            "null",
                            "int"
                        ],
                        "label": "Threads",
                        "description": "Number of threads for BWA, Samblaster and Sambamba sort process.",
                        "id": "#threads"
                    },
                    {
                        "sbg:category": "BWA Algorithm options",
                        "sbg:toolDefaultValue": "19",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-k",
                            "separate": true,
                            "itemSeparator": "null",
                            "sbg:cmdInclude": true
                        },
                        "label": "Minimum seed length",
                        "description": "Minimum seed length for BWA MEM.",
                        "id": "#minimum_seed_length"
                    },
                    {
                        "sbg:category": "BWA Algorithm options",
                        "sbg:toolDefaultValue": "100",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-d",
                            "separate": true,
                            "itemSeparator": "null",
                            "sbg:cmdInclude": true
                        },
                        "label": "Dropoff",
                        "description": "Off-diagonal X-dropoff.",
                        "id": "#dropoff"
                    },
                    {
                        "sbg:category": "BWA Algorithm options",
                        "sbg:toolDefaultValue": "1.5",
                        "type": [
                            "null",
                            "float"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-r",
                            "separate": true,
                            "itemSeparator": "null",
                            "sbg:cmdInclude": true
                        },
                        "label": "Select seeds",
                        "description": "Look for internal seeds inside a seed longer than {-k} * FLOAT.",
                        "id": "#select_seeds"
                    },
                    {
                        "sbg:category": "BWA Algorithm options",
                        "sbg:toolDefaultValue": "20",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-y",
                            "separate": true,
                            "itemSeparator": "null",
                            "sbg:cmdInclude": true
                        },
                        "label": "Seed occurrence for the 3rd round",
                        "description": "Seed occurrence for the 3rd round seeding.",
                        "id": "#seed_occurrence_for_the_3rd_round"
                    },
                    {
                        "sbg:category": "BWA Algorithm options",
                        "sbg:toolDefaultValue": "500",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-c",
                            "separate": true,
                            "itemSeparator": "null",
                            "sbg:cmdInclude": true
                        },
                        "label": "Skip seeds with more than INT occurrences",
                        "description": "Skip seeds with more than INT occurrences.",
                        "id": "#skip_seeds"
                    },
                    {
                        "sbg:category": "BWA Algorithm options",
                        "sbg:toolDefaultValue": "0.50",
                        "type": [
                            "null",
                            "float"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-D",
                            "separate": true,
                            "itemSeparator": "null",
                            "sbg:cmdInclude": true
                        },
                        "label": "Drop chains fraction",
                        "description": "Drop chains shorter than FLOAT fraction of the longest overlapping chain.",
                        "id": "#drop_chains_fraction"
                    },
                    {
                        "sbg:category": "BWA Algorithm options",
                        "sbg:toolDefaultValue": "0",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-W",
                            "separate": true,
                            "itemSeparator": "null",
                            "sbg:cmdInclude": true
                        },
                        "label": "Discard chain length",
                        "description": "Discard a chain if seeded bases shorter than INT.",
                        "id": "#discard_chain_length"
                    },
                    {
                        "sbg:category": "BWA Algorithm options",
                        "sbg:toolDefaultValue": "50",
                        "type": [
                            "null",
                            "string"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-m",
                            "separate": true,
                            "itemSeparator": "null",
                            "sbg:cmdInclude": true
                        },
                        "label": "Mate rescue rounds",
                        "description": "Perform at most INT rounds of mate rescues for each read.",
                        "id": "#mate_rescue_rounds"
                    },
                    {
                        "sbg:category": "BWA Algorithm options",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-S",
                            "separate": true,
                            "itemSeparator": "null",
                            "sbg:cmdInclude": true
                        },
                        "label": "Skip mate rescue",
                        "description": "Skip mate rescue.",
                        "id": "#skip_mate_rescue"
                    },
                    {
                        "sbg:category": "BWA Algorithm options",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-P",
                            "separate": true,
                            "itemSeparator": "null",
                            "sbg:cmdInclude": true
                        },
                        "label": "Skip pairing",
                        "description": "Skip pairing; mate rescue performed unless -S also in use.",
                        "id": "#skip_pairing"
                    },
                    {
                        "sbg:category": "BWA Algorithm options",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-e",
                            "separate": true,
                            "itemSeparator": "null",
                            "sbg:cmdInclude": true
                        },
                        "label": "Discard exact matches",
                        "description": "Discard full-length exact matches.",
                        "id": "#discard_exact_matches"
                    },
                    {
                        "sbg:category": "BWA Scoring options",
                        "sbg:toolDefaultValue": "1",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-A",
                            "separate": true,
                            "itemSeparator": "null",
                            "sbg:cmdInclude": true
                        },
                        "label": "Score for a sequence match",
                        "description": "Score for a sequence match, which scales options -TdBOELU unless overridden.",
                        "id": "#score_for_a_sequence_match"
                    },
                    {
                        "sbg:category": "BWA Scoring options",
                        "sbg:toolDefaultValue": "4",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-B",
                            "separate": true,
                            "itemSeparator": "null",
                            "sbg:cmdInclude": true
                        },
                        "label": "Mismatch penalty",
                        "description": "Penalty for a mismatch.",
                        "id": "#mismatch_penalty"
                    },
                    {
                        "sbg:category": "BWA Input/output options",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-p",
                            "separate": true,
                            "itemSeparator": "null",
                            "sbg:cmdInclude": true
                        },
                        "label": "Smart pairing in input FASTQ file",
                        "description": "Smart pairing in input FASTQ file (ignoring in2.fq).",
                        "id": "#smart_pairing_in_input_fastq"
                    },
                    {
                        "sbg:category": "BWA Read Group Options",
                        "sbg:toolDefaultValue": "Constructed from per-attribute parameters or inferred from metadata.",
                        "type": [
                            "null",
                            "string"
                        ],
                        "label": "Read group header",
                        "description": "Read group header line such as '@RG\\tID:foo\\tSM:bar'.  This value takes precedence over per-attribute parameters.",
                        "id": "#read_group_header"
                    },
                    {
                        "sbg:category": "BWA Input/output options",
                        "type": [
                            "null",
                            "string"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-H",
                            "separate": true,
                            "itemSeparator": "null",
                            "sbg:cmdInclude": true
                        },
                        "label": "Insert string to output SAM or BAM header",
                        "description": "Insert STR to header if it starts with @; or insert lines in FILE.",
                        "id": "#insert_string_to_header"
                    },
                    {
                        "sbg:category": "BWA Input/output options",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-j",
                            "separate": true,
                            "itemSeparator": "null",
                            "sbg:cmdInclude": true
                        },
                        "label": "Ignore ALT file",
                        "description": "Treat ALT contigs as part of the primary assembly (i.e. ignore <idxbase>.alt file).",
                        "id": "#ignore_alt_file"
                    },
                    {
                        "sbg:category": "BWA Input/output options",
                        "sbg:toolDefaultValue": "3",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "1",
                                    "2",
                                    "3",
                                    "4"
                                ],
                                "name": "verbose_level"
                            }
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-v",
                            "separate": true,
                            "itemSeparator": "null",
                            "sbg:cmdInclude": true
                        },
                        "label": "Verbose level",
                        "description": "Verbose level: 1=error, 2=warning, 3=message, 4+=debugging.",
                        "id": "#verbose_level"
                    },
                    {
                        "sbg:category": "BWA Input/output options",
                        "sbg:toolDefaultValue": "30",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-T",
                            "separate": true,
                            "itemSeparator": "null",
                            "sbg:cmdInclude": true
                        },
                        "label": "Minimum alignment score for a read to be output in SAM/BAM",
                        "description": "Minimum alignment score for a read to be output in SAM/BAM.",
                        "id": "#minimum_output_score"
                    },
                    {
                        "sbg:category": "BWA Input/output options",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-a",
                            "separate": true,
                            "itemSeparator": "null",
                            "sbg:cmdInclude": true
                        },
                        "label": "Output alignments",
                        "description": "Output all alignments for SE or unpaired PE.",
                        "id": "#output_alignments"
                    },
                    {
                        "sbg:category": "BWA Input/output options",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-C",
                            "separate": true,
                            "itemSeparator": "null",
                            "sbg:cmdInclude": true
                        },
                        "label": "Append comment",
                        "description": "Append FASTA/FASTQ comment to SAM output.",
                        "id": "#append_comment"
                    },
                    {
                        "sbg:category": "BWA Input/output options",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-V",
                            "separate": true,
                            "itemSeparator": "null",
                            "sbg:cmdInclude": true
                        },
                        "label": "Output header",
                        "description": "Output the reference FASTA header in the XR tag.",
                        "id": "#output_header"
                    },
                    {
                        "sbg:category": "BWA Input/output options",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-Y",
                            "separate": true,
                            "itemSeparator": "null",
                            "sbg:cmdInclude": true
                        },
                        "label": "Use soft clipping",
                        "description": "Use soft clipping for supplementary alignments.",
                        "id": "#use_soft_clipping"
                    },
                    {
                        "sbg:category": "BWA Input/output options",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-M",
                            "separate": true,
                            "itemSeparator": "null",
                            "sbg:cmdInclude": true
                        },
                        "label": "Mark shorter",
                        "description": "Mark shorter split hits as secondary.",
                        "id": "#mark_shorter"
                    },
                    {
                        "sbg:category": "BWA Scoring options",
                        "sbg:toolDefaultValue": "[6,6]",
                        "type": [
                            "null",
                            {
                                "type": "array",
                                "items": "int"
                            }
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-O",
                            "separate": false,
                            "itemSeparator": ",",
                            "sbg:cmdInclude": true
                        },
                        "label": "Gap open penalties",
                        "description": "Gap open penalties for deletions and insertions. This array can't have more than two values.",
                        "id": "#gap_open_penalties"
                    },
                    {
                        "sbg:category": "BWA Scoring options",
                        "sbg:toolDefaultValue": "[1,1]",
                        "type": [
                            "null",
                            {
                                "type": "array",
                                "items": "int"
                            }
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-E",
                            "separate": false,
                            "itemSeparator": ",",
                            "sbg:cmdInclude": true
                        },
                        "label": "Gap extension",
                        "description": "Gap extension penalty; a gap of size k cost '{-O} + {-E}*k'. This array can't have more than two values.",
                        "id": "#gap_extension_penalties"
                    },
                    {
                        "sbg:category": "BWA Scoring options",
                        "sbg:toolDefaultValue": "[5,5]",
                        "type": [
                            "null",
                            {
                                "type": "array",
                                "items": "int"
                            }
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-L",
                            "separate": false,
                            "itemSeparator": ",",
                            "sbg:cmdInclude": true
                        },
                        "label": "Clipping penalty",
                        "description": "Penalty for 5'- and 3'-end clipping.",
                        "id": "#clipping_penalty"
                    },
                    {
                        "sbg:category": "BWA Scoring options",
                        "sbg:toolDefaultValue": "17",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-U",
                            "separate": true,
                            "itemSeparator": "null",
                            "sbg:cmdInclude": true
                        },
                        "label": "Unpaired read penalty",
                        "description": "Penalty for an unpaired read pair.",
                        "id": "#unpaired_read_penalty"
                    },
                    {
                        "sbg:category": "BWA Scoring options",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "pacbio",
                                    "ont2d",
                                    "intractg"
                                ],
                                "name": "read_type"
                            }
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-x",
                            "separate": true,
                            "itemSeparator": "null",
                            "sbg:cmdInclude": true
                        },
                        "label": "Sequencing technology-specific settings",
                        "description": "Sequencing technology-specific settings; Setting -x changes multiple parameters unless overriden. pacbio: -k17 -W40 -r10 -A1 -B1 -O1 -E1 -L0  (PacBio reads to ref). ont2d: -k14 -W20 -r10 -A1 -B1 -O1 -E1 -L0  (Oxford Nanopore 2D-reads to ref). intractg: -B9 -O16 -L5  (intra-species contigs to ref).",
                        "id": "#read_type"
                    },
                    {
                        "sbg:category": "BWA Input/output options",
                        "sbg:toolDefaultValue": "[5, 200]",
                        "type": [
                            "null",
                            {
                                "type": "array",
                                "items": "int"
                            }
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-h",
                            "separate": false,
                            "itemSeparator": ",",
                            "sbg:cmdInclude": true
                        },
                        "label": "Output in XA",
                        "description": "If there are <INT hits with score >80% of the max score, output all in XA. This array should have no more than two values.",
                        "id": "#output_in_xa"
                    },
                    {
                        "sbg:category": "BWA Input/output options",
                        "type": [
                            "null",
                            {
                                "type": "array",
                                "items": "float"
                            }
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-I",
                            "separate": false,
                            "itemSeparator": "null",
                            "sbg:cmdInclude": true
                        },
                        "label": "Specify distribution parameters",
                        "description": "Specify the mean, standard deviation (10% of the mean if absent), max (4 sigma from the mean if absent) and min of the insert size distribution.FR orientation only. This array can have maximum four values, where first two should be specified as FLOAT and last two as INT.",
                        "id": "#speficy_distribution_parameters"
                    },
                    {
                        "sbg:category": "BWA Algorithm options",
                        "sbg:toolDefaultValue": "100",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-w",
                            "separate": true,
                            "itemSeparator": "null",
                            "sbg:cmdInclude": true
                        },
                        "label": "Band width",
                        "description": "Band width for banded alignment.",
                        "id": "#band_width"
                    },
                    {
                        "sbg:category": "BWA Read Group Options",
                        "sbg:toolDefaultValue": "Inferred from metadata",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "454",
                                    "Helicos",
                                    "Illumina",
                                    "Solid",
                                    "IonTorrent"
                                ],
                                "name": "rg_platform"
                            }
                        ],
                        "label": "Platform",
                        "description": "Specify the version of the technology that was used for sequencing, which will be placed in RG line.",
                        "id": "#rg_platform"
                    },
                    {
                        "sbg:category": "BWA Read Group Options",
                        "sbg:toolDefaultValue": "Inferred from metadata",
                        "type": [
                            "null",
                            "string"
                        ],
                        "label": "Sample ID",
                        "description": "Specify the sample ID for RG line - A human readable identifier for a sample or specimen, which could contain some metadata information. A sample or specimen is material taken from a biological entity for testing, diagnosis, propagation, treatment, or research purposes, including but not limited to tissues, body fluids, cells, organs, embryos, body excretory products, etc.",
                        "id": "#rg_sample_id"
                    },
                    {
                        "sbg:category": "BWA Read Group Options",
                        "sbg:toolDefaultValue": "Inferred from metadata",
                        "type": [
                            "null",
                            "string"
                        ],
                        "label": "Library ID",
                        "description": "Specify the identifier for the sequencing library preparation, which will be placed in RG line.",
                        "id": "#rg_library_id"
                    },
                    {
                        "sbg:category": "BWA Read Group Options",
                        "sbg:toolDefaultValue": "Inferred from metadata",
                        "type": [
                            "null",
                            "string"
                        ],
                        "label": "Platform unit ID",
                        "description": "Specify the platform unit (lane/slide) for RG line - An identifier for lanes (Illumina), or for slides (SOLiD) in the case that a library was split and ran over multiple lanes on the flow cell or slides.",
                        "id": "#rg_platform_unit_id"
                    },
                    {
                        "sbg:category": "BWA Read Group Options",
                        "type": [
                            "null",
                            "string"
                        ],
                        "label": "Data submitting center",
                        "description": "Specify the data submitting center for RG line.",
                        "id": "#rg_data_submitting_center"
                    },
                    {
                        "sbg:category": "BWA Read Group Options",
                        "type": [
                            "null",
                            "string"
                        ],
                        "label": "Median fragment length",
                        "description": "Specify the median fragment length for RG line.",
                        "id": "#rg_median_fragment_length"
                    },
                    {
                        "sbg:category": "Execution",
                        "sbg:toolDefaultValue": "Coordinate Sorted BAM",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "SAM",
                                    "BAM",
                                    "CRAM",
                                    "Queryname Sorted BAM",
                                    "Queryname Sorted SAM",
                                    "Coordinate Sorted BAM"
                                ],
                                "name": "output_format"
                            }
                        ],
                        "label": "Output format",
                        "description": "Cordinate sort is default output.",
                        "id": "#output_format"
                    },
                    {
                        "sbg:category": "Execution",
                        "type": [
                            "null",
                            "int"
                        ],
                        "label": "Memory for BAM sorting",
                        "description": "Amount of RAM [Gb] to give to the sorting algorithm (if not provided will be set to one third of the total memory).",
                        "id": "#sort_memory"
                    },
                    {
                        "sbg:category": "Biobambam2 parameters",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "None",
                                    "MarkDuplicates",
                                    "RemoveDuplicates"
                                ],
                                "name": "deduplication"
                            }
                        ],
                        "label": "PCR duplicate detection",
                        "description": "Use Biobambam2 for finding duplicates on sequence reads.",
                        "id": "#deduplication"
                    },
                    {
                        "sbg:category": "Execution",
                        "sbg:stageInput": null,
                        "sbg:toolDefaultValue": "15",
                        "type": [
                            "null",
                            "int"
                        ],
                        "label": "Total memory",
                        "description": "Total memory to be used by the tool in GB. It's sum of BWA, Sambamba Sort and Samblaster. For fastq files of total size less than 10GB, we suggest using the default setting of 15GB, for larger files we suggest using 58GB of memory (and 32CPU cores).",
                        "id": "#total_memory"
                    },
                    {
                        "sbg:category": "Execution",
                        "sbg:stageInput": null,
                        "sbg:toolDefaultValue": "False",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "label": "Filter out secondary alignments",
                        "description": "Filter out secondary alignments. Sambamba view tool will be used to perform this internally.",
                        "id": "#filter_out_secondary_alignments"
                    },
                    {
                        "sbg:category": "Configuration",
                        "type": [
                            "null",
                            "string"
                        ],
                        "label": "Output SAM/BAM file name",
                        "description": "Name of the output BAM file.",
                        "id": "#output_name"
                    },
                    {
                        "sbg:category": "Configuration",
                        "sbg:stageInput": null,
                        "sbg:toolDefaultValue": "1",
                        "type": [
                            "null",
                            "int"
                        ],
                        "label": "Reserved number of threads on the instance",
                        "description": "Reserved number of threads on the instance used by scheduler.",
                        "id": "#reserved_threads"
                    },
                    {
                        "sbg:category": "Configuration",
                        "sbg:toolDefaultValue": "1",
                        "type": [
                            "null",
                            "string"
                        ],
                        "label": "Read group ID",
                        "description": "Read group ID",
                        "id": "#rg_id"
                    },
                    {
                        "sbg:category": "Execution",
                        "sbg:stageInput": null,
                        "sbg:toolDefaultValue": "False",
                        "type": [
                            "null",
                            "int"
                        ],
                        "label": "Optimize threads for HG38",
                        "description": "Lower the number of threads if HG38 reference genome is used.",
                        "id": "#wgs_hg38_mode_threads"
                    },
                    {
                        "sbg:stageInput": null,
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-5",
                            "separate": true,
                            "itemSeparator": "null",
                            "sbg:cmdInclude": true
                        },
                        "label": "Split alignment smallest coordinate as primary",
                        "description": "for split alignment, take the alignment with the smallest coordinate as primary.",
                        "id": "#split_alignment_primary"
                    },
                    {
                        "sbg:stageInput": null,
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-q",
                            "separate": true,
                            "itemSeparator": "null",
                            "sbg:cmdInclude": true
                        },
                        "label": "Don't modify mapQ of supplementary alignments",
                        "description": "Don't modify mapQ of supplementary alignments",
                        "id": "#mapQ_of_suplementary"
                    },
                    {
                        "sbg:stageInput": null,
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-K",
                            "separate": true,
                            "itemSeparator": "null",
                            "sbg:cmdInclude": true
                        },
                        "label": "process INT input bases in each batch (for reproducibility)",
                        "description": "process INT input bases in each batch regardless of nThreads (for reproducibility)",
                        "id": "#num_input_bases_in_each_batch"
                    },
                    {
                        "sbg:stageInput": "copy",
                        "type": [
                            "null",
                            "File"
                        ],
                        "inputBinding": {
                            "position": 4,
                            "separate": true,
                            "itemSeparator": "null",
                            "valueFrom": {
                                "class": "Expression",
                                "engine": "#cwl-js-engine",
                                "script": "{\n    return \"\";\n}"
                            }
                        },
                        "label": "Fasta Index file for CRAM output",
                        "description": "Fasta index file is required for CRAM output when no PCR Deduplication is selected.",
                        "sbg:fileTypes": "FAI",
                        "id": "#fasta_index"
                    }
                ],
                "outputs": [
                    {
                        "type": [
                            "null",
                            "File"
                        ],
                        "label": "Aligned SAM/BAM",
                        "description": "Aligned reads.",
                        "sbg:fileTypes": "SAM, BAM, CRAM",
                        "outputBinding": {
                            "glob": "{*.sam,*.bam,*.cram}",
                            "sbg:metadata": {
                                "reference_genome": {
                                    "script": "{\n  reference_file = $job.inputs.reference_index_tar.path.split('/')[$job.inputs.reference_index_tar.path.split('/').length-1]\n  name = reference_file.slice(0, -4) // cut .tar extension \n  \n  name_list = name.split('.')\n  ext = name_list[name_list.length-1]\n\n  if (ext == 'gz' || ext == 'GZ'){\n    a = name_list.pop() // strip fasta.gz\n    a = name_list.pop()\n  } else\n    a = name_list.pop() //strip only fasta/fa\n  \n  return name_list.join('.')\n  \n}",
                                    "class": "Expression",
                                    "engine": "#cwl-js-engine"
                                }
                            },
                            "sbg:inheritMetadataFrom": "#input_reads",
                            "secondaryFiles": [
                                ".bai",
                                "^.bai",
                                ".crai",
                                "^.crai"
                            ]
                        },
                        "id": "#aligned_reads"
                    },
                    {
                        "type": [
                            "null",
                            "File"
                        ],
                        "label": "Sormadup metrics",
                        "description": "Metrics file for biobambam mark duplicates",
                        "sbg:fileTypes": "LOG",
                        "outputBinding": {
                            "glob": "*.sormadup_metrics.log"
                        },
                        "id": "#dups_metrics"
                    }
                ],
                "requirements": [
                    {
                        "class": "ExpressionEngineRequirement",
                        "id": "#cwl-js-engine",
                        "requirements": [
                            {
                                "class": "DockerRequirement",
                                "dockerPull": "rabix/js-engine"
                            }
                        ]
                    }
                ],
                "hints": [
                    {
                        "class": "sbg:CPURequirement",
                        "value": {
                            "script": "{  \n  // Calculate suggested number of CPUs depending of the input reads size\n  if ($job.inputs.input_reads.constructor == Array){\n    if ($job.inputs.input_reads[1]){\n      reads_size = $job.inputs.input_reads[0].size + $job.inputs.input_reads[1].size\n    } else{\n      reads_size = $job.inputs.input_reads[0].size\n    }\n  }\n  else{\n    reads_size = $job.inputs.input_reads.size\n  }\n  if(!reads_size) { reads_size = 0 }\n\n\n  GB_1 = 1024*1024*1024\n  if(reads_size < GB_1){ suggested_cpus = 1 }\n  else if(reads_size < 10 * GB_1){ suggested_cpus = 8 }\n  else { suggested_cpus = 31 }\n  \n  if($job.inputs.reserved_threads){ return $job.inputs.reserved_threads }\n  else if($job.inputs.threads){ return $job.inputs.threads } \n  else if($job.inputs.sambamba_threads) { return $job.inputs.sambamba_threads }\n  else{    return suggested_cpus  }\n}",
                            "class": "Expression",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "class": "sbg:MemRequirement",
                        "value": {
                            "script": "{  \n\n  // Calculate suggested number of CPUs depending of the input reads size\n  if ($job.inputs.input_reads.constructor == Array){\n    if ($job.inputs.input_reads[1]){\n      reads_size = $job.inputs.input_reads[0].size + $job.inputs.input_reads[1].size\n    } else{\n      reads_size = $job.inputs.input_reads[0].size\n    }\n  }\n  else{\n    reads_size = $job.inputs.input_reads.size\n  }\n  if(!reads_size) { reads_size = 0 }\n \n  GB_1 = 1024*1024*1024\n  if(reads_size < GB_1){ suggested_memory = 4 }\n  else if(reads_size < 10 * GB_1){ suggested_memory = 15 }\n  else { suggested_memory = 58 }\n  \n  if($job.inputs.total_memory){  \t\n    return  $job.inputs.total_memory* 1024  \n  } \n  else if($job.inputs.sort_memory){\n    return  $job.inputs.sort_memory* 1024\n  }\n  else{  \t\n    return suggested_memory * 1024  \n  }\n}",
                            "class": "Expression",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "class": "DockerRequirement",
                        "dockerPull": "images.sbgenomics.com/vladimirk/bwa_biobambam2:0.7.17"
                    }
                ],
                "arguments": [
                    {
                        "position": 112,
                        "prefix": "",
                        "separate": false,
                        "itemSeparator": "null",
                        "valueFrom": {
                            "class": "Expression",
                            "engine": "#cwl-js-engine",
                            "script": "{\n  ///////////////////////////////////////////\n ///  BIOBAMBAM BAMSORMADUP   //////////////////////\n///////////////////////////////////////////\n  \nfunction common_substring(a,b) {\n  var i = 0;\n  while(a[i] === b[i] && i < a.length)\n  {\n    i = i + 1;\n  }\n\n  return a.slice(0, i);\n}\n\n   // Set output file name\n  if($job.inputs.input_reads[0] instanceof Array){\n    input_1 = $job.inputs.input_reads[0][0] // scatter mode\n    input_2 = $job.inputs.input_reads[0][1]\n  } else if($job.inputs.input_reads instanceof Array){\n    input_1 = $job.inputs.input_reads[0]\n    input_2 = $job.inputs.input_reads[1]\n  }else {\n    input_1 = [].concat($job.inputs.input_reads)[0]\n    input_2 = input_1\n  }\n  full_name = input_1.path.split('/')[input_1.path.split('/').length-1] \n  \n  if($job.inputs.output_name){name = $job.inputs.output_name }\n  else if ($job.inputs.input_reads.length == 1){\n    name = full_name\n    if(name.slice(-3, name.length) === '.gz' || name.slice(-3, name.length) === '.GZ')\n      name = name.slice(0, -3)   \n    if(name.slice(-3, name.length) === '.fq' || name.slice(-3, name.length) === '.FQ')\n      name = name.slice(0, -3)\n    if(name.slice(-6, name.length) === '.fastq' || name.slice(-6, name.length) === '.FASTQ')\n      name = name.slice(0, -6)\n       \n  }else{\n    full_name2 = input_2.path.split('/')[input_2.path.split('/').length-1] \n    name = common_substring(full_name, full_name2)\n    \n    if(name.slice(-1, name.length) === '_' || name.slice(-1, name.length) === '.')\n      name = name.slice(0, -1)\n    if(name.slice(-2, name.length) === 'p_' || name.slice(-1, name.length) === 'p.')\n      name = name.slice(0, -2)\n    if(name.slice(-2, name.length) === 'P_' || name.slice(-1, name.length) === 'P.')\n      name = name.slice(0, -2)\n    if(name.slice(-3, name.length) === '_p_' || name.slice(-3, name.length) === '.p.')\n      name = name.slice(0, -3)\n    if(name.slice(-3, name.length) === '_pe' || name.slice(-3, name.length) === '.pe')\n      name = name.slice(0, -3)\n  }\n\n  //////////////////////////\n  // Set sort memory size\n  \n  reads_size = 0 // Not used because of situations when size does not exist!\n  GB_1 = 1024*1024*1024\n  if(reads_size < GB_1){ \n    suggested_memory = 4\n    suggested_cpus = 1\n  }\n  else if(reads_size < 10 * GB_1){ \n    suggested_memory = 15\n    suggested_cpus = 8\n  }\n  else { \n    suggested_memory = 58 \n    suggested_cpus = 31\n  }\n  \n  \n  if(!$job.inputs.total_memory){ total_memory = suggested_memory }\n  else{ total_memory = $job.inputs.total_memory }\n\n  // TODO:Rough estimation, should be fine-tuned!\n  if(total_memory > 16){ sorter_memory = parseInt(total_memory / 3) }\n  else{ sorter_memory = 5 }\n          \n  if ($job.inputs.sort_memory){\n    sorter_memory_string = $job.inputs.sort_memory +'GiB'\n  }\n  else sorter_memory_string = sorter_memory + 'GiB' \n  \n  // Read number of threads if defined\n  if ($job.inputs.threads){\n    threads = $job.inputs.threads\n  }\n  else if ($job.inputs.wgs_hg38_mode_threads){\n    MAX_THREADS = 36\n    ref_name_arr = $job.inputs.reference_index_tar.path.split('/')\n    ref_name = ref_name_arr[ref_name_arr.length - 1]\n    if (ref_name.search('38') >= 0){threads = $job.inputs.wgs_hg38_mode_threads}\n    else {threads = MAX_THREADS}\n  }\n  else { threads = 8 }\n  \n  \n  \nif ($job.inputs.deduplication == \"MarkDuplicates\") {\n    tool = 'bamsormadup'\n    dedup = ' markduplicates=1'\n} else {\n    if ($job.inputs.output_format == 'CRAM') {\n        tool = 'bamsort index=0'\n    } else {\n        tool = 'bamsort index=1'\n    }\n    if ($job.inputs.deduplication == \"RemoveDuplicates\") {\n        dedup = ' rmdup=1'\n    } else {\n        dedup = ''\n    }\n}\nsort_path = tool + dedup\n  \n  indexfilename = ' '\n  // Coordinate Sorted BAM is default\n  if ($job.inputs.output_format == 'CRAM'){\n    out_format = ' outputformat=cram SO=coordinate'\n    ref_name_arr = $job.inputs.reference_index_tar.path.split('/')\n    ref_name = ref_name_arr[ref_name_arr.length - 1].split('.tar')[0]\n    out_format += ' reference=' + ref_name\n    if (sort_path != 'bamsort index=0') {\n            indexfilename = ' indexfilename=' + name + '.cram.crai'\n        }\n    extension = '.cram'    \n  }else if($job.inputs.output_format == 'SAM'){\n    out_format = ' outputformat=sam SO=coordinate'\n    extension = '.sam'    \n  }else if ($job.inputs.output_format == 'Queryname Sorted BAM'){\n    out_format = ' outputformat=bam SO=queryname'\n    extension = '.bam'\n  }else if ($job.inputs.output_format == 'Queryname Sorted SAM'){\n    out_format = ' outputformat=sam SO=queryname'\n    extension = '.sam'    \n  }else {\n    out_format = ' outputformat=bam SO=coordinate'\n    indexfilename = ' indexfilename=' + name + '.bam.bai'\n    extension = '.bam'\n  }\n    cmd = \" | \" + sort_path + \" threads=\" + threads + \" level=1 tmplevel=-1 inputformat=sam\" \n    cmd += out_format\n    cmd += indexfilename\n    // capture metrics file\n    cmd += \" M=\" + name + \".sormadup_metrics.log\"\n    \n    if($job.inputs.output_format == 'SAM'){\n        cmd = ''\n    }\n    return cmd + ' > ' + name + extension\n\n}\n  \n"
                        }
                    },
                    {
                        "position": 1,
                        "prefix": "",
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "engine": "#cwl-js-engine",
                            "script": "{\n  \n  if($job.inputs.read_group_header){\n  \treturn '-R ' + $job.inputs.read_group_header\n  }\n    \n  function add_param(key, val){\n    if(!val){\n      return\n\t}\n    param_list.push(key + ':' + val)\n  }\n\n  param_list = []\n\n  // Set output file name\n  if($job.inputs.input_reads[0] instanceof Array){\n    input_1 = $job.inputs.input_reads[0][0] // scatter mode\n  } else if($job.inputs.input_reads instanceof Array){\n    input_1 = $job.inputs.input_reads[0]\n  }else {\n    input_1 = [].concat($job.inputs.input_reads)[0]\n  }\n  \n  //Read metadata for input reads\n  read_metadata = input_1.metadata\n  if(!read_metadata) read_metadata = []\n  \n  // Used for scatter mode\n  var folder = input_1.path.split('/').slice(-2,-1).toString();\n  var suffix = \"_s\"\n \n  if($job.inputs.rg_id){\n    add_param('ID', $job.inputs.rg_id)\n  } else if (folder.indexOf(suffix, folder.length - suffix.length) !== -1) { // scatter mode\n        var rg = folder.split(\"_\").slice(-2)[0]\n        if (parseInt(rg)) add_param('ID', rg)\n        else add_param('ID', 1)\n    }\n  else {\n    add_param('ID', '1')\n  } \n   \n  \n  if($job.inputs.rg_data_submitting_center){\n  \tadd_param('CN', $job.inputs.rg_data_submitting_center)\n  }\n  else if('data_submitting_center' in  read_metadata){\n  \tadd_param('CN', read_metadata.data_submitting_center)\n  }\n  \n  if($job.inputs.rg_library_id){\n  \tadd_param('LB', $job.inputs.rg_library_id)\n  }\n  else if('library_id' in read_metadata){\n  \tadd_param('LB', read_metadata.library_id)\n  }\n  \n  if($job.inputs.rg_median_fragment_length){\n  \tadd_param('PI', $job.inputs.rg_median_fragment_length)\n  }\n\n  \n  if($job.inputs.rg_platform){\n  \tadd_param('PL', $job.inputs.rg_platform)\n  }\n  else if('platform' in read_metadata){\n    if(read_metadata.platform == 'HiSeq X Ten'){\n      rg_platform = 'Illumina'\n    }\n    else{\n      rg_platform = read_metadata.platform\n    }\n  \tadd_param('PL', rg_platform)\n  }\n  \n  if($job.inputs.rg_platform_unit_id){\n  \tadd_param('PU', $job.inputs.rg_platform_unit_id)\n  }\n  else if('platform_unit_id' in read_metadata){\n  \tadd_param('PU', read_metadata.platform_unit_id)\n  }\n  \n  if($job.inputs.rg_sample_id){\n  \tadd_param('SM', $job.inputs.rg_sample_id)\n  }\n  else if('sample_id' in  read_metadata){\n  \tadd_param('SM', read_metadata.sample_id)\n  }\n    \n  return \"-R '@RG\\\\t\" + param_list.join('\\\\t') + \"'\"\n  \n}"
                        }
                    },
                    {
                        "position": 101,
                        "separate": true,
                        "itemSeparator": "null",
                        "valueFrom": {
                            "script": "{\n  /////// Set input reads in the correct order depending of the paired end from metadata\n    \n     // Set output file name\n  if($job.inputs.input_reads[0] instanceof Array){\n    input_reads = $job.inputs.input_reads[0] // scatter mode\n  } else {\n    input_reads = $job.inputs.input_reads = [].concat($job.inputs.input_reads)\n  }\n  \n  \n  //Read metadata for input reads\n  read_metadata = input_reads[0].metadata\n  if(!read_metadata) read_metadata = []\n  \n  order = 0 // Consider this as normal order given at input: pe1 pe2\n  \n  // Check if paired end 1 corresponds to the first given read\n  if(read_metadata == []){ order = 0 }\n  else if('paired_end' in  read_metadata){ \n    pe1 = read_metadata.paired_end\n    if(pe1 != 1) order = 1 // change order\n  }\n\n  // Return reads in the correct order\n  if (input_reads.length == 1){\n    return input_reads[0].path // Only one read present\n  }\n  else if (input_reads.length == 2){\n    if (order == 0) return input_reads[0].path + ' ' + input_reads[1].path\n    else return input_reads[1].path + ' ' + input_reads[0].path\n  }\n\n}",
                            "class": "Expression",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "position": 2,
                        "prefix": "-t",
                        "separate": true,
                        "itemSeparator": "null",
                        "valueFrom": {
                            "script": "{\n  MAX_THREADS = 36\n  suggested_threads = 8\n  \n  if($job.inputs.threads){ threads = $job.inputs.threads  }\n  else if ($job.inputs.wgs_hg38_mode_threads){\n    ref_name_arr = $job.inputs.reference_index_tar.path.split('/')\n    ref_name = ref_name_arr[ref_name_arr.length - 1]\n    if (ref_name.search('38') >= 0){threads = $job.inputs.wgs_hg38_mode_threads}\n    else {threads = MAX_THREADS}\n  }\n  else{ threads = suggested_threads  }\n    \n  return threads\n}",
                            "class": "Expression",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "position": 10,
                        "separate": true,
                        "itemSeparator": "null",
                        "valueFrom": {
                            "script": "{\n  name = ''\n  metadata = [].concat($job.inputs.reference_index_tar)[0].metadata\n  \n  if (metadata && metadata.reference_genome) {\n \tname = metadata.reference_genome\n  }\n  else {\n\treference_file = $job.inputs.reference_index_tar.path.split('/')[$job.inputs.reference_index_tar.path.split('/').length-1]\n  \tname = reference_file.slice(0, -4) // cut .tar extension \n  }\n    \n  return name \t\n}",
                            "class": "Expression",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "position": 10000,
                        "separate": true,
                        "itemSeparator": "null",
                        "valueFrom": {
                            "script": "{\n  cmd = \";declare -i pipe_statuses=(\\\\${PIPESTATUS[*]});len=\\\\${#pipe_statuses[@]};declare -i tot=0;echo \\\\${pipe_statuses[*]};for (( i=0; i<\\\\${len}; i++ ));do if [ \\\\${pipe_statuses[\\\\$i]} -ne 0 ];then tot=\\\\${pipe_statuses[\\\\$i]}; fi;done;if [ \\\\$tot -ne 0 ]; then >&2 echo Error in piping. Pipe statuses: \\\\${pipe_statuses[*]};fi; if [ \\\\$tot -ne 0 ]; then false;fi\\\"\"\n  return cmd\n}",
                            "class": "Expression",
                            "engine": "#cwl-js-engine"
                        }
                    }
                ],
                "sbg:toolAuthor": "Heng Li",
                "sbg:toolkit": "BWA",
                "sbg:license": "BWA: GNU Affero General Public License v3.0, MIT License. Sambamba: GNU GENERAL PUBLIC LICENSE. Samblaster: The MIT License (MIT)",
                "sbg:categories": [
                    "Alignment",
                    "FASTQ Processing"
                ],
                "sbg:projectName": "SBG Public data",
                "sbg:toolkitVersion": "0.7.17",
                "sbg:image_url": null,
                "sbg:cmdPreview": "/bin/bash -c \" export REF_CACHE=${PWD} ;  tar -tvf reference.HG38.fasta.gz.tar 1>&2; tar -xf reference.HG38.fasta.gz.tar ;  bwa mem  -R '@RG\\tID:1\\tPL:Illumina\\tSM:dnk_sample' -t 10  reference.HG38.fasta.gz  /path/to/LP6005524-DNA_C01_lane_7.sorted.converted.filtered.pe_2.gz /path/to/LP6005524-DNA_C01_lane_7.sorted.converted.filtered.pe_1.gz  | bamsormadup threads=10 level=1 tmplevel=-1 inputformat=sam outputformat=cram SO=coordinate reference=reference.HG38.fasta.gz indexfilename=LP6005524-DNA_C01_lane_7.sorted.converted.filtered.cram.crai M=LP6005524-DNA_C01_lane_7.sorted.converted.filtered.sormadup_metrics.log > LP6005524-DNA_C01_lane_7.sorted.converted.filtered.cram  ;declare -i pipe_statuses=(\\${PIPESTATUS[*]});len=\\${#pipe_statuses[@]};declare -i tot=0;echo \\${pipe_statuses[*]};for (( i=0; i<\\${len}; i++ ));do if [ \\${pipe_statuses[\\$i]} -ne 0 ];then tot=\\${pipe_statuses[\\$i]}; fi;done;if [ \\$tot -ne 0 ]; then >&2 echo Error in piping. Pipe statuses: \\${pipe_statuses[*]};fi; if [ \\$tot -ne 0 ]; then false;fi\"",
                "sbg:revisionsInfo": [
                    {
                        "sbg:revision": 0,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1532539866,
                        "sbg:revisionNotes": "Copy of vladimirk/bwa-mem-bundle-0-7-13-demo/bwa-mem-bundle-0-7-13/46"
                    },
                    {
                        "sbg:revision": 1,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1532539866,
                        "sbg:revisionNotes": "init"
                    },
                    {
                        "sbg:revision": 2,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1532539866,
                        "sbg:revisionNotes": "added biobambam2 sort"
                    },
                    {
                        "sbg:revision": 3,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1532539866,
                        "sbg:revisionNotes": "dedup added"
                    },
                    {
                        "sbg:revision": 4,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1532539866,
                        "sbg:revisionNotes": "boolean inputs fixed"
                    },
                    {
                        "sbg:revision": 5,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1532539866,
                        "sbg:revisionNotes": "output written with >"
                    },
                    {
                        "sbg:revision": 6,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1532539866,
                        "sbg:revisionNotes": "sambamba and samblaster"
                    },
                    {
                        "sbg:revision": 7,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1532539866,
                        "sbg:revisionNotes": "samblaster path corrected"
                    },
                    {
                        "sbg:revision": 8,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1532539866,
                        "sbg:revisionNotes": "Added ALT Contig reference"
                    },
                    {
                        "sbg:revision": 9,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1532539866,
                        "sbg:revisionNotes": "docs"
                    },
                    {
                        "sbg:revision": 10,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1532539866,
                        "sbg:revisionNotes": "num_bases_reproducibility"
                    },
                    {
                        "sbg:revision": 11,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1532539867,
                        "sbg:revisionNotes": "Do_not_use_alt_38 parameter removed due to redundancy"
                    },
                    {
                        "sbg:revision": 12,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1553711380,
                        "sbg:revisionNotes": "Added new @RG options."
                    },
                    {
                        "sbg:revision": 13,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1553711381,
                        "sbg:revisionNotes": "added bamsormadup"
                    },
                    {
                        "sbg:revision": 14,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1553711381,
                        "sbg:revisionNotes": "add 'inputformat=sam'"
                    },
                    {
                        "sbg:revision": 15,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1553711381,
                        "sbg:revisionNotes": "add 'cram output support and capture reference'"
                    },
                    {
                        "sbg:revision": 16,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1553711381,
                        "sbg:revisionNotes": "capture output with + ' > ' + name + extension"
                    },
                    {
                        "sbg:revision": 17,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1553711381,
                        "sbg:revisionNotes": "capturing cram output and dups metrics file"
                    },
                    {
                        "sbg:revision": 18,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1553711381,
                        "sbg:revisionNotes": "add cram selection as an output format"
                    },
                    {
                        "sbg:revision": 19,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1553711381,
                        "sbg:revisionNotes": "fix output_format options"
                    },
                    {
                        "sbg:revision": 20,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1553711381,
                        "sbg:revisionNotes": "lower case outputformat=cram"
                    },
                    {
                        "sbg:revision": 21,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1553711381,
                        "sbg:revisionNotes": "fix typo"
                    },
                    {
                        "sbg:revision": 22,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1553711381,
                        "sbg:revisionNotes": "tar -tv"
                    },
                    {
                        "sbg:revision": 23,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1553711382,
                        "sbg:revisionNotes": "see tar contents"
                    },
                    {
                        "sbg:revision": 24,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1553711382,
                        "sbg:revisionNotes": "1>&2"
                    },
                    {
                        "sbg:revision": 25,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1553711382,
                        "sbg:revisionNotes": "typo"
                    },
                    {
                        "sbg:revision": 26,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1553711382,
                        "sbg:revisionNotes": "add export REF_CACHE=$CWD"
                    },
                    {
                        "sbg:revision": 27,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1553711382,
                        "sbg:revisionNotes": "export REF_CACHE=$CWD ;"
                    },
                    {
                        "sbg:revision": 28,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1553711382,
                        "sbg:revisionNotes": "REF_CACHE=$PWD"
                    },
                    {
                        "sbg:revision": 29,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1553711382,
                        "sbg:revisionNotes": "set REF_CACHE"
                    },
                    {
                        "sbg:revision": 30,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1553711382,
                        "sbg:revisionNotes": "link to reference_tarball"
                    },
                    {
                        "sbg:revision": 31,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1553711382,
                        "sbg:revisionNotes": ".bam.bai instead only .bai"
                    },
                    {
                        "sbg:revision": 32,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1553711382,
                        "sbg:revisionNotes": "_R multi lane"
                    },
                    {
                        "sbg:revision": 33,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1554195132,
                        "sbg:revisionNotes": "label version to 0.7.17"
                    },
                    {
                        "sbg:revision": 34,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1556185556,
                        "sbg:revisionNotes": "Coordinate Sorted BAM enum label"
                    },
                    {
                        "sbg:revision": 35,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1556185557,
                        "sbg:revisionNotes": "description. Threads mapped to bamsortmadup"
                    },
                    {
                        "sbg:revision": 36,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1556185557,
                        "sbg:revisionNotes": "-q -5 boolean fix!"
                    },
                    {
                        "sbg:revision": 37,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1558705106,
                        "sbg:revisionNotes": "bamsort bamsormadup"
                    },
                    {
                        "sbg:revision": 38,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1558705108,
                        "sbg:revisionNotes": "description for deduplication"
                    },
                    {
                        "sbg:revision": 39,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1558705108,
                        "sbg:revisionNotes": "bamsort index=1"
                    },
                    {
                        "sbg:revision": 40,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1593179098,
                        "sbg:revisionNotes": "biobambam2 off if SAM is output"
                    },
                    {
                        "sbg:revision": 41,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1593179099,
                        "sbg:revisionNotes": "Bug fix for CRAM output with no PCR deduplication"
                    },
                    {
                        "sbg:revision": 42,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1593179099,
                        "sbg:revisionNotes": "Bug fix for CRAM output with no PCR deduplication"
                    },
                    {
                        "sbg:revision": 43,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1593179099,
                        "sbg:revisionNotes": "Coordinate SOrted BAM added to enum list"
                    },
                    {
                        "sbg:revision": 44,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1593179099,
                        "sbg:revisionNotes": "Updated JS to assign a unique Read group ID when the tool is scattered"
                    },
                    {
                        "sbg:revision": 45,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1649159192,
                        "sbg:revisionNotes": "update categories"
                    }
                ],
                "sbg:job": {
                    "allocatedResources": {
                        "cpu": 1,
                        "mem": 4096
                    },
                    "inputs": {
                        "read_group_header": "",
                        "band_width": null,
                        "rg_sample_id": "",
                        "mark_shorter": false,
                        "rg_platform": null,
                        "rg_data_submitting_center": "",
                        "sort_memory": null,
                        "wgs_hg38_mode_threads": 10,
                        "output_format": "CRAM",
                        "threads": null,
                        "total_memory": null,
                        "rg_platform_unit_id": "",
                        "rg_id": "",
                        "output_name": "",
                        "split_alignment_primary": false,
                        "rg_library_id": "",
                        "rg_median_fragment_length": "",
                        "reserved_threads": null,
                        "skip_seeds": null,
                        "reference_index_tar": {
                            "size": 0,
                            "class": "File",
                            "path": "/path/to/reference.HG38.fasta.gz.tar",
                            "secondaryFiles": [
                                {
                                    "path": ".amb"
                                },
                                {
                                    "path": ".ann"
                                },
                                {
                                    "path": ".bwt"
                                },
                                {
                                    "path": ".pac"
                                },
                                {
                                    "path": ".sa"
                                }
                            ]
                        },
                        "filter_out_secondary_alignments": false,
                        "num_input_bases_in_each_batch": null,
                        "mapQ_of_suplementary": false,
                        "input_reads": [
                            {
                                "size": 30000000000,
                                "class": "File",
                                "path": "/path/to/LP6005524-DNA_C01_lane_7.sorted.converted.filtered.pe_1.gz",
                                "secondaryFiles": [],
                                "metadata": {
                                    "paired_end": "2",
                                    "platform": "HiSeq X Ten",
                                    "sample_id": "dnk_sample"
                                }
                            },
                            {
                                "path": "/path/to/LP6005524-DNA_C01_lane_7.sorted.converted.filtered.pe_2.gz"
                            }
                        ],
                        "deduplication": "RemoveDuplicates"
                    }
                },
                "sbg:links": [
                    {
                        "id": "http://bio-bwa.sourceforge.net/",
                        "label": "Homepage"
                    },
                    {
                        "id": "https://github.com/lh3/bwa",
                        "label": "Source code"
                    },
                    {
                        "id": "http://bio-bwa.sourceforge.net/bwa.shtml",
                        "label": "Wiki"
                    },
                    {
                        "id": "http://sourceforge.net/projects/bio-bwa/",
                        "label": "Download"
                    },
                    {
                        "id": "http://arxiv.org/abs/1303.3997",
                        "label": "Publication"
                    },
                    {
                        "id": "http://www.ncbi.nlm.nih.gov/pubmed/19451168",
                        "label": "Publication BWA Algorithm"
                    }
                ],
                "sbg:expand_workflow": false,
                "sbg:appVersion": [
                    "sbg:draft-2"
                ],
                "sbg:id": "admin/sbg-public-data/bwa-mem-bundle-0-7-17/45",
                "sbg:revision": 45,
                "sbg:revisionNotes": "update categories",
                "sbg:modifiedOn": 1649159192,
                "sbg:modifiedBy": "admin",
                "sbg:createdOn": 1532539866,
                "sbg:createdBy": "admin",
                "sbg:project": "admin/sbg-public-data",
                "sbg:sbgMaintained": false,
                "sbg:validationErrors": [],
                "sbg:contributors": [
                    "admin"
                ],
                "sbg:latestRevision": 45,
                "sbg:publisher": "sbg",
                "sbg:content_hash": "a51b17304fd4034b7467e50aceec7bf180988476261df5039c4d0cb811b3772b5",
                "sbg:workflowLanguage": "CWL"
            },
            "label": "BWA MEM",
            "sbg:x": -38.31304931640625,
            "sbg:y": -43.3974494934082
        },
        {
            "id": "sbg_fasta_indices",
            "in": [
                {
                    "id": "reference",
                    "source": "reference"
                }
            ],
            "out": [
                {
                    "id": "fasta_reference"
                },
                {
                    "id": "fasta_index"
                },
                {
                    "id": "fasta_dict"
                }
            ],
            "run": {
                "cwlVersion": "sbg:draft-2",
                "class": "CommandLineTool",
                "$namespaces": {
                    "sbg": "https://sevenbridges.com"
                },
                "id": "admin/sbg-public-data/sbg-fasta-indices/21",
                "label": "SBG FASTA Indices",
                "description": "Create indices for FASTA file.\n\n###**Overview**  \n\nTool allows creating FASTA dictionary and index simultaneously which is necessary for running GATK tools. This version of tool for indexing uses SAMtools faidx command (toolkit version 1.9), while for the FASTA dictionary is used CreateFastaDictionary (GATK toolkit version 4.1.0.0).\n\n\n###**Inputs**  \n\n- FASTA file \n\n###**Output**  \n\n- FASTA Reference file\n- FASTA Index file\n- FASTA Dictionary file\n\n\n###**Changes made by Seven Bridges**\n\nCreateFastaDictionary function creates a DICT file describing the contents of the FASTA file. Parameter -UR was added to the command line that sets the UR field to just the Reference file name, instead of the whole path to file. This allows Memoisation feature of the platform to work.",
                "baseCommand": [
                    "samtools",
                    "faidx"
                ],
                "inputs": [
                    {
                        "sbg:stageInput": "link",
                        "sbg:category": "Input files",
                        "type": [
                            "File"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "FASTA file",
                        "description": "FASTA file to be indexed",
                        "sbg:fileTypes": "FASTA, FA, FA.GZ, FASTA.GZ",
                        "id": "#reference"
                    },
                    {
                        "sbg:category": "Execution",
                        "sbg:toolDefaultValue": "2048",
                        "type": [
                            "null",
                            "int"
                        ],
                        "label": "Memory per job",
                        "description": "Memory in megabytes required for each execution of the tool.",
                        "id": "#memory_per_job"
                    }
                ],
                "outputs": [
                    {
                        "type": [
                            "null",
                            "File"
                        ],
                        "label": "Reference",
                        "sbg:fileTypes": "FASTA",
                        "outputBinding": {
                            "glob": {
                                "script": "{\n  return $job.inputs.reference.path.split('/').pop()\n}",
                                "class": "Expression",
                                "engine": "#cwl-js-engine"
                            },
                            "sbg:inheritMetadataFrom": "#reference",
                            "secondaryFiles": [
                                ".fai",
                                "^.dict",
                                "^^.dict"
                            ]
                        },
                        "id": "#fasta_reference"
                    },
                    {
                        "type": [
                            "null",
                            "File"
                        ],
                        "label": "FASTA Index",
                        "sbg:fileTypes": "FAI",
                        "outputBinding": {
                            "glob": "*.fai"
                        },
                        "id": "#fasta_index"
                    },
                    {
                        "type": [
                            "null",
                            "File"
                        ],
                        "label": "FASTA Dictionary",
                        "sbg:fileTypes": "DICT",
                        "outputBinding": {
                            "glob": "*.dict"
                        },
                        "id": "#fasta_dict"
                    }
                ],
                "requirements": [
                    {
                        "class": "ExpressionEngineRequirement",
                        "id": "#cwl-js-engine",
                        "requirements": [
                            {
                                "dockerPull": "rabix/js-engine",
                                "class": "DockerRequirement"
                            }
                        ]
                    }
                ],
                "hints": [
                    {
                        "class": "sbg:CPURequirement",
                        "value": 1
                    },
                    {
                        "class": "sbg:MemRequirement",
                        "value": {
                            "script": "{\n  if($job.inputs.memory_per_job)return $job.inputs.memory_per_job + 500\n  else return 2548\n}",
                            "class": "Expression",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "class": "DockerRequirement",
                        "dockerImageId": "b177f5bd06db",
                        "dockerPull": "images.sbgenomics.com/vladimirk/gatk4-samtools:4.1.4.0-1.9"
                    }
                ],
                "arguments": [
                    {
                        "position": 1,
                        "prefix": "&&",
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "engine": "#cwl-js-engine",
                            "script": "{\n  memory = '2048'\n  if ($job.inputs.memory_per_job){\n    memory = $job.inputs.memory_per_job\n  }\n  filename = $job.inputs.reference.path.split('/').pop()\n  basename = filename.split('.')\n  if (filename.endsWith('.gz')){\n    basename.pop()\n  }\n  basename.pop()\n  name = basename.join('.')\n  return 'java -Xmx' + memory + 'M -jar /gatk/gatk-package-4.1.0.0-local.jar CreateSequenceDictionary -R=' + $job.inputs.reference.path + ' -O=' + name + '.dict'\n}"
                        }
                    },
                    {
                        "position": 3,
                        "prefix": "-UR=",
                        "separate": false,
                        "valueFrom": {
                            "class": "Expression",
                            "engine": "#cwl-js-engine",
                            "script": "{\n  return $job.inputs.reference.path.split('/')[ $job.inputs.reference.path.split('/').length - 1]\n}"
                        }
                    }
                ],
                "sbg:toolAuthor": "Sanja Mijalkovic, Seven Bridges Genomics, <sanja.mijalkovic@sbgenomics.com>",
                "sbg:cmdPreview": "samtools faidx  /path/to/reference.fa.gz && java -Xmx10M -jar /gatk/gatk-package-4.1.0.0-local.jar CreateSequenceDictionary -R=/path/to/reference.fa.gz -O=reference.dict -UR=reference.fa.gz",
                "sbg:toolkit": "SBGTools",
                "sbg:image_url": null,
                "sbg:job": {
                    "allocatedResources": {
                        "cpu": 1,
                        "mem": 510
                    },
                    "inputs": {
                        "reference": {
                            "secondaryFiles": [],
                            "path": "/path/to/reference.fa.gz",
                            "size": 0,
                            "class": "File"
                        },
                        "memory_per_job": 10
                    }
                },
                "sbg:projectName": "SBG Public data",
                "sbg:categories": [
                    "SBGTools",
                    "Indexing"
                ],
                "sbg:revisionsInfo": [
                    {
                        "sbg:revision": 0,
                        "sbg:modifiedBy": "sanja.mijalkovic",
                        "sbg:modifiedOn": 1448043983,
                        "sbg:revisionNotes": null
                    },
                    {
                        "sbg:revision": 1,
                        "sbg:modifiedBy": "djordje_klisic",
                        "sbg:modifiedOn": 1459163478,
                        "sbg:revisionNotes": null
                    },
                    {
                        "sbg:revision": 2,
                        "sbg:modifiedBy": "djordje_klisic",
                        "sbg:modifiedOn": 1459163478,
                        "sbg:revisionNotes": null
                    },
                    {
                        "sbg:revision": 3,
                        "sbg:modifiedBy": "djordje_klisic",
                        "sbg:modifiedOn": 1459163478,
                        "sbg:revisionNotes": null
                    },
                    {
                        "sbg:revision": 4,
                        "sbg:modifiedBy": "djordje_klisic",
                        "sbg:modifiedOn": 1459163478,
                        "sbg:revisionNotes": null
                    },
                    {
                        "sbg:revision": 5,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1504629640,
                        "sbg:revisionNotes": "Removed python script. Changed docker to just samtools and picard. Wrapped both faidx and CreateSequenceDictionary and exposed memory parameter for java execution."
                    },
                    {
                        "sbg:revision": 6,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1506681176,
                        "sbg:revisionNotes": "Changed join to join('.')."
                    },
                    {
                        "sbg:revision": 7,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1521479429,
                        "sbg:revisionNotes": "Added support for FA.GZ, FASTA.GZ"
                    },
                    {
                        "sbg:revision": 8,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1521479429,
                        "sbg:revisionNotes": "Added secondary .dict support for fasta.gz"
                    },
                    {
                        "sbg:revision": 9,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1530631714,
                        "sbg:revisionNotes": "returned to rev 8"
                    },
                    {
                        "sbg:revision": 10,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1530631714,
                        "sbg:revisionNotes": "rev 7"
                    },
                    {
                        "sbg:revision": 11,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1530631714,
                        "sbg:revisionNotes": "rev 9: Added secondary .dict support"
                    },
                    {
                        "sbg:revision": 12,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1545924498,
                        "sbg:revisionNotes": "Updated version for samtools (1.9) and picard (2.18.14)"
                    },
                    {
                        "sbg:revision": 13,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1545924498,
                        "sbg:revisionNotes": "Reverted."
                    },
                    {
                        "sbg:revision": 14,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1575892952,
                        "sbg:revisionNotes": "Added URI to eliminate randomness in .dict"
                    },
                    {
                        "sbg:revision": 15,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1575892952,
                        "sbg:revisionNotes": "Added URI to remove randomness"
                    },
                    {
                        "sbg:revision": 16,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1575892952,
                        "sbg:revisionNotes": "Updated to GATK 4.1.0.0"
                    },
                    {
                        "sbg:revision": 17,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1575892952,
                        "sbg:revisionNotes": "bug fix"
                    },
                    {
                        "sbg:revision": 18,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1575892952,
                        "sbg:revisionNotes": "description"
                    },
                    {
                        "sbg:revision": 19,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1575892952,
                        "sbg:revisionNotes": "updated command line preview"
                    },
                    {
                        "sbg:revision": 20,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1630934170,
                        "sbg:revisionNotes": "Tool description update to clarify it only takes one FASTA file"
                    },
                    {
                        "sbg:revision": 21,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1648035724,
                        "sbg:revisionNotes": "Updated categories"
                    }
                ],
                "sbg:license": "Apache License 2.0",
                "sbg:expand_workflow": false,
                "sbg:appVersion": [
                    "sbg:draft-2"
                ],
                "sbg:id": "admin/sbg-public-data/sbg-fasta-indices/21",
                "sbg:revision": 21,
                "sbg:revisionNotes": "Updated categories",
                "sbg:modifiedOn": 1648035724,
                "sbg:modifiedBy": "admin",
                "sbg:createdOn": 1448043983,
                "sbg:createdBy": "sanja.mijalkovic",
                "sbg:project": "admin/sbg-public-data",
                "sbg:sbgMaintained": false,
                "sbg:validationErrors": [],
                "sbg:contributors": [
                    "admin",
                    "sanja.mijalkovic",
                    "djordje_klisic"
                ],
                "sbg:latestRevision": 21,
                "sbg:publisher": "sbg",
                "sbg:content_hash": "a21b3ebe8e82b8fd5100676f5de37ea9b35992d0cbbb0c97a62c7e6a8dea4d620",
                "sbg:workflowLanguage": "CWL"
            },
            "label": "SBG FASTA Indices",
            "sbg:x": -242.14425659179688,
            "sbg:y": 142.7831268310547
        },
        {
            "id": "gatk_haplotypecaller_4_2_0_0",
            "in": [
                {
                    "id": "in_alignments",
                    "source": [
                        "bwa_mem_bundle_0_7_17/aligned_reads"
                    ]
                },
                {
                    "id": "in_reference",
                    "source": "sbg_fasta_indices/fasta_reference"
                }
            ],
            "out": [
                {
                    "id": "out_variants"
                },
                {
                    "id": "out_alignments"
                },
                {
                    "id": "out_graph"
                },
                {
                    "id": "out_assembly_region"
                }
            ],
            "run": {
                "class": "CommandLineTool",
                "cwlVersion": "v1.2",
                "$namespaces": {
                    "sbg": "https://sevenbridges.com"
                },
                "id": "admin/sbg-public-data/gatk-haplotypecaller-4-2-0-0/5",
                "baseCommand": [
                    "/opt/gatk-4.2.0.0/gatk",
                    "--java-options"
                ],
                "inputs": [
                    {
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "0.002",
                        "id": "active_probability_threshold",
                        "type": "float?",
                        "inputBinding": {
                            "prefix": "--active-probability-threshold",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Active probability threshold",
                        "doc": "Minimum probability for a locus to be considered active."
                    },
                    {
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "false",
                        "id": "adaptive_pruning",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--adaptive-pruning",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Adaptive pruning",
                        "doc": "Use Mutect2's adaptive graph pruning algorithm."
                    },
                    {
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "0.001",
                        "id": "adaptive_pruning_initial_error_rate",
                        "type": "float?",
                        "inputBinding": {
                            "prefix": "--adaptive-pruning-initial-error-rate",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Adaptive pruning initial error rate",
                        "doc": "Initial base error rate estimate for adaptive pruning."
                    },
                    {
                        "sbg:altPrefix": "-add-output-sam-program-record",
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "true",
                        "id": "add_output_sam_program_record",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "true",
                                    "false"
                                ],
                                "name": "add_output_sam_program_record"
                            }
                        ],
                        "inputBinding": {
                            "prefix": "--add-output-sam-program-record",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Add output SAM program record",
                        "doc": "If true, adds a PG tag to created SAM/BAM/CRAM files."
                    },
                    {
                        "sbg:altPrefix": "-add-output-vcf-command-line",
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "true",
                        "id": "add_output_vcf_command_line",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "true",
                                    "false"
                                ],
                                "name": "add_output_vcf_command_line"
                            }
                        ],
                        "inputBinding": {
                            "prefix": "--add-output-vcf-command-line",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Add output VCF command line",
                        "doc": "If true, adds a command line header line to created VCF files."
                    },
                    {
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "false",
                        "id": "all_site_pls",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--all-site-pls",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Annotate all sites with PLs",
                        "doc": "Advanced, experimental argument: if SNP likelihood model is specified, and if EMIT_ALL_SITES output mode is set, when we set this argument then we will also emit PLs at all sites. This will give a measure of reference confidence and a measure of which alt alleles are more plausible (if any). WARNINGS: - This feature will inflate VCF file size considerably. - All SNP ALT alleles will be emitted with corresponding 10 PL values. - An error will be emitted if EMIT_ALL_SITES is not set, or if anything other than diploid SNP model is used"
                    },
                    {
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "null",
                        "id": "alleles",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--alleles",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Alleles",
                        "doc": "The set of alleles to force-call regardless of evidence.",
                        "sbg:fileTypes": "VCF, VCF.GZ",
                        "secondaryFiles": [
                            {
                                "pattern": ".idx",
                                "required": false
                            },
                            {
                                "pattern": ".tbi",
                                "required": false
                            }
                        ]
                    },
                    {
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "false",
                        "id": "allow_non_unique_kmers_in_ref",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--allow-non-unique-kmers-in-ref",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Allow non unique kmers in ref",
                        "doc": "Allow graphs that have non-unique kmers in the reference."
                    },
                    {
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "false",
                        "id": "annotate_with_num_discovered_alleles",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--annotate-with-num-discovered-alleles",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Annotate with num discovered alleles",
                        "doc": "If provided, we will annotate records with the number of alternate alleles that were discovered (but not necessarily genotyped) at a given site."
                    },
                    {
                        "sbg:altPrefix": "-A",
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "null",
                        "id": "annotation",
                        "type": "string[]?",
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 4,
                            "valueFrom": "${\n    var cmd = \"\";\n    for (var i = 0; i < [].concat(inputs.annotation).length; i++ ){\n        cmd += \" --annotation \" + [].concat(inputs.annotation)[i];\n    }    \n    return cmd;\n}"
                        },
                        "label": "Annotation",
                        "doc": "One or more specific annotations to add to variant calls. This argument may be specified 0 or more times.\n\nPossible values: \nAlleleFraction, AS_BaseQualityRankSumTest,  AS_FisherStrand,  AS_InbreedingCoeff, AS_MappingQualityRankSumTest,  AS_QualByDepth,  AS_ReadPosRankSumTest,  AS_RMSMappingQuality, AS_StrandBiasMutectAnnotation,  AS_StrandOddsRatio,  BaseQuality,  BaseQualityHistogram, BaseQualityRankSumTest,  ChromosomeCounts,  ClippingRankSumTest,  CountNs,  Coverage,  DepthPerAlleleBySample,  DepthPerSampleHC,  ExcessHet,  FisherStrand,  FragmentLength, GenotypeSummaries,  InbreedingCoeff,  LikelihoodRankSumTest,  MappingQuality, MappingQualityRankSumTest,  MappingQualityZero,  OrientationBiasReadCounts, OriginalAlignment,  PossibleDeNovo,  QualByDepth,  ReadPosition,  ReadPosRankSumTest, ReferenceBases,  RMSMappingQuality,  SampleList,  StrandBiasBySample,  StrandOddsRatio, TandemRepeat,  UniqueAltReadCount"
                    },
                    {
                        "sbg:altPrefix": "-G",
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "null",
                        "id": "annotation_group",
                        "type": "string[]?",
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 4,
                            "valueFrom": "${\n    var cmd = \"\";\n    for (var i = 0; i < [].concat(inputs.annotation_group).length; i++ ){\n        cmd += \" --annotation-group \" + [].concat(inputs.annotation_group)[i];\n    }    \n    return cmd;\n}"
                        },
                        "label": "Annotation group",
                        "doc": "One or more groups of annotations to apply to variant calls. Any requirements that are not met (e.g. failing to provide a pedigree file for a pedigree-based annotation) may cause the run to fail. This argument may be specified 0 or more times.\n\nPossible values: \nAlleleSpecificAnnotation,  AS_StandardAnnotation,  ReducibleAnnotation,  StandardAnnotation, StandardHCAnnotation,  StandardMutectAnnotation"
                    },
                    {
                        "sbg:altPrefix": "-AX",
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "null",
                        "id": "annotations_to_exclude",
                        "type": "string[]?",
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 4,
                            "valueFrom": "${\n    var cmd = \"\";\n    for (var i = 0; i < [].concat(inputs.annotations_to_exclude).length; i++ ){\n        cmd += \" --annotations-to-exclude \" + [].concat(inputs.annotations_to_exclude)[i];\n    }    \n    return cmd;\n}"
                        },
                        "label": "Annotations to exclude",
                        "doc": "One or more specific annotations to exclude from variant calls. This argument may be specified 0 or more times. Which annotations to exclude from output in the variant calls. Note that this argument has higher priority than the -A or -G arguments, so these annotations will be excluded even if they are explicitly included with the other options.\n\nPossible values: \nBaseQualityRankSumTest, ChromosomeCounts, Coverage, DepthPerAlleleBySample, DepthPerSampleHC, ExcessHet, FisherStrand, InbreedingCoeff, MappingQualityRankSumTest, QualByDepth, ReadPosRankSumTest, RMSMappingQuality, StrandOddsRatio"
                    },
                    {
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "null",
                        "id": "assembly_region_out",
                        "type": "string?",
                        "inputBinding": {
                            "prefix": "--assembly-region-out",
                            "shellQuote": false,
                            "position": 4,
                            "valueFrom": "${\n    if(inputs.assembly_region_out) {\n        var tmp = inputs.assembly_region_out.slice(-4);\n        if(tmp == \".igv\" || tmp == \".IGV\") {\n            return tmp + '.assembly.igv';\n        }\n        else {\n            return inputs.assembly_region_out + '.assembly.igv';\n        }\n    }\n    else {\n        return null;\n    }\n}"
                        },
                        "label": "Assembly region output",
                        "doc": "Name of the IGV file to which assembly region should be written."
                    },
                    {
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "100",
                        "id": "assembly_region_padding",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--assembly-region-padding",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Assembly region padding",
                        "doc": "Number of additional bases of context to include around each assembly region."
                    },
                    {
                        "sbg:altPrefix": "-bamout",
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "null",
                        "id": "bam_output",
                        "type": "string?",
                        "inputBinding": {
                            "prefix": "--bam-output",
                            "shellQuote": false,
                            "position": 4,
                            "valueFrom": "${\n    if(inputs.bam_output) {\n        var tmp = inputs.bam_output.slice(-4);\n        if(tmp == \".bam\" || tmp == \".BAM\") {\n            return tmp + '.bam';\n        }\n        else {\n            return inputs.bam_output + '.bam';\n        }\n    }\n    else {\n        return null;\n    }\n}"
                        },
                        "label": "BAM output",
                        "doc": "Name of the file to which assembled haplotypes should be written."
                    },
                    {
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "CALLED_HAPLOTYPES",
                        "id": "bam_writer_type",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "ALL_POSSIBLE_HAPLOTYPES",
                                    "CALLED_HAPLOTYPES",
                                    "NO_HAPLOTYPES"
                                ],
                                "name": "bam_writer_type"
                            }
                        ],
                        "inputBinding": {
                            "prefix": "--bam-writer-type",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "BAM writer type",
                        "doc": "Which haplotypes should be written to the BAM."
                    },
                    {
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "18",
                        "id": "base_quality_score_threshold",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--base-quality-score-threshold",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Base quality score threshold",
                        "doc": "Base qualities below this threshold will be reduced to the minimum (6)."
                    },
                    {
                        "sbg:altPrefix": "-comp",
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "null",
                        "id": "comp",
                        "type": "File[]?",
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 4,
                            "valueFrom": "${\n    var cmd = \"\";\n    for (var i = 0; i < [].concat(inputs.comp).length; i++ ){\n        cmd += \" --comparison \" + [].concat(inputs.comp)[i].path;\n    }    \n    return cmd;\n}"
                        },
                        "label": "Comparison VCF",
                        "doc": "Comparison vcf file(s). If a call overlaps with a record from the provided comp track, the INFO field will be annotated as such in the output with the track name. Records that are filtered in the comp track will be ignored. Note that 'dbSNP' has been special-cased (see the --dbsnp)",
                        "sbg:fileTypes": "VCF, VCF.GZ",
                        "secondaryFiles": [
                            {
                                "pattern": ".idx",
                                "required": false
                            },
                            {
                                "pattern": ".tbi",
                                "required": false
                            }
                        ]
                    },
                    {
                        "sbg:altPrefix": "-contamination-file",
                        "sbg:category": "Advanced Arguments",
                        "id": "contamination_fraction_per_sample_file",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--contamination-fraction-per-sample-file",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Contamination fraction per sample",
                        "doc": "Tab-separated file containing fraction of contamination in sequencing data (per sample) to aggressively remove. Format should be \"<SampleID><TAB><Contamination>\" (Contamination is double) per line; No header.",
                        "sbg:fileTypes": "TSV"
                    },
                    {
                        "sbg:altPrefix": "-contamination",
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "0.0",
                        "id": "contamination_fraction_to_filter",
                        "type": "float?",
                        "inputBinding": {
                            "prefix": "--contamination-fraction-to-filter",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Contamination fraction to filter",
                        "doc": "Fraction of contamination in sequencing data (for all samples) to aggressively remove ."
                    },
                    {
                        "sbg:altPrefix": "-OBI",
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "true",
                        "id": "create_output_bam_index",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "true",
                                    "false"
                                ],
                                "name": "create_output_bam_index"
                            }
                        ],
                        "inputBinding": {
                            "prefix": "--create-output-bam-index",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Create output BAM index",
                        "doc": "If true, create a BAM/CRAM index when writing a coordinate-sorted BAM/CRAM file."
                    },
                    {
                        "sbg:altPrefix": "-OVI",
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "true",
                        "id": "create_output_variant_index",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "true",
                                    "false"
                                ],
                                "name": "create_output_variant_index"
                            }
                        ],
                        "inputBinding": {
                            "prefix": "--create-output-variant-index",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Create output variant index",
                        "doc": "If true, create a VCF index when writing a coordinate-sorted VCF file."
                    },
                    {
                        "sbg:altPrefix": "-D",
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "null",
                        "id": "dbsnp",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--dbsnp",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "dbSNP",
                        "doc": "dbSNP file.",
                        "sbg:fileTypes": "VCF, VCF.GZ",
                        "secondaryFiles": [
                            {
                                "pattern": ".idx",
                                "required": false
                            },
                            {
                                "pattern": ".tbi",
                                "required": false
                            }
                        ]
                    },
                    {
                        "sbg:altPrefix": "-debug",
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "false",
                        "id": "debug_assembly",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--debug-assembly",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Debug assembly",
                        "doc": "Print out verbose debug information about each assembly region."
                    },
                    {
                        "sbg:altPrefix": "-DBIC",
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "false",
                        "id": "disable_bam_index_caching",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--disable-bam-index-caching",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Disable BAM index caching",
                        "doc": "If true, don't cache BAM indexes, this will reduce memory requirements but may harm performance if many intervals are specified. Caching is automatically disabled if there are no intervals specified."
                    },
                    {
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "false",
                        "id": "disable_optimizations",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--disable-optimizations",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Disable optimizations",
                        "doc": "Don't skip calculations in active regions with no variants."
                    },
                    {
                        "sbg:altPrefix": "-DF",
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "null",
                        "id": "disable_read_filter",
                        "type": "string[]?",
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 4,
                            "valueFrom": "${\n    var cmd = \"\";\n    for (var i = 0; i < [].concat(inputs.disable_read_filter).length; i++ ){\n        cmd += \" --disable-read-filter \" + [].concat(inputs.disable_read_filter)[i];\n    }    \n    return cmd;\n}"
                        },
                        "label": "Disable read filter",
                        "doc": "Read filters to be disabled before analysis. This argument may be specified 0 or more times.\n\nPossible values:\nGoodCigarReadFilter, MappedReadFilter, MappingQualityAvailableReadFilter, MappingQualityReadFilter, NonZeroReferenceLengthAlignmentReadFilter, NotDuplicateReadFilter, NotSecondaryAlignmentReadFilter, PassesVendorQualityCheckReadFilter, WellformedReadFilter"
                    },
                    {
                        "sbg:altPrefix": "-disable-sequence-dictionary-validation",
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "false",
                        "id": "disable_sequence_dictionary_validation",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--disable-sequence-dictionary-validation",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Disable sequence dictionary validation",
                        "doc": "If specified, do not check the sequence dictionaries from our inputs for compatibility. Use at your own risk!"
                    },
                    {
                        "sbg:altPrefix": "-disable-tool-default-annotations",
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "false",
                        "id": "disable_tool_default_annotations",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--disable-tool-default-annotations",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Disable tool default annotations",
                        "doc": "Disable all tool default annotations."
                    },
                    {
                        "sbg:altPrefix": "-disable-tool-default-read-filters",
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "false",
                        "id": "disable_tool_default_read_filters",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--disable-tool-default-read-filters",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Disable tool default read filters",
                        "doc": "Disable all tool default read filters (warning: many tools will not function correctly without their default read filters on)."
                    },
                    {
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "false",
                        "id": "do_not_run_physical_phasing",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--do-not-run-physical-phasing",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Do not run physical phasing",
                        "doc": "Disable physical phasing."
                    },
                    {
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "false",
                        "id": "dont_increase_kmer_sizes_for_cycles",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--dont-increase-kmer-sizes-for-cycles",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Dont increase kmer sizes for cycles",
                        "doc": "Disable iterating over kmer sizes when graph cycles are detected."
                    },
                    {
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "false",
                        "id": "dont_use_soft_clipped_bases",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--dont-use-soft-clipped-bases",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Do not use soft clipped bases",
                        "doc": "Do not analyze soft clipped bases in the reads."
                    },
                    {
                        "sbg:altPrefix": "-ERC",
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "NONE",
                        "id": "emit_ref_confidence",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "NONE",
                                    "BP_RESOLUTION",
                                    "GVCF"
                                ],
                                "name": "emit_ref_confidence"
                            }
                        ],
                        "inputBinding": {
                            "prefix": "--emit-ref-confidence",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Emit ref confidence",
                        "doc": "Mode for emitting reference confidence scores."
                    },
                    {
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "false",
                        "id": "enable_all_annotations",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--enable-all-annotations",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Enable all annotations",
                        "doc": "Use all possible annotations (not for the faint of heart)."
                    },
                    {
                        "sbg:altPrefix": "-XL",
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "null",
                        "id": "exclude_intervals_string",
                        "type": "string[]?",
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 4,
                            "valueFrom": "${\n    var cmd = \"\";\n    for (var i = 0; i < [].concat(inputs.exclude_intervals_string).length; i++ ){\n        cmd += \" --exclude-intervals \" + [].concat(inputs.exclude_intervals_string)[i];\n    }    \n    return cmd;\n}\n"
                        },
                        "label": "Exclude intervals string",
                        "doc": "One or more genomic intervals to exclude from processing. This argument may be specified 0 or more times."
                    },
                    {
                        "sbg:altPrefix": "-founder-id",
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "null",
                        "id": "founder_id",
                        "type": "string[]?",
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 4,
                            "valueFrom": "${\n    var cmd = \"\";\n    for (var i = 0; i < [].concat(inputs.founder_id).length; i++ ){\n        cmd += \" --founder-id \" + [].concat(inputs.founder_id)[i];\n    }    \n    return cmd;\n}"
                        },
                        "label": "Founder ID",
                        "doc": "Samples representing the population \"founders\".  This argument may be specified 0 or more times."
                    },
                    {
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "false",
                        "sbg:altPrefix": "-genotype-filtered-alleles",
                        "id": "force_call_filtered_alleles",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--force-call-filtered-alleles",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Force-call filtered alleles",
                        "doc": "Force-call filtered alleles included in the resource specified by --alleles."
                    },
                    {
                        "sbg:altPrefix": "-graph",
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "null",
                        "id": "graph_output",
                        "type": "string?",
                        "inputBinding": {
                            "prefix": "--graph-output",
                            "shellQuote": false,
                            "position": 4,
                            "valueFrom": "${\n    if(inputs.graph_output) {\n        var tmp = inputs.graph_output.slice(-4);\n        if(tmp == \".txt\" || tmp == \".TXT\") {\n            return tmp + '.txt';\n        }\n        else {\n            return inputs.graph_output + '.txt';\n        }\n    }\n    else {\n        return null;\n    }\n}"
                        },
                        "label": "Graph output",
                        "doc": "Name of the file to which debug assembly graph information should be written."
                    },
                    {
                        "sbg:altPrefix": "-GQB",
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 70, 80, 90, 99",
                        "id": "gvcf_gq_bands",
                        "type": "int[]?",
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 4,
                            "valueFrom": "${\n    var cmd = \"\";\n    for (var i = 0; i < [].concat(inputs.gvcf_gq_bands).length; i++ ){\n        cmd += \" --gvcf-gq-bands \" + [].concat(inputs.gvcf_gq_bands)[i];\n    }    \n    return cmd;\n}"
                        },
                        "label": "GVCF GQ bands",
                        "doc": "Exclusive upper bounds for reference confidence GQ bands (must be in [1, 100] and specified in increasing order). This argument may be specified 0 or more times."
                    },
                    {
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "0.001",
                        "id": "heterozygosity",
                        "type": "float?",
                        "inputBinding": {
                            "prefix": "--heterozygosity",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Heterozygosity",
                        "doc": "Heterozygosity value used to compute prior likelihoods for any locus. See the GATKDocs for full details on the meaning of this population genetics concept."
                    },
                    {
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "0.01",
                        "id": "heterozygosity_stdev",
                        "type": "float?",
                        "inputBinding": {
                            "prefix": "--heterozygosity-stdev",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Heterozygosity stdev",
                        "doc": "Standard deviation of heterozygosity for SNP and indel calling."
                    },
                    {
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "1.25E-4",
                        "id": "indel_heterozygosity",
                        "type": "float?",
                        "inputBinding": {
                            "prefix": "--indel-heterozygosity",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Indel heterozygosity",
                        "doc": "Heterozygosity for indel calling. See the GATKDocs for heterozygosity for full details on the meaning of this population genetics concept."
                    },
                    {
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "10",
                        "id": "indel_size_to_eliminate_in_ref_model",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--indel-size-to-eliminate-in-ref-model",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Indel size to eliminate in ref model",
                        "doc": "The size of an indel to check for in the reference model."
                    },
                    {
                        "sbg:altPrefix": "-I",
                        "sbg:category": "Required Arguments",
                        "id": "in_alignments",
                        "type": "File[]",
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 4,
                            "valueFrom": "${\n    var cmd = \"\";\n    for (var i = 0; i < [].concat(inputs.in_alignments).length; i++ ){\n        cmd += \" --input \" + [].concat(inputs.in_alignments)[i].path;\n    }    \n    return cmd;\n}"
                        },
                        "label": "Input alignments",
                        "doc": "BAM/SAM/CRAM file containing reads. This argument must be specified at least once.",
                        "sbg:fileTypes": "BAM, CRAM",
                        "secondaryFiles": [
                            {
                                "pattern": ".bai",
                                "required": false
                            },
                            {
                                "pattern": "^.bai",
                                "required": false
                            },
                            {
                                "pattern": ".crai",
                                "required": false
                            },
                            {
                                "pattern": "^.crai",
                                "required": false
                            }
                        ]
                    },
                    {
                        "sbg:altPrefix": "-ixp",
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "0",
                        "id": "interval_exclusion_padding",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--interval-exclusion-padding",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Interval exclusion padding",
                        "doc": "Amount of padding (in bp) to add to each interval you are excluding."
                    },
                    {
                        "sbg:altPrefix": "-imr",
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "ALL",
                        "id": "interval_merging_rule",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "ALL",
                                    "OVERLAPPING_ONLY"
                                ],
                                "name": "interval_merging_rule"
                            }
                        ],
                        "inputBinding": {
                            "prefix": "--interval-merging-rule",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Interval merging rule",
                        "doc": "Interval merging rule for abutting intervals."
                    },
                    {
                        "sbg:altPrefix": "-ip",
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "0",
                        "id": "interval_padding",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--interval-padding",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Interval padding",
                        "doc": "Amount of padding (in bp) to add to each interval you are including."
                    },
                    {
                        "sbg:altPrefix": "-isr",
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "UNION",
                        "id": "interval_set_rule",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "UNION",
                                    "INTERSECTION"
                                ],
                                "name": "interval_set_rule"
                            }
                        ],
                        "inputBinding": {
                            "prefix": "--interval-set-rule",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Interval set rule",
                        "doc": "Set merging approach to use for combining interval inputs."
                    },
                    {
                        "sbg:altPrefix": "-L",
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "null",
                        "id": "include_intervals_file",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--intervals",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Include intervals file",
                        "doc": "One or more genomic intervals over which to operate.",
                        "sbg:fileTypes": "INTERVAL_LIST, LIST, BED"
                    },
                    {
                        "sbg:altPrefix": "-L",
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "null",
                        "id": "include_intervals_string",
                        "type": "string[]?",
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 4,
                            "valueFrom": "${\n    var cmd = \"\";\n    for (var i = 0; i < [].concat(inputs.include_intervals_string).length; i++ ){\n        cmd += \" --intervals \" + [].concat(inputs.include_intervals_string)[i];\n    }    \n    return cmd;\n}\n"
                        },
                        "label": "Include intervals string",
                        "doc": "One or more genomic intervals over which to operate. This argument may be specified 0 or more times."
                    },
                    {
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "10, 25",
                        "id": "kmer_size",
                        "type": "int[]?",
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 4,
                            "valueFrom": "${\n    var cmd = \"\";\n    for (var i = 0; i < [].concat(inputs.kmer_size).length; i++ ){\n        cmd += \" --kmer-size \" + [].concat(inputs.kmer_size)[i];\n    }    \n    return cmd;\n}"
                        },
                        "label": "Kmer size",
                        "doc": "Kmer size to use in the read threading assembler. This argument may be specified 0 or more times."
                    },
                    {
                        "sbg:altPrefix": "-LE",
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "false",
                        "id": "lenient",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--lenient",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Lenient",
                        "doc": "Lenient processing of VCF files."
                    },
                    {
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "6",
                        "id": "max_alternate_alleles",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--max-alternate-alleles",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Max alternate alleles",
                        "doc": "Maximum number of alternate alleles to genotype."
                    },
                    {
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "300",
                        "id": "max_assembly_region_size",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--max-assembly-region-size",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Max assembly region size",
                        "doc": "Maximum size of an assembly region."
                    },
                    {
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "1024",
                        "id": "max_genotype_count",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--max-genotype-count",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Max genotype count",
                        "doc": "Maximum number of genotypes to consider at any site."
                    },
                    {
                        "sbg:altPrefix": "-mnp-dist",
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "0",
                        "id": "max_mnp_distance",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--max-mnp-distance",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Max MNP distance",
                        "doc": "Two or more phased substitutions separated by this distance or less are merged into MNPs."
                    },
                    {
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "128",
                        "id": "max_num_haplotypes_in_population",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--max-num-haplotypes-in-population",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Max num haplotypes in population",
                        "doc": "Maximum number of haplotypes to consider for your population."
                    },
                    {
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "50",
                        "id": "max_prob_propagation_distance",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--max-prob-propagation-distance",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Max prob propagation distance",
                        "doc": "Upper limit on how many bases away probability mass can be moved around when calculating the boundaries between active and inactive assembly regions."
                    },
                    {
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "50",
                        "id": "max_reads_per_alignment_start",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--max-reads-per-alignment-start",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Max reads per alignment start",
                        "doc": "Maximum number of reads to retain per alignment start position. Reads above this threshold will be downsampled. Set to 0 to disable."
                    },
                    {
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "100",
                        "id": "max_unpruned_variants",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--max-unpruned-variants",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Max unpruned variants",
                        "doc": "Maximum number of variants in graph the adaptive pruner will allow."
                    },
                    {
                        "sbg:category": "Execution and Platform",
                        "sbg:toolDefaultValue": "100",
                        "id": "mem_overhead_per_job",
                        "type": "int?",
                        "label": "Memory overhead per job",
                        "doc": "It allows a user to set the desired overhead memory (in MB) when running a tool or adding it to a workflow."
                    },
                    {
                        "sbg:category": "Execution and Platform",
                        "sbg:toolDefaultValue": "4000",
                        "id": "mem_per_job",
                        "type": "int?",
                        "label": "Memory per job",
                        "doc": "It allows a user to set the desired memory requirement (in MB) when running a tool or adding it to a workflow."
                    },
                    {
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "50",
                        "id": "min_assembly_region_size",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--min-assembly-region-size",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Min assembly region size",
                        "doc": "Minimum size of an assembly region."
                    },
                    {
                        "sbg:altPrefix": "-mbq",
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "10",
                        "id": "min_base_quality_score",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--min-base-quality-score",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Min base quality score",
                        "doc": "Minimum base quality required to consider a base for calling."
                    },
                    {
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "4",
                        "id": "min_dangling_branch_length",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--min-dangling-branch-length",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Min dangling branch length",
                        "doc": "Minimum length of a dangling branch to attempt recovery."
                    },
                    {
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "2",
                        "id": "min_pruning",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--min-pruning",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Min pruning",
                        "doc": "Minimum support to not prune paths in the graph."
                    },
                    {
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "4",
                        "id": "native_pair_hmm_threads",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--native-pair-hmm-threads",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Native pairHMM threads",
                        "doc": "How many threads should a native pairHMM implementation use."
                    },
                    {
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "false",
                        "id": "native_pair_hmm_use_double_precision",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--native-pair-hmm-use-double-precision",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Native pairHMM use double precision",
                        "doc": "Use double precision in the native pairHMM. This is slower but matches the java implementation better."
                    },
                    {
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "1",
                        "id": "num_pruning_samples",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--num-pruning-samples",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Num pruning samples",
                        "doc": "Number of samples that must pass the minPruning threshold."
                    },
                    {
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "0",
                        "id": "num_reference_samples_if_no_call",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--num-reference-samples-if-no-call",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Num reference samples if no call",
                        "doc": "Number of hom-ref genotypes to infer at sites not present in a panel."
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "sbg:toolDefaultValue": "null",
                        "id": "output_prefix",
                        "type": "string?",
                        "label": "Output name prefix",
                        "doc": "Output file name prefix."
                    },
                    {
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "EMIT_VARIANTS_ONLY",
                        "id": "output_mode",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "EMIT_VARIANTS_ONLY",
                                    "EMIT_ALL_CONFIDENT_SITES",
                                    "EMIT_ALL_ACTIVE_SITES"
                                ],
                                "name": "output_mode"
                            }
                        ],
                        "inputBinding": {
                            "prefix": "--output-mode",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Output mode",
                        "doc": "Specifies which type of calls we should output."
                    },
                    {
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "10",
                        "id": "pair_hmm_gap_continuation_penalty",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--pair-hmm-gap-continuation-penalty",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Pair HMM gap continuation penalty",
                        "doc": "Flat gap continuation penalty for use in the pairHMM."
                    },
                    {
                        "sbg:altPrefix": "-pairHMM",
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "FASTEST_AVAILABLE",
                        "id": "pair_hmm_implementation",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "EXACT",
                                    "ORIGINAL",
                                    "LOGLESS_CACHING",
                                    "AVX_LOGLESS_CACHING",
                                    "AVX_LOGLESS_CACHING_OMP",
                                    "EXPERIMENTAL_FPGA_LOGLESS_CACHING",
                                    "FASTEST_AVAILABLE"
                                ],
                                "name": "pair_hmm_implementation"
                            }
                        ],
                        "inputBinding": {
                            "prefix": "--pair-hmm-implementation",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Pair HMM implementation",
                        "doc": "The pairHMM implementation to use for genotype likelihood calculations."
                    },
                    {
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "CONSERVATIVE",
                        "id": "pcr_indel_model",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "NONE",
                                    "HOSTILE",
                                    "AGGRESSIVE",
                                    "CONSERVATIVE"
                                ],
                                "name": "pcr_indel_model"
                            }
                        ],
                        "inputBinding": {
                            "prefix": "--pcr-indel-model",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "PCR indel model",
                        "doc": "The PCR indel model to use."
                    },
                    {
                        "sbg:altPrefix": "-ped",
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "null",
                        "id": "pedigree",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--pedigree",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Pedigree",
                        "doc": "Pedigree file for determining the population \"founders\".",
                        "sbg:fileTypes": "PED"
                    },
                    {
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "45",
                        "id": "phred_scaled_global_read_mismapping_rate",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--phred-scaled-global-read-mismapping-rate",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Phred scaled global read mismapping rate",
                        "doc": "The global assumed mismapping rate for reads."
                    },
                    {
                        "sbg:altPrefix": "-population",
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "null",
                        "id": "population_callset",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--population-callset",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Population callset",
                        "doc": "Callset to use in calculating genotype priors.",
                        "sbg:fileTypes": "VCF, VCF.GZ",
                        "secondaryFiles": [
                            {
                                "pattern": ".idx",
                                "required": false
                            },
                            {
                                "pattern": ".tbi",
                                "required": false
                            }
                        ]
                    },
                    {
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "2.302585092994046",
                        "id": "pruning_lod_threshold",
                        "type": "float?",
                        "inputBinding": {
                            "prefix": "--pruning-lod-threshold",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Pruning lod threshold",
                        "doc": "Ln likelihood ratio threshold for adaptive pruning algorithm."
                    },
                    {
                        "sbg:altPrefix": "-RF",
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "null",
                        "id": "read_filter",
                        "type": "string[]?",
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 4,
                            "valueFrom": "${\n    var cmd = \"\";\n    for (var i = 0; i < [].concat(inputs.read_filter).length; i++ ){\n        cmd += \" --read-filter \" + [].concat(inputs.read_filter)[i];\n    }    \n    return cmd;\n}\n"
                        },
                        "label": "Read filter",
                        "doc": "Read filters to be applied before analysis. This argument may be specified 0 or more times.\n\nPossible values: \nAlignmentAgreesWithHeaderReadFilter, AllowAllReadsReadFilter, AmbiguousBaseReadFilter, CigarContainsNoNOperator, FirstOfPairReadFilter, FragmentLengthReadFilter, GoodCigarReadFilter, HasReadGroupReadFilter, IntervalOverlapReadFilter, LibraryReadFilter, MappedReadFilter, MappingQualityAvailableReadFilter, MappingQualityNotZeroReadFilter, MappingQualityReadFilter, MatchingBasesAndQualsReadFilter, MateDifferentStrandReadFilter, MateDistantReadFilter, MateOnSameContigOrNoMappedMateReadFilter, MateUnmappedAndUnmappedReadFilter, MetricsReadFilter, NonChimericOriginalAlignmentReadFilter, NonZeroFragmentLengthReadFilter, NonZeroReferenceLengthAlignmentReadFilter, NotDuplicateReadFilter, NotOpticalDuplicateReadFilter, NotProperlyPairedReadFilter, NotSecondaryAlignmentReadFilter, NotSupplementaryAlignmentReadFilter, OverclippedReadFilter, PairedReadFilter, PassesVendorQualityCheckReadFilter, PlatformReadFilter, PlatformUnitReadFilter, PrimaryLineReadFilter, ProperlyPairedReadFilter, ReadGroupBlackListReadFilter, ReadGroupReadFilter, ReadLengthEqualsCigarLengthReadFilter, ReadLengthReadFilter, ReadNameReadFilter, ReadStrandFilter, SampleReadFilter, SecondOfPairReadFilter, SeqIsStoredReadFilter, SoftClippedReadFilter, ValidAlignmentEndReadFilter, ValidAlignmentStartReadFilter, WellformedReadFilter"
                    },
                    {
                        "sbg:altPrefix": "-VS",
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "SILENT",
                        "id": "read_validation_stringency",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "STRICT",
                                    "LENIENT",
                                    "SILENT"
                                ],
                                "name": "read_validation_stringency"
                            }
                        ],
                        "inputBinding": {
                            "prefix": "--read-validation-stringency",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Read validation stringency",
                        "doc": "Validation stringency for all SAM/BAM/CRAM/SRA files read by this program. The default stringency value silent can improve performance when processing a bam file in which variable-length data (read, qualities, tags) do not otherwise need to be decoded."
                    },
                    {
                        "sbg:altPrefix": "-R",
                        "sbg:category": "Required Arguments",
                        "sbg:toolDefaultValue": "FASTA, FA",
                        "id": "in_reference",
                        "type": "File",
                        "inputBinding": {
                            "prefix": "--reference",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Reference",
                        "doc": "Reference sequence file.",
                        "sbg:fileTypes": "FASTA, FA",
                        "secondaryFiles": [
                            {
                                "pattern": ".fai",
                                "required": false
                            },
                            {
                                "pattern": "^.dict",
                                "required": false
                            }
                        ]
                    },
                    {
                        "sbg:altPrefix": "-ALIAS",
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "null",
                        "id": "sample_name",
                        "type": "string?",
                        "inputBinding": {
                            "prefix": "--sample-name",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Sample name",
                        "doc": "Name of single sample to use from a multi-sample bam."
                    },
                    {
                        "sbg:altPrefix": "-ploidy",
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "2",
                        "id": "sample_ploidy",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--sample-ploidy",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Sample ploidy",
                        "doc": "Ploidy (number of chromosomes) per sample. For pooled data, set to (number of samples in each pool x Sample Ploidy)."
                    },
                    {
                        "sbg:altPrefix": "-sequence-dictionary",
                        "sbg:category": "Optional Arguments",
                        "id": "sequence_dictionary",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--sequence-dictionary",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Sequence dictionary",
                        "doc": "Use the given sequence dictionary as the master/canonical sequence dictionary. Must be a .dict file.",
                        "sbg:fileTypes": "DICT"
                    },
                    {
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "false",
                        "id": "sites_only_vcf_output",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--sites-only-vcf-output",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Sites only VCF output",
                        "doc": "If true, don't emit genotype fields when writing VCF file output."
                    },
                    {
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "JAVA",
                        "id": "smith_waterman",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "FASTEST_AVAILABLE",
                                    "AVX_ENABLED",
                                    "JAVA"
                                ],
                                "name": "smith_waterman"
                            }
                        ],
                        "inputBinding": {
                            "prefix": "--smith-waterman",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Smith waterman",
                        "doc": "Which Smith-Waterman implementation to use, generally FASTEST_AVAILABLE is the right choice."
                    },
                    {
                        "sbg:altPrefix": "-stand-call-conf",
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "30.0",
                        "id": "standard_min_confidence_threshold_for_calling",
                        "type": "float?",
                        "inputBinding": {
                            "prefix": "--standard-min-confidence-threshold-for-calling",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Standard min confidence threshold for calling",
                        "doc": "The minimum phred-scaled confidence threshold at which variants should be called. Only variant sites with QUAL equal or greater than this threshold will be called. When HaplotypeCaller is used in GVCF mode (using either -ERC GVCF or -ERC BP_RESOLUTION) the call threshold is automatically set to zero. Call confidence thresholding will then be performed in the subsequent GenotypeGVCFs command."
                    },
                    {
                        "sbg:category": "Advanced Arguments",
                        "sbg:toolDefaultValue": "false",
                        "id": "use_filtered_reads_for_annotations",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--use-filtered-reads-for-annotations",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Use filtered reads for annotations",
                        "doc": "Use the contamination-filtered read maps for the purposes of annotating variants."
                    },
                    {
                        "sbg:altPrefix": "-XL",
                        "sbg:category": "Optional Arguments",
                        "id": "exclude_intervals_file",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--exclude-intervals",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Exclude intervals file",
                        "doc": "One or more genomic intervals to exclude from processing.",
                        "sbg:fileTypes": "INTERVAL_LIST, LIST, BED"
                    },
                    {
                        "sbg:category": "Execution and Platform",
                        "sbg:toolDefaultValue": "1",
                        "id": "cpu_per_job",
                        "type": "int?",
                        "label": "CPU per job",
                        "doc": "Number of CPUs to be used per job."
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "sbg:toolDefaultValue": "vcf.gz",
                        "id": "output_extension",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "vcf",
                                    "vcf.gz"
                                ],
                                "name": "output_extension"
                            }
                        ],
                        "label": "Output VCF extension",
                        "doc": "Output VCF extension."
                    },
                    {
                        "sbg:toolDefaultValue": "10.00",
                        "sbg:category": "Optional Arguments",
                        "sbg:altPrefix": "-seconds-between-progress-updates",
                        "id": "seconds_between_progress_updates",
                        "type": "float?",
                        "inputBinding": {
                            "prefix": "--seconds-between-progress-updates",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Seconds between progress updates",
                        "doc": "Output traversal statistics every time this many seconds elapse."
                    },
                    {
                        "sbg:category": "Optional Arguments",
                        "sbg:altPrefix": "-read-index",
                        "id": "read_index",
                        "type": "File[]?",
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 4,
                            "valueFrom": "${\n    var cmd = \"\";\n    for (var i = 0; i < [].concat(inputs.read_index).length; i++ ){\n        cmd += \" --read-index \" + [].concat(inputs.read_index)[i].path;\n    }    \n    return cmd;\n}"
                        },
                        "label": "Read index",
                        "doc": "Indices to use for the read inputs. If specified, an index must be provided for every read input and in the same order as the read inputs. If this argument is not specified, the path to the index for each input will be inferred automatically.",
                        "sbg:fileTypes": "BAI, CRAI"
                    },
                    {
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "false",
                        "id": "dont_use_dragstr_pair_hmm_scores",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--dont-use-dragstr-pair-hmm-scores",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Do not use DRAGstr pair hmm scores",
                        "doc": "Disable DRAGstr pair-hmm score even when dragstr-params-path was provided."
                    },
                    {
                        "sbg:toolDefaultValue": "false",
                        "sbg:category": "Optional Arguments",
                        "id": "dragen_mode",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--dragen-mode",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "DRAGEN mode",
                        "doc": "Single argument for enabling the bulk of DRAGEN-GATK features. NOTE: THIS WILL OVERWRITE PROVIDED ARGUMENT CHECK TOOL INFO TO SEE WHICH ARGUMENTS ARE SET)."
                    },
                    {
                        "sbg:toolDefaultValue": "2",
                        "sbg:category": "Optional Arguments",
                        "id": "dragstr_het_hom_ratio",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--dragstr-het-hom-ratio",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "DRAGstr het hom ratio",
                        "doc": "Het to hom prior ratio use with DRAGstr on."
                    },
                    {
                        "sbg:category": "Optional Arguments",
                        "id": "dragstr_params_path",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--dragstr-params-path",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "DRAGstr parameters",
                        "doc": "File with the DRAGstr model parameters for STR error correction used in the Pair HMM. When provided, it overrides other PCR error correcting mechanisms.",
                        "sbg:fileTypes": "TXT"
                    },
                    {
                        "sbg:toolDefaultValue": "false",
                        "sbg:category": "Optional Arguments",
                        "id": "enable_dynamic_read_disqualification_for_genotyping",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--enable-dynamic-read-disqualification-for-genotyping",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Enable dynamic read disqualification for genotyping",
                        "doc": "Will enable less strict read disqualification low base quality reads. If enabled, rather than disqualifying all reads over a threshold of minimum hmm scores we will instead choose a less strict and less aggressive cap for disqualification based on the read length and base qualities."
                    },
                    {
                        "sbg:category": "Optional Arguments",
                        "sbg:altPrefix": "-gam",
                        "sbg:toolDefaultValue": "USE_PLS_TO_ASSIGN",
                        "id": "genotype_assignment_method",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "SET_TO_NO_CALL",
                                    "USE_PLS_TO_ASSIGN",
                                    "SET_TO_NO_CALL_NO_ANNOTATIONS",
                                    "BEST_MATCH_TO_ORIGINAL",
                                    "DO_NOT_ASSIGN_GENOTYPES",
                                    "USE_POSTERIOR_PROBABILITIES"
                                ],
                                "name": "genotype_assignment_method"
                            }
                        ],
                        "inputBinding": {
                            "prefix": "--genotype-assignment-method",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Genotype assignment method",
                        "doc": "How genotypes are assigned."
                    },
                    {
                        "sbg:toolDefaultValue": "false",
                        "sbg:category": "Optional Arguments",
                        "sbg:altPrefix": "-gp-qual",
                        "id": "use_posteriors_to_calculate_qual",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--use-posteriors-to-calculate-qual",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Use posteriors to calculate qual",
                        "doc": "If available, use the genotype posterior probabilities to calculate the site QUAL."
                    },
                    {
                        "sbg:toolDefaultValue": "2",
                        "sbg:category": "Advanced Arguments",
                        "id": "allele_informative_reads_overlap_margin",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--allele-informative-reads-overlap-margin",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Allele informative reads overlap margin",
                        "doc": "Likelihood and read-based annotations will only take into consideration reads that overlap the variant or any base no further than this distance expressed in base pairs."
                    },
                    {
                        "sbg:toolDefaultValue": "false",
                        "sbg:category": "Advanced Arguments",
                        "id": "apply_bqd",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--apply-bqd",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Apply BQD",
                        "doc": "If enabled this argument will apply the DRAGEN-GATK BaseQualityDropout model to the genotyping model for filtering sites due to Linked Error mode."
                    },
                    {
                        "sbg:toolDefaultValue": "false",
                        "sbg:category": "Advanced Arguments",
                        "id": "apply_frd",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--apply-frd",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Apply FRD",
                        "doc": "If enabled this argument will apply the DRAGEN-GATK ForeignReadDetection model to the genotyping model for filtering sites."
                    },
                    {
                        "sbg:toolDefaultValue": "false",
                        "sbg:category": "Advanced Arguments",
                        "id": "disable_cap_base_qualities_to_map_quality",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--disable-cap-base-qualities-to-map-quality",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Disable cap base qualities to map quality",
                        "doc": "If false this disables capping of base qualities in the HMM to the mapping quality of the read."
                    },
                    {
                        "sbg:toolDefaultValue": "false",
                        "sbg:category": "Advanced Arguments",
                        "id": "disable_spanning_event_genotyping",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--disable-spanning-event-genotyping",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Disable spanning event genotyping",
                        "doc": "If enabled this argument will disable inclusion of the '*' spanning event when genotyping events that overlap deletions."
                    },
                    {
                        "sbg:toolDefaultValue": "false",
                        "sbg:category": "Advanced Arguments",
                        "id": "disable_symmetric_hmm_normalizing",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--disable-symmetric-hmm-normalizing",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Disable symmetric HMM normalizing",
                        "doc": "Toggle to revive legacy behavior of asymmetrically normalizing the arguments to the reference haplotype."
                    },
                    {
                        "sbg:toolDefaultValue": "false",
                        "sbg:category": "Advanced Arguments",
                        "id": "do_not_correct_overlapping_quality",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--do-not-correct-overlapping-quality",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Do not correct overlapping quality",
                        "doc": "Disable overlapping base quality correction. Base quality is capped at half of PCR error rate for bases where read and mate overlap, to account for full correlation of PCR errors at these bases. This argument disables that correction."
                    },
                    {
                        "sbg:toolDefaultValue": "false",
                        "sbg:category": "Advanced Arguments",
                        "id": "dont_use_dragstr_priors",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--dont-use-dragstr-priors",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Dont use dragstr priors",
                        "doc": "Forfeit the use of the DRAGstr model to calculate genotype priors. This argument does not have any effect in the absence of DRAGstr model parameters (--dragstr-model-params)."
                    },
                    {
                        "sbg:toolDefaultValue": "0.02",
                        "sbg:category": "Advanced Arguments",
                        "id": "expected_mismatch_rate_for_read_disqualification",
                        "type": "float?",
                        "inputBinding": {
                            "prefix": "--expected-mismatch-rate-for-read-disqualification",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Expected mismatch rate for read disqualification",
                        "doc": "Error rate used to set expectation for post HMM read disqualification based on mismatches."
                    },
                    {
                        "sbg:toolDefaultValue": "false",
                        "sbg:category": "Advanced Arguments",
                        "id": "floor_blocks",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--floor-blocks",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Floor blocks",
                        "doc": "Output the band lower bound for each GQ block regardless of the data it represents."
                    },
                    {
                        "sbg:toolDefaultValue": "false",
                        "sbg:category": "Advanced Arguments",
                        "id": "force_active",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--force-active",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Force active",
                        "doc": "If provided, all regions will be marked as active."
                    },
                    {
                        "sbg:toolDefaultValue": "false",
                        "sbg:category": "Advanced Arguments",
                        "id": "linked_de_bruijn_graph",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--linked-de-bruijn-graph",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Linked De Bruijn graph",
                        "doc": "If enabled, the Assembly Engine will construct a Linked De Bruijn graph to recover better haplotypes. Disables graph simplification into a seq graph, opts to construct a proper De Bruijn graph with potential loops NOTE: --linked-de-bruijn-graph is an experimental feature that does not directly match with the regular HaplotypeCaller. Specifically the haplotype finding code does not perform correctly at complicated sites. Use this mode at your own risk."
                    },
                    {
                        "sbg:toolDefaultValue": "20",
                        "sbg:category": "Advanced Arguments",
                        "id": "mapping_quality_threshold_for_genotyping",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--mapping-quality-threshold-for-genotyping",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Mapping quality threshold for genotyping",
                        "doc": "Control the threshold for discounting reads from the genotyper due to mapping quality after the active region detection and assembly steps but before genotyping. NOTE: this is in contrast to the --minimum-mapping-quality argument which filters reads from all parts of the HaplotypeCaller. If you would like to call genotypes with a different threshold both arguments must be set."
                    },
                    {
                        "sbg:toolDefaultValue": "0",
                        "sbg:category": "Advanced Arguments",
                        "id": "max_effective_depth_adjustment_for_frd",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--max-effective-depth-adjustment-for-frd",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Max effective depth adjustment for FRD",
                        "doc": "Set the maximum depth to modify FRD adjustment to in the event of high depth sites (0 to disable)."
                    },
                    {
                        "sbg:toolDefaultValue": "9.210340371976184",
                        "sbg:category": "Advanced Arguments",
                        "id": "pruning_seeding_lod_threshold",
                        "type": "float?",
                        "inputBinding": {
                            "prefix": "--pruning-seeding-lod-threshold",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Pruning seeding lod threshold",
                        "doc": "Ln likelihood ratio threshold for seeding subgraph of good variation in adaptive pruning algorithm."
                    },
                    {
                        "sbg:toolDefaultValue": "false",
                        "sbg:category": "Advanced Arguments",
                        "id": "recover_all_dangling_branches",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--recover-all-dangling-branches",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Recover all dangling branches",
                        "doc": "Recover all dangling branches. By default, the read threading assembler does not recover dangling branches that fork after splitting from the reference. This argument tells the assembly engine to recover all dangling branches."
                    },
                    {
                        "sbg:toolDefaultValue": "false",
                        "sbg:category": "Advanced Arguments",
                        "id": "soft_clip_low_quality_ends",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--soft-clip-low-quality-ends",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Soft clip low quality ends",
                        "doc": "If enabled will preserve low-quality read ends as softclips (used for DRAGEN-GATK BQD genotyper model)."
                    },
                    {
                        "sbg:toolDefaultValue": "false",
                        "sbg:category": "Advanced Arguments",
                        "id": "transform_dragen_mapping_quality",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--transform-dragen-mapping-quality",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Transform DRAGEN mapping quality",
                        "doc": "If enabled this argument will map DRAGEN aligner aligned reads with mapping quality <=250 to scale up to MQ 50."
                    },
                    {
                        "sbg:category": "Conditional Arguments for readFilter",
                        "sbg:toolDefaultValue": "null",
                        "id": "ambig_filter_bases",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--ambig-filter-bases",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Ambig filter bases",
                        "doc": "Valid only if \"AmbiguousBaseReadFilter\" is specified:\nThreshold number of ambiguous bases. If null, uses threshold fraction; otherwise, overrides threshold fraction. Cannot be used in conjuction with argument(s) ambig-filter-frac."
                    },
                    {
                        "sbg:category": "Conditional Arguments for readFilter",
                        "sbg:toolDefaultValue": "0.05",
                        "id": "ambig_filter_frac",
                        "type": "float?",
                        "inputBinding": {
                            "prefix": "--ambig-filter-frac",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Ambig filter frac",
                        "doc": "Valid only if \"AmbiguousBaseReadFilter\" is specified:\nThreshold fraction of ambiguous bases. Cannot be used in conjuction with argument(s) ambig-filter-bases."
                    },
                    {
                        "sbg:category": "Conditional Arguments for readFilter",
                        "sbg:toolDefaultValue": "1000000",
                        "id": "max_fragment_length",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--max-fragment-length",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Max fragment length",
                        "doc": "Valid only if \"FragmentLengthReadFilter\" is specified:\nMaximum length of fragment (insert size)."
                    },
                    {
                        "sbg:category": "Conditional Arguments for readFilter",
                        "sbg:toolDefaultValue": "0",
                        "id": "min_fragment_length",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--min-fragment-length",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Min fragment length",
                        "doc": "Valid only if \"FragmentLengthReadFilter\" is specified:\nMinimum length of fragment (insert size)."
                    },
                    {
                        "sbg:category": "Conditional Arguments for readFilter",
                        "sbg:toolDefaultValue": "null",
                        "id": "keep_intervals",
                        "type": "string[]?",
                        "inputBinding": {
                            "prefix": "--keep-intervals",
                            "shellQuote": false,
                            "position": 4,
                            "valueFrom": "${\n    var cmd = \"\";\n    for (var i = 0; i < [].concat(inputs.keep_intervals).length; i++ ){\n        cmd += \" --keep-intervals \" + [].concat(inputs.keep_intervals)[i];\n    }    \n    return cmd;\n}\n\n\n"
                        },
                        "label": "Keep intervals",
                        "doc": "Valid only if \"IntervalOverlapReadFilter\" is specified:\nOne or more genomic intervals to keep. This argument must be specified at least once."
                    },
                    {
                        "sbg:altPrefix": "-library",
                        "sbg:category": "Conditional Arguments for readFilter",
                        "sbg:toolDefaultValue": "null",
                        "id": "library",
                        "type": "string[]?",
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 4,
                            "valueFrom": "${\n    var cmd = \"\";\n    for (var i = 0; i < [].concat(inputs.library).length; i++ ){\n        cmd += \" --library \" + [].concat(inputs.library)[i];\n    }    \n    return cmd;\n}\n\n\n"
                        },
                        "label": "Library",
                        "doc": "Valid only if \"LibraryReadFilter\" is specified:\nName of the library to keep. This argument must be specified at least once. Required."
                    },
                    {
                        "sbg:category": "Conditional Arguments for readFilter",
                        "sbg:toolDefaultValue": "null",
                        "id": "maximum_mapping_quality",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--maximum-mapping-quality",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Maximum mapping quality",
                        "doc": "Valid only if \"MappingQualityReadFilter\" is specified:\nMaximum mapping quality to keep (inclusive)."
                    },
                    {
                        "sbg:category": "Conditional Arguments for readFilter",
                        "sbg:toolDefaultValue": "10",
                        "id": "minimum_mapping_quality",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--minimum-mapping-quality",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Minimum mapping quality",
                        "doc": "Valid only if \"MappingQualityReadFilter\" is specified:\nMinimum mapping quality to keep (inclusive)."
                    },
                    {
                        "sbg:toolDefaultValue": "1000",
                        "sbg:category": "Conditional Arguments for readFilter",
                        "id": "mate_too_distant_length",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--mate-too-distant-length",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Mate too distant length",
                        "doc": "Valid only if \"MateDistantReadFilter\" is specified:\nMinimum start location difference at which mapped mates are considered distant."
                    },
                    {
                        "sbg:category": "Conditional Arguments for readFilter",
                        "sbg:toolDefaultValue": "false",
                        "id": "dont_require_soft_clips_both_ends",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--dont-require-soft-clips-both-ends",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Dont require soft clips both ends",
                        "doc": "Valid only if \"OverclippedReadFilter\" is specified:\nAllow a read to be filtered out based on having only 1 soft-clipped block. By default, both ends must have a soft-clipped block, setting this flag requires only 1 soft-clipped block."
                    },
                    {
                        "sbg:category": "Conditional Arguments for readFilter",
                        "sbg:toolDefaultValue": "30",
                        "id": "filter_too_short",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--filter-too-short",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Filter too short",
                        "doc": "Valid only if \"OverclippedReadFilter\" is specified:\nMinimum number of aligned bases."
                    },
                    {
                        "sbg:category": "Conditional Arguments for readFilter",
                        "sbg:toolDefaultValue": "null",
                        "id": "platform_filter_name",
                        "type": "string[]?",
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 4,
                            "valueFrom": "${\n    var cmd = \"\";\n    for (var i = 0; i < [].concat(inputs.platform_filter_name).length; i++ ){\n        cmd += \" --platform-filter-name \" + [].concat(inputs.platform_filter_name)[i];\n    }    \n    return cmd;\n}\n\n\n"
                        },
                        "label": "Platform filter name",
                        "doc": "Valid only if \"PlatformReadFilter\" is specified:\nPlatform attribute (PL) to match. This argument must be specified at least once. Required."
                    },
                    {
                        "sbg:category": "Conditional Arguments for readFilter",
                        "sbg:toolDefaultValue": "null",
                        "id": "black_listed_lanes",
                        "type": "string[]?",
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 4,
                            "valueFrom": "${\n    var cmd = \"\";\n    for (var i = 0; i < [].concat(inputs.black_listed_lanes).length; i++ ){\n        cmd += \" --black-listed-lanes \" + [].concat(inputs.black_listed_lanes)[i];\n    }    \n    return cmd;\n}"
                        },
                        "label": "Black listed lanes",
                        "doc": "Valid only if \"PlatformUnitReadFilter\" is specified:\nPlatform unit (PU) to filter out. This argument must be specified at least once. Required."
                    },
                    {
                        "sbg:category": "Conditional Arguments for readFilter",
                        "sbg:toolDefaultValue": "null",
                        "id": "read_group_black_list",
                        "type": "string[]?",
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 4,
                            "valueFrom": "${\n    var cmd = \"\";\n    for (var i = 0; i < [].concat(inputs.read_group_black_list).length; i++ ){\n        cmd += \" --read-group-black-list \" + [].concat(inputs.read_group_black_list)[i];\n    }    \n    return cmd;\n}\n\n\n"
                        },
                        "label": "Read group black list",
                        "doc": "Valid only if \"ReadGroupBlackListReadFilter\" is specified:\nA read group filter expression in the form \"attribute:value\", where \"attribute\" is a two character read group attribute such as \"RG\" or \"PU\". This argument must be specified at least once. Required."
                    },
                    {
                        "sbg:category": "Conditional Arguments for readFilter",
                        "sbg:toolDefaultValue": "null",
                        "id": "keep_read_group",
                        "type": "string?",
                        "inputBinding": {
                            "prefix": "--keep-read-group",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Keep read group",
                        "doc": "Valid only if \"ReadGroupReadFilter\" is specified:\nThe name of the read group to keep. Required."
                    },
                    {
                        "sbg:category": "Conditional Arguments for readFilter",
                        "sbg:toolDefaultValue": "null",
                        "id": "max_read_length",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--max-read-length",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Max read length",
                        "doc": "Valid only if \"ReadLengthReadFilter\" is specified:\nKeep only reads with length at most equal to the specified value. Required."
                    },
                    {
                        "sbg:category": "Conditional Arguments for readFilter",
                        "sbg:toolDefaultValue": "1",
                        "id": "min_read_length",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--min-read-length",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Min read length",
                        "doc": "Valid only if \"ReadLengthReadFilter\" is specified:\nKeep only reads with length at least equal to the specified value."
                    },
                    {
                        "sbg:category": "Conditional Arguments for readFilter",
                        "sbg:toolDefaultValue": "null",
                        "id": "read_name",
                        "type": "string?",
                        "inputBinding": {
                            "prefix": "--read-name",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Read name",
                        "doc": "Valid only if \"ReadNameReadFilter\" is specified:\nKeep only reads with this read name. Required."
                    },
                    {
                        "sbg:category": "Conditional Arguments for readFilter",
                        "sbg:toolDefaultValue": "null",
                        "id": "keep_reverse_strand_only",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "true",
                                    "false"
                                ],
                                "name": "keep_reverse_strand_only"
                            }
                        ],
                        "inputBinding": {
                            "prefix": "--keep-reverse-strand-only",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Keep reverse strand only",
                        "doc": "Valid only if \"ReadStrandFilter\" is specified:\nKeep only reads on the reverse strand. Required."
                    },
                    {
                        "sbg:altPrefix": "-sample",
                        "sbg:category": "Conditional Arguments for readFilter",
                        "sbg:toolDefaultValue": "null",
                        "id": "sample",
                        "type": "string[]?",
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 4,
                            "valueFrom": "${\n    var cmd = \"\";\n    for (var i = 0; i < [].concat(inputs.sample).length; i++ ){\n        cmd += \" --sample \" + [].concat(inputs.sample)[i];\n    }    \n    return cmd;\n}\n\n\n"
                        },
                        "label": "Sample",
                        "doc": "Valid only if \"SampleReadFilter\" is specified:\nThe name of the sample(s) to keep, filtering out all others. This argument must be specified at least once. Required."
                    },
                    {
                        "sbg:toolDefaultValue": "false",
                        "sbg:category": "Conditional Arguments for readFilter",
                        "id": "invert_soft_clip_ratio_filter",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--invert-soft-clip-ratio-filter",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Invert soft clip ratio filter",
                        "doc": "Valid only if \"SoftClippedReadFilter\" is specified:\nInverts the results from this filter, causing all variants that would pass to fail and visa-versa."
                    },
                    {
                        "sbg:toolDefaultValue": "null",
                        "sbg:category": "Conditional Arguments for readFilter",
                        "id": "soft_clipped_leading_trailing_ratio",
                        "type": "float?",
                        "inputBinding": {
                            "prefix": "--soft-clipped-leading-trailing-ratio",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Soft clipped leading trailing ratio",
                        "doc": "Valid only if \"SoftClippedReadFilter\" is specified:\nThreshold ratio of soft clipped bases (leading / trailing the cigar string) to total bases in read for read to be filtered. Cannot be used in conjunction with argument(s) soft-clipped-ratio-threshold."
                    },
                    {
                        "sbg:toolDefaultValue": "null",
                        "sbg:category": "Conditional Arguments for readFilter",
                        "id": "soft_clipped_ratio_threshold",
                        "type": "float?",
                        "inputBinding": {
                            "prefix": "--soft-clipped-ratio-threshold",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Soft clipped ratio threshold",
                        "doc": "Valid only if \"SoftClippedReadFilter\" is specified:\nThreshold ratio of soft clipped bases (anywhere in the cigar string) to total bases in read for read to be filtered.  Cannot be used in conjunction with argument(s) soft-clipped-leading-trailing-ratio."
                    },
                    {
                        "sbg:category": "Optional Arguments",
                        "sbg:toolDefaultValue": "false",
                        "sbg:altPrefix": "-OVM",
                        "id": "create_output_variant_md5",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--create-output-variant-md5",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Create output variant md5",
                        "doc": "If true, create a a MD5 digest any VCF file created."
                    },
                    {
                        "sbg:toolDefaultValue": "false",
                        "sbg:category": "Optional Arguments",
                        "sbg:altPrefix": "-OBM",
                        "id": "create_output_bam_md5",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--create-output-bam-md5",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Create output bam md5",
                        "doc": "If true, create a MD5 digest for any BAM/SAM/CRAM file created."
                    },
                    {
                        "sbg:toolDefaultValue": "true",
                        "sbg:category": "Optional Arguments",
                        "sbg:altPrefix": "-new-qual",
                        "id": "use_new_qual_calculator",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "true",
                                    "false"
                                ],
                                "name": "use_new_qual_calculator"
                            }
                        ],
                        "inputBinding": {
                            "prefix": "--use-new-qual-calculator",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Use new qual calculator",
                        "doc": "Use the new AF model instead of the so-called exact model."
                    },
                    {
                        "sbg:toolDefaultValue": "false",
                        "sbg:category": "Optional Arguments",
                        "id": "allow_old_rms_mapping_quality_annotation_data",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--allow-old-rms-mapping-quality-annotation-data",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "Allow old rms mapping quality annotation data",
                        "doc": "Valid only if \"RMSMappingQuality\" is specified:\nOverride to allow old RMSMappingQuality annotated VCFs to function."
                    }
                ],
                "outputs": [
                    {
                        "id": "out_variants",
                        "doc": "File to which variants should be written.",
                        "label": "VCF output",
                        "type": "File",
                        "outputBinding": {
                            "glob": "${\n    var output_ext = inputs.output_extension ? inputs.output_extension : \"vcf.gz\";\n    return \"*.\" + output_ext;\n}",
                            "outputEval": "$(inheritMetadata(self, inputs.in_alignments))"
                        },
                        "secondaryFiles": [
                            {
                                "pattern": ".idx",
                                "required": false
                            },
                            {
                                "pattern": ".tbi",
                                "required": false
                            },
                            {
                                "pattern": ".md5",
                                "required": false
                            }
                        ],
                        "sbg:fileTypes": "VCF, VCF.GZ"
                    },
                    {
                        "id": "out_alignments",
                        "doc": "File to which assembled haplotypes should be written.",
                        "label": "BAM output",
                        "type": "File?",
                        "outputBinding": {
                            "glob": "${\n    if(inputs.bam_output) {\n        return '*.bam';\n    }\n    else {\n        return null;\n    }\n}",
                            "outputEval": "$(inheritMetadata(self, inputs.in_alignments))"
                        },
                        "secondaryFiles": [
                            {
                                "pattern": "^.bai",
                                "required": false
                            },
                            {
                                "pattern": ".md5",
                                "required": false
                            }
                        ],
                        "sbg:fileTypes": "BAM"
                    },
                    {
                        "id": "out_graph",
                        "doc": "File to which assembly graph information should be written.",
                        "label": "Graph output",
                        "type": "File?",
                        "outputBinding": {
                            "glob": "${\n    if(inputs.graph_output) {\n        return '*.txt';\n    }\n    else {\n        return null;\n    }\n}",
                            "outputEval": "$(inheritMetadata(self, inputs.in_alignments))"
                        },
                        "sbg:fileTypes": "TXT"
                    },
                    {
                        "id": "out_assembly_region",
                        "doc": "Output the assembly region to this IGV formatted file.",
                        "label": "Assembly region",
                        "type": "File?",
                        "outputBinding": {
                            "glob": "${\n    if(inputs.assembly_region_out) {\n        return '*.assembly.igv';\n    }\n    else {\n        return null;\n    }\n}",
                            "outputEval": "$(inheritMetadata(self, inputs.in_alignments))"
                        },
                        "sbg:fileTypes": "IGV"
                    }
                ],
                "doc": "**GATK HaplotypeCaller** calls germline SNPs and indels from input BAM file(s) via local re-assembly of haplotypes [1].\n\n**GATK HaplotypeCaller** is capable of calling SNPs and indels simultaneously via local de-novo assembly of haplotypes in an active region. In other words, whenever the program encounters a region showing signs of variation, it discards the existing mapping information and completely reassembles the reads in that region. This allows the **GATK HaplotypeCaller** to be more accurate when calling regions that are traditionally difficult to call, for example when they contain different types of variants close to each other. It also makes the **GATK HaplotypeCaller** much better at calling indels than position-based callers like UnifiedGenotyper [1].\n\nIn the GVCF workflow used for scalable variant calling in DNA sequence data, **GATK HaplotypeCaller** runs per-sample to generate an intermediate GVCF (not to be used in final analysis), which can then be used in GenotypeGVCFs for joint genotyping of multiple samples in a very efficient way. The GVCF workflow enables rapid incremental processing of samples as they roll off the sequencer, as well as scaling to very large cohort sizes [1].\n\nIn addition, **HaplotypeCaller** is able to handle non-diploid organisms as well as pooled experiment data. Note however that the algorithms used to calculate variant likelihoods are not well suited to extreme allele frequencies (relative to ploidy) so its use is not recommended for somatic (cancer) variant discovery. For that purpose, use **Mutect2** instead [1].\n\nFinally, **GATK HaplotypeCaller** is also able to correctly handle splice junctions that make RNAseq a challenge for most variant callers, on the condition that the input read data has previously been processed according to [GATK RNAseq short variant discovery (SNPs + Indels)](https://gatk.broadinstitute.org/hc/en-us/articles/360035531192?id=4067) [1].\n\n*A list of **all inputs and parameters** with corresponding descriptions can be found at the bottom of this page.*\n\n***Please note that any cloud infrastructure costs resulting from app and pipeline executions, including the use of public apps, are the sole responsibility of you as a user. To avoid excessive costs, please read the app description carefully and set the app parameters and execution settings accordingly.***\n\n### Common Use Cases\n\n- Call variants individually on each sample in GVCF mode\n\n```\n gatk --java-options \"-Xmx4g\" HaplotypeCaller  \\\n   -R Homo_sapiens_assembly38.fasta \\\n   -I input.bam \\\n   -O output.g.vcf.gz \\\n   -ERC GVCF\n```\n\n\n- Call variants individually on each sample in GVCF mode with allele-specific annotations. [Here](https://gatk.broadinstitute.org/hc/en-us/articles/360035890551?id=9622) you can read more details about allele-specific annotation and filtering.\n\n```\ngatk --java-options \"-Xmx4g\" HaplotypeCaller  \\\n   -R Homo_sapiens_assembly38.fasta \\\n   -I input.bam \\\n   -O output.g.vcf.gz \\\n   -ERC GVCF \\\n   -G Standard \\\n   -G AS_Standard\n```\n\n\n- Call variants with bamout to show realigned reads.\n\n```\n gatk --java-options \"-Xmx4g\" HaplotypeCaller  \\\n   -R Homo_sapiens_assembly38.fasta \\\n   -I input.bam \\\n   -O output.vcf.gz \\\n   -bamout bamout.bam\n```\n\n### Changes Introduced by Seven Bridges\n\n* **Include intervals** (`--intervals`) option is divided into **Include intervals file** and **Include intervals string** options.\n* **Exclude intervals** (`--exclude-intervals`) option is divided into **Exclude intervals file** and **Exclude intervals string** options.\n* **VCF output** will be prefixed using the **Output name prefix** parameter. If this value is not set, the output name will be generated based on the **Sample ID** metadata value from **Input alignments**. If the **Sample ID** value is not set, the name will be inherited from the **Input alignments** file name. In case there are multiple files on the **Input alignments** input, the files will be sorted by name and output file name will be generated based on the first file in the sorted file list, following the rules defined in the previous case. \n* The user can specify the output file format using the **Output VCF extension** argument. Otherwise, the output will be in the compressed VCF file format.\n* The following parameters were excluded from the tool wrapper: `--arguments_file`, `--cloud-index-prefetch-buffer`, `--cloud-prefetch-buffer`, `--gatk-config-file`, `--gcs-max-retries`, `--gcs-project-for-requester-pays`, `--help`, `--QUIET`, `--recover-dangling-heads` (deprecated), `--showHidden`, `--tmp-dir`, `--use-jdk-deflater`, `--use-jdk-inflater`, `--verbosity`, `--version`\n\n### Common Issues and Important Notes\n\n*  **Memory per job** (`mem_per_job`) input allows a user to set the desired memory requirement when running a tool or adding it to a workflow. This input should be defined in MB. It is propagated to the Memory requirements part and “-Xmx” parameter of the tool. The default value is 4000 MB.\n* **Memory overhead per job** (`mem_overhead_per_job`) input allows a user to set the desired overhead memory when running a tool or adding it to a workflow. This input should be defined in MB. This amount will be added to the **Memory per job** in the Memory requirements section but it will not be added to the “-Xmx” parameter. The default value is 100 MB. \n* Note: GATK tools that take in mapped read data expect a BAM file as the primary format [2]. More on GATK requirements for mapped sequence data formats can be found [here](https://gatk.broadinstitute.org/hc/en-us/articles/360035890791-SAM-or-BAM-or-CRAM-Mapped-sequence-data-formats).\n* Note: **Alleles**, **Comparison VCF**, **dbSNP**, **Input alignments**, **Population callset** should have corresponding index files in the same folder. \n* Note: **Reference** FASTA file should have corresponding .fai (FASTA index) and .dict (FASTA dictionary) files in the same folder. \n* Note: When working with PCR-free data, be sure to set **PCR indel model** (`--pcr_indel_model`) to NONE [1].\n* Note: When running **Emit ref confidence** ( `--emit-ref-confidence`) in GVCF or in BP_RESOLUTION mode, the confidence threshold is automatically set to 0. This cannot be overridden by the command line. The threshold can be set manually to the desired level when using **GenotypeGVCFs** [1].\n* Note: It is recommended to use a list of intervals to speed up the analysis. See [this document](https://gatk.broadinstitute.org/hc/en-us/articles/360035889551?id=4133) for details [1].\n* Note: **HaplotypeCaller** is able to handle many non-diploid use cases; the desired ploidy can be specified using the `-ploidy` argument. Note however that very high ploidies (such as are encountered in large pooled experiments) may cause performance challenges including excessive slowness [1].\n* Note: These **Read Filters** (`--read-filter`) are automatically applied to the data by the Engine before processing by **HaplotypeCaller** [1]: **NotSecondaryAlignmentReadFilter**, **GoodCigarReadFilter**, **NonZeroReferenceLengthAlignmentReadFilter**, **PassesVendorQualityCheckReadFilter**, **MappedReadFilter**, **MappingQualityAvailableReadFilter**, **NotDuplicateReadFilter**, **MappingQualityReadFilter**, **WellformedReadFilter**\n* Note: If the **Read filter** (`--read-filter`) option is set to \"LibraryReadFilter\", the **Library** (`--library`) option must be set to some value.\n* Note: If the **Read filter** (`--read-filter`) option is set to \"PlatformReadFilter\", the **Platform filter name** (`--platform-filter-name`) option must be set to some value.\n* Note: If the **Read filter** (`--read-filter`) option is set to \"PlatformUnitReadFilter\", the **Black listed lanes** (`--black-listed-lanes`) option must be set to some value. \n* Note: If the **Read filter** (`--read-filter`) option is set to \"ReadGroupBlackListReadFilter\", the **Read group black list** (`--read-group-black-list`) option must be set to some value.\n* Note: If the **Read filter** (`--read-filter`) option is set to \"ReadGroupReadFilter\", the **Keep read group** (`--keep-read-group`) option must be set to some value.\n* Note: If the **Read filter** (`--read-filter`) option is set to \"ReadLengthReadFilter\", the **Max read length** (`--max-read-length`) option must be set to some value.\n* Note: If the **Read filter** (`--read-filter`) option is set to \"ReadNameReadFilter\", the **Read name** (`--read-name`) option must be set to some value.\n* Note: If the **Read filter** (`--read-filter`) option is set to \"ReadStrandFilter\", the **Keep reverse strand only** (`--keep-reverse-strand-only`) option must be set to some value.\n* Note: If the **Read filter** (`--read-filter`) option is set to \"SampleReadFilter\", the **Sample** (`--sample`) option must be set to some value.\n* Note: If the **Read filter** (`--read-filter`) option is set to \"IntervalOverlapReadFilter\", the **Keep intervals** (`--keep-intervals`) option must be set to some value.\n* Note: The following options are valid only if the appropriate **Read filter** (`--read-filter`) is specified: **Ambig filter bases** (`--ambig-filter-bases`), **Ambig filter frac** (`--ambig-filter-frac`), **Max fragment length** (`--max-fragment-length`), **Min fragment length** (`--min-fragment-length`), **Keep intervals** (`--keep-intervals`), **Library** (`--library`), **Maximum mapping quality** (`--maximum-mapping-quality`), **Minimum mapping quality** (`--minimum-mapping-quality`),  **Mate too distant length** (`--mate-too-distant-length`), **Do not require soft clips** (`--dont-require-soft-clips-both-ends`), **Filter too short** (`--filter-too-short`), **Platform filter name** (`--platform-filter-name`), **Black listed lanes** (`--black-listed-lanes`), **Read group black list** (`--read-group-black-list`), **Keep read group** (`--keep-read-group`), **Max read length** (`--max-read-length`), **Min read length** (`--min-read-length`), **Read name** (`--read-name`), **Keep reverse strand only** (`--keep-reverse-strand-only`), **Sample** (`--sample`), **Invert soft clip ratio filter** (`--invert-soft-clip-ratio-filter`), **Soft clipped leading trailing ratio** (`--soft-clipped-leading-trailing-ratio`), **Soft clipped ratio threshold** (`--soft-clipped-ratio-threshold`) . See the description of each parameter for information on the associated **Read filter**.\n* Note: Allele-specific annotations are not yet supported in the VCF mode.\n* Note: The wrapper has not been tested for the SAM file type on the **Input alignments** input port.\n* Note: DRAGEN-GATK features have not been tested. Once the full DRAGEN-GATK pipeline is released, parameters related to DRAGEN-GATK mode will be tested. \n\n### Performance Benchmarking\n\nBelow is a table describing the runtimes and task costs for a couple of samples with different file sizes.\n\n| Experiment type |  Input size | Paired-end | # of reads | Read length | Duration | Cost (on-demand) | AWS instance type |\n|:--------------:|:------------:|:--------:|:-------:|:---------:|:----------:|:------:|:------:|:------:|\n|     RNA-Seq     | 2.5 GB |     Yes    |     16M     |     101     |   52min   | 0.47$ | c4.2xlarge |\n|     RNA-Seq     | 7.5 GB |     Yes    |     50M     |     101     |   1h46min   | 0.95$ | c4.2xlarge |\n|     RNA-Seq     | 12.5 GB |     Yes    |     82M    |     101     |  2h40min  | 1.43$ | c4.2xlarge |\n|     RNA-Seq     | 24.5 GB |     Yes    |     164M    |     101     |  4h55min  | 2.64$ | c4.2xlarge |\n\n*Cost can be significantly reduced by using **spot instances**. Visit the [knowledge center](https://docs.sevenbridges.com/docs/about-spot-instances) for more details.*\n\n###Portability\n\n**GATK HaplotypeCaller** is tested with cwltool version: \"3.0.20201203173111\"\n\n### References\n[1] [GATK HaplotypeCaller](https://gatk.broadinstitute.org/hc/en-us/articles/360056969012-HaplotypeCaller)\n\n[2] [GATK Mapped sequence data formats](https://gatk.broadinstitute.org/hc/en-us/articles/360035890791-SAM-or-BAM-or-CRAM-Mapped-sequence-data-formats)",
                "label": "GATK HaplotypeCaller",
                "arguments": [
                    {
                        "prefix": "",
                        "shellQuote": false,
                        "position": 1,
                        "valueFrom": "${\n    if (inputs.mem_per_job) {\n        return '\\\"-Xmx'.concat(inputs.mem_per_job, 'M') + '\\\"';\n    } else {\n        return '\\\"-Xmx4000M\\\"';\n    }\n}"
                    },
                    {
                        "prefix": "",
                        "shellQuote": false,
                        "position": 2,
                        "valueFrom": "HaplotypeCaller"
                    },
                    {
                        "prefix": "--output",
                        "shellQuote": false,
                        "position": 3,
                        "valueFrom": "${\n  var output_name =  \"\";\n  var count = \"\";\n  var input_files = [].concat(inputs.in_alignments);\n  var tmp_ext = inputs.output_extension ? inputs.output_extension : \"vcf.gz\";\n  \n  if(inputs.emit_ref_confidence == 'GVCF' || inputs.emit_ref_confidence == 'BP_RESOLUTION'){\n      var output_ext = 'g.' + tmp_ext;\n  } \n  else {\n      var output_ext = tmp_ext;\n      \n  }\n  \n  var extension = \".\" + output_ext;\n    \n  if (input_files.length > 1){\n        count = \".\".concat(input_files.length);\n  }\n  if (inputs.output_prefix){\n    output_name = inputs.output_prefix;\n  } else {\n    if (input_files.length > 1){\n        input_files.sort(function(file1, file2) {\n            var file1_name = file1.basename.toUpperCase();\n            var file2_name = file2.basename.toUpperCase();\n            if (file1_name < file2_name) {\n                return -1;\n            }\n            if (file1_name > file2_name) {\n                return 1;\n            }\n            return 0;\n        });\n    }\n      \n    var sample_id = \"\";\n    var in_first_file = input_files[0];\n    \n    if (in_first_file.metadata && in_first_file.metadata.sample_id){\n      sample_id = in_first_file.metadata.sample_id;\n      }\n    if (sample_id){\n      output_name = sample_id;\n    } else {\n      output_name = in_first_file.basename.split('.')[0];\n    }\n  }\n  \n  // ensure there are no special characters in output_name\n  output_name = output_name.replace(/[^a-zA-Z0-9\\_\\-\\.]/g, \"\");\n  \n  return output_name + count + extension;\n}"
                    }
                ],
                "requirements": [
                    {
                        "class": "ShellCommandRequirement"
                    },
                    {
                        "class": "ResourceRequirement",
                        "ramMin": "${\n  var memory = 4000;\n  \n  if(inputs.mem_per_job) {\n  \t memory = inputs.mem_per_job;\n  }\n  if(inputs.mem_overhead_per_job) {\n\tmemory += inputs.mem_overhead_per_job;\n  }\n  else {\n      memory += 100;\n  }\n  return memory;\n}",
                        "coresMin": "${\n    return inputs.cpu_per_job ? inputs.cpu_per_job : 1;\n}"
                    },
                    {
                        "class": "DockerRequirement",
                        "dockerPull": "images.sbgenomics.com/marijeta_slavkovic/gatk-4-2-0-0:0"
                    },
                    {
                        "class": "InitialWorkDirRequirement",
                        "listing": []
                    },
                    {
                        "class": "InlineJavascriptRequirement",
                        "expressionLib": [
                            "\nvar setMetadata = function(file, metadata) {\n    if (!('metadata' in file)) {\n        file['metadata'] = {}\n    }\n    for (var key in metadata) {\n        file['metadata'][key] = metadata[key];\n    }\n    return file\n};\nvar inheritMetadata = function(o1, o2) {\n    var commonMetadata = {};\n    if (!o2) {\n        return o1;\n    };\n    if (!Array.isArray(o2)) {\n        o2 = [o2]\n    }\n    for (var i = 0; i < o2.length; i++) {\n        var example = o2[i]['metadata'];\n        for (var key in example) {\n            if (i == 0)\n                commonMetadata[key] = example[key];\n            else {\n                if (!(commonMetadata[key] == example[key])) {\n                    delete commonMetadata[key]\n                }\n            }\n        }\n        for (var key in commonMetadata) {\n            if (!(key in example)) {\n                delete commonMetadata[key]\n            }\n        }\n    }\n    if (!Array.isArray(o1)) {\n        o1 = setMetadata(o1, commonMetadata)\n        if (o1.secondaryFiles) {\n            o1.secondaryFiles = inheritMetadata(o1.secondaryFiles, o2)\n        }\n    } else {\n        for (var i = 0; i < o1.length; i++) {\n            o1[i] = setMetadata(o1[i], commonMetadata)\n            if (o1[i].secondaryFiles) {\n                o1[i].secondaryFiles = inheritMetadata(o1[i].secondaryFiles, o2)\n            }\n        }\n    }\n    return o1;\n};"
                        ]
                    }
                ],
                "sbg:categories": [
                    "Variant Calling",
                    "CWLtool Tested"
                ],
                "sbg:image_url": null,
                "sbg:license": "Apache License 2.0",
                "sbg:links": [
                    {
                        "id": "https://gatk.broadinstitute.org/hc/en-us",
                        "label": "Homepage"
                    },
                    {
                        "id": "https://github.com/broadinstitute/gatk",
                        "label": "Source Code"
                    },
                    {
                        "id": "https://github.com/broadinstitute/gatk/releases/download/4.2.0.0/gatk-4.2.0.0.zip",
                        "label": "Download"
                    },
                    {
                        "id": "https://www.biorxiv.org/content/10.1101/201178v3",
                        "label": "Publication"
                    },
                    {
                        "id": "https://gatk.broadinstitute.org/hc/en-us/articles/360056969012-HaplotypeCaller",
                        "label": "Documentation"
                    }
                ],
                "sbg:projectName": "SBG Public data",
                "sbg:revisionsInfo": [
                    {
                        "sbg:revision": 0,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1634729387,
                        "sbg:revisionNotes": null
                    },
                    {
                        "sbg:revision": 1,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1634729387,
                        "sbg:revisionNotes": "initial copy"
                    },
                    {
                        "sbg:revision": 2,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1634729387,
                        "sbg:revisionNotes": "description portability"
                    },
                    {
                        "sbg:revision": 3,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1634729388,
                        "sbg:revisionNotes": "changes after review process"
                    },
                    {
                        "sbg:revision": 4,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1648047573,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 5,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1648047573,
                        "sbg:revisionNotes": "categories"
                    }
                ],
                "sbg:toolAuthor": "Broad Institute",
                "sbg:toolkit": "GATK",
                "sbg:toolkitVersion": "4.2.0.0",
                "sbg:expand_workflow": false,
                "sbg:appVersion": [
                    "v1.2"
                ],
                "sbg:id": "admin/sbg-public-data/gatk-haplotypecaller-4-2-0-0/5",
                "sbg:revision": 5,
                "sbg:revisionNotes": "categories",
                "sbg:modifiedOn": 1648047573,
                "sbg:modifiedBy": "admin",
                "sbg:createdOn": 1634729387,
                "sbg:createdBy": "admin",
                "sbg:project": "admin/sbg-public-data",
                "sbg:sbgMaintained": false,
                "sbg:validationErrors": [],
                "sbg:contributors": [
                    "admin"
                ],
                "sbg:latestRevision": 5,
                "sbg:publisher": "sbg",
                "sbg:content_hash": "ad203c311e5a98de23da72909b9e6a0e7b6b065952d7c42cb94f51cf3cb04fbd5",
                "sbg:workflowLanguage": "CWL"
            },
            "label": "HaplotypeCaller",
            "sbg:x": 131.650634765625,
            "sbg:y": 136.51815795898438
        },
        {
            "id": "variant_effect_predictor_101_0_cwl1_0",
            "in": [
                {
                    "id": "in_variants",
                    "source": "gatk_haplotypecaller_4_2_0_0/out_variants"
                },
                {
                    "id": "cache_file",
                    "source": "cache_file"
                },
                {
                    "id": "variant_class",
                    "source": "variant_class"
                },
                {
                    "id": "pick",
                    "source": "pick"
                },
                {
                    "id": "species",
                    "source": "species"
                }
            ],
            "out": [
                {
                    "id": "vep_output_file"
                },
                {
                    "id": "compressed_vep_output"
                },
                {
                    "id": "summary_file"
                },
                {
                    "id": "warning_file"
                }
            ],
            "run": {
                "class": "CommandLineTool",
                "cwlVersion": "v1.0",
                "$namespaces": {
                    "sbg": "https://sevenbridges.com"
                },
                "id": "admin/sbg-public-data/variant-effect-predictor-101-0-cwl1-0/7",
                "baseCommand": [],
                "inputs": [
                    {
                        "sbg:category": "Input options",
                        "id": "in_variants",
                        "type": "File",
                        "inputBinding": {
                            "prefix": "--input_file",
                            "shellQuote": false,
                            "position": 0
                        },
                        "label": "Input VCF",
                        "doc": "Input VCF file to annotate.",
                        "sbg:fileTypes": "VCF, VCF.GZ"
                    },
                    {
                        "sbg:category": "Cache options",
                        "id": "cache_file",
                        "type": "File",
                        "label": "Species cache file",
                        "doc": "Cache file for the chosen species.",
                        "sbg:fileTypes": "TAR.GZ"
                    },
                    {
                        "sbg:category": "Execution",
                        "sbg:toolDefaultValue": "8",
                        "id": "cpu_per_job",
                        "type": "int?",
                        "label": "Number of CPUs",
                        "doc": "Number of CPUs to use."
                    },
                    {
                        "sbg:category": "Execution",
                        "sbg:toolDefaultValue": "15000",
                        "id": "mem_per_job",
                        "type": "int?",
                        "label": "Memory to use for the task",
                        "doc": "Assign memory for the execution in MB."
                    },
                    {
                        "sbg:category": "Input options",
                        "sbg:toolDefaultValue": "Use found assembly version",
                        "id": "assembly",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "GRCh37",
                                    "GRCh38"
                                ],
                                "name": "assembly"
                            }
                        ],
                        "inputBinding": {
                            "prefix": "--assembly",
                            "shellQuote": false,
                            "position": 0
                        },
                        "label": "Assembly version",
                        "doc": "Select the assembly version to use if more than one available. If using the cache, you must have the appropriate assembly's cache file installed. If not specified and you have only 1 assembly version installed, this will be chosen by default. For homo sapiens use either GRCh38 or GRCh37."
                    },
                    {
                        "sbg:category": "Cache options",
                        "id": "in_references",
                        "type": "File[]?",
                        "inputBinding": {
                            "prefix": "--fasta",
                            "shellQuote": false,
                            "position": 0
                        },
                        "label": "Fasta file(s) to use to look up reference sequence",
                        "doc": "Specify a FASTA file or a directory containing FASTA files to use to look up reference sequence. The first time you run the script with this parameter an index will be built which can take a few minutes. This is required if fetching HGVS annotations (--hgvs) or checking reference sequences (--check_ref) in offline mode (--offline), and optional with some performance increase in cache mode (--cache).",
                        "sbg:fileTypes": "FASTA, FA, FA.GZ, FASTA.GZ"
                    },
                    {
                        "sbg:category": "Basic options",
                        "sbg:toolDefaultValue": "8",
                        "id": "fork",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--fork",
                            "shellQuote": false,
                            "position": 0,
                            "valueFrom": "${\n  if (inputs.fork!=-1)\n  {\n    return inputs.fork;\n  }\n  else if (inputs.cpu_per_job)\n  {\n    return inputs.cpu_per_job;\n  }\n  else\n  {\n    return 8;\n  }\n}\n    "
                        },
                        "label": "Fork number",
                        "doc": "Enable forking, using the specified number of forks. Forking can dramatically improve the runtime of the script. Not used by default.",
                        "default": -1
                    },
                    {
                        "sbg:category": "Cache options",
                        "sbg:toolDefaultValue": "20000",
                        "id": "buffer_size",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--buffer_size",
                            "shellQuote": false,
                            "position": 0,
                            "valueFrom": "${\n  if (inputs.buffer_size!=-1 && inputs.buffer_size>1000)\n  \treturn inputs.buffer_size;\n  else\n    return 20000;\n}"
                        },
                        "label": "Buffer size to use",
                        "doc": "Sets the internal buffer size, corresponding to the number of variations that are read in to memory simultaneously. Set this lower to use less memory at the expense of longer run time, and higher to use more memory with a faster run time. Default = 5000.",
                        "default": -1
                    },
                    {
                        "sbg:category": "Plugins",
                        "id": "dbNSFP_file",
                        "type": "File?",
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 0,
                            "valueFrom": "${\n if (inputs.dbNSFP_file && inputs.dbNSFP_columns!=undefined)\n {\n   var tempout=\"--plugin dbNSFP,\".concat(inputs.dbNSFP_file.path).concat(\",\").concat(inputs.dbNSFP_columns.join());\n   return tempout;\n }\n else if (inputs.dbNSFP_file)\n {\n   var tempout=\"--plugin dbNSFP,\".concat(inputs.dbNSFP_file.path, ',FATHMM_pred,MetaSVM_pred,GERP++_RS');\n   return tempout;\n }\n else\n {\n   return '';\n }\n}"
                        },
                        "label": "dbNSFP database file",
                        "doc": "dbNSFP database file used by the dbNSFP plugin. Please note that dbNSFP 3.x versions should be used for GRCh38, whereas 2.x versions correspond to GRCh37.",
                        "sbg:fileTypes": "GZ",
                        "secondaryFiles": [
                            ".tbi"
                        ]
                    },
                    {
                        "sbg:category": "Plugins",
                        "sbg:toolDefaultValue": "FATHMM_pred,MetaSVM_pred,GERP++_RS",
                        "id": "dbNSFP_columns",
                        "type": "string[]?",
                        "label": "Columns of dbNSFP to report",
                        "doc": "Columns of dbNSFP database to be included in the VCF. Please see dbNSFP readme files for a full list."
                    },
                    {
                        "sbg:category": "Plugins",
                        "id": "dbscSNV_f",
                        "type": "File?",
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 0,
                            "valueFrom": "${\n if (inputs.dbscSNV_f)\n {\n   var tempout=\"--plugin dbscSNV,\".concat(inputs.dbscSNV_f.path);\n   return tempout;\n }\n else\n {\n   return \"\";\n }\n}\n\n"
                        },
                        "label": "dbscSNV database file",
                        "doc": "Preprocessed database file for the dbscSNV plugin.",
                        "sbg:fileTypes": "GZ",
                        "secondaryFiles": [
                            ".tbi"
                        ]
                    },
                    {
                        "sbg:category": "Other annotation sources",
                        "id": "gff_annotation_file",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--gff",
                            "shellQuote": false,
                            "position": 0
                        },
                        "label": "GFF annotation file",
                        "doc": "Use GFF transcript annotations as an annotation source. Requires a FASTA file of genomic sequence.",
                        "sbg:fileTypes": "GFF.GZ",
                        "secondaryFiles": [
                            ".tbi"
                        ]
                    },
                    {
                        "sbg:category": "Other annotation sources",
                        "id": "gtf_annotation_file",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--gtf",
                            "shellQuote": false,
                            "position": 0
                        },
                        "label": "GTF annotation file",
                        "doc": "Use GTF transcript annotations as an annotation source. Requires a FASTA file of genomic sequence.",
                        "sbg:fileTypes": "GTF.GZ",
                        "secondaryFiles": [
                            ".tbi"
                        ]
                    },
                    {
                        "sbg:category": "Other annotation sources",
                        "id": "bam_transcript_models_corrections_file",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--bam",
                            "shellQuote": false,
                            "position": 0
                        },
                        "label": "NCBI BAM file for correcting transcript models",
                        "doc": "Use BAM file of sequence alignments to correct transcript models not derived from reference genome sequence. Used to correct RefSeq transcript models. Enables --use_transcript_ref; add --use_given_ref to override this behaviour. Eligible BAM inputs are available from NCBI (see VEP documentation).",
                        "sbg:fileTypes": "BAM",
                        "secondaryFiles": [
                            ".bai"
                        ]
                    },
                    {
                        "sbg:category": "Other annotation sources",
                        "id": "custom_annotation_sources",
                        "type": "File[]?",
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 0,
                            "valueFrom": "${\n  if (inputs.custom_annotation_sources != undefined)\n  {\n    var tempout = '';\n    for (var k = 0, len=inputs.custom_annotation_sources.length; k < len; k++)\n    {\n      if (inputs.custom_annotation_sources[k].path != '')\n      {\n        tempout = tempout.concat(' --custom ', inputs.custom_annotation_sources[k].path);\n        if ((inputs.custom_annotation_parameters[k] != 'None') && (inputs.custom_annotation_parameters[k] != undefined))\n        {\n          tempout = tempout.concat(',',inputs.custom_annotation_parameters[k]);\n        }\n      }\n    }\n  return tempout;\n  }\n}"
                        },
                        "label": "Custom annotation sources",
                        "doc": "Add custom annotation to the output. Files must be tabix indexed or in the bigWig format. Multiple files can be specified. See VEP documentation for full details.",
                        "secondaryFiles": [
                            ".tbi"
                        ]
                    },
                    {
                        "sbg:category": "Basic options",
                        "id": "config_file",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--config",
                            "shellQuote": false,
                            "position": 0
                        },
                        "label": "Optional config file",
                        "doc": "Load configuration options from a config file. The config file should consist of whitespace-separated pairs of option names and settings. Options from this file will be overwritten by options manually supplied on the command line."
                    },
                    {
                        "sbg:category": "Other annotation sources",
                        "id": "custom_annotation_parameters",
                        "type": "string[]?",
                        "label": "Annotation parameters for custom annotation sources (comma separated values, ensembl-vep --custom flag format)",
                        "doc": "Annotation parameters for custom annotation sources, one field for each custom annotation source supplied, in the same order. If no parameters should be applied to an annotation source, please type None. Entries should follow the ensembl-vep --custom flag format."
                    },
                    {
                        "sbg:category": "Other annotation sources",
                        "id": "custom_annotation_BigWig_sources",
                        "type": "File[]?",
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 0,
                            "valueFrom": "${\n  if (inputs.custom_annotation_BigWig_sources != undefined)\n  {\n    var tempout = '';\n    for (var k = 0, len=inputs.custom_annotation_BigWig_sources.length; k < len; k++)\n    {\n      if (inputs.custom_annotation_BigWig_sources[k].path != '')\n      {\n        tempout = tempout.concat(' --custom ', inputs.custom_annotation_BigWig_sources[k].path);\n        if ((inputs.custom_annotation_BigWig_parameters[k] != 'None') && (inputs.custom_annotation_BigWig_parameters[k] != undefined))\n        {\n          tempout = tempout.concat(',',inputs.custom_annotation_BigWig_parameters[k]);\n        }\n      }\n    }\n  return tempout;\n  }\n}"
                        },
                        "label": "Custom annotation - BigWig sources only",
                        "doc": "Custon annotation sources - please list your BigWig annotation sources only here.",
                        "sbg:fileTypes": "BW"
                    },
                    {
                        "sbg:category": "Other annotation sources",
                        "id": "custom_annotation_BigWig_parameters",
                        "type": "string[]?",
                        "label": "Annotation parameters for custom BigWig annotation sources only",
                        "doc": "Annotation parameters for custom BigWig annotation sources. One entry per source, in order of files supplied, in ensembl-vep --custom flag format."
                    },
                    {
                        "sbg:category": "Input options",
                        "sbg:toolDefaultValue": "STDERR",
                        "id": "warning_file_name",
                        "type": "string?",
                        "inputBinding": {
                            "prefix": "--warning_file",
                            "shellQuote": false,
                            "position": 0,
                            "valueFrom": "${\n  if (inputs.warning_file_name)\n  {\n    return inputs.warning_file_name.concat('_vep_warnings.txt');\n  }\n}"
                        },
                        "label": "Optional file name for warnings file output",
                        "doc": "File name to write warnings and errors to."
                    },
                    {
                        "sbg:category": "Output options",
                        "id": "individuals_to_annotate",
                        "type": "string[]?",
                        "inputBinding": {
                            "prefix": "--individual",
                            "itemSeparator": ",",
                            "shellQuote": false,
                            "position": 1,
                            "valueFrom": "${\n  if (inputs.individuals_to_annotate)\n  {\n    return inputs.individuals_to_annotate;\n  }\n}"
                        },
                        "label": "Samples to annotate [--individual]",
                        "doc": "Consider only alternate alleles present in the genotypes of the specified individual(s). May be a single individual, a list of samples or \"all\" to assess all individuals separately. Individual variant combinations homozygous for the given reference allele will not be reported. Each individual and variant combination is given on a separate line of output. Only works with VCF files containing individual genotype data; individual IDs are taken from column headers. Not used by default."
                    },
                    {
                        "sbg:category": "Basic options",
                        "sbg:toolDefaultValue": "False",
                        "id": "everything",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--everything",
                            "shellQuote": false,
                            "position": 1
                        },
                        "label": "Shortcut flag to turn on most commonly used annotations [--everything]",
                        "doc": "Shortcut flag to switch on all of the following: --sift b, --polyphen b, --ccds, --uniprot, --hgvs, --symbol, --numbers, --domains, --regulatory, --canonical, --protein, --biotype, --uniprot, --tsl, --appris, --gene_phenotype --af, --af_1kg, --af_esp, --af_gnomad, --max_af, --pubmed, --variant_class, --mane."
                    },
                    {
                        "sbg:category": "Cache options",
                        "sbg:toolDefaultValue": "101",
                        "id": "cache_version",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--cache_version",
                            "shellQuote": false,
                            "position": 2
                        },
                        "label": "Version of VEP cache if not default",
                        "doc": "Use a different cache version than the assumed default (the VEP version). This should be used with Ensembl Genomes caches since their version numbers do not match Ensembl versions. For example, the VEP/Ensembl version may be 74 and the Ensembl Genomes version 21. Not used by default."
                    },
                    {
                        "sbg:category": "Cache options",
                        "sbg:toolDefaultValue": "Ensembl cache",
                        "id": "cache_type",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "Ensembl cache",
                                    "RefSeq cache",
                                    "Merged cache"
                                ],
                                "name": "cache_type"
                            }
                        ],
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 2,
                            "valueFrom": "${\n  if (inputs.cache_type)\n  {\n    if (inputs.cache_type=='RefSeq cache')\n    {\n      return '--refseq';\n    }\n    else if (inputs.cache_type=='Merged cache')\n    {\n      return '--merged';\n    }\n    else\n    {\n      return '';\n    }\n  }\n  else\n  {\n    return '';\n  }\n}"
                        },
                        "label": "Specify whether the cache used is an Ensembl, RefSeq or merged VEP cache",
                        "doc": "Specify whether the cache used is an Ensembl, RefSeq or merged VEP cache (--refseq or --merged). Ensembl is the default and does not have to be specified as such.  Specify this option if you have installed the RefSeq cache in order for VEP to pick up the alternate cache directory. This cache contains transcript objects corresponding to RefSeq transcripts (to include CCDS and Ensembl ESTs also, use --all_refseq). Consequence output will be given relative to these transcripts in place of the default Ensembl transcripts.  Use the merged Ensembl and RefSeq cache. Consequences are flagged with the SOURCE of each transcript used."
                    },
                    {
                        "sbg:category": "Input options",
                        "sbg:toolDefaultValue": "False",
                        "id": "no_stats",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--no_stats",
                            "shellQuote": false,
                            "position": 2
                        },
                        "label": "Do not generate a stats file [--no_stats]",
                        "doc": "Don't generate a stats file. Provides marginal gains in run time."
                    },
                    {
                        "sbg:category": "Output options",
                        "sbg:toolDefaultValue": "False",
                        "id": "variant_class",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--variant_class",
                            "shellQuote": false,
                            "position": 3
                        },
                        "label": "Output Sequence Ontology variant class",
                        "doc": "Output the Sequence Ontology variant class. Not used by default."
                    },
                    {
                        "sbg:category": "Output options",
                        "sbg:toolDefaultValue": "False",
                        "id": "humdiv",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--humdiv",
                            "shellQuote": false,
                            "position": 4
                        },
                        "label": "PolyPhen2 HumDiv",
                        "doc": "Retrieve the humDiv PolyPhen prediction instead of the defaulat humVar. Not used by default.HumDiv-trained model should be used for evaluating rare alleles at loci potentially involved in complex phenotypes, dense mapping of regions identified by genome-wide association studies, and analysis of natural selection from sequence data, where even mildly deleterious alleles must be treated as damaging. Human only."
                    },
                    {
                        "sbg:category": "Output options",
                        "sbg:toolDefaultValue": "False",
                        "id": "sift",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "prediction",
                                    "score",
                                    "both (prediction and score)"
                                ],
                                "name": "sift"
                            }
                        ],
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 4,
                            "valueFrom": "${\n  if (inputs.sift)\n  {\n    if (inputs.sift == 'prediction')\n    {\n      return '--sift p';\n    }\n    else if (inputs.sift == 'score')\n    {\n      return '--sift s';\n    }\n    else if (inputs.sift == 'both (prediction and score)')\n    {\n      return '--sift b';\n    }\n  }\n}"
                        },
                        "label": "SIFT prediction",
                        "doc": "SIFT predicts whether an amino acid substitution affects protein function based on sequence homology and the physical properties of amino acids. VEP can output the prediction term, score or both. Not used by default"
                    },
                    {
                        "sbg:category": "Output options",
                        "sbg:toolDefaultValue": "Not used by default.",
                        "id": "polyphen",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "prediction",
                                    "score",
                                    "both (prediction and score)"
                                ],
                                "name": "polyphen"
                            }
                        ],
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 4,
                            "valueFrom": "${\n  if (inputs.polyphen)\n  {\n    if (inputs.polyphen == 'prediction')\n    {\n      return '--polyphen p';\n    }\n    else if (inputs.polyphen == 'score')\n    {\n      return '--polyphen s';\n    }\n    else if (inputs.polyphen == 'both (prediction and score)')\n    {\n      return '--polyphen b';\n    }\n  }\n}"
                        },
                        "label": "PolyPhen prediction",
                        "doc": "PolyPhen is a tool which predicts possible impact of an amino acid substitution on the structure and function of a human protein using straightforward physical and comparative considerations. VEP can output the prediction term, score or both. VEP uses the humVar score by default - please set the additional humDiv option to retrieve the humDiv score. Not used by default. Human only."
                    },
                    {
                        "sbg:category": "Output options",
                        "sbg:toolDefaultValue": "False",
                        "id": "domains",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--domains",
                            "shellQuote": false,
                            "position": 5
                        },
                        "label": "Overlapping protein domains",
                        "doc": "Adds names of overlapping protein domains to output."
                    },
                    {
                        "sbg:category": "Output options",
                        "sbg:toolDefaultValue": "False",
                        "id": "no_escape",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--no_escape",
                            "shellQuote": false,
                            "position": 5
                        },
                        "label": "No url escaping HGSV strings",
                        "doc": "Don't URI escape HGVS strings."
                    },
                    {
                        "sbg:category": "Output options",
                        "sbg:toolDefaultValue": "5000",
                        "id": "distance",
                        "type": "string?",
                        "inputBinding": {
                            "prefix": "--distance",
                            "shellQuote": false,
                            "position": 5
                        },
                        "label": "Distance",
                        "doc": "Modify the distance up and/or downstream between a variant and a transcript for which VEP will assign the upstream_gene_variant or downstream_gene_variant consequences. Giving one distance will modify both up- and downstream distances; prodiving two separated by commas will set the up- (5') and down- (3') stream distances respectively. Default: 5000"
                    },
                    {
                        "sbg:category": "Output options",
                        "id": "gene_phenotype",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--gene_phenotype",
                            "shellQuote": false,
                            "position": 5
                        },
                        "label": "Connect overlapped gene with phenotype",
                        "doc": "Indicates if the overlapped gene is associated with a phenotype, disease or trait. Not used by default."
                    },
                    {
                        "sbg:category": "Output options",
                        "sbg:toolDefaultValue": "False",
                        "id": "keep_csq",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--keep_csq",
                            "shellQuote": false,
                            "position": 5
                        },
                        "label": "Keep existing CSQ entries in the input VCF INFO field",
                        "doc": "Don't overwrite existing CSQ entry in VCF INFO field. Overwrites by default."
                    },
                    {
                        "sbg:category": "Output options",
                        "sbg:toolDefaultValue": "Sequence Ontology",
                        "id": "terms",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "Sequence Ontology",
                                    "Ensembl"
                                ],
                                "name": "terms"
                            }
                        ],
                        "inputBinding": {
                            "prefix": "--terms",
                            "shellQuote": false,
                            "position": 5,
                            "valueFrom": "${\n  if (inputs.terms)\n  {\n    if (inputs.terms == 'Sequence Ontology')\n    {\n      return 'SO';\n    }\n    else if (inputs.terms == 'Ensembl')\n    {\n      return 'ensembl';\n    }\n  }\n}"
                        },
                        "label": "Type of consequence terms to report",
                        "doc": "Type of consequence terms to output (Ensembl or Sequence Ontology) Default = Sequence Ontology."
                    },
                    {
                        "sbg:category": "Output options",
                        "sbg:toolDefaultValue": "False",
                        "id": "numbers",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--numbers",
                            "shellQuote": false,
                            "position": 5
                        },
                        "label": "Adds affected exon and intron numbering",
                        "doc": "Adds affected exon and intron numbering to to output. Format is Number/Total. Not used by default."
                    },
                    {
                        "sbg:category": "Output options",
                        "sbg:toolDefaultValue": "False",
                        "id": "total_length",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--total_length",
                            "shellQuote": false,
                            "position": 5
                        },
                        "label": "Add cDNA, CDS and protein positions (position/length)",
                        "doc": "Give cDNA, CDS and protein positions as Position/Length. Not used by default."
                    },
                    {
                        "sbg:category": "Output options",
                        "sbg:toolDefaultValue": "CSQ",
                        "id": "vcf_info_field",
                        "type": "string?",
                        "inputBinding": {
                            "prefix": "--vcf_info_field",
                            "shellQuote": false,
                            "position": 5
                        },
                        "label": "VCF info field name",
                        "doc": "Change the name of the INFO key that VEP write the consequences to in its VCF output. Use \"ANN\" for compatibility with other tools such as snpEff. Default: CSQ."
                    },
                    {
                        "sbg:category": "Output options",
                        "sbg:toolDefaultValue": "Not used by default",
                        "id": "nearest",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "transcript",
                                    "gene",
                                    "symbol"
                                ],
                                "name": "nearest"
                            }
                        ],
                        "inputBinding": {
                            "prefix": "--nearest",
                            "shellQuote": false,
                            "position": 5,
                            "valueFrom": "${\n  if (inputs.nearest)\n  {\n    return inputs.nearest;\n  }\n}"
                        },
                        "label": "Retrieve nearest transcript/gene",
                        "doc": "Retrieve the transcript or gene with the nearest protein-coding transcription start site (TSS) to each input variant. Use \"transcript\" to retrieve the transcript stable ID, \"gene\" to retrieve the gene stable ID, or \"symbol\" to retrieve the gene symbol. Note that the nearest TSS may not belong to a transcript that overlaps the input variant, and more than one may be reported in the case where two are equidistant from the input coordinates."
                    },
                    {
                        "sbg:category": "Output options",
                        "sbg:toolDefaultValue": "False",
                        "id": "allele_number",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--allele_number",
                            "shellQuote": false,
                            "position": 5
                        },
                        "label": "Identify allele number from VCF input",
                        "doc": "Identify allele number from VCF input, where 1 = first ALT allele, 2 = second ALT allele etc. Useful when using --minimal. Not used by default."
                    },
                    {
                        "sbg:category": "Output options",
                        "sbg:toolDefaultValue": "False",
                        "id": "no_headers",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--no_headers",
                            "shellQuote": false,
                            "position": 5
                        },
                        "label": "Do not write header lines to output files",
                        "doc": "Do not write header lines in output files."
                    },
                    {
                        "sbg:category": "Output options",
                        "sbg:toolDefaultValue": "False",
                        "id": "regulatory",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--regulatory",
                            "shellQuote": false,
                            "position": 6
                        },
                        "label": "Report overlaps with regulatory regions [--regulatory]",
                        "doc": "Look for overlaps with regulatory regions. The script can also call if a variant falls in a high information position within a transcription factor binding site. Output lines have a Feature type of RegulatoryFeature or MotifFeature. Not used by default."
                    },
                    {
                        "sbg:category": "Output options",
                        "sbg:toolDefaultValue": "Not used by default",
                        "id": "cell_type",
                        "type": "string[]?",
                        "inputBinding": {
                            "prefix": "--cell_type",
                            "itemSeparator": ",",
                            "shellQuote": false,
                            "position": 6,
                            "valueFrom": "${\n  if (inputs.cell_type)\n  {\n    return inputs.cell_type;\n  }\n}"
                        },
                        "label": "Cell type(s) to report regulatory regions for",
                        "doc": "Report only regulatory regions that are found in the given cell type(s). Can be a single cell type or a comma-separated list. The functional type in each cell type is reported under CELL_TYPE in the output."
                    },
                    {
                        "sbg:category": "Identifiers",
                        "id": "synonyms",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--synonyms",
                            "shellQuote": false,
                            "position": 8
                        },
                        "label": "Chromosome synonyms",
                        "doc": "Load a file of chromosome synonyms. File should be tab-delimited with the primary identifier in column 1 and the synonym in column 2. Synonyms are used bi-directionally so columns may be switched. Synoyms allow you to use different chromosome identifiers in your input file to those used in any annotation source used (cache, DB).",
                        "sbg:fileTypes": "TSV, TXT"
                    },
                    {
                        "sbg:category": "Identifiers",
                        "sbg:toolDefaultValue": "False",
                        "id": "appris",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--appris",
                            "shellQuote": false,
                            "position": 8
                        },
                        "label": "Add APPRIS identifiers",
                        "doc": "Adds the APPRIS isoform annotation for this transcript to the output. Not available for GRCh37. Not used by default."
                    },
                    {
                        "sbg:category": "Identifiers",
                        "sbg:toolDefaultValue": "False",
                        "id": "xref_refseq",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--xref_refseq",
                            "shellQuote": false,
                            "position": 8
                        },
                        "label": "Output aligned RefSeq mRNA identifier",
                        "doc": "Output aligned RefSeq mRNA identifier for transcript. NB: theRefSeq and Ensembl transcripts aligned in this way MAY NOT, AND FREQUENTLY WILL NOT, match exactly in sequence, exon structure and protein product."
                    },
                    {
                        "sbg:category": "Identifiers",
                        "sbg:toolDefaultValue": "False",
                        "id": "hgvs",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--hgvs",
                            "shellQuote": false,
                            "position": 8
                        },
                        "label": "Add HGVS identifiers",
                        "doc": "Add HGVS nomenclature based on Ensembl stable identifiers to the output. Both coding and protein sequence names are added where appropriate. A FASTA file is required to generate HGVS identifiers on SBPLA. HGVS notations given on Ensembl identifiers are versioned. Not used by default."
                    },
                    {
                        "sbg:category": "Identifiers",
                        "sbg:toolDefaultValue": "False",
                        "id": "hgvsg",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--hgvsg",
                            "shellQuote": false,
                            "position": 8
                        },
                        "label": "Add genomic HGVS identifiers",
                        "doc": "Add genomic HGVS nomenclature based on the input chromosome name. FASTA file is required. Not used by default."
                    },
                    {
                        "sbg:category": "Identifiers",
                        "sbg:toolDefaultValue": "False",
                        "id": "protein",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--protein",
                            "shellQuote": false,
                            "position": 8
                        },
                        "label": "Add Ensembl protein identifiers",
                        "doc": "Add Ensembl protein identifiers to the output where appropriate. Not used by default."
                    },
                    {
                        "sbg:category": "Identifiers",
                        "sbg:toolDefaultValue": "False",
                        "id": "symbol",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--symbol",
                            "shellQuote": false,
                            "position": 8
                        },
                        "label": "Add gene symbols where available",
                        "doc": "Adds the gene symbol (e.g. HGNC) (where available) to the output. Not used by default."
                    },
                    {
                        "sbg:category": "Identifiers",
                        "sbg:toolDefaultValue": "False",
                        "id": "ccds",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--ccds",
                            "shellQuote": false,
                            "position": 8
                        },
                        "label": "Add CCDS transcript identifers",
                        "doc": "Add CCDS transcript identifers (where available) to the output. Not used by default."
                    },
                    {
                        "sbg:category": "Identifiers",
                        "sbg:toolDefaultValue": "False",
                        "id": "uniprot",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--uniprot",
                            "shellQuote": false,
                            "position": 8
                        },
                        "label": "Add UniProt-associated database identifiers",
                        "doc": "Adds best match accessions for translated protein products from three UniProt-related databases (SWISSPROT, TREMBL and UniParc) to the output. Not used by default."
                    },
                    {
                        "sbg:category": "Identifiers",
                        "sbg:toolDefaultValue": "False",
                        "id": "tsl",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--tsl",
                            "shellQuote": false,
                            "position": 8
                        },
                        "label": "Add transcript support level",
                        "doc": "Add transcript support level for this transcript to the output. Note: not available for GRCh37.Not used by default."
                    },
                    {
                        "sbg:category": "Identifiers",
                        "sbg:toolDefaultValue": "False",
                        "id": "canonical",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--canonical",
                            "shellQuote": false,
                            "position": 8
                        },
                        "label": "Add a flag indicating if the transcript is canonical",
                        "doc": "Adds a flag indicating if the transcript is the canonical transcript for the gene. Not used by default."
                    },
                    {
                        "sbg:category": "Identifiers",
                        "sbg:toolDefaultValue": "False",
                        "id": "biotype",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--biotype",
                            "shellQuote": false,
                            "position": 8
                        },
                        "label": "Add biotype of transcript or regulatory feature",
                        "doc": "Adds the biotype of the transcript or regulatory feature. Not used by default."
                    },
                    {
                        "sbg:category": "Identifiers",
                        "sbg:toolDefaultValue": "Shift (1)",
                        "id": "shift_hgvs",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "Do not shift (0)",
                                    "Shift (1)"
                                ],
                                "name": "shift_hgvs"
                            }
                        ],
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 8,
                            "valueFrom": "${\n  if (inputs.shift_hgvs == 'Do not shift (0)')\n  {\n    return \"--shift_hgvs 0\";\n  }\n  else if (inputs.shift_hgvs == 'Shift (1)')\n  {\n    return \"--shift_hgvs 1\";\n  }\n}"
                        },
                        "label": "Enable or disable 3' shifting of HGVS notations",
                        "doc": "Enable or disable 3' shifting of HGVS notations. When enabled, this causes ambiguous insertions or deletions (typically in repetetive sequence tracts) to be \"shifted\" to their most 3' possible coordinates (relative to the transcript sequence and strand) before the HGVS notations are calculated; the flag HGVS_OFFSET is set to the number of bases by which the variant has shifted, relative to the input genomic coordinates. Disabling retains the original input coordinates of the variant. Default: 1 (shift)."
                    },
                    {
                        "sbg:category": "Co-located variants",
                        "sbg:toolDefaultValue": "Exclude failed variants [0]",
                        "id": "failed",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "Exclude failed variants [0]",
                                    "Include failed variants [1]"
                                ],
                                "name": "failed"
                            }
                        ],
                        "inputBinding": {
                            "prefix": "--failed",
                            "shellQuote": false,
                            "position": 10,
                            "valueFrom": "${\n  if (inputs.failed)\n  {\n    if (inputs.failed == 'Include failed variants [1]')\n    {\n      return '1';\n    }\n    else if (inputs.failed == 'Exclude failed variants [0]')\n    {\n      return '0';\n    }\n  }\n}"
                        },
                        "label": "Include failed collocated variants",
                        "doc": "When checking for co-located variants, by default the script will exclude variants that have been flagged as failed. Set this flag to include such variants. Default: 0 (exclude)."
                    },
                    {
                        "sbg:category": "Co-located variants",
                        "sbg:toolDefaultValue": "False",
                        "id": "check_existing",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--check_existing",
                            "shellQuote": false,
                            "position": 10
                        },
                        "label": "Check for co-located known variants",
                        "doc": "Check for the existence of known variants that are co-located with your input. By default the alleles are compared and variants on an allele-specific basis - to compare only coordinates, use --no_check_alleles option.  Some databases may contain variants with unknown (null) alleles and these are included by default; to exclude them use --exclude_null_alleles."
                    },
                    {
                        "sbg:category": "Co-located variants",
                        "sbg:toolDefaultValue": "False",
                        "id": "pubmed",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--pubmed",
                            "shellQuote": false,
                            "position": 10
                        },
                        "label": "Report Pubmed IDs for publications that cite an existing variant",
                        "doc": "Report Pubmed IDs for publications that cite existing variant. Must be used with a vep cache. Not used by default."
                    },
                    {
                        "sbg:category": "Co-located variants",
                        "sbg:toolDefaultValue": "False",
                        "id": "af",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--af",
                            "shellQuote": false,
                            "position": 10
                        },
                        "label": "Add 1000 genomes phase 3 global allele frequency",
                        "doc": "Add the global allele frequency (AF) from 1000 Genomes Phase 3 data for any known co-located variant to the output. For this and all --af_* flags, the frequency reported is for the input allele only, not necessarily the non-reference or derived allele. Supercedes --gmaf.Not used by default."
                    },
                    {
                        "sbg:category": "Co-located variants",
                        "sbg:toolDefaultValue": "False",
                        "id": "af_1kg",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--af_1kg",
                            "shellQuote": false,
                            "position": 10
                        },
                        "label": "Add allele frequency from continental 1000 genomes populations",
                        "doc": "Add allele frequency from continental populations (AFR,AMR,EAS,EUR,SAS) of 1000 Genomes Phase 3 to the output. Must be used with --cache. Supercedes --maf_1kg. Not used by default."
                    },
                    {
                        "sbg:category": "Co-located variants",
                        "sbg:toolDefaultValue": "False",
                        "id": "af_esp",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--af_esp",
                            "shellQuote": false,
                            "position": 10
                        },
                        "label": "Add allele frequency from NHLBI-ESP populations",
                        "doc": "Include allele frequency from NHLBI-ESP populations. Must be used with --cache. Supercedes --maf_esp. Not used by default."
                    },
                    {
                        "sbg:category": "Co-located variants",
                        "sbg:toolDefaultValue": "False",
                        "id": "af_gnomad",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "",
                            "shellQuote": false,
                            "position": 10,
                            "valueFrom": "${\n  if ((inputs.cache_version) && (inputs.cache_version < 90) && (inputs.af_gnomad))\n  {\n    return '--af_exac';\n  }\n  else if (inputs.af_gnomad)\n  {\n    return '--af_gnomad';\n  }\n}"
                        },
                        "label": "Add gnomAD allele frequencies (or ExAc frequencies with cache < 90)",
                        "doc": "Include allele frequency from Genome Aggregation Database (gnomAD) exome populations. Note only data from the gnomAD exomes are included; to retrieve data from the additional genomes data set, please see ensembl-vep documentation. Must be used with --cache Not used by default. If a vep cache version < 90 is used, the ExAc frequencies are reported instead."
                    },
                    {
                        "sbg:category": "Co-located variants",
                        "sbg:toolDefaultValue": "False",
                        "id": "exclude_null_alleles",
                        "type": "boolean?",
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 10,
                            "valueFrom": "${\n  if (inputs.check_existing)\n  {\n    if (inputs.exclude_null_alleles)\n    {\n      return '--exclude_null_alleles';\n    }\n  }\n  else\n  {\n    return '';\n  }\n}\n    "
                        },
                        "label": "Exclude null alleles when checking co-located variants",
                        "doc": "Do not include variants with unknown alleles when checking for co-located variants. The human variation database contains variants from HGMD and COSMIC for which the alleles are not publically available; by default these are included when using --check_existing, use this flag to exclude them. Not used by default."
                    },
                    {
                        "sbg:category": "Co-located variants",
                        "sbg:toolDefaultValue": "False",
                        "id": "no_check_alleles",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--no_check_alleles",
                            "shellQuote": false,
                            "position": 10
                        },
                        "label": "Do not check alleles of co-located variants",
                        "doc": "When checking for existing variants, by default VEP only reports a co-located variant if none of the input alleles are novel. For example, if the user input has alleles A/G, and an existing co-located variant has alleles A/C, the co-located variant will not be reported.  Strand is also taken into account - in the same example, if the user input has alleles T/G but on the negative strand, then the co-located variant will be reported since its alleles match the reverse complement of user input.  Use this flag to disable this behaviour and compare using coordinates alone. Not used by default."
                    },
                    {
                        "sbg:category": "Co-located variants",
                        "sbg:toolDefaultValue": "False",
                        "id": "max_af",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--max_af",
                            "shellQuote": false,
                            "position": 10
                        },
                        "label": "Report highest allele frequency observed in 1000 genomes, ESP or gnomAD populations",
                        "doc": "Report the highest allele frequency observed in any population from 1000 genomes, ESP or gnomAD. Not used by default."
                    },
                    {
                        "sbg:category": "Data format options",
                        "sbg:toolDefaultValue": "Not used by default",
                        "id": "compress_output",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "gzip",
                                    "bgzip"
                                ],
                                "name": "compress_output"
                            }
                        ],
                        "inputBinding": {
                            "prefix": "--compress_output",
                            "shellQuote": false,
                            "position": 11
                        },
                        "label": "Compress output",
                        "doc": "Writes output compressed using either gzip or bgzip. Not used by default"
                    },
                    {
                        "sbg:category": "Data format options",
                        "sbg:toolDefaultValue": "vcf",
                        "id": "output_format",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "vcf",
                                    "tab",
                                    "json"
                                ],
                                "name": "output_format"
                            }
                        ],
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 11,
                            "valueFrom": "${\n  if (inputs.output_format!='vcf')\n  {\n    if (inputs.output_format == 'tab')\n    {\n      return '--tab';\n    }\n    else if (inputs.output_format == 'json')\n    {\n      return '--json';\n    }\n  }\n  else if (inputs.output_format=='vcf')\n  {\n    return '--vcf';\n  }\n  else if (!inputs.most_severe)\n  {\n    return '--vcf';\n  }\n}"
                        },
                        "label": "Output format",
                        "doc": "Format in which to write the output. VCF by default.",
                        "default": "vcf"
                    },
                    {
                        "sbg:category": "Data format options",
                        "sbg:toolDefaultValue": "Not used by default",
                        "id": "fields",
                        "type": "string[]?",
                        "inputBinding": {
                            "prefix": "--fields",
                            "itemSeparator": ",",
                            "shellQuote": false,
                            "position": 11
                        },
                        "label": "Fields to configure the output format (VCF or tab only) with",
                        "doc": "Configure the output format using a list of fields. Fields may be those present in the default output columns, or any of those that appear in the Extra column (including those added by plugins or custom annotations). Output remains tab-delimited. Can only be used with tab or VCF format output. Not used by default."
                    },
                    {
                        "sbg:category": "Data format options",
                        "sbg:toolDefaultValue": "False",
                        "id": "minimal",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--minimal",
                            "shellQuote": false,
                            "position": 11
                        },
                        "label": "Convert alleles to minimal representation before assigning consequences",
                        "doc": "Convert alleles to their most minimal representation before consequence calculation i.e. sequence that is identical between each pair of reference and alternate alleles is trimmed off from both ends, with coordinates adjusted accordingly. Note this may lead to discrepancies between input coordinates and coordinates reported by VEP relative to transcript sequences; to avoid issues, use --allele_number and/or ensure that your input variants have unique identifiers. The MINIMISED flag is set in the VEP output where relevant. Not used by default."
                    },
                    {
                        "sbg:category": "Filtering and QC options",
                        "sbg:toolDefaultValue": "False",
                        "id": "dont_skip",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--dont_skip",
                            "shellQuote": false,
                            "position": 15
                        },
                        "label": "Do not skip input variants that fail validation",
                        "doc": "Don't skip input variants that fail validation, e.g. those that fall on unrecognised sequences."
                    },
                    {
                        "sbg:category": "Filtering and QC options",
                        "sbg:toolDefaultValue": "False",
                        "id": "allow_non_variant",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--allow_non_variant",
                            "shellQuote": false,
                            "position": 15
                        },
                        "label": "Keep non-variant lines (null ALT) in the VEP VCF output",
                        "doc": "When using VCF format as input and output, by default VEP will skip non-variant lines of input (where the ALT allele is null). Enabling this option the lines will be printed in the VCF output with no consequence data added."
                    },
                    {
                        "sbg:category": "Filtering and QC options",
                        "sbg:toolDefaultValue": "False",
                        "id": "check_ref",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--check_ref",
                            "shellQuote": false,
                            "position": 15
                        },
                        "label": "Check REF allele against provided reference sequence",
                        "doc": "Force the script to check the supplied reference allele against the sequence stored in the Ensembl Core database or supplied FASTA file. Lines that do not match are skipped. Not used by default."
                    },
                    {
                        "sbg:category": "Filtering and QC options",
                        "sbg:toolDefaultValue": "False",
                        "id": "gencode_basic",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--gencode_basic",
                            "shellQuote": false,
                            "position": 15
                        },
                        "label": "Limit analysis to GENCODE basic transcript set",
                        "doc": "Limit your analysis to transcripts belonging to the GENCODE basic set. This set has fragmented or problematic transcripts removed. Not used by default."
                    },
                    {
                        "sbg:category": "Filtering and QC options",
                        "sbg:toolDefaultValue": "False",
                        "id": "all_refseq",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--all_refseq",
                            "shellQuote": false,
                            "position": 15
                        },
                        "label": "Include Ensembl identifiers when using RefSeq and merged caches",
                        "doc": "When using the RefSeq or merged cache, include e.g. CCDS and Ensembl EST transcripts in addition to those from RefSeq (see documentation). Only works when using --refseq or --merged."
                    },
                    {
                        "sbg:category": "Filtering and QC options",
                        "sbg:toolDefaultValue": "False",
                        "id": "exclude_predicted",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--exclude_predicted",
                            "shellQuote": false,
                            "position": 15
                        },
                        "label": "Exclude predicted transcripts when using RefSeq or merged cache",
                        "doc": "When using RefSeq or merged caches, exclude predicted transcripts (i.e. those with identifiers beginning with \"XM_\" or \"XR_\")."
                    },
                    {
                        "sbg:category": "Filtering and QC options",
                        "id": "transcript_filter",
                        "type": "string?",
                        "inputBinding": {
                            "prefix": "--transcript_filter",
                            "shellQuote": false,
                            "position": 15
                        },
                        "label": "Filter transcripts according to arbitrary rules",
                        "doc": "Filter transcripts according to any arbitrary set of rules. Uses similar notation to filter_vep.  You may filter on any key defined in the root of the transcript object; most commonly this will be \"stable_id\":  --transcript_filter \"stable_id match N[MR]_\"."
                    },
                    {
                        "sbg:category": "Filtering and QC options",
                        "sbg:toolDefaultValue": "Not used by default",
                        "id": "chromosome_select",
                        "type": "string?",
                        "inputBinding": {
                            "prefix": "--chr",
                            "shellQuote": false,
                            "position": 15
                        },
                        "label": "Select a subset of chromosomes to analyse",
                        "doc": "Select a subset of chromosomes to analyse from your file. Any data not on this chromosome in the input will be skipped. The list can be comma separated, with \"-\" characters representing an interval. For example, to include chromosomes 1, 2, 3, 10 and X you could use --chr 1-3,10,X Not used by default."
                    },
                    {
                        "sbg:category": "Filtering and QC options",
                        "sbg:toolDefaultValue": "False",
                        "id": "coding_only",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--coding_only",
                            "shellQuote": false,
                            "position": 15
                        },
                        "label": "Only return consequences that fall in the coding regions of transcripts",
                        "doc": "Only return consequences that fall in the coding regions of transcripts. Not used by default."
                    },
                    {
                        "sbg:category": "Filtering and QC options",
                        "sbg:toolDefaultValue": "False",
                        "id": "no_intergenic",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--no_intergenic",
                            "shellQuote": false,
                            "position": 15
                        },
                        "label": "Exclude intergenic consequences from the output",
                        "doc": "Do not include intergenic consequences in the output. Not used by default."
                    },
                    {
                        "sbg:category": "Filtering and QC options",
                        "sbg:toolDefaultValue": "False",
                        "id": "most_severe",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--most_severe",
                            "shellQuote": false,
                            "position": 15
                        },
                        "label": "Output only the most severe consequence per variant",
                        "doc": "Output only the most severe consequence per variant. Transcript-specific columns will be left blank. Consequence ranks are given in this table. Not used by default."
                    },
                    {
                        "sbg:category": "Filtering and QC options",
                        "sbg:toolDefaultValue": "False",
                        "id": "summary",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--summary",
                            "shellQuote": false,
                            "position": 15
                        },
                        "label": "Output only a comma-separated list of all observed consequences per variant",
                        "doc": "Output only a comma-separated list of all observed consequences per variant. Transcript-specific columns will be left blank. Not used by default."
                    },
                    {
                        "sbg:category": "Filtering and QC options",
                        "sbg:toolDefaultValue": "False",
                        "id": "filter_common",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--filter_common",
                            "shellQuote": false,
                            "position": 15
                        },
                        "label": "Exclude variants with a common (>1 % AF) co-located variant",
                        "doc": "Shortcut flag for the filters below - this will exclude variants that have a co-located existing variant with global AF > 0.01 (1%). May be modified using any of the freq_* filters. Not used by default."
                    },
                    {
                        "sbg:category": "Filtering and QC options",
                        "sbg:toolDefaultValue": "False",
                        "id": "pick",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--pick",
                            "shellQuote": false,
                            "position": 15
                        },
                        "label": "Pick one line or block of consequence data per variant, including transcript-specific columns",
                        "doc": "Pick one line or block of consequence data per variant, including transcript-specific columns. Consequences are chosen according to the criteria described here, and the order the criteria are applied may be customised with --pick_order. This is the best method to use if you are interested only in one consequence per variant. Not used by default."
                    },
                    {
                        "sbg:category": "Filtering and QC options",
                        "sbg:toolDefaultValue": "False",
                        "id": "pick_allele",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--pick_allele",
                            "shellQuote": false,
                            "position": 15
                        },
                        "label": "Pick one line or block of consequence data per variant allele",
                        "doc": "Like --pick, but chooses one line or block of consequence data per variant allele. Will only differ in behaviour from --pick when the input variant has multiple alternate alleles. Not used by default."
                    },
                    {
                        "sbg:category": "Filtering and QC options",
                        "sbg:toolDefaultValue": "False",
                        "id": "per_gene",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--per_gene",
                            "shellQuote": false,
                            "position": 15
                        },
                        "label": "Output only the most severe consequence per gene",
                        "doc": "Output only the most severe consequence per gene. The transcript selected is arbitrary if more than one has the same predicted consequence. Uses the same ranking system as --pick. Not used by default."
                    },
                    {
                        "sbg:category": "Filtering and QC options",
                        "sbg:toolDefaultValue": "False",
                        "id": "pick_allele_gene",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--pick_allele_gene",
                            "shellQuote": false,
                            "position": 15
                        },
                        "label": "Pick one line or block of consequence data per variant allele and gene combination",
                        "doc": "Like --pick_allele, but chooses one line or block of consequence data per variant allele and gene combination. Not used by default."
                    },
                    {
                        "sbg:category": "Filtering and QC options",
                        "sbg:toolDefaultValue": "False",
                        "id": "flag_pick",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--flag_pick",
                            "shellQuote": false,
                            "position": 15
                        },
                        "label": "Pick one line or block of consequence data per variant with PICK flag",
                        "doc": "Pick one line or block of consequence data per variant, including transcript-specific columns, but add the PICK flag to the chosen block of consequence data and retains others. Not used by default.."
                    },
                    {
                        "sbg:category": "Filtering and QC options",
                        "sbg:toolDefaultValue": "False",
                        "id": "flag_pick_allele",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--flag_pick_allele",
                            "shellQuote": false,
                            "position": 15
                        },
                        "label": "Pick one line or block of consequence data per variant allele, with PICK flag",
                        "doc": "As per --pick_allele, but adds the PICK flag to the chosen block of consequence data and retains others. Not used by default."
                    },
                    {
                        "sbg:category": "Filtering and QC options",
                        "sbg:toolDefaultValue": "False",
                        "id": "flag_pick_allele_gene",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--flag_pick_allele_gene",
                            "shellQuote": false,
                            "position": 15
                        },
                        "label": "Pick one line or block of consequence data per variant allele and gene combination, with PICK flag",
                        "doc": "As per --pick_allele_gene, but adds the PICK flag to the chosen block of consequence data and retains others. Not used by default."
                    },
                    {
                        "sbg:category": "Filtering and QC options",
                        "sbg:toolDefaultValue": "canonical,appris,tsl,biotype,ccds,rank,length",
                        "id": "pick_order",
                        "type": "string[]?",
                        "inputBinding": {
                            "prefix": "--pick_order",
                            "itemSeparator": ",",
                            "shellQuote": false,
                            "position": 15
                        },
                        "label": "Customise the order of criteria applied when picking a block of annotation data",
                        "doc": "Customise the order of criteria applied when choosing a block of annotation data with e.g. --pick. Valid criteria are: canonical,appris,tsl,biotype,ccds,rank,length."
                    },
                    {
                        "sbg:category": "Filtering and QC options",
                        "sbg:toolDefaultValue": "False",
                        "id": "check_frequency",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--check_frequency",
                            "shellQuote": false,
                            "position": 16
                        },
                        "label": "Use frequency filtering",
                        "doc": "Turns on frequency filtering. Use this to include or exclude variants based on the frequency of co-located existing variants in the Ensembl Variation database. You must also specify all of the associated --freq_* flags. Frequencies used in filtering are added to the output under the FREQS key in the Extra field. Not used by default."
                    },
                    {
                        "sbg:category": "Filtering and QC options",
                        "sbg:toolDefaultValue": "Not used by default",
                        "id": "freq_pop",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "1000 genomes combined population (global) [1KG_ALL]",
                                    "1000 genomes combined African population [1KG_AFR]",
                                    "1000 genomes combined American population [1KG_AMR]",
                                    "1000 genomes combined East Asian population [1KG_EAS]",
                                    "1000 genomes combined European population [1KG_EUR]",
                                    "1000 genomes combined South Asian population [1KG_SAS]",
                                    "NHLBI-ESP African American [ESP_AA]",
                                    "NHLBI-ESP European American [ESP_EA]",
                                    "ExAC combined population [ExAC]",
                                    "ExAC combined adjusted population [ExAC_Adj]",
                                    "ExAC African [ExAC_AFR]",
                                    "ExAC American [ExAC_AMR]",
                                    "ExAC East Asian [ExAC_EAS]",
                                    "ExAC Finnish [ExAC_FIN]",
                                    "ExAC non-Finnish European [ExAC_NFE]",
                                    "ExAC South Asian [ExAC_SAS]",
                                    "ExAC other [ExAC_OTH]"
                                ],
                                "name": "freq_pop"
                            }
                        ],
                        "inputBinding": {
                            "prefix": "--freq_pop",
                            "shellQuote": false,
                            "position": 16,
                            "valueFrom": "${\n  if (inputs.freq_pop)\n  {\n    var tempout = inputs.freq_pop.split('[').pop(1);\n    tempout = tempout.split(']')[0];\n    return tempout;\n  }\n}"
                        },
                        "label": "Population to use in the frequency filter",
                        "doc": "Name of the population to use in frequency filter."
                    },
                    {
                        "sbg:category": "Filtering and QC options",
                        "sbg:toolDefaultValue": "Not used by default",
                        "id": "freq_freq",
                        "type": "float?",
                        "inputBinding": {
                            "prefix": "--freq_freq",
                            "shellQuote": false,
                            "position": 16
                        },
                        "label": "Allele frequency to use for filtering",
                        "doc": "Allele frequency to use for filtering. Must be a float value between 0 and 1."
                    },
                    {
                        "sbg:category": "Filtering and QC options",
                        "id": "freq_gt_lt",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "greater than",
                                    "less than"
                                ],
                                "name": "freq_gt_lt"
                            }
                        ],
                        "inputBinding": {
                            "prefix": "--freq_gt_lt",
                            "shellQuote": false,
                            "position": 16,
                            "valueFrom": "${\n  if (inputs.freq_gt_lt)\n  {\n    if (inputs.freq_gt_lt=='greater than')\n    {\n      return 'gt';\n    }\n    else if (inputs.freq_gt_lt=='less than')\n    {\n      return 'lt';\n    }\n  }\n}"
                        },
                        "label": "Frequency cutoff operator",
                        "doc": "Specify whether the frequency of the co-located variant must be greater than (gt) or less than (lt) the frequency filtering cutoff."
                    },
                    {
                        "sbg:category": "Filtering and QC options",
                        "id": "freq_filter",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "include",
                                    "exclude"
                                ],
                                "name": "freq_filter"
                            }
                        ],
                        "inputBinding": {
                            "prefix": "--freq_filter",
                            "shellQuote": false,
                            "position": 16
                        },
                        "label": "Specify whether to exclude or include only variants that pass the frequency filter",
                        "doc": "Specify whether to exclude or include only variants that pass the frequency filter."
                    },
                    {
                        "sbg:category": "Input options",
                        "sbg:toolDefaultValue": "Auto-detects",
                        "id": "format",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "ensembl",
                                    "vcf"
                                ],
                                "name": "format"
                            }
                        ],
                        "inputBinding": {
                            "prefix": "--format",
                            "shellQuote": false,
                            "position": 20
                        },
                        "label": "Input file format",
                        "doc": "Input file format - one of \"ensembl\", \"vcf\", \"pileup\", \"hgvs\", \"id\". By default, the script auto-detects the input file format. Using this option you can force the script to read the input file as Ensembl, VCF, pileup or HGVS format, a list of variant identifiers (e.g. rsIDs from dbSNP), or the output from the VEP (e.g. to add custom annotation to an existing results file using --custom)."
                    },
                    {
                        "sbg:category": "Input options",
                        "id": "input_data",
                        "type": "string?",
                        "inputBinding": {
                            "prefix": "--id",
                            "shellQuote": false,
                            "position": 20
                        },
                        "label": "Raw input data string",
                        "doc": "Raw input data as a string. May be used, for example, to input a single rsID or HGVS notation quickly to vep: --input_data rs699."
                    },
                    {
                        "sbg:category": "Input options",
                        "sbg:toolDefaultValue": "variant_effect_output.txt_summary.html",
                        "id": "stats_file",
                        "type": "string?",
                        "inputBinding": {
                            "prefix": "--stats_file",
                            "shellQuote": false,
                            "position": 20,
                            "valueFrom": "${\n  if (inputs.stats_file)\n  {\n    if (inputs.stats_text)\n    {\n      return inputs.stats_file.concat('_summary.txt');\n    }\n    else\n    {\n      return inputs.stats_file.concat('_summary.html');\n    }\n  }\n}"
                        },
                        "label": "Summary stats file name",
                        "doc": "Summary stats file name. This is an HTML file containing a summary of the VEP run."
                    },
                    {
                        "sbg:category": "Input options",
                        "sbg:toolDefaultValue": "False",
                        "id": "stats_text",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--stats_text",
                            "shellQuote": false,
                            "position": 20
                        },
                        "label": "Generate plain text stats file instead of HTML",
                        "doc": "Generate a plain text stats file in place of the HTML."
                    },
                    {
                        "sbg:category": "Other annotation sources",
                        "sbg:toolDefaultValue": "False",
                        "id": "use_given_ref_with_bam",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--use_given_ref",
                            "shellQuote": false,
                            "position": 45
                        },
                        "label": "Use user-provided ref allele with bam",
                        "doc": "Use user-provided reference alleles when BAM files (--bam flag) are used on input."
                    },
                    {
                        "sbg:category": "Other annotation sources",
                        "sbg:toolDefaultValue": "False unless --bam is activated",
                        "id": "use_transcript_ref",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--use_transcript_ref",
                            "shellQuote": false,
                            "position": 45
                        },
                        "label": "Override input reference allele with overlapped transcript ref allele",
                        "doc": "By default VEP uses the reference allele provided in the user input to calculate consequences for the provided alternate allele(s). Use this flag to force VEP to replace the user-provided reference allele with sequence derived from the overlapped transcript. This is especially relevant when using the RefSeq cache, see documentation for more details. The GIVEN_REF and USED_REF fields are set in the output to indicate any change. Not used by default."
                    },
                    {
                        "sbg:category": "Plugins",
                        "sbg:toolDefaultValue": "False",
                        "id": "use_LoFtool",
                        "type": "boolean?",
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 100,
                            "valueFrom": "${\n if (inputs.use_LoFtool== true)\n {\n   return \"--plugin LoFtool\";\n }\n else\n {\n   return \"\";\n }\n}"
                        },
                        "label": "Use LoFtool plugin",
                        "doc": "Activates the use of the LoFtool plugin."
                    },
                    {
                        "sbg:category": "Plugins",
                        "sbg:toolDefaultValue": "False",
                        "id": "use_MaxEntScan",
                        "type": "boolean?",
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 100,
                            "valueFrom": "${\n if (inputs.use_MaxEntScan== true)\n {\n   return \"--plugin MaxEntScan,/opt/vep/src/ensembl-vep/plugin-files\";\n }\n else\n {\n   return \"\";\n }\n}\n\n"
                        },
                        "label": "Use MaxEntScan plugin",
                        "doc": "Activates the use of the MaxEntScan plugin."
                    },
                    {
                        "sbg:category": "Plugins",
                        "sbg:toolDefaultValue": "False",
                        "id": "use_CSN",
                        "type": "boolean?",
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 100,
                            "valueFrom": "${\n if (inputs.use_CSN== true)\n {\n   return \"--plugin CSN\";\n }\n else\n {\n   return \"\";\n }\n}"
                        },
                        "label": "Use CSN plugin",
                        "doc": "Activates the use of the CSN plugin."
                    },
                    {
                        "sbg:toolDefaultValue": "tool-default-output-file-name",
                        "id": "output_file_name",
                        "type": "string?",
                        "inputBinding": {
                            "prefix": "--output_file",
                            "shellQuote": false,
                            "position": 10,
                            "valueFrom": "${\n  if (inputs.in_variants[0] instanceof Array) {\n        var input_1 = inputs.in_variants[0][0] // scatter mode\n    } \n    else if (inputs.in_variants instanceof Array) {\n        var input_1 = inputs.in_variants[0]\n    } \n    else {\n        var input_1 = [].concat(inputs.in_variants)[0]\n    }\n    \n  if (inputs.output_file_name=='tool-default-output-file-name')\n  {\n    var fileName=input_1.path.split('/').pop();\n    var tempout=fileName.split('.vcf')[0];\n    if (inputs.output_format == 'tab')\n    {\n      tempout = tempout.concat('','.vep.tab');\n    }\n    else if (inputs.output_format == 'json')\n    {\n      tempout = tempout.concat('','.vep.json');\n    }\n    else if (inputs.compress_output)\n    {\n      tempout = tempout.concat('','.vep.vcf.gz');\n    }\n    else if (inputs.most_severe)\n    {\n      tempout = tempout.concat('','.vep.tab');\n    }\n    else\n    {\n      tempout = tempout.concat('','.vep.vcf');\n    }\n    return tempout;    \n  }\n  else\n  {\n    var tempout = inputs.output_file_name;\n    if (inputs.output_format == 'tab')\n    {\n      tempout = tempout.concat('','.vep.tab');\n    }\n    else if (inputs.output_format == 'json')\n    {\n      tempout = tempout.concat('','.vep.json');\n    }\n    else if (inputs.compress_output)\n    {\n      tempout = tempout.concat('','.vep.vcf.gz');\n    }\n    else\n    {\n      tempout = tempout.concat('','.vep.vcf');  \n    }\n    return tempout;\n  }\n}"
                        },
                        "label": "Output file name",
                        "doc": "Output file name.",
                        "default": "tool-default-output-file-name"
                    },
                    {
                        "sbg:category": "Filtering and QC options",
                        "sbg:toolDefaultValue": "False",
                        "id": "lookup_ref",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--lookup_ref",
                            "shellQuote": false,
                            "position": 15
                        },
                        "label": "Overwrite the supplied reference allele",
                        "doc": "Force overwrite the supplied reference allele with the sequence stored in the supplied reference FASTA file."
                    },
                    {
                        "sbg:category": "Identifiers",
                        "sbg:toolDefaultValue": "False",
                        "id": "mane",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--mane",
                            "shellQuote": false,
                            "position": 8
                        },
                        "label": "Adds MANE identifiers",
                        "doc": "Adds a flag indicating if the transcript is the MANE Select transcript for the gene."
                    },
                    {
                        "sbg:category": "Basic options",
                        "sbg:toolDefaultValue": "10MB",
                        "id": "max_sv_size",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--max_sv_size",
                            "shellQuote": false,
                            "position": 1
                        },
                        "label": "Extend the maximum Structural Variant size",
                        "doc": "Extend the maximum Structural Variant size VEP can process. By default, VEP only annotates variants with a size of up to 10MB. By increasing the maximum it will increase the memory requirements for annotation."
                    },
                    {
                        "sbg:toolDefaultValue": "False",
                        "sbg:category": "Basic options",
                        "id": "no_check_variants_order",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--no_check_variants_order",
                            "shellQuote": false,
                            "position": 1
                        },
                        "label": "Permit the use of unsorted input files",
                        "doc": "Set to True if running VEP on unsorted input files. This slows down the tool and requires more memory."
                    },
                    {
                        "sbg:category": "Output options",
                        "sbg:toolDefaultValue": "False",
                        "id": "overlaps",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--overlaps",
                            "shellQuote": false,
                            "position": 3
                        },
                        "label": "Transcript overlap",
                        "doc": "Report the proportion and length of a transcript overlapped by a structural variant in VCF format."
                    },
                    {
                        "sbg:category": "Output options",
                        "sbg:toolDefaultValue": "0",
                        "id": "shift_3prime",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--shift_3prime",
                            "shellQuote": false,
                            "position": 6
                        },
                        "label": "Right align all variants",
                        "doc": "Right aligns all variants relative to their associated transcripts prior to consequence calculation. Set to 1 for VEP to right align (default is 0)."
                    },
                    {
                        "sbg:category": "Output options",
                        "sbg:toolDefaultValue": "0",
                        "id": "shift_genomic",
                        "type": "int?",
                        "inputBinding": {
                            "prefix": "--shift_genomic",
                            "shellQuote": false,
                            "position": 6
                        },
                        "label": "Right aligns all variants including intergenic variants",
                        "doc": "Right aligns all variants, including intergenic variants, before consequence calculation and updates the Location field. To right align set the value to 1 (default is 0)."
                    },
                    {
                        "sbg:category": "Output options",
                        "sbg:toolDefaultValue": "False",
                        "id": "shift_length",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--shift_length",
                            "shellQuote": false,
                            "position": 6
                        },
                        "label": "Shifted distance",
                        "doc": "Reports the distance each variant has been shifted when used in conjuction with --shift_3prime."
                    },
                    {
                        "sbg:category": "Output options",
                        "sbg:toolDefaultValue": "False",
                        "id": "show_ref_allele",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--show_ref_allele",
                            "shellQuote": false,
                            "position": 6
                        },
                        "label": "Add reference allele in the output",
                        "doc": "Adds the reference allele in the output. Mainly useful for the VEP \"default\" and tab-delimited output formats."
                    },
                    {
                        "sbg:toolDefaultValue": "False",
                        "sbg:category": "Identifiers",
                        "id": "transcript_version",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--transcript_version",
                            "shellQuote": false,
                            "position": 8
                        },
                        "label": "Add transcript version",
                        "doc": "Add version numbers to Ensembl transcript identifiers."
                    },
                    {
                        "sbg:toolDefaultValue": "False",
                        "sbg:category": "Co-located variants",
                        "id": "var_synonyms",
                        "type": "boolean?",
                        "inputBinding": {
                            "prefix": "--var_synonyms",
                            "shellQuote": false,
                            "position": 8
                        },
                        "label": "Report known synonyms for colocated variants",
                        "doc": "Report known synonyms for colocated variants."
                    },
                    {
                        "sbg:category": "Config Inputs",
                        "id": "species",
                        "type": "string?",
                        "inputBinding": {
                            "prefix": "--species",
                            "shellQuote": false,
                            "position": 10
                        },
                        "label": "Species",
                        "doc": "Species."
                    }
                ],
                "outputs": [
                    {
                        "id": "vep_output_file",
                        "doc": "Output file (annotated VCF) from VEP.",
                        "label": "VEP output file",
                        "type": "File?",
                        "outputBinding": {
                            "glob": "{*.vep.vcf,*.vep.json,*.vep.txt,*.vep.tab}",
                            "outputEval": "$(inheritMetadata(self, inputs.in_variants))"
                        },
                        "sbg:fileTypes": "VCF, TXT, JSON, TAB"
                    },
                    {
                        "id": "compressed_vep_output",
                        "doc": "Compressed (bgzip/gzip) output.",
                        "label": "Compressed (bgzip/gzip) output",
                        "type": "File?",
                        "outputBinding": {
                            "glob": "*.vep.*gz",
                            "outputEval": "$(inheritMetadata(self, inputs.in_variants))"
                        },
                        "sbg:fileTypes": "GZ"
                    },
                    {
                        "id": "summary_file",
                        "doc": "Summary stats file, if requested.",
                        "label": "Output summary stats file",
                        "type": "File?",
                        "outputBinding": {
                            "glob": "*summary.*",
                            "outputEval": "$(inheritMetadata(self, inputs.in_variants))"
                        },
                        "sbg:fileTypes": "HTML, TXT"
                    },
                    {
                        "id": "warning_file",
                        "doc": "Optional file with VEP warnings and errors.",
                        "label": "Optional file with VEP warnings and errors",
                        "type": "File?",
                        "outputBinding": {
                            "glob": "*_warnings.txt"
                        },
                        "sbg:fileTypes": "TXT"
                    }
                ],
                "doc": "**Variant Effect Predictor** predicts functional effects of genomic variants [1] and is used to annotate VCF files.\n\n**Variant Effect Predictor** determines the effect of your variants (SNPs, insertions, deletions, CNVs or structural variants) on genes, transcripts, and protein sequence, as well as regulatory regions [2].\n\n*A list of **all inputs and parameters** with corresponding descriptions can be found at the end of the page.*\n\n### Common Use Cases\n\n**Variant Effect Predictor** is a tool commonly used for variant and gene level annotation of VCF or VCF.GZ files. Running the tool on the Seven Bridges platform requires using a VEP cache file. VEP cache files can be obtained from our **Public Reference Files** section (`homo_sapiens_vep_101_GRCh37.indexed.tar.gz` and `homo_sapiens_vep_101_GRCh38.indexed.tar.gz`) or imported as files to your project from [Ensembl ftp site](ftp://ftp.ensembl.org/pub/release-101/variation/indexed_vep_cache/) using the [FTP/HTTP import](https://docs.sevenbridges.com/docs/upload-from-an-ftp-server) feature.\n\n### Changes Introduced by Seven Bridges\n\n- Additional boolean flags are introduced to activate the use of plugins included in the Seven Bridges version of the tool (CSN, MaxEntScan, and LoFtool plugins can be accessed with parameters **Use CSN plugin**, **Use MaxEntScan plugin**, and **Use LoFtool plugin**, respectively).\n- When using custom annotation sources (`--custom` flag) input files and parameters are specified separately and both must be provided to run the tool (inputs **Custom annotation sources** and **Annotation parameters for custom annotation sources (comma separated values, ensembl-vep --custom flag format)**). Additionally, separate inputs have been provided for BigWig custom annotation sources and parameters, as these files do not require indexing before use (inputs **Custom annotation - BigWig sources only** and **Annotation parameters for custom BigWig annotation sources only**). Tabix TBI indices are required for other custom annotation sources.\n- The following parameters have been excluded from the Seven Bridges version of the tool:\n    * `--help`: Not present in the Seven Bridges version in general.\n    * `--quiet`: Warnings are desirable.\n    * `--species [species]`: Relevant only if **Variant Effect Predictor** is connecting to the Ensembl database online, which is not the case with the tool on the Platform.\n    * `--force_overwrite`: Overwriting existing output, which is not likely to be found on the Seven Bridges Platform.\n    * `--dir_cache [directory]`, `--dir_plugins [directory]`: Covered with a more general flag (`--dir`).\n    * `--cache`: The `--offline` argument is always used instead.\n    * `--format:` argument with its corresponding suboptions `hgvs`, and `id`. These options require an Ensembl database connection.\n    * `--show_cache_info`: This option only shows cache info and quits.\n    * `--plugin [plugin name]`: Several plugins are supplied in the **Variant Effect Predictor** tool on the Platform (e.g. dbNSFP [4], CSN, MaxEntScan, LoFtool). However, this option was not wrapped because, in order to use any plugin, it must be installed on the **Variant Effect Predictor** Docker image. Additional plugins can be added upon request.\n    * `--phased`: Used with plugins requiring phased data. No such plugins are present in the wrapper.\n    * `--database`: Database access-only option\n    * `--host [hostname]`: Database access-only option\n    * `--user [username]`: Database access-only option\n    * `--port [number]`: Database access-only option\n    * `--password [password]`: Database access-only option\n    * `--genomes`: Database access-only option\n    * `--lrg`: Database access-only option\n    * `--check_svs`: Database access-only option\n    * `--db_version [number]`: Database access-only option\n    * `--registry [filename]`: Database access-only option\n\n### Common Issues and Important Notes\n \n* Inputs **Input VCF** (`--input_file`) and **Species cache** files are required. They represent a variant file containing variants to be annotated and a database cache file used for annotating the most common variants found in the particular species, respectively. The cache file reduces the need to send requests to an outside **Variant Effect Predictor** relevant annotation database, which is usually located online.   \n* **Fasta file(s) to use to look up reference sequences** (`--fasta`) is not required, however, it is highly recommended when using **Variant Effect Predictor** in offline mode which requires a FASTA file for several annotations.\n* Please see flag descriptions or official documentation [3] for detailed descriptions of limitations.\n* The **Add gnomAD allele frequencies (or ExAc frequencies with cache < 90)** (`--af_exac` or `--af_gnomAD`) parameter should be set: Please note that ExAC data has been superseded by gnomAD data and is only accessible with older (<90) cache versions. The Seven Bridges version of the tool will automatically swap flags according to the cache version reported.\n* The **Include Ensembl identifiers when using RefSeq and merged caches** (`--all_refseq`) and **Exclude predicted transcripts when using RefSeq or merged cache** (`--exclude_predicted`) parameters should only be used with RefSeq or merged caches\n* The **Add APPRIS identifiers** (`--appris`) parameter - APPRIS is only available for GRCh38.\n* The **Fields to configure the output format (VCF or tab only) with** (`--fields`) parameter \n can only be used with VCF and TSV output.\n* The **Samples to annotate** (`--individual`) parameter requires that all samples of interest have proper genotype entries for all variant rows in the file. **Variant Effect Predictor** will not output multiple variant rows per sample if genotypes are missing in those rows.\n* If dbNSFP [4] is used for annotation, a preprocessed dbNSFP file (input **dbNSFP database file**) and dbNSFP column names (parameter **Columns of dbNSFP to report**) should be provided. dbNSFP column names should match the release of dbNSFP provided for annotation (for a detailed list of column names, please consult the [readme files accompanying the dbNSFP release](https://sites.google.com/site/jpopgen/dbNSFP) used for annotation). If no dbNSFP column names are provided alongside a dbNSFP annotation file, the following example subset of columns applicable to dbNSFP versions 2.9.3, 3.Xc and 4.0c will be used for annotation: `FATHMM_pred,MetaSVM_pred,GERP++_RS`.\n * If using dbscSNV for annotation, a dbscSNV file (input **dbscSNV database file**) should be provided.\n* The **Version of VEP cache if not default** parameter (`--cache_version`) must be supplied if not using a VEP 101 cache.\n* If using custom annotation sources (input **Custom annotation sources**), corresponding parameters (input **Annotation parameters for custom annotation sources (comma separated values, ensembl-vep --custom flag format)**) must be set and must match the order of supplied input files.\n* Input parameter **Output only the most severe consequence per variant** (`--most_severe`) is incompatible with **Output format** `vcf`. Using this parameter produces a tab-separated output file.\n\nThe input files **GFF annotation** (`--gff`) and **GTF annotation** (`--gtf`), which are used for transcript annotation, should be bgzipped (using the **Tabix Bgzip** tool) and tabix-indexed (using the **Tabix Index** tool), and a FASTA file containing genomic sequences is required (input **Fasta file(s) to use to look up reference sequence**). If preprocessing these files locally, implement the following [1]:\n\n    grep -v \"#\" data.gff | sort -k1,1 -k4,4n -k5,5n | bgzip -c > data.gff.gz\n\n    tabix -p gff data.gff.gz\n\n\n### Performance Benchmarking\n\nPerformance of **Variant Effect Predictor** will vary greatly depending on the annotation options selected and input file size. Increasing the number of forks used with the parameter **Fork number** (`--fork`) and the number of processors will help. Additionally, tabix-indexing your supplied FASTA file, or setting the **Do not generate a stats file** (`--no_stats`) flag will speed up annotation. Preprocessing the VEP cache using the **convert_cache.pl** script included in the **ensembl-vep distribution** will also help if using **Check for co-located known variants** (`--check_existing`) flag or any of the allele frequency associated flags. VEP caches available on the Seven Bridges Platform are indexed Ensembl VEP cache files obtained directly from their [ftp repository](ftp://ftp.ensembl.org/pub/release-100/variation/indexed_vep_cache/).\nUsing **Add HGVS identifiers** (`--hgvs`) parameter will slow down the annotation process.\n\nIn the following table you can find estimates of **Variant Effect Predictor** running time and cost. The sample that was annotated was NA12878 genome (~100 Mb, as VCF.GZ).\n\n*Cost can be significantly reduced by **spot instance** usage. Visit [knowledge center](https://docs.sevenbridges.com/docs/about-spot-instances) for more details.*            \n\n                   \n| Experiment type  | Duration | Cost | Instance (AWS)|\n|-----------------------|-----------------|------------|-----------------|-------------|--------------|------------------|-------------|---------------|\n| All available annotations, all plugins and dbNSFP4.0c   | 3h 28 min   | $1.79            |c4.2xlarge      |\n| Basic annotations, without plugins and dbNSFP4.0c  | 37 min    | $0.23                | c4.2xlarge     |\n\n\n### References\n\n[1] [Ensembl Variant Effect Predictor github page](https://github.com/Ensembl/ensembl-vep)\n\n[2] [Homepage](http://www.ensembl.org/info/docs/tools/vep/script/index.html)\n\n[3] [Running VEP - Documentation page](https://www.ensembl.org/info/docs/tools/vep/script/vep_options.html)\n\n[4] [dbNSFP](https://sites.google.com/site/jpopgen/dbNSFP)",
                "label": "Variant Effect Predictor CWL1.0",
                "arguments": [
                    {
                        "prefix": "",
                        "shellQuote": false,
                        "position": 0,
                        "valueFrom": "${ return \"tar xfz\";\n}"
                    },
                    {
                        "prefix": "",
                        "shellQuote": false,
                        "position": 0,
                        "valueFrom": "$(inputs.cache_file.path)"
                    },
                    {
                        "prefix": "",
                        "shellQuote": false,
                        "position": 0,
                        "valueFrom": "${ return \"-C /opt/vep/src/ensembl-vep/ &&\";\n}"
                    },
                    {
                        "prefix": "",
                        "shellQuote": false,
                        "position": 0,
                        "valueFrom": "${\n  return \"perl -I /root/.vep/Plugins/\";\n}"
                    },
                    {
                        "prefix": "",
                        "shellQuote": false,
                        "position": 0,
                        "valueFrom": "${ return \"/opt/vep/src/ensembl-vep/vep\";\n}"
                    },
                    {
                        "prefix": "",
                        "shellQuote": false,
                        "position": 0,
                        "valueFrom": "--offline"
                    },
                    {
                        "prefix": "--dir",
                        "shellQuote": false,
                        "position": 0,
                        "valueFrom": "/opt/vep/src/ensembl-vep"
                    },
                    {
                        "prefix": "",
                        "shellQuote": false,
                        "position": 1000,
                        "valueFrom": "${\n  if ((!inputs.no_stats) && (!inputs.stats_text))\n  {\n    return \"; sed -i 's=http:\\/\\/www.google.com\\/jsapi=https:\\/\\/www.google.com\\/jsapi=g' *summary.html\";\n  }\n}"
                    }
                ],
                "requirements": [
                    {
                        "class": "ShellCommandRequirement"
                    },
                    {
                        "class": "ResourceRequirement",
                        "ramMin": "${\n  if(inputs.memory_for_job>0)\n  \treturn inputs.memory_for_job;\n  else\n    return 15000;\n}",
                        "coresMin": "${\n  if(inputs.cpu_per_job>0)\n  \treturn inputs.cpu_per_job;\n  else\n    return 8;\n}"
                    },
                    {
                        "class": "DockerRequirement",
                        "dockerPull": "images.sbgenomics.com/lea_lenhardt_ackovic/ensembl-vep-101-0:0"
                    },
                    {
                        "class": "InlineJavascriptRequirement",
                        "expressionLib": [
                            "\nvar setMetadata = function(file, metadata) {\n    if (!('metadata' in file))\n        file['metadata'] = metadata;\n    else {\n        for (var key in metadata) {\n            file['metadata'][key] = metadata[key];\n        }\n    }\n    return file\n};\n\nvar inheritMetadata = function(o1, o2) {\n    var commonMetadata = {};\n    if (!Array.isArray(o2)) {\n        o2 = [o2]\n    }\n    for (var i = 0; i < o2.length; i++) {\n        var example = o2[i]['metadata'];\n        for (var key in example) {\n            if (i == 0)\n                commonMetadata[key] = example[key];\n            else {\n                if (!(commonMetadata[key] == example[key])) {\n                    delete commonMetadata[key]\n                }\n            }\n        }\n    }\n    if (!Array.isArray(o1)) {\n        o1 = setMetadata(o1, commonMetadata)\n    } else {\n        for (var i = 0; i < o1.length; i++) {\n            o1[i] = setMetadata(o1[i], commonMetadata)\n        }\n    }\n    return o1;\n};",
                            "\nvar setMetadata = function(file, metadata) {\n    if (!('metadata' in file)) {\n        file['metadata'] = {}\n    }\n    for (var key in metadata) {\n        file['metadata'][key] = metadata[key];\n    }\n    return file\n};\nvar inheritMetadata = function(o1, o2) {\n    var commonMetadata = {};\n    if (!o2) {\n        return o1;\n    };\n    if (!Array.isArray(o2)) {\n        o2 = [o2]\n    }\n    for (var i = 0; i < o2.length; i++) {\n        var example = o2[i]['metadata'];\n        for (var key in example) {\n            if (i == 0)\n                commonMetadata[key] = example[key];\n            else {\n                if (!(commonMetadata[key] == example[key])) {\n                    delete commonMetadata[key]\n                }\n            }\n        }\n        for (var key in commonMetadata) {\n            if (!(key in example)) {\n                delete commonMetadata[key]\n            }\n        }\n    }\n    if (!Array.isArray(o1)) {\n        o1 = setMetadata(o1, commonMetadata)\n        if (o1.secondaryFiles) {\n            o1.secondaryFiles = inheritMetadata(o1.secondaryFiles, o2)\n        }\n    } else {\n        for (var i = 0; i < o1.length; i++) {\n            o1[i] = setMetadata(o1[i], commonMetadata)\n            if (o1[i].secondaryFiles) {\n                o1[i].secondaryFiles = inheritMetadata(o1[i].secondaryFiles, o2)\n            }\n        }\n    }\n    return o1;\n};"
                        ]
                    }
                ],
                "sbg:toolkit": "ensembl-vep",
                "sbg:toolkitVersion": "101.0",
                "sbg:links": [
                    {
                        "id": "https://github.com/Ensembl/ensembl-vep",
                        "label": "Source Code"
                    },
                    {
                        "id": "http://www.ensembl.org/info/docs/tools/vep/script/index.html",
                        "label": "Homepage"
                    },
                    {
                        "id": "https://genomebiology.biomedcentral.com/articles/10.1186/s13059-016-0974-4",
                        "label": "Publication"
                    }
                ],
                "sbg:toolAuthor": "Ensembl",
                "sbg:license": "Modified Apache licence",
                "sbg:categories": [
                    "Annotation",
                    "VCF Processing"
                ],
                "sbg:revisionsInfo": [
                    {
                        "sbg:revision": 0,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1617277719,
                        "sbg:revisionNotes": null
                    },
                    {
                        "sbg:revision": 1,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1617277806,
                        "sbg:revisionNotes": "Final version"
                    },
                    {
                        "sbg:revision": 2,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1617277806,
                        "sbg:revisionNotes": "Default for cache version edited"
                    },
                    {
                        "sbg:revision": 3,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1617277806,
                        "sbg:revisionNotes": "Description edited"
                    },
                    {
                        "sbg:revision": 4,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1617277806,
                        "sbg:revisionNotes": "Output filename JS edited for array of files."
                    },
                    {
                        "sbg:revision": 5,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1617277806,
                        "sbg:revisionNotes": "Metadata inheritance for summary file added."
                    },
                    {
                        "sbg:revision": 6,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1625490165,
                        "sbg:revisionNotes": "Added --species input"
                    },
                    {
                        "sbg:revision": 7,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1648039700,
                        "sbg:revisionNotes": "categories update"
                    }
                ],
                "sbg:image_url": null,
                "sbg:projectName": "SBG Public data",
                "sbg:expand_workflow": false,
                "sbg:appVersion": [
                    "v1.0"
                ],
                "sbg:id": "admin/sbg-public-data/variant-effect-predictor-101-0-cwl1-0/7",
                "sbg:revision": 7,
                "sbg:revisionNotes": "categories update",
                "sbg:modifiedOn": 1648039700,
                "sbg:modifiedBy": "admin",
                "sbg:createdOn": 1617277719,
                "sbg:createdBy": "admin",
                "sbg:project": "admin/sbg-public-data",
                "sbg:sbgMaintained": false,
                "sbg:validationErrors": [],
                "sbg:contributors": [
                    "admin"
                ],
                "sbg:latestRevision": 7,
                "sbg:publisher": "sbg",
                "sbg:content_hash": "ad60fb9e6f4497fe114cce135b8e10c6c0cf0fd2d7675a5078492d29d98cf7d26",
                "sbg:workflowLanguage": "CWL"
            },
            "label": "Variant Effect Predictor",
            "sbg:x": 316.2168884277344,
            "sbg:y": 247.2168731689453
        },
        {
            "id": "bcftools_consensus",
            "in": [
                {
                    "id": "input_file",
                    "source": "variant_effect_predictor_101_0_cwl1_0/vep_output_file"
                },
                {
                    "id": "reference",
                    "source": "reference"
                }
            ],
            "out": [
                {
                    "id": "output_file"
                }
            ],
            "run": {
                "cwlVersion": "sbg:draft-2",
                "class": "CommandLineTool",
                "$namespaces": {
                    "sbg": "https://sevenbridges.com"
                },
                "id": "admin/sbg-public-data/bcftools-consensus/5",
                "label": "Bcftools Consensus",
                "description": "**BCFtools Consensus**: Create a consensus sequence by applying VCF variants to a reference FASTA file. \n\n\n**BCFtools** is a set of utilities that manipulate variant calls in the Variant Call Format (VCF) and its binary counterpart BCF. All commands work transparently with both VCFs and BCFs, both uncompressed and BGZF-compressed. Most commands accept VCF, bgzipped VCF and BCF with filetype detected automatically even when streaming from a pipe. Indexed VCF and BCF will work in all situations. Un-indexed VCF and BCF and streams will work in most, but not all situations. In general, whenever multiple VCFs are read simultaneously, they must be indexed and therefore also compressed. [1]\n\nA list of **all inputs and parameters** with corresponding descriptions can be found at the bottom of the page.\n\n\n### Common Use Cases\n\nBy default, the program will apply all ALT variants to the reference FASTA to obtain the consensus sequence. Can be also used with the **SAMtools Faidx** tool where the desired part of reference can be extracted and then provided  to this tool.\n\n\nUsing the **Sample** (`--sample`) (and, optionally, **Haplotype** (`--haplotype`) option will apply genotype (haplotype) calls from FORMAT/GT. \n```\n$bcftools consensus -s NA001 -f in.fa in.vcf.gz > out.fa\n```\n\nApply variants present in sample \"NA001\", output IUPAC codes using **Output in IUPAC** (`--iupac-codes`) option\n```\nbcftools consensus --iupac-codes -s NA001 -f in.fa in.vcf.gz > out.fa\n```\n\n### Changes Introduced by Seven Bridges\n\n* BCFtools works in all cases with gzipped and indexed VCF/BCF files. To be sure BCFtools works in all cases, we added subsequet bgzip and index commands if a VCF file is provided on input. If VCF.GZ is given on input only indexing will be done. Output type can still be chosen with the `output type` command.\n\n### Common Issues and Important Notes\n\n* By default, the program will apply all ALT variants to the reference FASTA to obtain the consensus sequence. \n\n * If the FASTA sequence does not match the REF allele at a given position, the tool will fail.\n\n### Performance Benchmarking\n\nIt took 5 minutes to execute this tool on AWS c4.2xlarge instance with a 56 KB VCF and a 3 GB reference FASTA file. The price is negligible ($0.02).\n\n*Cost can be significantly reduced by using **spot instances**. Visit the [Knowledge Center](https://docs.sevenbridges.com/docs/about-spot-instances) for more details.*\n\n### References\n[1 - BCFtools page](https://samtools.github.io/bcftools/bcftools.html)",
                "baseCommand": [
                    {
                        "script": "{\n  fname = $job.inputs.input_file.path.replace(/^.*[\\\\\\/]/, '')\n  if(fname.split('.').pop().toLowerCase() == 'gz'){ \n    fname = $job.inputs.input_file.path.replace(/^.*[\\\\\\/]/, '').replace(/\\.[^/.]+$/, \"\")\n    return \"bcftools index  -f -t \" + fname + \".gz &&\"\n  }\n  else{\n  \n    return \"bgzip -c -f \" + fname + \" > \" + fname + \".gz\" + \" && bcftools index -f -t \" + fname + \".gz &&\"\n  \n  }\n  \n  \n  \n}",
                        "class": "Expression",
                        "engine": "#cwl-js-engine"
                    },
                    "bcftools",
                    "consensus"
                ],
                "inputs": [
                    {
                        "sbg:category": "File Input",
                        "sbg:stageInput": "link",
                        "type": [
                            "File"
                        ],
                        "inputBinding": {
                            "position": 40,
                            "separate": true,
                            "valueFrom": {
                                "script": "{\n  fname = $job.inputs.input_file.path.replace(/^.*[\\\\\\/]/, '')\n  if(fname.split('.').pop().toLowerCase() == 'gz'){ \n    fname = $job.inputs.input_file.path.replace(/^.*[\\\\\\/]/, '').replace(/\\.[^/.]+$/, \"\")\n    return fname + \".gz\"\n  }\n  else{\n  \n    return fname + \".gz\"\n  \n  }\n  \n  \n  \n}",
                                "class": "Expression",
                                "engine": "#cwl-js-engine"
                            },
                            "sbg:cmdInclude": true
                        },
                        "label": "Input file",
                        "description": "Input VCF file.",
                        "sbg:fileTypes": "VCF, VCF.GZ",
                        "id": "#input_file"
                    },
                    {
                        "sbg:category": "General Options",
                        "sbg:altPrefix": "-i",
                        "type": [
                            "null",
                            "string"
                        ],
                        "inputBinding": {
                            "position": 5,
                            "prefix": "--include",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Include expression",
                        "description": "Include only sites for which the expression is true.",
                        "id": "#include_expression"
                    },
                    {
                        "sbg:category": "General Options",
                        "sbg:altPrefix": "-e",
                        "type": [
                            "null",
                            "string"
                        ],
                        "inputBinding": {
                            "position": 1,
                            "prefix": "--exclude",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Exclude expression",
                        "description": "Exclude sites for which the expression is true.",
                        "id": "#exclude_expression"
                    },
                    {
                        "sbg:category": "Configuration",
                        "type": [
                            "null",
                            "string"
                        ],
                        "label": "Output file name",
                        "description": "Name of the output file.",
                        "id": "#output_name"
                    },
                    {
                        "sbg:category": "General Options",
                        "sbg:altPrefix": "-s",
                        "type": [
                            "null",
                            "string"
                        ],
                        "inputBinding": {
                            "position": 20,
                            "prefix": "--sample",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Sample",
                        "description": "Apply variants of the given sample.",
                        "id": "#sample"
                    },
                    {
                        "sbg:category": "Execution",
                        "sbg:stageInput": null,
                        "sbg:toolDefaultValue": "1",
                        "type": [
                            "null",
                            "int"
                        ],
                        "label": "Number of CPUs",
                        "description": "Number of CPUs. Appropriate instance will be chosen based on this parameter.",
                        "id": "#cpu"
                    },
                    {
                        "sbg:category": "Execution",
                        "sbg:stageInput": null,
                        "sbg:toolDefaultValue": "1000",
                        "type": [
                            "null",
                            "int"
                        ],
                        "label": "Memory in MB",
                        "description": "Memory in MB. Appropriate instance will be chosen based on this parameter.",
                        "id": "#memory"
                    },
                    {
                        "sbg:category": "General Options",
                        "sbg:altPrefix": "-c",
                        "type": [
                            "null",
                            "File"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--chain",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Chain file",
                        "description": "A chain file for liftover.",
                        "id": "#chain"
                    },
                    {
                        "sbg:altPrefix": "-f",
                        "type": [
                            "File"
                        ],
                        "inputBinding": {
                            "position": 2,
                            "prefix": "--fasta-ref",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Reference Genome",
                        "description": "Reference sequence in fasta format.",
                        "sbg:fileTypes": "FASTA",
                        "id": "#reference"
                    },
                    {
                        "sbg:category": "General Options",
                        "sbg:altPrefix": "-h",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "1",
                                    "2",
                                    "R",
                                    "A",
                                    "LR,LA",
                                    "SR,SA"
                                ],
                                "name": "haplotype"
                            }
                        ],
                        "inputBinding": {
                            "position": 4,
                            "prefix": "--haplotype",
                            "separate": true,
                            "valueFrom": {
                                "script": "{\n\n  if($job.inputs.haplotype == '1'){return \"1\"}\n  if($job.inputs.haplotype == '2'){return \"2\"}\n  if($job.inputs.haplotype == 'R'){return \"R\"}\n  if($job.inputs.haplotype == 'A'){return \"A\"}\n  if($job.inputs.haplotype == 'LR,LA'){return \"LR,LA\"}\n  if($job.inputs.haplotype == 'SR,SA'){return \"SR,SA\"}\n\n\n\n\n\n}",
                                "class": "Expression",
                                "engine": "#cwl-js-engine"
                            },
                            "sbg:cmdInclude": true
                        },
                        "label": "Haplotype",
                        "description": "Choose which allele to use from the FORMAT/GT field.",
                        "id": "#haplotype"
                    },
                    {
                        "sbg:category": "General Options",
                        "sbg:altPrefix": "-I",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 6,
                            "prefix": "--iupac-codes",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Output in IUPAC",
                        "description": "Output variants in the form of IUPAC ambiguity codes.",
                        "id": "#iupac"
                    },
                    {
                        "sbg:category": "General Options",
                        "sbg:altPrefix": "-m",
                        "type": [
                            "null",
                            "File"
                        ],
                        "inputBinding": {
                            "position": 7,
                            "prefix": "--mask",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Mask file",
                        "description": "Replace regions with N.",
                        "id": "#mask"
                    },
                    {
                        "sbg:category": "General Options",
                        "sbg:altPrefix": "-M",
                        "type": [
                            "null",
                            "string"
                        ],
                        "inputBinding": {
                            "position": 8,
                            "prefix": "--missing",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Missing genotypes",
                        "description": "Output <char> instead of skipping the missing genotypes.",
                        "id": "#missing"
                    }
                ],
                "outputs": [
                    {
                        "type": [
                            "null",
                            "File"
                        ],
                        "label": "Output file",
                        "description": "Consensus sequence",
                        "sbg:fileTypes": "VCF, BCF, VCF.GZ, BCF.GZ",
                        "outputBinding": {
                            "glob": {
                                "script": "{\n  fname = $job.inputs.input_file.path.replace(/^.*[\\\\\\/]/, '')\n  if(fname.split('.').pop().toLowerCase() == 'gz'){ \n    fname = $job.inputs.input_file.path.replace(/^.*[\\\\\\/]/, '').replace(/\\.[^/.]+$/, \"\").split('.vcf')[0]\n  }\n  \n  else{\n  \n  fname = fname.replace(/\\.[^/.]+$/, \"\")\n  \n  }\n  \n  \n  return fname + \".fa\"\n}",
                                "class": "Expression",
                                "engine": "#cwl-js-engine"
                            },
                            "sbg:inheritMetadataFrom": "#input_file"
                        },
                        "id": "#output_file"
                    }
                ],
                "requirements": [
                    {
                        "class": "ExpressionEngineRequirement",
                        "id": "#cwl-js-engine",
                        "requirements": [
                            {
                                "dockerPull": "rabix/js-engine",
                                "class": "DockerRequirement"
                            }
                        ]
                    }
                ],
                "hints": [
                    {
                        "class": "sbg:CPURequirement",
                        "value": {
                            "class": "Expression",
                            "engine": "#cwl-js-engine",
                            "script": "{\n  if($job.inputs.cpu){\n    return $job.inputs.cpu}\n  else{\n    return 1}\n}"
                        }
                    },
                    {
                        "class": "sbg:MemRequirement",
                        "value": {
                            "class": "Expression",
                            "engine": "#cwl-js-engine",
                            "script": "{\n  if($job.inputs.memory){\n    return $job.inputs.memory}\n  else{\n    return 1000}\n}    "
                        }
                    },
                    {
                        "class": "DockerRequirement",
                        "dockerImageId": "21caaa02f72e",
                        "dockerPull": "images.sbgenomics.com/luka_topalovic/bcftools:1.9"
                    }
                ],
                "arguments": [
                    {
                        "position": 3,
                        "prefix": "--output",
                        "separate": true,
                        "valueFrom": {
                            "script": "{\n  fname = $job.inputs.input_file.path.replace(/^.*[\\\\\\/]/, '')\n  if(fname.split('.').pop().toLowerCase() == 'gz'){ \n    fname = $job.inputs.input_file.path.replace(/^.*[\\\\\\/]/, '').replace(/\\.[^/.]+$/, \"\").split('.vcf')[0]\n  }\n  \n  else{\n  \n  fname = fname.replace(/\\.[^/.]+$/, \"\")\n  \n  }\n  \n  \n  return fname + \".fa\"\n}",
                            "class": "Expression",
                            "engine": "#cwl-js-engine"
                        }
                    }
                ],
                "sbg:projectName": "SBG Public data",
                "sbg:toolkitVersion": "1.9",
                "sbg:toolAuthor": "Petr Danecek, Shane McCarthy, John Marshall",
                "sbg:categories": [
                    "VCF Processing"
                ],
                "sbg:links": [
                    {
                        "id": "http://samtools.github.io/bcftools/",
                        "label": "Homepage"
                    },
                    {
                        "id": "https://github.com/samtools/bcftools",
                        "label": "Source code"
                    },
                    {
                        "id": "https://github.com/samtools/bcftools/wiki",
                        "label": "Wiki"
                    },
                    {
                        "id": "https://github.com/samtools/bcftools/archive/1.9.zip",
                        "label": "Download"
                    }
                ],
                "sbg:cmdPreview": "bcftools index  -f -t input_file.vcf.gz && bcftools consensus --fasta-ref /path/to/reference.ext --output input_file.fa  input_file.vcf.gz",
                "sbg:revisionsInfo": [
                    {
                        "sbg:revision": 0,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1538758819,
                        "sbg:revisionNotes": null
                    },
                    {
                        "sbg:revision": 1,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1538758819,
                        "sbg:revisionNotes": "Initial"
                    },
                    {
                        "sbg:revision": 2,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1538758819,
                        "sbg:revisionNotes": "Description"
                    },
                    {
                        "sbg:revision": 3,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1538758819,
                        "sbg:revisionNotes": "Description"
                    },
                    {
                        "sbg:revision": 4,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1561459470,
                        "sbg:revisionNotes": "Updated default CPU and memory parameter"
                    },
                    {
                        "sbg:revision": 5,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1649155693,
                        "sbg:revisionNotes": "update categories"
                    }
                ],
                "sbg:toolkit": "bcftools",
                "abg:revisionNotes": "Initial version",
                "sbg:image_url": null,
                "sbg:job": {
                    "allocatedResources": {
                        "cpu": 8,
                        "mem": 10000
                    },
                    "inputs": {
                        "exclude_expression": "",
                        "memory": null,
                        "include_expression": "",
                        "missing": "",
                        "haplotype": null,
                        "reference": {
                            "class": "File",
                            "size": 0,
                            "secondaryFiles": [],
                            "path": "/path/to/reference.ext"
                        },
                        "output_name": "",
                        "sample": "",
                        "input_file": {
                            "class": "File",
                            "size": 0,
                            "secondaryFiles": [
                                {
                                    "path": ".tbi"
                                }
                            ],
                            "path": "/path/to/input_file.vcf.gz"
                        },
                        "iupac": false,
                        "cpu": null
                    }
                },
                "sbg:license": "MIT License",
                "sbg:expand_workflow": false,
                "sbg:appVersion": [
                    "sbg:draft-2"
                ],
                "sbg:id": "admin/sbg-public-data/bcftools-consensus/5",
                "sbg:revision": 5,
                "sbg:revisionNotes": "update categories",
                "sbg:modifiedOn": 1649155693,
                "sbg:modifiedBy": "admin",
                "sbg:createdOn": 1538758819,
                "sbg:createdBy": "admin",
                "sbg:project": "admin/sbg-public-data",
                "sbg:sbgMaintained": false,
                "sbg:validationErrors": [],
                "sbg:contributors": [
                    "admin"
                ],
                "sbg:latestRevision": 5,
                "sbg:publisher": "sbg",
                "sbg:content_hash": "a9d669b73713884d7f34213654edf77f54d7c666f68b136b3ca847cc9213dc5e1",
                "sbg:workflowLanguage": "CWL"
            },
            "label": "BCFftools Consensus",
            "sbg:x": 514.349365234375,
            "sbg:y": 76.30127716064453
        },
        {
            "id": "centrifuge_classifier_1",
            "in": [
                {
                    "id": "centrifuge_index_archive",
                    "source": "centrifuge_index_archive"
                },
                {
                    "id": "input_file",
                    "source": [
                        "input_reads"
                    ]
                }
            ],
            "out": [
                {
                    "id": "Centrifuge_report"
                },
                {
                    "id": "Classification_result"
                },
                {
                    "id": "un_conc_output"
                },
                {
                    "id": "al_conc_output"
                },
                {
                    "id": "aligned_unpaired_reads_output"
                },
                {
                    "id": "unaligned_unpaired_reads_output"
                }
            ],
            "run": {
                "cwlVersion": "sbg:draft-2",
                "class": "CommandLineTool",
                "$namespaces": {
                    "sbg": "https://sevenbridges.com"
                },
                "id": "admin/sbg-public-data/centrifuge-classifier-1/16",
                "label": "Centrifuge Classifier",
                "description": "**Centrifuge Classifier** is the main component of the Centrifuge suite, used for classification of metagenomics reads. Upon building (or downloading) and inspecting an Index (if desired), this tool can be used to process samples of interest. It can be used as a standalone tool, or as a part of **Metagenomics WGS analysis** workflow.\n\n**Centrifuge** is a novel microbial classification engine that enables rapid, accurate, and sensitive labeling of reads and quantification of species present in metagenomic samples. The system uses a novel indexing scheme based on the Burrows-Wheeler transform (BWT) and the Ferragina-Manzini (FM) index, optimized specifically for the metagenomic classification problem [1]. \n\n\nThe **Centrifuge Classifier** tool requires the following input files:\n\n- **Input reads** files with metagenomic reads - they can be in FASTQ or FASTA format, gzip-ed (extension .GZ) or bzip2-ed (extension .BZ2); in case of host-associated samples, it is presumed that files are already cleaned from  the host's genomic sequences;\n- **Reference index** in TAR format; for larger indexes the TAR.GZ format can be used, in this case we suggest the user manually set the required memory for the **Centrifuge Classifier** job by changing the value for the **Memory per job** parameter.\n\nThe results of the classification process are presented in two output files:\n\n- **Centrifuge report**, a tab delimited text file with containing results of an analysis for each taxonomic category from the reference organized into eight columns: (1) ID of a read, (2) sequence ID of the genomic sequence where the read is classified, (3) taxonomic ID of the genomic sequence from the second column, (4) the score of the classification, (5) the score for the next best classification, (6) an approximate number of base pairs of the read that match the genomic sequence, (7) the length of a read, and (8) the number of classifications for this read. The resulting line per read looks like the following:   \n     `HWUSI-EAS688_103028660:7:100:10014:18930 NC_020104.1 1269028 81 0 24 200 1`\n\n- **Classification result**, a tab delimited file with a classification summary for each genome or taxonomic unit from the reference index organized into seven columns: (1) the name of a genome, (2) taxonomic ID, (3) taxonomic rank, (4) the length of the genome sequence, (5) the number of reads classified to the provided genomic sequences, including multi-classified, (6) the number of reads uniquely classified to this particular genomic sequence, (7) the proportion of this genome normalized by its genomic length. The resulting line per genome looks like the following:   \n     `Streptococcus phage 20617 1392231 species 48800 1436 1325 0.453983`\n\n\nBased on the `--met-file` parameter value, **Centrifuge Classifier** can produce an additional output file with alignment metrics. However, it seems that this option does not work properly (see *Common Issues and Important Notes*). We suggest excluding it.\n\n*A list of **all inputs and parameters** with corresponding descriptions can be found at the end of the page.*\n\n### Common Use Cases\n\n**Centrifuge Classifier** takes files from the **Input reads** input node with raw reads (presumably cleaned from host genomic sequences as recommended by [Human Microbiome Project](https://hmpdacc.org/)) and one reference index file (in TAR ot TAR.GZ format) with microbial reference sequences. Based on the k-mer exact matching algorithm, Centrifuge assigns scores for each species on which k-mers from the read are aligned, and afterwards traverses upwards along the taxonomic tree to reduce the number of assignments, first by considering the genus that includes the largest number of species and then replacing those species with the genus. For more details on Centrifuge's algorithm see [1].\nThe results of the classification analysis are given for each reference sequence (in the **Classification result** file) and for each read (in the **Centrifuge report** file).\n\nThe index used in the analysis is Centrifuge's FM-index, whose size is reduced by compressing redundant genomic sequences. It can be downloaded from [Centrifuge's website](https://ccb.jhu.edu/software/centrifuge/manual.shtml) or created with the **Centrifuge Build** tool and/or the **Reference Index Creation workflow** provided by the Seven Bridges platform. In either case, it must be in the appropriate format (this can be checked with the **Centrifuge Inspect** tool). Based on our experience, an index should contain all of the organisms that are expected to be present in the sample. Providing an index with a smaller number of organisms (for example, in cases when the user is just interested in detecting one particular species) can result in miscalculated abundances of organisms within the sample.\n\n\n### Changes Introduced by Seven Bridges\n\n* **Centrifuge Classifier options** `--un`, `--un-conc`, `--al`, `--al-conc` and `--met-file` do not work properly, therefore all of them are excluded from the Seven Bridges version of the tool. In case a new release of the tool addresses these issues, an updated Seven Bridges version of the tool will be released as well.\n* The tool will automatically extract the index TAR file into the working directory and the basename from the **Reference genome** metadata field will be passed to **Centrifuge Classifier** using the `-x` argument.\n\n### Common Issues and Important Notes\n\n* If the index is in TAR.GZ format, the memory for **Centrifuge Classifier** should be set manually by changing the default value for the **Memory per job** parameter (in MB). Based on our experience, it would be enough to use twice as much memory as the size of the index file, with an additional 4GB overhead. For example, if the size of the index file is 8GB, the user should use 8 x 2 + 4 = 20GB, which amounts to 20 x 1024 = 20480MB.\n\n### Performance Benchmarking\n\n**Centrifuge Classifier** requires a significant amount of memory (based on our experience 4GB more than the size of the index files is suggested) in order to work properly. If the index is in TAR format, the tool will automatically allocate the required memory size. However, if the index is in TAR.GZ format, where the compression ratio is not always the same, we suggest the user manually set the required amount of memory necessary for the **Centrifuge Classifier** job. This can be done by changing the default **Memory per job** parameter value. This way, using expensive and memory overqualified instances, task failures would be avoided.\n\nIn the following table you can find estimates of **Centrifuge Classifier** running time and cost. All experiments are done with one sample. \n\n*Cost can be significantly reduced by using **spot instances**. Visit the [knowledge center](https://docs.sevenbridges.com/docs/about-spot-instances) for more details.*  \n\n| Experiment type | Input size | Duration | Cost | Instance (AWS)\n| --- | --- | --- | --- | --- |\n|p_h_v index (prokaryotic, human and viral genomes)|Index 6.9 GB, reads SRS013942 sample 2 x 1 GB| 11m| $ 0.11 | c4.2xlarge|\n|Viral index |Index 118 MB, reads SRS013942 sample 2 x 1 GB| 5m| $ 0.07 | c4.2xlarge|\n|Bacterial index |Index 13GB, reads SRS013942 sample 2 x 1 GB | 16m| $ 0.25 | c4.4xlarge|\n|Bacterial index |Index 13GB, reads SRS019027 sample 2 x 3.5 GB | 27m| $ 0.42 | c4.4xlarge|\n\n\n### References\n[1] Kim D, Song L, Breitwieser FP, and Salzberg SL. [Centrifuge: rapid and sensitive classification of metagenomic sequences](http://genome.cshlp.org/content/early/2016/11/16/gr.210641.116.abstract). Genome Research 2016",
                "baseCommand": [
                    {
                        "class": "Expression",
                        "script": "{\n  index_file = $job.inputs.centrifuge_index_archive.path\n  return \"tar -xvf \" + index_file + \"; \" + \"basename=$(ls | grep '.cf$' | head -1 | cut -d '.' -f 1); \"\n  \n}",
                        "engine": "#cwl-js-engine"
                    },
                    "centrifuge"
                ],
                "inputs": [
                    {
                        "sbg:stageInput": "link",
                        "sbg:category": "Input files",
                        "type": [
                            "File"
                        ],
                        "label": "Reference index",
                        "description": "The basename of the index for the reference genomes. The basename is the name of any of the index files up to but not including the final .1.cf / etc. centrifuge looks for the specified index first in the current directory, then in the directory specified in the CENTRIFUGE_INDEXES environment variable.",
                        "sbg:fileTypes": "TAR, TAR.GZ",
                        "id": "#centrifuge_index_archive"
                    },
                    {
                        "sbg:category": "Input files",
                        "type": [
                            {
                                "type": "array",
                                "items": "File"
                            }
                        ],
                        "inputBinding": {
                            "position": 5,
                            "separate": true,
                            "itemSeparator": " ",
                            "valueFrom": {
                                "class": "Expression",
                                "script": "{\n  filepath = ($job.inputs.input_file)[0].path\n  filename = filepath.split(\"/\").pop()\n  ext = filename.substr(filename.lastIndexOf('.') + 1)\n\n  if (ext === \"fa\" || ext === \"fasta\")\n  {\n    return \"-f \" \n  }\n  else if (ext === \"fq\" || ext === \"fastq\")\n  {\n    return \"-q \" \n  }\n}\n\n",
                                "engine": "#cwl-js-engine"
                            },
                            "sbg:cmdInclude": true
                        },
                        "label": "Input reads",
                        "description": "Read sequence in FASTQ or FASTA format. Could be also gzip'ed (extension .gz) or bzip2'ed (extension .bz2). In case of paired-end alignment it is crucial to set metadata 'paired-end' field to 1/2.",
                        "sbg:fileTypes": "FASTA, FASTQ, FA, FQ, FASTQ.GZ, FQ.GZ, FASTQ.BZ2, FQ.BZ2",
                        "id": "#input_file"
                    },
                    {
                        "sbg:stageInput": null,
                        "sbg:altPrefix": "-5",
                        "sbg:category": "Input",
                        "sbg:toolDefaultValue": "0",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--trim5",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Trim from 5'",
                        "description": "Trim specific number of bases from 5' (left) end of each read before alignment (default: 0).",
                        "id": "#trim_from_5"
                    },
                    {
                        "sbg:altPrefix": "-3",
                        "sbg:category": "Input",
                        "sbg:toolDefaultValue": "0",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--trim3",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Trim from 3'",
                        "description": "Trim specific number of bases from 3' (right) end of each read before alignment.",
                        "id": "#trim_from_3"
                    },
                    {
                        "sbg:altPrefix": "-u",
                        "sbg:category": "Input",
                        "sbg:toolDefaultValue": "No limit",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--upto",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Align first n reads",
                        "description": "Align the first n reads or read pairs from the input (after the -s/--skip reads or pairs have been skipped), then stop.",
                        "id": "#align_first_n_reads"
                    },
                    {
                        "sbg:stageInput": null,
                        "sbg:altPrefix": "-s",
                        "sbg:category": "Input",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--skip",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Skip the first n reads",
                        "description": "Skip (do not align) the first n reads or pairs in the input.",
                        "id": "#skip_n_reads"
                    },
                    {
                        "sbg:category": "Input",
                        "sbg:toolDefaultValue": "Phred+33",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "Phred+33",
                                    "Phred+64",
                                    "Integers"
                                ],
                                "name": "quality"
                            }
                        ],
                        "label": "Quality scale",
                        "description": "Input qualities are ASCII chars equal to Phred+33 or Phred+64 encoding, or ASCII integers (which are treated as being on the Phred quality scale).",
                        "id": "#quality"
                    },
                    {
                        "sbg:category": "Classification",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--host-taxids",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Host taxids",
                        "description": "A comma-separated list of taxonomic IDs that will be preferred in classification procedure. The descendants from these IDs will also be preferred. In case some of a read's assignments correspond to these taxonomic IDs, only those corresponding assignments will be reported.",
                        "id": "#host_taxids"
                    },
                    {
                        "sbg:category": "Classification",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--exclude-taxids",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Exclude taxids",
                        "description": "A comma-separated list of taxonomic IDs that will be excluded in classification procedure. The descendants from these IDs will also be exclude.",
                        "id": "#exclude_taxids"
                    },
                    {
                        "sbg:stageInput": null,
                        "sbg:altPrefix": "-t",
                        "sbg:category": "Output options",
                        "sbg:toolDefaultValue": "Off",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--time",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Time",
                        "description": "Print the wall-clock time required to load the index files and align the reads. This is printed to the \"standard error\" (\"stderr\") filehandle.",
                        "id": "#time"
                    },
                    {
                        "sbg:stageInput": null,
                        "sbg:category": "Output options",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--quiet",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Quiet",
                        "description": "Print nothing besides alignments and serious errors.",
                        "id": "#quiet"
                    },
                    {
                        "sbg:stageInput": null,
                        "sbg:category": "Output options",
                        "sbg:toolDefaultValue": "Metrics disabled",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--met-stderr",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Metrics standard error",
                        "description": "Write centrifuge metrics to the \"standard error\" (\"stderr\") filehandle. This is not mutually exclusive with --met-file. Having alignment metric can be useful for debugging certain problems, especially performance issues.",
                        "id": "#metrics_standard_error"
                    },
                    {
                        "sbg:stageInput": null,
                        "sbg:category": "Output options",
                        "sbg:toolDefaultValue": "1",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--met",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Metrics",
                        "description": "Write a new centrifuge metrics record every <int> seconds. Only matters if either --met-stderr or --met-file are specified.",
                        "id": "#met"
                    },
                    {
                        "sbg:altPrefix": "--threads",
                        "sbg:category": "Performance options",
                        "sbg:toolDefaultValue": "1",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "-p",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Parallel threads",
                        "description": "Launch NTHREADS parallel search threads (default: 1). Threads will run on separate processors/cores and synchronize when parsing reads and outputting alignments. Searching for alignments is highly parallel, and speedup is close to linear. Increasing -p increases Centrifuge's memory footprint. E.g. when aligning to a human genome index, increasing -p from 1 to 8 increases the memory footprint by a few hundred megabytes. This option is only available if bowtie is linked with the pthreads library (i.e. if BOWTIE_PTHREADS=0 is not specified at build time).",
                        "id": "#parallel_threads"
                    },
                    {
                        "sbg:stageInput": null,
                        "sbg:category": "Performance options",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--mm",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Memory mapping",
                        "description": "Use memory-mapped I/O to load the index, rather than typical file I/O. Memory-mapping allows many concurrent bowtie processes on the same computer to share the same memory image of the index (i.e. you pay the memory overhead just once). This facilitates memory-efficient parallelization of bowtie in situations where using -p is not possible or not preferable.",
                        "id": "#memory_mapping"
                    },
                    {
                        "sbg:stageInput": null,
                        "sbg:category": "Classification",
                        "sbg:toolDefaultValue": "22",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--min-hitlen",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Minimum length of partial hits",
                        "description": "Minimum length of partial hits, which must be greater than 15.",
                        "id": "#min_hitlen"
                    },
                    {
                        "sbg:stageInput": null,
                        "sbg:category": "Classification",
                        "sbg:toolDefaultValue": "0",
                        "type": [
                            "null",
                            "int"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--min-totallen",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Minimum summed length",
                        "description": "Minimum summed length of partial hits per read.",
                        "id": "#min_totallen"
                    },
                    {
                        "sbg:category": "Input",
                        "sbg:toolDefaultValue": "False",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--ignore-quals",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Ignore qualities",
                        "description": "Treat all quality values as 30 on Phred scale.",
                        "id": "#ignore_quals"
                    },
                    {
                        "sbg:category": "Input",
                        "sbg:toolDefaultValue": ".fq/.fastq",
                        "type": [
                            "null",
                            {
                                "type": "enum",
                                "symbols": [
                                    "FASTQ (.fq/.fastq)",
                                    "QSEQ",
                                    "FASTA (.fa/.mfa)",
                                    "raw-one-sequence-per-line",
                                    "comma-separated-lists"
                                ],
                                "name": "query_input_files"
                            }
                        ],
                        "label": "Query input files",
                        "description": "Query input files can be in FASTQ, (multi-) FASTA or QSEQ format, or one line per read.",
                        "id": "#query_input_files"
                    },
                    {
                        "sbg:category": "Input",
                        "type": [
                            "null",
                            "string"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--sra-acc",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "SRA accession number",
                        "description": "Comma-separated list of SRA accession numbers, e.g. --sra-acc SRR353653,SRR353654. Information about read types is available at http://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?sp=runinfo&acc=sra-acc&retmode=xml, where sra-acc is SRA accession number. If users run HISAT2 on a computer cluster, it is recommended to disable SRA-related caching (see the instruction at SRA-MANUAL).",
                        "id": "#SRA_accession_number"
                    },
                    {
                        "sbg:category": "Input",
                        "sbg:toolDefaultValue": "Off",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--nofw",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "No forward version",
                        "description": "Do not align forward (original) version of the read.",
                        "id": "#nofw"
                    },
                    {
                        "sbg:category": "Input",
                        "sbg:toolDefaultValue": "Off",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--norc",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "No reverse complement",
                        "description": "Do not align reverse-complement version of the read.",
                        "id": "#norc"
                    },
                    {
                        "sbg:category": "Output",
                        "sbg:toolDefaultValue": "tab",
                        "type": [
                            "null",
                            "string"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--out-fmt",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Output format",
                        "description": "Define output format, either 'tab' or 'sam'.",
                        "id": "#out_fmt"
                    },
                    {
                        "sbg:category": "Output",
                        "sbg:toolDefaultValue": "readID,seqID,taxID,score,2ndBestScore,hitLength,queryLength,numMatches",
                        "type": [
                            "null",
                            "string"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--tab-fmt-cols",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "Columns in tabular format",
                        "description": "Columns in tabular format, comma separated.",
                        "id": "#tab_fmt_cols"
                    },
                    {
                        "sbg:category": "Other",
                        "sbg:toolDefaultValue": "Off",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "inputBinding": {
                            "position": 0,
                            "prefix": "--qc-filter",
                            "separate": true,
                            "sbg:cmdInclude": true
                        },
                        "label": "QC filter",
                        "description": "Filters out reads that are bad according to QSEQ filter.",
                        "id": "#qc_filter"
                    },
                    {
                        "sbg:category": "Execution",
                        "sbg:toolDefaultValue": "4096",
                        "type": [
                            "null",
                            "int"
                        ],
                        "label": "Memory per job",
                        "description": "Amount of RAM memory (in MB) to be used per job.",
                        "id": "#memory_per_job"
                    },
                    {
                        "sbg:category": "Output",
                        "sbg:toolDefaultValue": "TXT",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "label": "Paired reads not aligned concordantly",
                        "description": "Writes pairs that didn't align concordantly to the output file",
                        "id": "#un_conc"
                    },
                    {
                        "sbg:category": "Output",
                        "sbg:toolDefaultValue": "TXT",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "label": "Paired reads aligned concordantly",
                        "description": "Writes pairs that aligned concordantly at least once to the output file.",
                        "id": "#al_conc"
                    },
                    {
                        "sbg:stageInput": null,
                        "sbg:category": "Output",
                        "sbg:toolDefaultValue": "TXT",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "label": "Unpaired reads that aligned at least once",
                        "description": "Writes unpaired reads that aligned at least once to the output file.",
                        "id": "#aligned_unpaired_reads"
                    },
                    {
                        "sbg:stageInput": null,
                        "sbg:category": "Output",
                        "sbg:toolDefaultValue": "T",
                        "type": [
                            "null",
                            "boolean"
                        ],
                        "label": "Unpaired reads that didn't align",
                        "description": "Writes unpaired reads that didn't align to the reference in the output file.",
                        "id": "#unaligned_unpaired_reads"
                    }
                ],
                "outputs": [
                    {
                        "type": [
                            "null",
                            "File"
                        ],
                        "label": "Centrifuge report",
                        "description": "Centrifuge report.",
                        "sbg:fileTypes": "TSV",
                        "outputBinding": {
                            "glob": "*Centrifuge_report.tsv",
                            "sbg:inheritMetadataFrom": "#input_file"
                        },
                        "id": "#Centrifuge_report"
                    },
                    {
                        "type": [
                            "null",
                            "File"
                        ],
                        "label": "Classification result",
                        "description": "Classification result.",
                        "sbg:fileTypes": "TXT",
                        "outputBinding": {
                            "glob": "*Classification_result.txt",
                            "sbg:inheritMetadataFrom": "#input_file"
                        },
                        "id": "#Classification_result"
                    },
                    {
                        "type": [
                            "null",
                            {
                                "type": "array",
                                "items": "File"
                            }
                        ],
                        "label": "Pairs that didn't align concordantly",
                        "description": "Output text file containing pairs that did not align concordantly, when un_conc option is selected.",
                        "sbg:fileTypes": "TXT",
                        "outputBinding": {
                            "glob": "*un_conc*",
                            "sbg:inheritMetadataFrom": "#input_file"
                        },
                        "id": "#un_conc_output"
                    },
                    {
                        "type": [
                            "null",
                            {
                                "type": "array",
                                "items": "File"
                            }
                        ],
                        "label": "Pairs that aligned concordantly at least once",
                        "description": "Output text file containing pairs that aligned concordantly at least once, when al_conc option is selected.",
                        "sbg:fileTypes": "TXT",
                        "outputBinding": {
                            "glob": "*al_conc*",
                            "sbg:inheritMetadataFrom": "#input_file"
                        },
                        "id": "#al_conc_output"
                    },
                    {
                        "type": [
                            "null",
                            {
                                "type": "array",
                                "items": "File"
                            }
                        ],
                        "label": "Unpaired reads that aligned at least once",
                        "description": "Output text file containing unpaired reads that aligned at least once.",
                        "sbg:fileTypes": "TXT",
                        "outputBinding": {
                            "glob": "*_aligned_unpaired_reads.txt",
                            "sbg:inheritMetadataFrom": "#input_file"
                        },
                        "id": "#aligned_unpaired_reads_output"
                    },
                    {
                        "type": [
                            "null",
                            {
                                "type": "array",
                                "items": "File"
                            }
                        ],
                        "label": "Unpaired reads that that didn't align",
                        "description": "Output text file containing unpaired unaligned reads.",
                        "sbg:fileTypes": "TXT",
                        "outputBinding": {
                            "glob": "*unaligned_unpaired_reads.txt",
                            "sbg:inheritMetadataFrom": "#input_file"
                        },
                        "id": "#unaligned_unpaired_reads_output"
                    }
                ],
                "requirements": [
                    {
                        "class": "ExpressionEngineRequirement",
                        "id": "#cwl-js-engine",
                        "requirements": [
                            {
                                "class": "DockerRequirement",
                                "dockerPull": "rabix/js-engine"
                            }
                        ]
                    }
                ],
                "hints": [
                    {
                        "class": "sbg:CPURequirement",
                        "value": {
                            "class": "Expression",
                            "script": "{\n  if($job.inputs.parallel_threads){\n  \treturn $job.inputs.parallel_threads\n  }\n  return 1\n}",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "class": "sbg:MemRequirement",
                        "value": {
                            "class": "Expression",
                            "script": "{  \n  if($job.inputs.memory_per_job){\n  \t\treturn $job.inputs.memory_per_job\n\t}\n\telse {\n      \tinput_size = $job.inputs.centrifuge_index_archive.size\n        input_MB = input_size/1048576\n       \n        \n        if ($job.inputs.centrifuge_index_archive.path.split('.').pop()==\"gz\"){\n          return 2*Math.ceil(input_MB) + 4096\n          \n        }\n      \telse {\n        \treturn Math.ceil(input_MB) + 4096\n          \n        }\n      \n\t}\n\n}\n\n\n",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "class": "DockerRequirement",
                        "dockerPull": "images.sbgenomics.com/aleksandar_danicic/centrifuge:1.0.3_feb2018"
                    }
                ],
                "arguments": [
                    {
                        "position": 1,
                        "prefix": "-x",
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "script": "{\n  return \"$basename\"\n}",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "position": 5,
                        "separate": false,
                        "valueFrom": {
                            "class": "Expression",
                            "script": "{\n  cmd = \"\"\n  reads = [].concat($job.inputs.input_file)\n  reads1 = [];\n  reads2 = [];\n  u_reads = [];\n  for (var i = 0; i < reads.length; i++){\n      if (reads[i].metadata.paired_end == 1){\n        reads1.push(reads[i].path);\n      }\n      else if (reads[i].metadata.paired_end == 2){\n        reads2.push(reads[i].path);\n      }\n    else {\n      u_reads.push(reads[i].path);\n     }\n    }\n  if (reads1.length > 0 & reads1.length == reads2.length){\n      cmd = \"-1 \" + reads1.join(\",\") + \" -2 \" + reads2.join(\",\");\n  }\n  if (u_reads.length > 0){\n      cmd = \" -U \" + u_reads.join(\",\");\n  }\n  return cmd\n}",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "position": 6,
                        "prefix": "-S",
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "script": "{\n  filepath = ($job.inputs.input_file)[0].path\n  filename = filepath.split(\"/\").pop()  \n  basename = filename.substr(0,filename.lastIndexOf(\".\")) \n  new_filename = basename + \".Classification_result.txt\" \n  \n  return new_filename;\n}\n\n\n\n\n",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "position": 0,
                        "prefix": "--report-file",
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "script": "{\n  filepath = ($job.inputs.input_file)[0].path\n  filename = filepath.split(\"/\").pop()  \n  basename = filename.substr(0,filename.lastIndexOf(\".\")) \n  new_filename = basename + \".Centrifuge_report.tsv\" \n  \n  return new_filename;\n}\n\n\n\n",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "position": 0,
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "script": "{\n\n  if ($job.inputs.query_input_files == \"FASTQ\")\n  {\n    return \"-q\" \n  }\n  else if ($job.inputs.query_input_files == \"QSEQ\")\n  {\n    return \"-qseq\" \n  }\n  else if ($job.inputs.query_input_files == \"FASTA\")\n  {\n    return \"-f\" \n  }\n  else if ($job.inputs.query_input_files == \"raw-one-sequence-per-line\")\n  {\n    return \"-r\" \n  }\n  else if ($job.inputs.query_input_files == \"comma-separated-lists\")\n  {\n    return \"-c \" \n  }\n  \n}",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "position": 0,
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "script": "{\n\n  if ($job.inputs.quality == \"Phred+33\")\n  {\n    return \"--phred33\" \n  }\n  else if ($job.inputs.quality == \"Phred+64\")\n  {\n    return \"--phred64\" \n  }\n  else if ($job.inputs.quality == \"Integers\")\n  {\n    return \"--int-quals\" \n  }\n    \n}",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "position": 10,
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "script": "{\n  return \"; echo \\\"\" + $job.inputs.centrifuge_index_archive.path.split('.').pop() + \"\\\"\"\n  \n  \n}",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "position": 0,
                        "prefix": "--un-conc",
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "script": "{\n  filepath = ($job.inputs.input_file)[0].path\n  filename = filepath.split(\"/\").pop()  \n  basename = filename.substr(0,filename.lastIndexOf(\".\")) \n  new_filename = basename + \".Centrifuge_un_conc.txt\" \n  \n  if ($job.inputs.un_conc == true)\n  {\n    return new_filename; \n  }\n}\n\n\n\n\n",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "position": 0,
                        "prefix": "--al-conc",
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "script": "{\n  filepath = ($job.inputs.input_file)[0].path\n  filename = filepath.split(\"/\").pop()  \n  basename = filename.substr(0,filename.lastIndexOf(\".\")) \n  new_filename = basename + \".Centrifuge_al_conc.txt\" \n  \n  if ($job.inputs.al_conc == true)\n  {\n    return new_filename; \n  }\n}\n\n\n\n\n\n",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "position": 0,
                        "prefix": "--al",
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "script": "{\n  filepath = ($job.inputs.input_file)[0].path\n  filename = filepath.split(\"/\").pop()  \n  basename = filename.substr(0,filename.lastIndexOf(\".\")) \n  new_filename = basename + \".Centrifuge_aligned_unpaired_reads.txt\" \n  \n  if ($job.inputs.aligned_unpaired_reads == true)\n  {\n    return new_filename; \n  }\n}\n\n",
                            "engine": "#cwl-js-engine"
                        }
                    },
                    {
                        "position": 0,
                        "prefix": "--un",
                        "separate": true,
                        "valueFrom": {
                            "class": "Expression",
                            "script": "{\n  filepath = ($job.inputs.input_file)[0].path\n  filename = filepath.split(\"/\").pop()  \n  basename = filename.substr(0,filename.lastIndexOf(\".\")) \n  new_filename = basename + \".Centrifuge_unaligned_unpaired_reads.txt\" \n  \n  if ($job.inputs.unaligned_unpaired_reads == true)\n  {\n    return new_filename; \n  }\n}\n\n\n",
                            "engine": "#cwl-js-engine"
                        }
                    }
                ],
                "stdout": "test.log",
                "sbg:categories": [
                    "Metagenomics",
                    "Taxonomic Profiling"
                ],
                "sbg:image_url": null,
                "sbg:cmdPreview": "tar -xvf /path/to/centrifuge_index_archive.ext.gz; basename=$(ls | grep '.cf$' | head -1 | cut -d '.' -f 1);  centrifuge --report-file input_file-1.Centrifuge_report.tsv    --phred33 --un-conc input_file-1.Centrifuge_un_conc.txt --al-conc input_file-1.Centrifuge_al_conc.txt --al input_file-1.Centrifuge_aligned_unpaired_reads.txt --un input_file-1.Centrifuge_unaligned_unpaired_reads.txt -x $basename -1 /path/to/input_file-1.ext -2 /path/to/input_file-2.ext -S input_file-1.Classification_result.txt  ; echo \"gz\" > test.log",
                "sbg:revisionsInfo": [
                    {
                        "sbg:revision": 0,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1509721131,
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-classifier-1/31"
                    },
                    {
                        "sbg:revision": 1,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1509721131,
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-classifier-1/34"
                    },
                    {
                        "sbg:revision": 2,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1509721131,
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-classifier-1/35"
                    },
                    {
                        "sbg:revision": 3,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1509721131,
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-classifier-1/36"
                    },
                    {
                        "sbg:revision": 4,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1509721131,
                        "sbg:revisionNotes": "memory per job script changed"
                    },
                    {
                        "sbg:revision": 5,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1509721131,
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-classifier-1/37"
                    },
                    {
                        "sbg:revision": 6,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1509721131,
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-classifier-1/44"
                    },
                    {
                        "sbg:revision": 7,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1509721131,
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-classifier-1/45"
                    },
                    {
                        "sbg:revision": 8,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1509721131,
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-classifier-1/46"
                    },
                    {
                        "sbg:revision": 9,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1509721131,
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-classifier-1/47"
                    },
                    {
                        "sbg:revision": 10,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1509721131,
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-classifier-1/53"
                    },
                    {
                        "sbg:revision": 11,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1510650872,
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-classifier-1/69"
                    },
                    {
                        "sbg:revision": 12,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1513010011,
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-classifier-1/70"
                    },
                    {
                        "sbg:revision": 13,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1513010012,
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-classifier-1/73"
                    },
                    {
                        "sbg:revision": 14,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1527589668,
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-classifier-1/83"
                    },
                    {
                        "sbg:revision": 15,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1530200317,
                        "sbg:revisionNotes": "Copy of aleksandar_danicic/centrifuge-dev/centrifuge-classifier-1/85"
                    },
                    {
                        "sbg:revision": 16,
                        "sbg:modifiedBy": "admin",
                        "sbg:modifiedOn": 1648560739,
                        "sbg:revisionNotes": "Copy of Rev. 86 from the Dev project; category added"
                    }
                ],
                "sbg:job": {
                    "inputs": {
                        "centrifuge_index_archive": {
                            "class": "File",
                            "path": "/path/to/centrifuge_index_archive.ext.gz",
                            "size": 7400140800,
                            "metadata": {
                                "reference_genome": "index"
                            },
                            "secondaryFiles": []
                        },
                        "nofw": false,
                        "unaligned_unpaired_reads": true,
                        "tab_fmt_cols": "tab_fmt_cols-string-value",
                        "host_taxids": null,
                        "metrics_standard_error": false,
                        "qc_filter": false,
                        "ignore_quals": false,
                        "quiet": false,
                        "trim_from_3": null,
                        "input_file": [
                            {
                                "class": "File",
                                "path": "/path/to/input_file-1.ext",
                                "size": 0,
                                "metadata": {
                                    "paired_end": "1"
                                },
                                "secondaryFiles": []
                            },
                            {
                                "class": "File",
                                "path": "/path/to/input_file-2.ext",
                                "size": 0,
                                "metadata": {
                                    "paired_end": "2"
                                },
                                "secondaryFiles": []
                            }
                        ],
                        "SRA_accession_number": "SRA_accession_number-string-value",
                        "al_conc": true,
                        "memory_mapping": false,
                        "aligned_unpaired_reads": true,
                        "min_totallen": null,
                        "quality": "Phred+33",
                        "align_first_n_reads": null,
                        "time": false,
                        "exclude_taxids": null,
                        "norc": false,
                        "skip_n_reads": null,
                        "query_input_files": "FASTQ (.fq/.fastq)",
                        "out_fmt": "out_fmt-string-value",
                        "met": null,
                        "memory_per_job": null,
                        "parallel_threads": null,
                        "trim_from_5": null,
                        "un_conc": true,
                        "min_hitlen": null
                    },
                    "allocatedResources": {
                        "mem": 18212,
                        "cpu": 1
                    }
                },
                "sbg:toolkitVersion": "1.0.3",
                "sbg:projectName": "SBG Public data",
                "sbg:links": [
                    {
                        "label": "Homepage",
                        "id": "https://ccb.jhu.edu/software/centrifuge/manual.shtml"
                    },
                    {
                        "label": "Source code",
                        "id": "https://github.com/infphilo/centrifuge"
                    }
                ],
                "sbg:toolkit": "centrifuge",
                "sbg:toolAuthor": "John Hopkins University, Center for Computational Biology",
                "sbg:expand_workflow": false,
                "sbg:appVersion": [
                    "sbg:draft-2"
                ],
                "sbg:id": "admin/sbg-public-data/centrifuge-classifier-1/16",
                "sbg:revision": 16,
                "sbg:revisionNotes": "Copy of Rev. 86 from the Dev project; category added",
                "sbg:modifiedOn": 1648560739,
                "sbg:modifiedBy": "admin",
                "sbg:createdOn": 1509721131,
                "sbg:createdBy": "admin",
                "sbg:project": "admin/sbg-public-data",
                "sbg:sbgMaintained": false,
                "sbg:validationErrors": [],
                "sbg:contributors": [
                    "admin"
                ],
                "sbg:latestRevision": 16,
                "sbg:publisher": "sbg",
                "sbg:content_hash": "ab156bd72b59727a44e87a22d020e16c3adc8ad737edf2d29bae6c39de17c8672",
                "sbg:workflowLanguage": "CWL"
            },
            "label": "Centrifuge Classifier",
            "sbg:x": -239.79489135742188,
            "sbg:y": -335.5662536621094
        }
    ],
    "requirements": [
        {
            "class": "InlineJavascriptRequirement"
        },
        {
            "class": "StepInputExpressionRequirement"
        }
    ],
    "sbg:projectName": "PhD_FinalProject",
    "sbg:revisionsInfo": [
        {
            "sbg:revision": 0,
            "sbg:modifiedBy": "hendrick.san",
            "sbg:modifiedOn": 1646027652,
            "sbg:revisionNotes": "Copy of hendrick.san/dissertation/cowid/1"
        },
        {
            "sbg:revision": 1,
            "sbg:modifiedBy": "hendrick.san",
            "sbg:modifiedOn": 1653809417,
            "sbg:revisionNotes": "Apps updated"
        },
        {
            "sbg:revision": 2,
            "sbg:modifiedBy": "hendrick.san",
            "sbg:modifiedOn": 1654233690,
            "sbg:revisionNotes": "Layout changed"
        },
        {
            "sbg:revision": 3,
            "sbg:modifiedBy": "hendrick.san",
            "sbg:modifiedOn": 1654745743,
            "sbg:revisionNotes": "without SBGFASTA"
        }
    ],
    "sbg:image_url": "https://cgc.sbgenomics.com/ns/brood/images/hendrick.san/phd-finalproject/cowid/2.png",
    "sbg:appVersion": [
        "v1.2",
        "sbg:draft-2",
        "v1.0"
    ],
    "sbg:id": "hendrick.san/phd-finalproject/cowid/2",
    "sbg:revision": 2,
    "sbg:revisionNotes": "Layout changed",
    "sbg:modifiedOn": 1654233690,
    "sbg:modifiedBy": "hendrick.san",
    "sbg:createdOn": 1646027652,
    "sbg:createdBy": "hendrick.san",
    "sbg:project": "hendrick.san/phd-finalproject",
    "sbg:sbgMaintained": false,
    "sbg:validationErrors": [],
    "sbg:contributors": [
        "hendrick.san"
    ],
    "sbg:latestRevision": 3,
    "sbg:publisher": "sbg",
    "sbg:content_hash": "a766494601653440d8ba4f8fd1b1e0acf100fa52e8bfeb67d3729ffd1c68a9356",
    "sbg:workflowLanguage": "CWL"
}