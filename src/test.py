import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles


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

    dut.tt_um_rejunity_telluride2023_neuron_uut.shift.value = 1;
    for i in range(50):
        await ClockCycles(dut.clk, 1)

    dut.tt_um_rejunity_telluride2023_neuron_uut.shift.value = 2;
    for i in range(50):
        await ClockCycles(dut.clk, 1)

    dut.tt_um_rejunity_telluride2023_neuron_uut.shift.value = 3;
    for i in range(50):
        await ClockCycles(dut.clk, 1)

    dut.tt_um_rejunity_telluride2023_neuron_uut.shift.value = 4;
    for i in range(50):
        await ClockCycles(dut.clk, 1)

    dut.tt_um_rejunity_telluride2023_neuron_uut.minus_teta.value = 0b0001;
    dut.tt_um_rejunity_telluride2023_neuron_uut.shift.value = 3;
    for i in range(100):
        await ClockCycles(dut.clk, 1)

