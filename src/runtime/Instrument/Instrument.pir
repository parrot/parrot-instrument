# Copyright (C) 2010, Parrot Foundation.
# $Id: Instrument.pir 47732 2010-06-20 16:41:14Z khairul $

=head1 NAME

runtime/parrot/library/Instrument/Instrument.pir - Loads all libraries required
by Instrument.

=head1 SYNOPSIS

   # Load the instrument dynpmc and required libraries.
   load_bytecode 'Instrument/InstrumentLib.pbc'

=cut

.include 'call_bits.pasm'
.loadlib 'bit_ops'

.sub '__instrument_lib_init' :init :load :anon
    .local pmc lib
    $P0 = loadlib './dynext/instrument_group'
    $I0 = defined $P0
    if $I0 goto have_instrument_group
    say "Could not load instrument_group"
    exit 0
  have_instrument_group:
    load_bytecode 'P6object.pbc'

    .return()
.end

.sub 'say'
    .param pmc msg
    say msg
.end

.sub 'die'
    .param pmc msg
    die msg
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:
