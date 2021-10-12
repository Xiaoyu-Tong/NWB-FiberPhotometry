# Fiberphotometry Extension for NWB

An extension of Neurodata Without Border (NWB) for fiber photometry (FP). Both single FP and multi-FP are supported.

The Miniscope acquisition software generally outputs the following files:

msCam[##].avi
behavCam[##].avi
timestamp.dat
settings_and_notes.dat
This extension adds  to the Device core NWB neurodata_type called Miniscope which contains fields for the data in settings_and_notes.dat. The following code demonstrates how to use this extension to properly convert fiberphotometry experimental data into formatted NWB files, which have a standardized interface thus facilitating the data sharing in research community. 
