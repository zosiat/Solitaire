# Solitaire in LÖVE2D

A simple Solitaire game made using Lua and the LÖVE2D framework.

---

## Programming Patterns Used

- **Object-Oriented Programming (OOP)**  
  Used Lua's table and metatable system to define `Card`, `Deck`, and `Pile` as modular objects. This allowed for encapsulated logic and reusable code for handling behavior like drawing, dragging, and stacking cards.

- **Model-View Separation**  
  The game state (e.g. cards, piles, dragging state) is separate from the rendering code. This makes it easier to maintain and extend game logic independently of how things are drawn.

- **State Management**  
  Dragging a card uses a clear `draggedCard` and `draggedCardOrigin` system to track what's being moved and from where. This keeps input logic straightforward and reduces bugs during drag-and-drop interactions.

---

## Peer Feedback

- **Sean Massa**  
  *Feedback:* Suggested refactoring `love.mousepressed` and `love.mousereleased` functions into smaller, focused helper functions (e.g. `handleClickDeck`, `handleDropOnPile`) to improve clarity and maintainability. Also suggested replacing hardcoded values with named constants and organizing gloabl variables into a central gameState table. Also mentioned creating `grabber.lua` module to handle card logic would streamline `main.lua`.
  *Response:* Implemented a `Dragger` file to clean up my main file. Added additional comments to make my code mmore readable. Currently working on transferring more logic from main to dragger.
---

## Postmortem

**What went well:**  
I successfully implemented drag-and-drop functionality with pile-specific behavior using OOP patterns. The game loop and input system remained relatively simple and readable throughout development.

**What I would do differently:**  
My next steps are to consider using an event-driven or observer pattern to reduce reliance on global state for drag logic. Additionally, a command pattern might be useful for handling undo/redo features cleanly.

---

## Assets

- **Playing Cards Pack:** [https://kenney.nl/assets/playing-cards-pack](https://kenney.nl/assets/playing-cards-pack)  
  All card sprites were sourced from Kenney assets.  
  No music, SFX, fonts, or shaders were used. All other visual and code assets were created by me.
