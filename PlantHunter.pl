#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use LWP::UserAgent;
use HTML::TreeBuilder;
use IO::Handle;

sub trim {
    my $s = shift;
    $s =~ s/^\s+|\s+$//g;
    return $s;
}

$| = 1;  # Desactivar el buffer de salida

# Configuración del UserAgent
my %output_data;
my $ua = LWP::UserAgent->new(
    ssl_opts => { verify_hostname => 0, SSL_verify_mode => 0x00 },
    timeout => 50,
    #agent => "PlantHunterBot/1.0 (tu_email@example.com)"  # Agente de usuario personalizado
);

# Argumentos del script
my ($input_file, $output_file);
GetOptions('i=s' => \$input_file, 'o=s' => \$output_file);

# Leer la lista de especies
open my $in, '<', $input_file or die "No se pudo abrir $input_file: $!";
my @species = map { chomp; $_ } <$in>;
close $in;

# Eliminar nombres repetidos
my %seen;
@species = grep { !$seen{$_}++ } @species;

# Procesar cada especie
open my $out, '>', $output_file or die "No se pudo abrir $output_file: $!";

foreach my $specie (@species) {
    # Mostrar mensaje en la terminal
    printf "Buscando información para $specie...\n";
    STDOUT->flush();

    # Hacer la solicitud al servidor usando la URL de World Flora Online
    my $url = "https://www.worldfloraonline.org/search?query=$specie";
    my $response = $ua->get($url);
    my $content = $response->decoded_content;

    if ($content =~ /Did you mean/) {
         print "El nombre de la especie $specie puede estar mal escrito o no es reconocido. Por favor, verifica.\n";
         print $out "$specie\tEl nombre puede estar mal escrito o no es reconocido.\n";
         next;
    }

    # Verificar si la solicitud fue exitosa
    if ($response->is_success) {
        my $tree = HTML::TreeBuilder->new_from_content($response->content());
        
        # Analizar la primera coincidencia
        my $first_match = ($tree->look_down('_tag' => 'div', 'id' => 'results')->look_down('_tag' => 'tr'))[0];
        my $status_element = $first_match->look_down('_tag' => 'span', 'id' => 'entryStatus');
        my $status = $status_element ? $status_element->as_text() : "No encontrado";

        if ($status eq 'Accepted Name') {
          
            my $specie_name = trim($first_match->look_down('_tag' => 'em')->as_text());
            my $status = trim($first_match->look_down('id' => 'entryStatus')->as_text());
            my $family_element = $first_match->look_down('_tag' => 'div', sub { $_[0]->as_text =~ /Family:/ });
            my $family = $family_element ? trim(($family_element->as_text =~ /Family:\s*(\S+)/)[0]) : "No encontrado";
            my $order_element = $first_match->look_down('_tag' => 'div', sub { $_[0]->as_text =~ /Order:/ });
            my $order = $order_element ? trim(($order_element->as_text =~ /Order:\s*(\S+)/)[0]) : "No encontrado";

            
            
            my ($genus) = split ' ', $specie_name;
            print $out join("\t", $specie_name, $status, $order, $family, $genus) . "\n";


        } elsif ($status =~ /Synonym of/) {
            my $synonym_name = $first_match->look_down('_tag' => 'a', 'class' => 'result')->as_text();
            print $out "$specie\tSynonym of $synonym_name\n";

        } else {
            print $out "$specie\t$status\n";
        }

    } else {
        print "Error: " . $response->status_line . "\n";  # Imprimir detalles del error
        print $out "$specie\tError en la solicitud\n";
    }

    sleep(5);  # Espera 5 segundos antes de la próxima solicitud
}

close $out;

# Ordenar el archivo de salida alfabéticamente según el estado de las especies
open my $in_out, '+<', $output_file or die "No se pudo abrir $output_file: $!";
my @lines = <$in_out>;
chomp @lines;  # Remove any trailing newline characters
@lines = sort { (split /\t/, $a)[1] cmp (split /\t/, $b)[1] } @lines;

# Agregar el encabezado al principio
unshift @lines, "Species\tStatus\tOrder\tFamily\tGenus";

# Limpiar el archivo antes de reescribir
seek $in_out, 0, 0;
truncate $in_out, 0;

# Escribe las líneas ordenadas al archivo
print $in_out join("\n", @lines);

close $in_out;
