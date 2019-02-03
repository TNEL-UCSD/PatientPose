# -*- coding: utf-8 -*-
"""
Created on Fri Jun  1 12:24:42 2018

@author: Paolo Gabriel
"""

from itertools import groupby

import numpy as np
from scipy import ndimage
import pandas as pd


def threshold_signal(array, thresh=0):
    """ Return array with values below threshold set to 0
    :param array: Array with values below threshold needing removal
    :param thresh: Threshold value compared against array values
    :return: Array with minimum values >= thresh
    """

    filtered_array = np.copy(array)
    filtered_array[filtered_array <= thresh] = 0
    filtered_array[filtered_array > thresh] = 1
    return filtered_array


def filter_isolated_cells(array, struct, len_isolation=1):
    """ Return array with completely isolated single cells removed
    :param array: Array with completely isolated single cells
    :param struct: Structure array for generating unique regions
    :return: Array with minimum region size > 1
    """

    filtered_array = np.copy(array)
    id_regions, num_ids = ndimage.label(filtered_array, structure=struct)
    id_sizes = np.array(ndimage.sum(array, id_regions, range(num_ids + 1)))
    area_mask = (id_sizes <= len_isolation)
    filtered_array[area_mask[id_regions]] = 0
    return filtered_array

def clean_detection(signal, len_isolation=1, min_spacing=1):        
    # forward pass, merge then filter
    signal_clean = merge_neighboring_cells(signal, min_spacing=min_spacing)
    signal_clean = filter_isolated_cells(signal_clean, struct=None, len_isolation=len_isolation)
    
    signal_removed = np.copy(signal)
    signal_removed[signal_clean.astype(bool)] = 0
    
    return signal_clean.astype(bool), signal_removed.astype(bool)

def array_to_sequence(array, invert=False):
    """ Return list of start indices and durations for events contained in
        a boolean array.
    :param array: Boolean array with sequences of true elements
    :return: List of start indices and durations for true sequences
    """

    df_sequences = []
    onset = 0
    for val, g in groupby(array):
        duration = len(list(g))

        entry = pd.DataFrame(data={'onset': [onset], 'duration': [duration]})

        if invert:
            val = np.logical_not(val)
        if val:
            df_sequences.append(entry)

        onset += duration

    return pd.concat(df_sequences, axis=0).reset_index(drop=True)


def merge_neighboring_cells(array, min_spacing=1):
    """ Return array with cells spaced below minimum allowed spacing merged
    :param array: Array with neighboring cells spaced below minimum allowed
    :param min_spacing: Value of minimum allowed spacing
    :return: Array of neighboring cells merged if spacing below allowed minimum
    """

    filtered_array = np.copy(array)
    sequence_inverted = array_to_sequence(filtered_array, invert=True)

    for ind, seq in sequence_inverted.iterrows():
        if seq['duration'] <= min_spacing:
            filtered_array[seq['onset']:(seq['onset']+seq['duration'])] = 1

    return filtered_array
