🚀 Space Defender
A little space shooter built in Processing (Java mode) — pilot a ship, fire at incoming meteorites, and survive as long as you can. Created as a creative coding project demonstrating object-oriented design, arrays, and coordinate transformations.
Language Type
_________________________________________________________________
🎮 About the Game
You control a spaceship at the bottom of the screen. Rotating meteorites fall from above, and your job is to shoot them down before they hit your ship or slip past you. Destroy meteorites to score points — but lose all your lives and it's game over.

	
Goal	Destroy meteorites before they reach you
Score	+10 points per meteorite destroyed
Lives	Start with 3 — lose one when a meteorite hits the ship or reaches the bottom

_________________________________________________________________
⌨️ Controls

Key	Action
← / →	Move the ship left / right
Space	Fire a bullet
R	Restart after game over

_________________________________________________________________
▶️ How to Run
●	Install the [Processing IDE](https://processing.org/download).
●	Open `SpaceDefender.pde` in Processing.
●	Press the **Run** button (▶).
No external libraries are required.
_________________________________________________________________
How It Works
The game is built from three classes, each with its own state and its own update() and display() methods:

Class	Role
Spaceship	The player and its cannon — moves, aims, and fires
Bullet	A single projectile fired upward by the ship
Meteorite	A rotating rock that falls and must be destroyed

Featured concepts
📦 Arrays
●	Two ArrayLists hold every active bullet and meteorite, looped through each frame to update, draw, and remove them.
●	Collision detection uses a nested loop (every bullet checked against every meteorite).
●	Each meteorite stores a float[] array of random corner offsets to generate its unique jagged shape.
🔄 Transformation
●	Meteorites use translate() + rotate() so they spin as they fall.
●	The spaceship uses translate() to draw its body and animated thruster flame relative to its own position.
_________________________________________________________________
📁 Project Structure
space-defender/
├── README.md              This file
├── SpaceDefender.pde      The game code
├── docs/                  Project documentation
└── media/
    └── SpaceDefender.mp4   Gameplay preview
_________________________________________________________________
🎥 Preview
A short gameplay preview is available in the media/ folder.
_________________________________________________________________
👤 Authors
Mohammedsaleh Ibrahim and Uruh Waheed
_________________________________________________________________

