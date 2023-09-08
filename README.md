![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg)

# LIF Neuron from Telluride Neuromorphic Workshop 2023

This is a standalone test for a Binarized Leaky Integrate and Fire neuron. The neuron itself is part of the Huge Neural Network On-Chip experimental design from Telluride Neuromorphic Workshop 2023.

![](paolas_design_notes/summary.png)

## Hot it works
Binarized Leaky Integrate and Fire (LIF) neuron supports binary {0/1} inputs and {-1/1} binarized weights.
Inputs are multiplied by weights and accumulated on the internal membrane. Membrane is exponentially decaying with every clock cycle.
Once membrane value (potential) reaches threshold, neuron spikes and membrane value is decreased.

Something along the line of this pseudocode:
```
membrane += inputs * weights
membrane *= decay_factor
membrane -= threshold if membrane > threshold
spike = 1 if membrane > threshold
```

## Collaborators
  - Paola Vitolo
  - Andrew Wabnitz
  - ReJ aka Renaldas Zioma

## TODO
  - Share your GDS on Twitter, tag it [#tinytapeout](https://twitter.com/hashtag/tinytapeout?src=hashtag_click) and [link me](https://twitter.com/matthewvenn)!
