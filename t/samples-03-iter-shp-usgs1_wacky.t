#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
#use Test::More tests => 2;
use Test::More;

eval { require Geo::ShapeFile; };
if ( $@ ) {
    print "1..1\nok 1\n";
    warn "skipping, Geo::ShapeFile not available\n";
    exit;
}

require './t/test_contains.pl';    # Loads test_contains method
use Image::GeoTIFF::Tiled;

# Wacky shape in usgs1.tif with lots of thin spikes
#   - values: 4,5

my $image     = Image::GeoTIFF::Tiled->new( "./t/samples/usgs1_.tif" );
my $shp       = Geo::ShapeFile->new( './t/samples/usgs1_wacky' );
my $shp_shape = $shp->get_shp_record( 1 );
my $shape =
    Image::GeoTIFF::Tiled::Shape->load_shape( $image, undef, $shp_shape );
my $iter = $image->get_iterator( $shape );

$iter->dump_buffer; 
# die;

test_contains( $image, $iter, $shp_shape );

done_testing( 2 );