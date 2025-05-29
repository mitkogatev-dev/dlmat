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
    # trace_alg("7","4","0");
    my @path;
    $html.=trace_alg($from_dev,$to_dev,"0",\@path);
    return $html;
}
sub trace_alg{
    my $from_dev=shift;
    my $to_dev=shift;
    my $parent=shift;
    my $path=shift;
    return if grep { $from_dev == $_->{device_id} } @$path;
    my $relations=get_device_relations($from_dev);
    return if !$relations;
    while(my $relation = shift(@{$relations})){
        next if $parent eq $relation->{to_dev_id};
        #next if grep { $id == $_->{device_id} } @$path;
        push (@{$path},$relation);
        if($relation->{to_dev_id} eq $to_dev){
            print $debug "Found IT!!!\n";
            print $debug Dumper($relation);
            print $debug Dumper($path);
            return 0;
        }else{
        trace_alg($relation->{to_dev_id},$to_dev,$relation->{device_id},$path);
        }
    }
    return show_path($path);
}
sub show_path{
    my $path=shift;
    my $txt="";
    foreach my $row (@{$path}){
        $txt.="<p>$row->{to_dev_name}($row->{to_int_name})</p>";
    }
    return $txt;
}

sub get_device_relations{
    my $device_id=shift;
     #full join
    my $q=qq(
        SELECT d.device_id,d.device_name,i.interface_id,i.interface_name,d2.device_id AS to_dev_id,d2.device_name AS to_dev_name,i2.interface_name AS to_int_name
        FROM `devices` d 
        JOIN interfaces i ON d.device_id=i.device_id
        JOIN i2i ON (i2i.int_a=i.interface_id OR i2i.int_b=i.interface_id)
        JOIN devices d2 ON d2.device_id=(SELECT device_id FROM interfaces WHERE (interface_id in(i2i.int_a,i2i.int_b) AND device_id != d.device_id ) LIMIT 1)
        JOIN interfaces i2 ON ((i2i.int_a=i2.interface_id OR i2i.int_b=i2.interface_id) AND i2.interface_id != i.interface_id)
        WHERE d.device_id=?;
    );
    my $dbh=Service::init_db();
    my $result=$dbh->selectall_arrayref($q,{Slice=>{}},$device_id); 
    $dbh->disconnect;
    return $result;
}


return 1;