#!/usr/bin/perl -w

package Svg;

use strict;
use FindBin 1.51 qw( $RealBin );
my $dir=$RealBin;
use JSON;


sub init{
    my $html=qq(
        <div>
        zoom <span onclick="handler.zoom.in()"><button>+</button></span> or <span onclick="handler.zoom.out()"><button>-</button></span>
        <button id="svgEnBtn" onclick="handler.svg.enableLinking()">enable linking</button>
        <button onclick="handler.svg.undo()">undo pair</button>
        <button id="unlinkEnBtn" onclick="handler.svg.enableUnLinking()">enable unlinking</button>
        <button onclick="handler.svg.save()">save</button>
        </div>

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
                    <div  id="i$interface->{interface_id}" class="interface" title="$interface->{interface_name}">$interface->{interface_number}</div>
                );
            }
        $html.="</div></div>";
    }
    $html.=qq(
            </div>
            </foreignobject>
        </svg>
    );
    my $links=to_json(Service::i2i_get());
    # foreach my $pair(@{$links}){
    #     $html.="<p>a=$pair->{int_a} | b=$pair->{int_b}</p>";
    # }
    $html.=qq(
            <script>
            handler.addClickListener("draw");
            handler.svg.redraw($links);
            </script>
            );
    return $html;
    
}

return 1;