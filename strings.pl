#!/usr/bin/perl -w

package Strings;

use strict;
use FindBin 1.51 qw( $RealBin );
my $dir=$RealBin;

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