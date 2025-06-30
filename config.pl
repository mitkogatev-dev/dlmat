#!/usr/bin/perl -w

################
#source: https://vocal.com/resources/development/how-can-i-implement-a-configuration-file-for-a-perl-script/
##########
package Cfg;

use strict;
use FindBin 1.51 qw( $RealBin );
my $dir=$RealBin;

#
# Default configuration
my %config;
my %sql_config = (
    sql_host => "127.0.0.1",
    sql_port => "3306",
    sql_user => "myuser",
    sql_pass => "fakepassword",
    sql_db => "dlmat"
);

my %debug_config = (
    debug_enabled => 0,
    debug_file => "$dir/debug.log",
    debug_cgi => 0
);
%config = (%sql_config,%debug_config);

my ($config_file)="$dir/config.cfg" || ""; #! can not comment lines in cfg file !!!
#
# Read in a config file and build the config hash

if (open my $cfg_file, "< $config_file") {
    while (my $line = <$cfg_file>) {
        if ($line =~ /(\w+)[ \t]*=[ \t]*(.*)/) {
            $config{$1} = $2;
        }
    }
    close $cfg_file;
}

sub print_config{
    foreach my $key (keys %config){
        print "$key = $config{$key}\n";
    }
};
sub get_config{
    return \%config;
}
sub get_debug{
    if ($config{debug_enabled}){
        open (my $debug_fh,">>", $config{debug_file}) or die $!;
        return $debug_fh;
    }
    return 0;
}

return 1;