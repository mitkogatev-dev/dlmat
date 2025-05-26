#!/usr/bin/perl -w

package Svg;

use strict;
use FindBin 1.51 qw( $RealBin );
my $dir=$RealBin;

sub init{
    my $html=qq(
        <div>zoom <span onclick="handler.zoom.in()"><button>+</button></span> or <span onclick="handler.zoom.out()"><button>-</button></span></div>

        <svg id="svg-container" width="100%" height="800px" style='transform: scale(1);transform-origin:top left;'>
            <foreignobject id="fobj" x="10" y="0" height="100%" width="100%" >
            <div class='devices'>
    );
    my $devices=Service::devices_get();
    foreach my $device (@$devices){
        $html.=qq(
            <div id="$device->{device_id}" class="device">
            <div class="dev_title">$device->{device_name}</div>
            <div class="interfaces">
        );
            foreach my $interface (@{$device->{interfaces}}){
                $html.=qq(
                    <div onclick="handler.svg.test(this)" id="i$interface->{interface_id}" class="interface" title="$interface->{interface_name}">$interface->{interface_number}</div>
                );
            }
        $html.="</div></div>";
    }
    $html.=qq(
            </div>
            </foreignobject>
        </svg>
    );
    
}

return 1;