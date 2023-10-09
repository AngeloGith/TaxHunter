# TaxHunter
Plant Hunter is a Perl script designed to scrape plant species taxonomic data from World Flora Online.

# Features

Input/Output: Reads a list of species from an input file and writes the scraped data to an output file.
Web Scraping: Utilizes LWP::UserAgent for HTTP requests and HTML::TreeBuilder for HTML parsing.
Data Extraction: Extracts valuable information like species name, status, order, family, and genus.

# Dependencies

* Getopt::Long
* LWP::UserAgent
* HTML::TreeBuilder
* IO::Handle

## Installation

To install and run this script, follow these steps in your terminal:


👉 **Terminal**

```plaintext
user@machine:~$ git clone https://github.com/tuusuario/PlantHunter.git
Cloning into 'PlantHunter'...
...
user@machine:~$ cd PlantHunter
```

# Usage

Prepare an input file containing a list of species names, one per line.
Run the script using the following command:

```perl plantHunter.pl -i input.txt -o output.txt```

# Example

### Input File
The input file should contain a list of species names, one per line. For example:

```plaintext
Arabidopsis thaliana
Oryza sativa
Zea mays
Fictus plantus
etc..
```

### Output File

The output file will contain the scraped data in a tab-separated format. Here's what the output might look like with different statuses:

```markdown
| Species              | Status                          | Order      | Family       | Genus       |
| -------------------- | ------------------------------- | ---------- | ------------ | ----------- |
| Arabidopsis thaliana | Accepted Name                   | Brassicales| Brassicaceae | Arabidopsis |
| Oryza sativa         | Accepted Name                   | Poales     | Poaceae      | Oryza       |
| Zea mays             | Accepted Name                   | Poales     | Poaceae      | Zea         |
| Fictus plantus       | The name may be misspelled or   |
|                      | not recognized                  | N/A        | N/A          | N/A         |

| etc...               |
```




