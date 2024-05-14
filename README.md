# PyraStats-Geometric-Insights

This program is designed to compute geometric properties for square pyramids. It calculates various statistical measures such as the minimum, maximum, sum, and average for lateral surface areas, total surface areas, and volumes of the shapes. Using the provided data sets for base lengths, slant heights, and heights of square pyramids, it employs mathematical formulas to derive these statistical measures.

For lateral surface areas, the program utilizes the formula: lateralAreas[n] = ((2 * bases[n]) * slants[n]).

For total surface areas, it employs the formula: totalArea = (bases * ((2 * slants) + bases)).

For volumes, the formula used is: volumes[n] = (((bases[n]^2) * heights[n]) / 3).

The program iterates through the given data sets, performs the necessary calculations, and stores the results in corresponding arrays. Finally, it computes statistical measures such as minimum, maximum, sum, and average for each property.
