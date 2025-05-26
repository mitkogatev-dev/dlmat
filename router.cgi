#!/usr/bin/perl -w
use strict;
use CGI qw(-utf8);
use CGI::Carp qw(fatalsToBrowser);
use JSON;
use Data::Dumper qw( Dumper );
use FindBin 1.51 qw( $RealBin );
use lib $RealBin;
# use lib $RealBin."/lib";
my $start_run=time();
my $dir=$RealBin;
my $clip=$ENV{REMOTE_ADDR};
our %input;
our $cgi = new CGI;
$cgi->charset('utf-8');
$CGI::LIST_CONTEXT_WARN = 0 ;
my @params=$cgi->param();
my $request_method=$cgi->request_method();
my $input_str="";

for my $key ( $cgi->param() ) {
 $input{$key} = $cgi->param($key);
 #workaround to pass inputs to other cgi
 $input_str.="$key=".$cgi->param($key)."&";
}
my $html=""; 
require "$dir/config.pl";
require "$dir/service.pl";
require "$dir/strings.pl";
require "$dir/device.pl";
require "$dir/svg.pl";
#
my $cfg=Cfg::get_config();
my $debug=Cfg::get_debug();

if($request_method eq "POST"){
    if($input{devices}){
        # $html=Strings::add_dev_form();
        $html=Device::handle();
    }
    elsif($input{linker_btn}){
        $html=Svg::init();
    }
    else{
        $html="POST";
    }
}elsif($request_method eq "GET"){
$html="GET";
}else{
    return 0;
}


print $cgi->header("text/html;charset=UTF-8");
#*******************
#*   HEAD SECTION
#*******************
print qq(
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/devices.css">
    <script src='js/script.js'></script>
    <script src='js/svg.min.js'></script>
    <script src='js/handler.js'></script>
    <title>Frame</title>
</head>
);
#*******************
#*  BODY SECTION
#*******************
print qq(
    <body>
    <div id='infobox'></div>
    <div id='mainframe'>
    $html
    </div>
    </body>
);
#DEBUG
my $end_run = time();
my $run_time = $end_run - $start_run;
print    "<div><h3>DEBUG cgi</h3> <div>Load time: $run_time seconds.</div>".Dumper($cgi)."</div>" if $cfg->{debug_cgi};

