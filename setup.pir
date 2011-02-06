
.sub main :main
    .param pmc args

    # Get self
    .local string me
    me = shift args

    load_bytecode 'distutils.pbc'

    .local pmc config, pmcs

    # Setup config.
    config = new ['Hash']
    config['name']     = 'parrot-instruments'
    config['abstract'] = 'Instrument framework for Parrot VM'

    # Setup pmcs
    $P0  = split "\n", <<'PMCS'
src/dynpmc/instrument.pmc
src/dynpmc/instrumentop.pmc
src/dynpmc/instrumentstubbase.pmc
src/dynpmc/instrumentinvokable.pmc
src/dynpmc/instrumentruncore.pmc
src/dynpmc/instrumentgc.pmc
src/dynpmc/instrumentclass.pmc
src/dynpmc/instrumentobject.pmc
PMCS
    $S0 = pop $P0

    pmcs = new ['Hash']
    pmcs['instrument_group'] = $P0

    config['dynpmc']        = pmcs
    config['dynpmc_cflags'] = "-g"

    $P0 = new ['Hash']
    $P0['src/runtime/Instrument/Base.pir']         = 'src/runtime/Instrument/Base.nqp'
    $P0['src/runtime/Instrument/Probe.pir']        = 'src/runtime/Instrument/Probe.nqp'
    $P0['src/runtime/Instrument/Event.pir']        = 'src/runtime/Instrument/Event.nqp'
    $P0['src/runtime/Instrument/EventLibrary.pir'] = 'src/runtime/Instrument/EventLibrary.nqp'
    config['pir_nqprx'] = $P0

    $P0 = new ['Hash']
    $P0['src/runtime/Instrument/Instrument.pbc']   = 'src/runtime/Instrument/Instrument.pir'
    $P0['src/runtime/Instrument/Base.pbc']         = 'src/runtime/Instrument/Base.pir'
    $P0['src/runtime/Instrument/Probe.pbc']        = 'src/runtime/Instrument/Probe.pir'
    $P0['src/runtime/Instrument/Event.pbc']        = 'src/runtime/Instrument/Event.pir'
    $P0['src/runtime/Instrument/EventLibrary.pbc'] = 'src/runtime/Instrument/EventLibrary.pir'
    config['pbc_pir'] = $P0

    $P0 = new ['Hash']
    $P1 = new ['ResizablePMCArray']
    push $P1, 'src/runtime/Instrument/Instrument.pbc'
    push $P1, 'src/runtime/Instrument/Base.pbc'
    push $P1, 'src/runtime/Instrument/Probe.pbc'
    push $P1, 'src/runtime/Instrument/Event.pbc'
    push $P1, 'src/runtime/Instrument/EventLibrary.pbc'
    $P0['src/runtime/Instrument/InstrumentLib.pbc'] = $P1
    config['pbc_pbc'] = $P0

    setup(args :flat, config :flat :named)
.end
