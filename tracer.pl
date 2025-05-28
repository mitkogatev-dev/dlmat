#!/usr/bin/perl -w

package Tracer;

use strict;
use FindBin 1.51 qw( $RealBin );
use lib $RealBin;
use Data::Dumper qw( Dumper );

my $dir=$RealBin;

my ($input)=\%main::input;
my $cfg=Cfg::get_config();
my $debug=Cfg::get_debug();

sub handle{
    if($input->{tracer_btn}){
        return Strings::trace_form();
    }
    elsif($input->{go_trace}){
        return &trace_dev();
    }
    else
    {
        return Dumper($input);
    }
}
sub trace_dev{
    my $from_dev=$input->{from_dev};
    my $to_dev=$input->{to_dev};
    my $html="trace from $from_dev to $to_dev";
    return $html;
}
sub trace_alg{
    my $from_dev="4";
    my $to_dev="7";
    my $first_q=qq(
        SELECT d.device_id,d.device_name,i.interface_id,i.interface_name,i2i.* FROM `devices` d 
        JOIN interfaces i ON d.device_id=i.device_id
        JOIN i2i ON (i2i.int_a=i.interface_id OR i2i.int_b=i.interface_id)
        WHERE d.device_id=4;
    );
    #if first_q return more than 1 row device is connected to multiple devices, so need to track all

    #full join
    my $fq=qq(
        SELECT d.device_id,d.device_name,i.interface_id,i.interface_name,d2.device_id AS to_dev_id,d2.device_name AS to_dev_name,i2.interface_name AS to_int_name
        FROM `devices` d 
        JOIN interfaces i ON d.device_id=i.device_id
        JOIN i2i ON (i2i.int_a=i.interface_id OR i2i.int_b=i.interface_id)
        JOIN devices d2 ON d2.device_id=(SELECT device_id FROM interfaces WHERE (interface_id in(i2i.int_a,i2i.int_b) AND device_id != d.device_id ) LIMIT 1)
        JOIN interfaces i2 ON ((i2i.int_a=i2.interface_id OR i2i.int_b=i2.interface_id) AND i2.interface_id != i.interface_id)
        WHERE d.device_id=4;
    );
    #if full join to_dev==$to_dev We found it! else continue loop

}


return 1;