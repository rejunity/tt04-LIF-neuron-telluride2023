![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg)

# Binarized LIF Neuron from Telluride Neuromorphic Workshop 2023

This is a standalone test for a Binarized Leaky Integrate and Fire (BLIF) neuron implemented in silicon. The neuron was developed during the [Telluride Neuromorphic Workshop 2023](https://sites.google.com/view/telluride-2023/home) and is part of a larger experiment ["The Huge Neural Network On-Chip"](https://github.com/rejunity/tt05-snn).

The main design goal behind BLIF neuron is to minimize the silicon area. The BLIF neuron with 8 synapses:
* 191 logic gates
* 0.003mm^2 on [Sky130 nm](https://skywater-pdk.readthedocs.io/en/main/)

In other words 300 neurons and 2400 synapses could fit in a 1 square millimeter on [Sky130 nm](https://skywater-pdk.readthedocs.io/en/main/) process.

![](paolas_design_notes/summary.png)

## Hot it works

Binarized Leaky Integrate and Fire (BLIF) neuron supports binary {0/1} inputs and {-1/1} binarized weights.
Inputs are multiplied by weights and accumulated on the internal membrane. Membrane is exponentially decaying with every clock cycle.
Once membrane value (potential) reaches threshold, neuron spikes and membrane value is decreased.

```
membrane += inputs * weights
membrane *= decay_factor
spike = 1             if membrane > threshold
membrane -= threshold if membrane > threshold

```

## ASIC tapeout

Binarized Leaky Integrate and Fire (BLIF) neuron was tapedout on [FOSS 130nm Production process](https://skywater-pdk.readthedocs.io/en/main/) via [Tiny Tapeout](https://tinytapeout.com/runs/tt04/) initiative.




## Collaborators
  - Paola Vitolo
  - Andrew Wabnitz
  - ReJ aka Renaldas Zioma

## Telluride topic Leader
  - Jason Esgharhian
