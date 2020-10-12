/*

This function, boxConcatenation (bcat) takes an array of boxes, which
consist of an array of rows for that box, and reduces it into a single 
multiline string with each box conncatenated horizontally.

This function will return nil if the number of rows in every box are
not equal or if the width of the rows of a box are not equal.

*/

func bcat(_ arr: [[String]]) -> String? {
	let height = arr.reduce(0) { max($0, $1.count) } 
	var rows = [String](repeating: "", count: height)
	for column in arr {
		if (column.count != height) { return nil }
		let width = column.reduce(0) { max($0, $1.count) }
		for (i, row) in column.enumerated() {
			if (row.count != width) { return nil } 
			rows[i].append(row)
		}
	}
	return rows.reduce("") { "\($0 ?? "")\($1)\n" } 
}
