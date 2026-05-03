package com.inventory.util;

import com.inventory.model.Item;
import java.util.List;
import java.util.ArrayList;

/**
 * OOP Concept: DATA STRUCTURE & ALGORITHM — Custom Merge Sort  O(n log n)
 *
 * This class implements Merge Sort manually (NOT Collections.sort()).
 * It is used in Component 02 (Expiry Management) to sort inventory items
 * by their expiry date in ascending order (soonest-to-expire first).
 *
 * Why Merge Sort?
 *   - Guaranteed O(n log n) in all cases (best, average, worst).
 *   - Stable sort — items with the same expiry date keep their original order.
 *   - Divide-and-conquer approach is easy to reason about and test.
 *
 * Algorithm outline:
 *   1. DIVIDE  — split the list in half recursively until each sub-list has 1 element.
 *   2. CONQUER — merge pairs of sorted sub-lists by comparing expiry dates.
 *   3. COMBINE — the merged result is a fully sorted list.
 */
public class MergeSort {

    /**
     * Public entry point.
     * Sorts a list of Items by expiryDate (YYYY-MM-DD) in ascending order.
     * Because dates are in ISO-8601 format, lexicographic comparison == chronological order.
     *
     * @param items the list to sort (a copy is sorted; the original is not mutated)
     * @return a new sorted list
     */
    public static List<Item> sortByExpiryDate(List<Item> items) {
        if (items == null || items.size() <= 1) {
            return new ArrayList<>(items == null ? new ArrayList<>() : items);
        }
        // Work on a copy so the caller's list is not mutated
        List<Item> copy = new ArrayList<>(items);
        mergeSort(copy, 0, copy.size() - 1);
        return copy;
    }

    // -----------------------------------------------------------------------
    // Private recursive implementation
    // -----------------------------------------------------------------------

    /**
     * DIVIDE step — recursively splits the sub-array [left, right] in half.
     */
    private static void mergeSort(List<Item> list, int left, int right) {
        if (left >= right) return; // Base case: single element is already sorted

        int mid = left + (right - left) / 2; // Avoids integer overflow

        mergeSort(list, left, mid);       // Sort left half
        mergeSort(list, mid + 1, right);  // Sort right half
        merge(list, left, mid, right);    // Merge the two sorted halves
    }

    /**
     * MERGE step — merges two sorted sub-arrays [left, mid] and [mid+1, right]
     * back into the original list in sorted order.
     *
     * Comparison: expiryDate strings in YYYY-MM-DD format are compared
     * lexicographically, which is equivalent to chronological order.
     */
    private static void merge(List<Item> list, int left, int mid, int right) {
        // Copy both halves into temporary lists
        List<Item> leftPart  = new ArrayList<>(list.subList(left, mid + 1));
        List<Item> rightPart = new ArrayList<>(list.subList(mid + 1, right + 1));

        int i = 0; // Pointer for leftPart
        int j = 0; // Pointer for rightPart
        int k = left; // Pointer for the merged position in the original list

        // Compare elements from both halves and place the smaller one first
        while (i < leftPart.size() && j < rightPart.size()) {
            String leftDate  = leftPart.get(i).getExpiryDate();
            String rightDate = rightPart.get(j).getExpiryDate();

            // Lexicographic comparison works for YYYY-MM-DD dates
            if (leftDate.compareTo(rightDate) <= 0) {
                list.set(k++, leftPart.get(i++));
            } else {
                list.set(k++, rightPart.get(j++));
            }
        }

        // Copy any remaining elements from the left half
        while (i < leftPart.size()) {
            list.set(k++, leftPart.get(i++));
        }

        // Copy any remaining elements from the right half
        while (j < rightPart.size()) {
            list.set(k++, rightPart.get(j++));
        }
    }
}

