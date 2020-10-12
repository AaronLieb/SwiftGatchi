import ArgumentParser
import Foundation

let WINDOW_HEIGHT = 10

struct Gotchi: ParsableCommand {
	@Option(name: .shortAndLong, help: "The number of minutes between ticks.")
	var time : Double = 5

	@Option(name: .shortAndLong, help: "The name of the pet.")
	var name: String?

	@Flag(name: .shortAndLong, help: "Save pet data to a file every tick.")
	var save = false;

	mutating func run() throws {
		let _ = Pet(time: time, name: name, save: save)
	}
}

class Pet {
	var name : String

	var save : Bool

	var hunger : Double = 1
	var fitness : Double = 1

	var timer : Timer?

	var alive = true


	init(time: Double, name: String?, save: Bool) {
		self.name = name ?? "Bob"
		self.save = save

		print("Created Pet Instance")
		print("Name: \(self.name)")

		self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in self.tick() }

		while alive && RunLoop.current.run(mode: .default, before: .distantFuture) {}

	}

	func tick() {
		hunger -= 0.1
		display()
		if (hunger <= 0) { die() }
	}

	func feed() {
		hunger += 0.2
	}

	func bar(height: Int, value: Int, color: Color) -> [String] {
		var rows : [String] = [Color.white + "┌─┐"]
		for i in (0..<height-2).reversed() {
			rows.append("│" + color + "\(value > i ? "█" : "▒")" + Color.white + "│")
		}
		rows.append(Color.white + "└─┘")
		return rows
	}

	func display() {
		let num = Int(hunger/0.1)
		let hungerBox = bar(height: WINDOW_HEIGHT, value: num, color: Color.red)
		let fitnessBox = bar(height: WINDOW_HEIGHT, value: num, color: Color.green)
		print(bcat([hungerBox, fitnessBox]) ?? "Failed", terminator: "")
		print("\u{001B}[\(WINDOW_HEIGHT)A", terminator:"")
		fflush(stdout)
	}

	func die() {
		print("\u{001B}[\(WINDOW_HEIGHT)B", terminator:"")
		DispatchQueue.main.async {self.alive = false}
		print("RIP \(name)")
		print("2020 - 2020")

	}
}


Gotchi.main()
