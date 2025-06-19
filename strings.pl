#!/usr/bin/perl -w

package Strings;

use strict;
use FindBin 1.51 qw( $RealBin );
my $dir=$RealBin;

sub trace_form{
    my $devices=Service::devices_get();
    my $options="";
    foreach my $device(@{$devices}){
        $options.=qq(
            <option value="$device->{device_id}">$device->{device_name}</option>
        );
    }


    my $txt="<h4>Trace connection between devices</h4>";
    $txt.=qq(
        <form method="post">
        <input type="hidden" name="tracer" value="tracer">
        <label for="from_dev">From: </label>
        <select id="from_dev" name="from_dev">
        $options
        </select>
        <label for="to_dev">To: </label>
        <select id="to_dev" name="to_dev">
        $options
        </select>
        <input type="submit" name="go_trace" value="trace" />
        </form>
        );
    return $txt;
}
sub interface_type_select{
    my $int_type=qq(<select name="interface_type">);
    my $types=Service::interfaces_get_types();
    foreach my $type (@{$types}){
        $int_type.=qq(<option vlaue="$type->{interface_type_id}">$type->{interface_type_name}</option>);
    }

    $int_type.="</select>";
    return $int_type;
}
sub int_type_mod{
    my $str=shift;
    my $idx=shift;
    my $type_id=shift;
    $str=~ s/interface_type/interface_type[$idx]/;
    $str=~ s/\"$type_id\"/\"$type_id\" selected=\"selected\" /;
    return $str;

}
sub add_dev_form{
    my $txt=qq(<form action="" method="post">);
    $txt.=qq(
        <label for="device_name">Name:</label>
        <input type="text" name="device_name" id="device_name" />
        <label for="int_count">Interfaces:</label>
        <input type="number" name="int_count" id="int_count" min="1" value="1" />
    );
    return $txt;
}


return 1;