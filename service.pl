#!/usr/bin/perl -w

package Service;

use strict;
use FindBin 1.51 qw( $RealBin );
use lib $RealBin;
use Data::Dumper qw( Dumper );
use DBI;

my $dir=$RealBin;

my ($input)=\%main::input;
my ($cgi)=$main::cgi;
my $cfg=Cfg::get_config();
my $debug=Cfg::get_debug();

sub init_db(){
    my $dbh;

    eval {
    $dbh = DBI->connect("DBI:mysql:$cfg->{sql_db}:$cfg->{sql_host}:$cfg->{sql_port}", $cfg->{sql_user}, $cfg->{sql_pass},
    { RaiseError => 1, AutoCommit => 1,mysql_enable_utf8mb4 => 1 });
    $dbh->do("SET NAMES 'utf8'");
    };
    if ( $@ ) {
    # do something with the error
    print $debug "\n$@\n" if $debug;
     return die if $cfg->{debug_cgi};
    exit 1;
    }
    return $dbh;
}
sub device_save{
    my $dbh=init_db();
    my $device_name=shift;
    my $sth=$dbh->prepare("INSERT INTO devices(device_name) VALUES(?);");
    $sth->execute($device_name);
    my $device_id=$sth->{mysql_insertid};
    $dbh->disconnect();

    return $device_id;

}
sub devices_get{
    my $device_id=shift;
    my $where=" 1";
    if ($device_id){
        $where=" device_id=?";
    }
    my $dbh=init_db();
    my $q="SELECT device_id,device_name FROM devices WHERE $where;";
    my $devices;
    if($device_id){
    $devices=$dbh->selectall_arrayref($q,{Slice=>{}},$device_id);
    }else{
    $devices=$dbh->selectall_arrayref($q,{Slice=>{}});
    }
    $dbh->disconnect();
    foreach my $device (@$devices){
        $device->{interfaces}=&interfaces_get($device->{device_id});
    }
    return $devices;
}
sub device_remove{
    my $device_id=shift;
    my $q="DELETE FROM devices WHERE device_id=?;";
    my $dbh=init_db();
    my $sth=$dbh->prepare($q);
    if ($sth->execute($device_id)){
        return 1;
    }else{return 0;}
}
sub device_update{
    my $device_id=shift;
    my $new_name=shift;
    my $dbh=init_db();
    my $q="UPDATE devices SET device_name=? WHERE device_id=?";
    my $sth=$dbh->prepare($q);
    $sth->execute($new_name,$device_id);
    $dbh->disconnect;
    return 1;
}
sub interfaces_get{
    my $device_id=shift;
    my $dbh=init_db();
    my $q="SELECT interface_id,device_id,interface_number,interface_name,interface_type FROM interfaces WHERE device_id=? ORDER BY interface_number";
    my $interfaces=$dbh->selectall_arrayref($q,{Slice=>{}},$device_id);
    $dbh->disconnect();
    return $interfaces;
}

sub interfaces_save{

    my @selected=$cgi->param('sel');
    my $device_id=$input->{device_id};
    my $dbh=init_db();
    my $sth=$dbh->prepare("INSERT INTO interfaces(device_id,interface_number,interface_name) VALUES(?,?,?);");
    my $counter=0;

    foreach my $idx (@selected) {
        $sth->execute($device_id,$input->{"int_number[$idx]"},$input->{"int_name[$idx]"});
        $counter++;
    }
    return $counter;
}
sub interfaces_update{

    my @selected=$cgi->param('sel');
    my $device_id=$input->{device_id};
    my $dbh=init_db();
    my $sth=$dbh->prepare("UPDATE interfaces SET interface_number =?, interface_name=?, interface_type=? WHERE interface_id=?");
    my $counter=0;

    foreach my $idx (@selected) {
        $sth->execute($input->{"int_number[$idx]"},$input->{"int_name[$idx]"},$input->{"interface_type[$idx]"},$idx);
        $counter++;
    }
    $dbh->disconnect;
    return $counter;
}
sub interfaces_get_types{
    my $q="SELECT interface_type_id,interface_type_name FROM interface_types WHERE 1";
    my $dbh=init_db();
    my $types=$dbh->selectall_arrayref($q,{Slice=>{}});
    $dbh->disconnect();
    return $types;
}
sub i2i_save{
    my $ids=shift;
    return if scalar @{$ids}<1;
    my $dbh=init_db();
    my $sth=$dbh->prepare("INSERT INTO i2i(int_a,int_b) VALUES (?,?)");

    for (my $i=0;$i<@{$ids};$i++) 
    {
        my $pair=@$ids[$i];
        my $int_a=substr(@$pair[0],1);
        my $int_b=substr(@$pair[1],1);
        $sth->execute($int_a,$int_b);
    }
    $dbh->disconnect;
}
sub i2i_get{
    my $dbh=init_db();
    my $q="SELECT int_a,int_b FROM i2i WHERE 1;";
    my $links=$dbh->selectall_arrayref($q,{Slice=>{}});
    $dbh->disconnect();
    return $links;
}
sub i2i_remove{
    my $ids=shift;
    return if scalar @{$ids}<1;
    my $dbh=init_db();
    my $sth=$dbh->prepare("DELETE FROM `i2i` WHERE (int_a=? AND int_b=?) OR (int_a=? AND int_b=?); ");

    for (my $i=0;$i<@{$ids};$i++) 
    {
        my $pair=@$ids[$i];
        my $int_a=@$pair[0];
        my $int_b=@$pair[1];
        $sth->execute($int_a,$int_b,$int_b,$int_a);
    }
    $dbh->disconnect;
}
return 1;