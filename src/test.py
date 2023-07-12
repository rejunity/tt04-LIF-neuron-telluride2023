import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles


segments = [ 63, 6, 91, 79, 102, 109, 124, 7, 127, 103 ]

@cocotb.test()
async def test_neuron(dut):
    dut._log.info("start")
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    dut._log.info("reset")
    dut.rst_n.value = 0
    dut.ui_in.value = 0b1101 # load weights
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    #dut.tt_neuron_uut.minus_teta.value = 0b1111;

    dut._log.info("accumulate")
    dut.ui_in.value = 0b0001
    for i in range(12):
        await ClockCycles(dut.clk, 1)

    dut.ui_in.value = 0b0011
    for i in range(12):
        await ClockCycles(dut.clk, 1)

    dut.ui_in.value = 0b0111
    for i in range(12):
        await ClockCycles(dut.clk, 1)

    dut.ui_in.value = 0b1111
    for i in range(12):
        await ClockCycles(dut.clk, 1)

    dut.tt_neuron_uut.shift.value = 1;
    for i in range(50):
        await ClockCycles(dut.clk, 1)

    dut.tt_neuron_uut.shift.value = 2;
    for i in range(50):
        await ClockCycles(dut.clk, 1)

    dut.tt_neuron_uut.shift.value = 3;
    for i in range(50):
        await ClockCycles(dut.clk, 1)

    dut.tt_neuron_uut.shift.value = 4;
    for i in range(50):
        await ClockCycles(dut.clk, 1)

    dut.tt_neuron_uut.minus_teta.value = 0b0001;
    dut.tt_neuron_uut.shift.value = 3;
    for i in range(100):
        await ClockCycles(dut.clk, 1)

    # dut._log.info("check all segments")
    # for i in range(10):
    #     dut._log.info("check segment {}".format(i))
    #     await ClockCycles(dut.clk, 1000)
    #     assert int(dut.segments.value) == segments[i]

    #     # all bidirectionals are set to output
    #     assert dut.uio_oe == 0xFF
