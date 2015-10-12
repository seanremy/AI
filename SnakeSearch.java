//SnakeSearch.java
//Searches for the best solution to the snake-in-the box problem in the dimension specified by the user
//Uses a heuristically driven hill climbing approach
//Sean Foley
//Fall 2014
//Made for Dr. Potter's Intro to AI course

import java.util.Scanner;

public class SnakeSearch {

	public static void main(String[] args) {

		Scanner scan = new Scanner(System.in);
		System.out.println("What dimension hypercube? (Works for 4 and up)");
		int n = scan.nextInt();
		long startTime = System.currentTimeMillis(); //time the execution
		int p = (int) Math.pow(2, n);
		boolean[][] mat = getAdjacencyMatrix(n);
		boolean[] closed = new boolean[p];
		int[] path = new int[p];
		int plen;
		int node;
		int bnode = 0;
		double score;
		double bestScore;
		boolean hasAdj;
		int adjnodes;
		int[] bestpath = new int[p];
		int bestpathlength = 0;
		boolean found;
		int dcount;
		int diff;
		double rand1 = 0, rand2 = 0, rand3 = 0;
		int sub1 = 5, sub2 = 5, sub3 = 5;
		double randsum = 0;
		boolean added;
		int[] dirs;

		int[] fits1, fits2, fits3;

		// loop FOREVER
		while (true) {

			dirs = new int[n];
			plen = 0;
			node = 0;
			closed = new boolean[p];
			hasAdj = true;

			// while there are moves left to make
			while (hasAdj) {
				found = false;
				bestScore = 0;

				// loop through all nodes
				for (int i = 0; i < p; i++) {
					adjnodes = 0;
					// if the node is adjacent and open
					if (mat[node][i] && !closed[i] && (i != p - 1)) {
						found = true;
						// count number of closed adjacent nodes
						for (int j = 0; j < p; j++) {
							if (mat[i][j] && !closed[j]) {
								adjnodes++;
							}
						}
						// find out how close the node is to the middle
						// by counting 1 digits in the binary number
						dcount = 0;
						for (int j = 0; j < n; j++) {
							if (node % (Math.pow(2, j)) == 0)
								dcount++;
						}

						/*
						 * THREE-PART SCORE 1.)CLOSEDNESS (visit node with
						 * either most or least adjacent closed nodes) 2.) POLE
						 * AVOIDANCE (stay farther away from the start node and
						 * its complement) 3.) TRANSITION PATTERN CONFORMITY
						 * (rank transition directions and stick with the
						 * likeliest ones)
						 * 
						 * randomize the relative importance of different scores
						 */
						rand1 = Math.random();
						rand2 = Math.random();
						rand3 = Math.random();
						randsum = rand1 + rand2 + rand3;

						score = rand1
								/ randsum
								* (adjnodes + 1)
								/ n
								+ rand2
								/ randsum
								* (1 - ((Math.abs((int) (n / 2) - dcount)) / ((int)(n / 2) + 1)))
								+ rand3
								/ randsum
								* (n - ((int)(Math.log(Math.abs(i - node)) / Math.log(2))));
						
						if (score >= bestScore) {
							// System.out.println(score);
							bestScore = score;
							bnode = i;
						}
					}
				}

				// if no moves left
				if (!found) {
					hasAdj = false;
				}

				// add to transition path
				diff = bnode - node;
				added = false;
				// add current direction to path
				for (int i = n - 1; i >= 0; i--) {
					if (diff % (Math.pow(2, i)) == 0 && !added) {
						path[plen] = i;
						dirs[i]++;
						plen++;
						added = true;
					}
				}

				// close all other adjacent nodes
				for (int i = 0; i < p; i++) {
					if (mat[node][i] == true) {
						closed[i] = true;
					}
				}

				// close current node
				closed[node] = true;

				// change current node to best node
				node = bnode;

			}

			// transition path
			if (plen > bestpathlength) {
				bestpath = path;
				bestpathlength = plen;
				// print best path
				System.out.println("The longest path found was length "
						+ (bestpathlength - 1)
						+ ". The transitions are listed below:");
				for (int i = 0; i < bestpathlength - 1; i++) {
					System.out.print(bestpath[i] + " ");
				}
				System.out.println("\nThe current time in milliseconds is: "
						+ (System.currentTimeMillis() - startTime));
				System.out.println();
			}

		}

	}

	//returns the adjacency matrix between points of a hypercube of dimension d
	public static boolean[][] getAdjacencyMatrix(int d) {
		int l = (int) Math.pow(2, d);
		String s, c;
		boolean[][] adj = new boolean[l][l];
		// loops through first dimension of the matrix
		for (int i = 0; i < l; i++) {
			s = Integer.toBinaryString(i);
			// make binary numbers length 2^N
			while (s.length() < d) {
				s = "0".concat(s);
			}
			// loop through all N characters of the binary number
			for (int k = 0; k < d; k++) {
				// stores each digit
				c = s.substring(k, k + 1);
				// adds N 1-flipped-digit numbers to the adjacency matrix
				if (c.equals("0")) {
					adj[i][(i + (int) Math.pow(2, (d - k - 1)))] = true;
				}
				if (c.equals("1")) {
					adj[i][(i - (int) Math.pow(2, (d - k - 1)))] = true;
				}
			}

		}
		return adj;
	}
}
