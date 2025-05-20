#!/usr/bin/perl -w

package Device;

use strict;
use FindBin 1.51 qw( $RealBin );
use lib $RealBin;
use Data::Dumper qw( Dumper );

my $dir=$RealBin;

my ($input)=\%main::input;
my $cfg=Cfg::get_config();
my $debug=Cfg::get_debug();

sub handle{
    if($input->{add_dev}){
        return &add_dev_form();
    }
    elsif($input->{create_device}){
        return &create();
    }
    else{
        return Dumper($input);
    }
}

sub create{
    my $name=$input->{device_name};
    my $int_count=$input->{int_count};
    #todo insert dev in DB and get id
    my $device_id=1;
    my $result="<p>created device: $name</p>";
    $result.=qq(
        <h4>Create interfaces for $name</h4>
        <form method="post">
        <input type="hidden" name="devices" value="devices">
        <table>
        <tr>
        <th>sel</th>
        <th>int num</th>
        <th>name</th>
        </tr>
        );
    for(my $i = 0; $i < $int_count; $i++){
        $result.=qq(
            <tr>
            <td><input type="checkbox" name="sel" /></td>
            <td><input type="number" name="int_number" disabled /></td>
            <td><input type="text" name="int_name" /></td>
            </tr>
            );
    }
    $result.=qq(
        </table>
        <input type="submit" name="create_int" />
        </form>
        <script>handleIntNum()</script>
        );
    return $result;
}
sub add_dev_form{
    my $txt=qq(<form action="" method="post">);
    $txt.=qq(
        <input type="hidden" name="devices" value="devices">
        <label for="device_name" >Name:</label>
        <input type="text" name="device_name" id="device_name" required />
        <label for="int_count">Interfaces:</label>
        <input type="number" name="int_count" id="int_count" min="1" value="1" />
        <input type="submit" name="create_device" value="create"/>
        </form>
    );
    return $txt;
}

return 1;