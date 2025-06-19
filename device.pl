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
    if($input->{add_dev_btn}){
        return &add_dev_form();
    }
    elsif($input->{create_dev_btn}){
        return &create_device();
    }
    elsif($input->{create_int_btn}){
        my $created=Service::interfaces_save();
        return "Created $created interfaces";
    }
    elsif($input->{show_devices_btn}){
        return &list_dev();
    }
    elsif($input->{remove_device_btn}){
        return &remove_device($input->{device_id});
    }
    elsif($input->{edit_device_btn}){
        return &edit_device($input->{device_id});
    }
    else{
        return Dumper($input);
    }
}
sub remove_device{
    my $device_id=shift;
    if (Service::device_remove($device_id)){
        return "Device Removed";
    }
    return "Error";
}
sub list_dev{
    my $devices=Service::devices_get();
    my $html="<h4>Devices</h4>";
    my $html="<div class='devices'>";
    foreach my $device (@$devices){
        $html.=qq(
            <div id="$device->{device_id}" class="device">
            <div class="dev_title">
                $device->{device_name}
                <div class="inline_menu">
                <form action="" method="post">
                <input type="hidden" name="devices" value="devices">
                <input type="hidden" name="device_id" value="$device->{device_id}">
                    <input type="submit" name="remove_device_btn" value="Delete"/>
                    <input type="submit" name="edit_device_btn" value="Edit"/>
                    <button>BTN B</button>
                    <button>BTN C</button>
                </form>
                </div>
            </div>
            <div class="interfaces">
            );
            foreach my $interface (@{$device->{interfaces}}){
                $html.=qq(
                    <div class="interface">$interface->{interface_number}</div>
                );
            }
            $html.="</div></div>";
    }
    $html.="</div>";
    $html.=qq(<script>handler.menuListener()</script>);
    return $html;
}
sub list_dev_old{
    my $devices=Service::devices_get();
    my $html="<h4>Devices</h4>";
    foreach my $device (@$devices){
        my $int_count=scalar(@{$device->{interfaces}});
        $html.="<p>$device->{device_name} interfaces:$int_count </p>";
    }
    return $html;

}

sub create_device{
    my $name=$input->{device_name};
    my $int_count=$input->{int_count};
    my $device_id=Service::device_save($name);
    my $result="<p>created device: $name</p>";
    $result.=qq(
        <h4>Create interfaces for $name</h4>
        <button onclick="selAll()">(de)Select all</button>
        <form method="post">
        <input type="hidden" name="devices" value="devices">
        <input type="hidden" name="device_id" value="$device_id">
        <table>
        <tr>
        <th>sel</th>
        <th>int num</th>
        <th>name</th>
        </tr>
        );
    for(my $i = 1; $i <= $int_count; $i++){
        $result.=qq(
            <tr>
            <td><input type="checkbox" name="sel" value="$i"/></td>
            <td><input type="hidden" name="int_number[$i]"/><span class="num_val"></span></td>
            <td><input type="text" name="int_name[$i]" /></td>
            </tr>
            );
    }
    $result.=qq(
        </table>
        <input type="submit" name="create_int_btn" />
        </form>
        <script>handleIntNum()</script>
        );
    return $result;
}
sub edit_interfaces_form{
    my $device=shift;
    # my $htm
    return 1;
    
}
sub add_dev_form{
    my $txt="<h4>Create new device</h4>";
    $txt.=qq(<form action="" method="post">);
    $txt.=qq(
        <input type="hidden" name="devices" value="devices">
        <label for="device_name" >Name:</label>
        <input type="text" name="device_name" id="device_name" required />
        <label for="int_count">Interfaces:</label>
        <input type="number" name="int_count" id="int_count" min="1" value="1" />
        <input type="submit" name="create_dev_btn" value="create"/>
        </form>
    );
    return $txt;
}
sub edit_device{
    my $device_id=shift;
    my $devices=Service::devices_get($device_id);
    my $device=$devices->[0];
    my $html="<h4>Edit device: $device->{device_name}</h4>";
    $html.=qq(
        <form method="post">
        <input type="hidden" name="devices" value="devices">
        <input type="hidden" name="device_id" value="$device_id">
        <label for="new_device_name">Change device name: </label>
        <input type="text" id="new_device_name" name="new_device_name" placeholder="New name" value="" />
        <table>
        <tr>
        <th>sel</th>
        <th>int num</th>
        <th>name</th>
        <th>type</th>
        </tr>
    );
    my $int_type=Strings::interface_type_select();
    
    foreach my $interface (@{$device->{interfaces}})
    {
        my $int_id=$interface->{interface_id};
        $html.=qq(
            <tr>
            <td><input type="checkbox" name="sel" value="$int_id"/></td>
            <td><input type="number" name="int_number[$int_id]" value="$interface->{interface_number}" style="width:60px;"/></td>
            <td><input type="text" name="int_name[$int_id]" value="$interface->{interface_name}" /></td>
            <td>$int_type</td>
            </tr>
        );
    }
    $html.="</table></form>";
    $html.=qq(
        <p>TODO:</p>
        <p>ADD ability to create new interfaces;</p>
        <p>add interface type;</p>
        <p>if type is virtual add adbility to select physycal members;</p>
        <p>int num, int name, int type CAN be changed</p>
        );
    return $html;

}

return 1;