# Fiberphotometry Extension for NWB

An extension of Neurodata Without Border (NWB) for fiber photometry (FP). Both single FP and multi-FP are supported.

The fiberphotometry acquisition software generally outputs the following files:

Single FP:
.TDT block

Multi-FP:
video with light intensity of channels

This extension adds  to the Device core NWB neurodata_type called Miniscope which contains fields for the data in settings_and_notes.dat. The following code demonstrates how to use this extension to properly convert fiberphotometry experimental data into formatted NWB files, which have a standardized interface thus facilitating the data sharing in research community. 

**Installation**

git clone https://github.com/bendichter/ndx-miniscope.git

generateExtension('path/to/ndx-miniscope/spec');

**Usage**

Code templates are provided (NWB_FP_CodeTemplate_DataRecipient.m and NWB_FP_CodeTemplate_DataSharer.m) with detailed annotation. The code templates cover the fundamental usage of the extension. Users do not need to write their own code except for changing variable and data names in the code templates.
