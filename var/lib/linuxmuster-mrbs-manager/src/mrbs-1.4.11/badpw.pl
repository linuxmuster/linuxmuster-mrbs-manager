#!/usr/bin/perl

# $Id: badpw.pl 1640 2010-11-24 17:50:28Z jberanek $

# Read AUTHENTICATION for more information
# about this script

use strict;

my %users;
my $un;
my $pw;

$un = shift;
$pw = shift;

exit 1 if (!$un || !$pw);

# The list of valid username and password pairs
$users{user1} = "pass1";
$users{user2} = "pass2";
$users{admin} = "secret";

if ($users{$un} eq $pw)
{
  exit 0;
}
else
{
  exit 1;
}
