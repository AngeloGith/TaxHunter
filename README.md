# TaxHunter
Plant Hunter Bot is a Perl script designed to scrape plant species data from World Flora Online. It takes a list of species names from an input file and fetches details like the accepted name, status, order, family, and genus. 

# Features

Input/Output: Reads a list of species from an input file and writes the scraped data to an output file.
Web Scraping: Utilizes LWP::UserAgent for HTTP requests and HTML::TreeBuilder for HTML parsing.
Data Extraction: Extracts valuable information like species name, status, order, family, and genus.

# Dependencies

* Getopt::Long
* LWP::UserAgent
* HTML::TreeBuilder
* IO::Handle

## Instalación

Para instalar y ejecutar este script, sigue los siguientes pasos en tu terminal:

👉 **Terminal**

```plaintext
user@machine:~$ git clone https://github.com/tuusuario/PlantHunterBot.git
Cloning into 'PlantHunterBot'...
...
user@machine:~$ cd PlantHunterBot
user@machine:~/PlantHunterBot$

