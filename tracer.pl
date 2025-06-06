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
    $html.=show_path(trace($from_dev,$to_dev));

    return $html;
}

sub trace{
    my $from_dev=shift;
    my $end_dev=shift;
    return if $from_dev eq $end_dev;
    my @all_paths;
    my $relations=get_device_relations($from_dev);
    my @visited=(eval $from_dev);
    my @path=(eval $from_dev);
    foreach my $relation (@{$relations}){
        if($relation->{to_dev_id} eq eval $end_dev){
            my @new_path=(eval $from_dev);
            push(@new_path,eval $end_dev);
            push(@all_paths,\@new_path);
            next;
        }
    
        trace_alg($relation->{to_dev_id},$end_dev,\@visited,\@path,\@all_paths);
        
    }
    
    return \@all_paths; 
}
sub trace_alg{
    my $from_dev=shift;
    my $end_dev=shift;
    my $visited=shift;
    my $path=shift;
    my $all_paths=shift;
    ###################
    return if grep { $from_dev == $_ } @$visited;
    push(@{$visited},$from_dev);
    my $relations=get_device_relations($from_dev);
    push (@{$path},$from_dev);
    while(my $relation = shift(@{$relations})){
        my @new_visited=@$visited;
        my @new_path=@$path;
        if($relation->{to_dev_id} eq $end_dev){
            push(@new_path,eval $end_dev);
            push(@{$all_paths},\@new_path);
            next;#using next as same device may have another longer route to dest
        }
         trace_alg($relation->{to_dev_id},$end_dev,\@new_visited,\@new_path,$all_paths) ;
    }
    return ;
}

sub show_path{
    my $paths=shift;
    return "<h4>No paths found.</h4>" if !$paths || !$paths->[0];
    my $txt="";
    for my $path (@$paths){
        $txt.="<p>".iterate($path)."</p>";
    }
    return $txt;
}
sub iterate{
    my $path=shift;
    my $len= scalar @{$path};
    my $txt="";
    for (my $i=0;$i < $len-1;$i++){
        my $from=@{$path}[$i];
        my $to=@{$path}[$i+1];
        my $row=get_device_relations($from,$to)->[0];
        $txt.=qq($row->{device_name}($row->{interface_name})->$row->{to_dev_name}($row->{to_int_name}) );
    }
    
    return $txt;
}

sub get_device_relations{
    my $device_id=shift;
    my $to_device_id=shift;
     #full join
    my $q=qq(
        SELECT d.device_id,d.device_name,i.interface_id,i.interface_name,d2.device_id AS to_dev_id,d2.device_name AS to_dev_name,i2.interface_id AS to_int_id,i2.interface_name AS to_int_name
        FROM `devices` d 
        JOIN interfaces i ON d.device_id=i.device_id
        JOIN i2i ON (i2i.int_a=i.interface_id OR i2i.int_b=i.interface_id)
        JOIN devices d2 ON d2.device_id=(SELECT device_id FROM interfaces WHERE (interface_id in(i2i.int_a,i2i.int_b) AND device_id != d.device_id ) LIMIT 1)
        JOIN interfaces i2 ON ((i2i.int_a=i2.interface_id OR i2i.int_b=i2.interface_id) AND i2.interface_id != i.interface_id)
        WHERE d.device_id=?
    );
    my $dbh=Service::init_db();
    my $result;
    if($to_device_id){
        $q.=" AND d2.device_id=? ";
        $result=$dbh->selectall_arrayref($q,{Slice=>{}},$device_id,$to_device_id);
    }else{
    $result=$dbh->selectall_arrayref($q,{Slice=>{}},$device_id); 
    }
    $dbh->disconnect;
    return $result;
}


return 1;